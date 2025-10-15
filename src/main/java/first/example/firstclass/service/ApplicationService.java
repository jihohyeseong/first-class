package first.example.firstclass.service;

import first.example.firstclass.dao.ApplicationDAO;
import first.example.firstclass.dao.TermAmountDAO;
import first.example.firstclass.domain.AdminJudgeDTO;
import first.example.firstclass.domain.ApplicationDTO;
import first.example.firstclass.domain.ApplicationListDTO;
import first.example.firstclass.domain.CodeDTO;
import first.example.firstclass.domain.TermAmountDTO;
import first.example.firstclass.domain.UserDTO;
import first.example.firstclass.util.AES256Util;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.function.BiConsumer;
import java.util.function.Predicate;

@Slf4j
@Service
@RequiredArgsConstructor
public class ApplicationService {

    private final ApplicationDAO applicationDAO;
    private final TermAmountDAO termAmountDAO;
    private final AES256Util aes256Util;

    @Transactional
    public Long createDraft(ApplicationDTO dto) {
        try {
            if (dto.getChildResiRegiNumber() != null && !dto.getChildResiRegiNumber().trim().isEmpty()) {
                dto.setChildResiRegiNumber(aes256Util.encrypt(dto.getChildResiRegiNumber()));
            }
            if (dto.getAccountNumber() != null && !dto.getAccountNumber().trim().isEmpty()) {
                dto.setAccountNumber(aes256Util.encrypt(dto.getAccountNumber()));
            }
        } catch (Exception e) { e.printStackTrace(); }

        dto.setStatusCode("ST_10");

        applicationDAO.insertApplication(dto);

        return dto.getApplicationNumber();
    }
    
    @Transactional
    public long saveDraftAndMaybeTerms(ApplicationDTO dto,
                                       List<Long> monthlyCompanyPay,
                                       boolean noCompanyPay) {
        // 자녀 주민등록번호, 계좌번호 암호화
        try {
            if (dto.getChildResiRegiNumber() != null && !dto.getChildResiRegiNumber().trim().isEmpty()) {
                dto.setChildResiRegiNumber(aes256Util.encrypt(dto.getChildResiRegiNumber()));
            }
            if (dto.getAccountNumber() != null && !dto.getAccountNumber().trim().isEmpty()) {
                dto.setAccountNumber(aes256Util.encrypt(dto.getAccountNumber()));
            }
        } catch (Exception e) { e.printStackTrace(); }

        // 임시저장 상태로
        dto.setStatusCode("ST_10");

        // 부모 INSERT
        applicationDAO.insertApplication(dto);
        long appNo = dto.getApplicationNumber();

        // 계산 가능한지 체크 (모든 값 존재해야 계산)
        if (readyForCalc(dto)) {
            LocalDate start = dto.getStartDate().toLocalDate();
            LocalDate end   = dto.getEndDate().toLocalDate();
            long regularWage = dto.getRegularWage();

            // 기존 단위기간 지우고 다시 넣기
            termAmountDAO.deleteTermsByAppNo(appNo);

            List<TermAmountDTO> terms = splitPeriodsAndCalc(
                    start, end, regularWage,
                    monthlyCompanyPay == null ? new ArrayList<>() : monthlyCompanyPay,
                    noCompanyPay
            );
            long totalGov = terms.stream().mapToLong(t -> t.getGovPayment() == null ? 0L : t.getGovPayment()).sum();

            for (TermAmountDTO t : terms) t.setApplicationNumber(appNo);
            if (!terms.isEmpty()) termAmountDAO.insertBatch(terms);

        }
        return appNo;
    }

    private boolean readyForCalc(ApplicationDTO dto) {
        return dto.getStartDate() != null
            && dto.getEndDate()   != null
            && dto.getRegularWage()!= null
            && !dto.getEndDate().before(dto.getStartDate());
    }

    @Transactional
    public long createAllWithComputedPayment(ApplicationDTO dto,
                                             List<Long> monthlyCompanyPay,
                                             boolean noCompanyPay) {
        // 암호화
        try {
            if (notBlank(dto.getChildResiRegiNumber())) {
                dto.setChildResiRegiNumber(aes256Util.encrypt(dto.getChildResiRegiNumber()));
            }
        } catch (Exception ignore) {}

        try {
            if (notBlank(dto.getAccountNumber())) {
                dto.setAccountNumber(aes256Util.encrypt(dto.getAccountNumber()));
            }
        } catch (Exception ignore) {}

        // 날짜/임금
        LocalDate start = toLocal(dto.getStartDate());
        LocalDate end   = toLocal(dto.getEndDate());
        long regularWage = nz(dto.getRegularWage());

       //단위기간/지급액 계산
        List<TermAmountDTO> terms = splitPeriodsAndCalc(start, end, regularWage, monthlyCompanyPay, noCompanyPay);
        long totalGov = terms.stream().mapToLong(t -> nz(t.getGovPayment())).sum();
        dto.setPayment(totalGov);

        //신청서 저장 
        applicationDAO.insertApplication(dto);
        Long appNo = dto.getApplicationNumber();

        if (appNo != null) {
            termAmountDAO.deleteTermsByAppNo(appNo);
            for (TermAmountDTO t : terms) t.setApplicationNumber(appNo);
            if (!terms.isEmpty()) {
                termAmountDAO.insertBatch(terms);
            }
            if ("ST_20".equals(dto.getStatusCode())) {
                applicationDAO.updateSubmittedNow(appNo);
            }
        }
        return appNo;
    }

    private LocalDate getPeriodEndDate(LocalDate originalStart, int monthIdx) {
    	LocalDate nextPeriodStart = originalStart.plusMonths(monthIdx);
    	
    	// 예) 1월 30일인데 2월 30일이 없다면
    	if (nextPeriodStart.getDayOfMonth() != originalStart.getDayOfMonth()) {
            nextPeriodStart = nextPeriodStart.plusMonths(1).withDayOfMonth(1); // 예) 다음 시작일은 3월 1일
        }
    	
    	return nextPeriodStart.minusDays(1); // 종료일 리턴. 종료일은 다음 시작일 -1일
    }

    // 단위기간 및 정부/회사 지급액 계산
    private List<TermAmountDTO> splitPeriodsAndCalc(LocalDate startDate, LocalDate endDate,
                                                    long regularWage, List<Long> monthlyCompanyPay,
                                                    boolean noCompanyPay) {
        if (startDate == null || endDate == null) {
            throw new IllegalArgumentException("기간이 비어 있습니다.");
        }
        if (endDate.isBefore(startDate)) {
            throw new IllegalArgumentException("종료일이 시작일보다 빠릅니다.");
        }

        List<TermAmountDTO> result = new ArrayList<>();
        LocalDate currentPeriodStart = startDate; // 단위기간 시작일
        int monthIdx = 1;

        while (!currentPeriodStart.isAfter(endDate) && monthIdx <= 12) {
            LocalDate theoreticalEndDate = getPeriodEndDate(startDate, monthIdx); // 단위기간 예정 종료일
            // 실제 종료일은 이론적 종료일과 전체 휴직 종료일 중 더 빠른 날짜
            LocalDate actualPeriodEnd = theoreticalEndDate.isAfter(endDate) ? endDate : theoreticalEndDate;
            
            if(currentPeriodStart.isAfter(actualPeriodEnd))
            	break;

            long companyPayment = (!noCompanyPay && monthlyCompanyPay != null && monthlyCompanyPay.size() >= monthIdx)
                    ? nz(monthlyCompanyPay.get(monthIdx - 1)) : 0L;

            long base = computeGovBase(regularWage, monthIdx);
            long govPayment = calcGovPayment(base, companyPayment, currentPeriodStart, actualPeriodEnd, theoreticalEndDate);
            if(regularWage < companyPayment + govPayment)
            	govPayment = regularWage - companyPayment; // 임금 초과시 정부지원금에서 감소

            TermAmountDTO term = new TermAmountDTO();
            term.setStartMonthDate(Date.valueOf(currentPeriodStart)); // 단위기간 시작일
            term.setEndMonthDate(Date.valueOf(actualPeriodEnd)); // 단위기간 종료일
            term.setPaymentDate(Date.valueOf(actualPeriodEnd.plusMonths(1).withDayOfMonth(1))); // 지급일은 다음달 1일
            term.setCompanyPayment(companyPayment); // 회사 지급액
            term.setGovPayment(govPayment); // 정부 지급액
            result.add(term);

            currentPeriodStart = actualPeriodEnd.plusDays(1); // 다음 개월차의 시작일은 현재 종료일 + 1일
            monthIdx++;
        }
        
        return result;
    }

    private long calcGovPayment(long base, long companyPayment, LocalDate startDate, LocalDate endDate, LocalDate theoreticalEndDate) {

    	long daysInTerm = ChronoUnit.DAYS.between(startDate, endDate) + 1; // 이번 단위기간 육아휴직 일수
    	long daysInFullMonth = ChronoUnit.DAYS.between(startDate, theoreticalEndDate) + 1; // 단위기간 한달 꽉 채웠을때 일수
    	
    	// 이론적으로 같거나 오차 허용 (>=)
        if (daysInTerm >= daysInFullMonth) {
            return base;
        }
        
        double ratio = (double) daysInTerm / daysInFullMonth; // 전체 단위기간 중 실제 육아휴직 비율
        
        return (long) Math.floor(base * ratio / 10) * 10;
    }

    private long computeGovBase(long regularWage, int monthIdx) {
        if (monthIdx <= 3) return Math.min(regularWage, 2_500_000L); // 3개월까지 최대 현재임금 or 250만중 작은값
        if (monthIdx <= 6) return Math.min(regularWage, 2_000_000L); // 6개월까지 최대 현재임금 or 200만중 작은값
        long eighty = Math.round(regularWage * 0.8);
        return Math.min(eighty, 1_600_000L); // 그 이후 최대 현재임금의 80% or 160만중 작은 값
    }
    
    @Transactional
    public void recalcAndReplaceTerms(long appNo,
                                      LocalDate start, LocalDate end,
                                      long regularWage,
                                      List<Long> monthlyCompanyPay,
                                      boolean noCompanyPay) {
        // 기존 단위기간 삭제
        termAmountDAO.deleteTermsByAppNo(appNo);
        //새로 계산
        List<TermAmountDTO> terms = splitPeriodsAndCalc(
                start, end, regularWage, monthlyCompanyPay, noCompanyPay
        );
        for (TermAmountDTO t : terms) {
            t.setApplicationNumber(appNo);
        }
        // 저장 
        if (!terms.isEmpty()) {
            termAmountDAO.insertBatch(terms);
        }
    }

    // 조회
    public ApplicationDTO findById(long appNo) {
        ApplicationDTO dto = applicationDAO.selectApplicationById(appNo);
        if (dto == null) return null;

        try {
            if (notBlank(dto.getChildResiRegiNumber())) {
                dto.setChildResiRegiNumber(aes256Util.decrypt(dto.getChildResiRegiNumber()));
            }
        } catch (Exception ignore) {}

        try {
            if (notBlank(dto.getAccountNumber())) {
                dto.setAccountNumber(aes256Util.decrypt(dto.getAccountNumber()));
            }
        } catch (Exception ignore) {}

        return dto;
    }

    public List<ApplicationListDTO> findListByUser(long userId) {
        return applicationDAO.selectListByUserId(userId);
    }

    public List<TermAmountDTO> findTerms(long appNo) {
        return termAmountDAO.selectByApplicationNumber(appNo);
    }

    // 신청서 수정, 삭제
    @Transactional
    public long updateApplication(ApplicationDTO dto,
                                  List<Long> monthlyCompanyPay,
                                  boolean noCompanyPay,
                                  boolean recomputeTerms) {
        //암호화
        try {
            if (dto.getChildResiRegiNumber() != null)
                dto.setChildResiRegiNumber(dto.getChildResiRegiNumber().trim().isEmpty()
                        ? "" : aes256Util.encrypt(dto.getChildResiRegiNumber()));
            if (dto.getAccountNumber() != null)
                dto.setAccountNumber(dto.getAccountNumber().trim().isEmpty()
                        ? "" : aes256Util.encrypt(dto.getAccountNumber()));
        } catch (Exception ignore) {}

        applicationDAO.updateApplicationSelective(dto);

        if (recomputeTerms && dto.getStartDate() != null && dto.getEndDate() != null && dto.getRegularWage() != null) {
            recalcAndReplaceTerms(
                dto.getApplicationNumber(),
                dto.getStartDate().toLocalDate(),
                dto.getEndDate().toLocalDate(),
                dto.getRegularWage(),
                monthlyCompanyPay,
                noCompanyPay
            );
        }
        return dto.getApplicationNumber();
    }

    @Transactional
    public void deleteApplication(long appNo) {
        termAmountDAO.deleteTermsByAppNo(appNo);
        applicationDAO.softDeleteApplication(appNo);
    }
    
    public List<String> validateForSubmit(ApplicationDTO app, List<TermAmountDTO> terms) {
        List<String> errs = new ArrayList<>();

        Predicate<String> blank = s -> (s == null || s.trim().isEmpty());
        BiConsumer<String,Object> req = (label, v) -> {
            if (v == null) errs.add(label);
            else if (v instanceof String && blank.test((String)v)) errs.add(label);
        };

        // 기본 필드
        req.accept("육아휴직 시작일", app.getStartDate());
        req.accept("육아휴직 종료일", app.getEndDate());
        req.accept("사업장 동의여부", app.getBusinessAgree());
        req.accept("사업장 이름", app.getBusinessName());
        req.accept("사업장 등록번호", app.getBusinessRegiNumber());
        req.accept("사업장 우편번호", app.getBusinessZipNumber());
        req.accept("사업장 기본주소", app.getBusinessAddrBase());
        req.accept("사업장 상세주소", app.getBusinessAddrDetail());
        req.accept("통상임금(월)", app.getRegularWage());
        req.accept("주당 소정근로시간", app.getWeeklyHours());
        req.accept("은행 코드", app.getBankCode());
        req.accept("계좌번호", app.getAccountNumber());
        req.accept("행정정보 공동이용 동의", app.getGovInfoAgree());

        // 날짜/상태 제약
        if (app.getStartDate() != null && app.getEndDate() != null) {
            if (app.getStartDate().after(app.getEndDate())) {
                errs.add("기간(시작일이 종료일보다 늦음)");
            } else {
                // 최대 12개월 제한
                Calendar a = Calendar.getInstance(); a.setTime(app.getStartDate());
                Calendar b = Calendar.getInstance(); b.setTime(app.getEndDate());
                int months = (b.get(Calendar.YEAR)-a.get(Calendar.YEAR))*12
                           + (b.get(Calendar.MONTH)-a.get(Calendar.MONTH)) + 1;
                if (months > 12) errs.add("기간(최대 12개월 초과)");
            }
        }

        // 자녀 정보
        req.accept("자녀 출생/예정일", app.getChildBirthDate());
        boolean bornMode = !blank.test(app.getChildName()) || !blank.test(app.getChildResiRegiNumber());
        if (bornMode) {
            req.accept("자녀 이름", app.getChildName());
            req.accept("자녀 주민등록번호", app.getChildResiRegiNumber());
        }

        // 금액/시간 유효값
        if (app.getRegularWage() != null && app.getRegularWage() <= 0) errs.add("통상임금(월)>0");
        if (app.getWeeklyHours() != null && app.getWeeklyHours() <= 0) errs.add("주당 소정근로시간>0");

        // 단위기간
        if (terms == null || terms.isEmpty()) {
            errs.add("단위기간(월별 구간 없음)");
        } else {
            for (int i = 0; i < terms.size(); i++) {
                TermAmountDTO t = terms.get(i);
                if (t.getStartMonthDate() == null || t.getEndMonthDate() == null) {
                    errs.add("단위기간 " + (i+1) + "의 기간");
                }
                // 회사지급액은 null 금지
                if (t.getCompanyPayment() == null) {
                    errs.add("단위기간 " + (i+1) + "의 사업장 지급액");
                } else if (t.getCompanyPayment() < 0) {
                    errs.add("단위기간 " + (i+1) + "의 사업장 지급액(음수 불가)");
                }
            }
        }

        return errs;
    }
    
    @Transactional
    public void submit(long appNo) {
    	int updated = applicationDAO.updateSubmittedNow(appNo);
		log.info("[SUBMIT] appNo={}, updated={}", appNo, updated);
        if (updated == 0) {
            throw new IllegalStateException("이미 제출되었거나 존재하지 않는 신청입니다.");
        }
    }


    // 공통 유틸
    private static long nz(Long v) { return v == null ? 0L : v; }

    private static LocalDate toLocal(Date d) {
        return (d == null) ? null : d.toLocalDate();
    }

    private static boolean notBlank(String s) {
        return s != null && !s.trim().isEmpty();
    }

    public List<CodeDTO> getBanks() {
        return applicationDAO.selectBankCode();
    }
    
    public UserDTO findApplicantByAppNo(long appNo) {
        UserDTO user = applicationDAO.selectUserByAppNo(appNo);
        if (user == null) return null;
        try {
            if (notBlank(user.getRegistrationNumber())) {
                user.setRegistrationNumber(aes256Util.decrypt(user.getRegistrationNumber()));
            }
        } catch (Exception ignore) {}
        return user;
    }

	public boolean adminReject(AdminJudgeDTO adminJudgeDTO, Long userId) {
		
		if(adminJudgeDTO.getRejectionReasonCode() == null || "".equals(adminJudgeDTO.getRejectionReasonCode()))
			return false;
		adminJudgeDTO.setProcessorId(userId);
		adminJudgeDTO.setPaymentResult("N");
		adminJudgeDTO.setStatusCode("ST_40");
		
		return applicationDAO.updateApplicationJudge(adminJudgeDTO) > 0 ? true : false;
	}

	public boolean adminApprove(AdminJudgeDTO adminJudgeDTO, Long userId) {
		
		adminJudgeDTO.setProcessorId(userId);
		adminJudgeDTO.setPaymentResult("Y");
		adminJudgeDTO.setStatusCode("ST_40");
		
		return applicationDAO.updateApplicationJudge(adminJudgeDTO) > 0 ? true : false;
	}
	
	@Transactional
	public int submitAndReturnCount(long appNo) {
	    return applicationDAO.updateSubmittedNow(appNo);
	}
	
	@Transactional
	public long submitApplication(ApplicationDTO dto,
	                              List<Long> monthlyCompanyPay,
	                              boolean noCompanyPay,
	                              boolean recomputeTerms) {
	    long appNo = updateApplication(dto, monthlyCompanyPay, noCompanyPay, recomputeTerms);
	    applicationDAO.updateSubmittedNow(appNo);

	    return appNo;
	}

	public boolean adminChecked(Long applicationNumber) {
		
		return applicationDAO.existsByApplicationNumber(applicationNumber) > 0 ? true : false;
	}

	// 심사중으로 변경
	public void updateStatusCode(Long appNo) {
		
		applicationDAO.updateStatusCode(appNo);
	}

}
