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

    /* ============================================================
       임시저장(ST_10) — 단일 insertApplication 사용
       - 필수값 검증 없음 (NULL 허용 스키마 + CHK 제약으로 커버)
       - submitted_dt는 매퍼 CASE WHEN으로 NULL
       - terms 미생성
    ============================================================ */
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

        // 임시저장도 공용 insert 사용
        applicationDAO.insertApplication(dto);

        // ❗ 여기서 null일 수 있음 → Long으로 안전하게 반환
        return dto.getApplicationNumber();
    }
    
    @Transactional
    public long saveDraftAndMaybeTerms(ApplicationDTO dto,
                                       List<Long> monthlyCompanyPay,
                                       boolean noCompanyPay) {
        // 1) 민감정보 암호화(값이 있을 때만)
        try {
            if (dto.getChildResiRegiNumber() != null && !dto.getChildResiRegiNumber().trim().isEmpty()) {
                dto.setChildResiRegiNumber(aes256Util.encrypt(dto.getChildResiRegiNumber()));
            }
            if (dto.getAccountNumber() != null && !dto.getAccountNumber().trim().isEmpty()) {
                dto.setAccountNumber(aes256Util.encrypt(dto.getAccountNumber()));
            }
        } catch (Exception e) { e.printStackTrace(); }

        // 2) 임시저장 상태
        dto.setStatusCode("ST_10");

        // 3) 부모 INSERT (하나의 insertApplication로 처리: submitted_dt는 ST_20일 때만 세팅됨)
        applicationDAO.insertApplication(dto);
        long appNo = dto.getApplicationNumber();

        // 4) 계산 가능한지 체크 (모두 들어오면 계산)
        if (readyForCalc(dto)) {
            LocalDate start = dto.getStartDate().toLocalDate();
            LocalDate end   = dto.getEndDate().toLocalDate();
            long regularWage = dto.getRegularWage();

            // 기존 term 싹 지우고 다시 넣기 (draft라도 재입력 가능)
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
        // 계산 불가능하면 term은 건드리지 않음(부족한 값은 NULL 그대로)
        return appNo;
    }

    private boolean readyForCalc(ApplicationDTO dto) {
        return dto.getStartDate() != null
            && dto.getEndDate()   != null
            && dto.getRegularWage()!= null
            && !dto.getEndDate().before(dto.getStartDate());
    }

    /* ============================================================
       제출(ST_20) — 단위기간 계산 + 총액 산출 + 단일 insertApplication
       - 컨트롤러에서 statusCode=ST_20 세팅 후 호출한다고 가정
       - 매퍼가 submitted_dt = SYSDATE로 자동 처리
    ============================================================ */
    @Transactional
    public long createAllWithComputedPayment(ApplicationDTO dto,
                                             List<Long> monthlyCompanyPay,
                                             boolean noCompanyPay) {
        // 선택 암호화
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

     // (2) 단위기간/지급액 계산
        List<TermAmountDTO> terms = splitPeriodsAndCalc(start, end, regularWage, monthlyCompanyPay, noCompanyPay);
        long totalGov = terms.stream().mapToLong(t -> nz(t.getGovPayment())).sum();
        dto.setPayment(totalGov);

        // (3) 신청서 저장 (ST_20이면 매퍼에서 submitted_dt 자동 세팅)
        applicationDAO.insertApplication(dto);
        Long appNo = dto.getApplicationNumber();

        // ⬇⬇⬇ 여기가 빠져 있어서 테이블이 안 만들어졌던 부분 ⬇⬇⬇
        if (appNo != null) {
            // 이전 단위기간 싹 지우고
            termAmountDAO.deleteTermsByAppNo(appNo);

            // 새 단위기간에 신청서 번호 채워서
            for (TermAmountDTO t : terms) t.setApplicationNumber(appNo);

            // 배치 저장
            if (!terms.isEmpty()) {
                termAmountDAO.insertBatch(terms);
            }

            // (옵션) 제출일시 보정 — 매퍼 CASE WHEN을 쓰지만, 보수적으로 한 번 더
            if ("ST_20".equals(dto.getStatusCode())) {
                applicationDAO.updateSubmittedNow(appNo);
            }
        }

        return appNo;
    }


    /* ============================================================
       단위기간 및 정부/회사 지급액 계산
    ============================================================ */
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
        LocalDate periodStart = startDate;
        int monthIdx = 1;

        while (!periodStart.isAfter(endDate)) {
            LocalDate nextSame = periodStart.plusMonths(1);
            boolean clamped = (nextSame.getDayOfMonth() != periodStart.getDayOfMonth());
            LocalDate periodEnd = clamped ? nextSame : nextSame.minusDays(1);
            if (periodEnd.isAfter(endDate)) periodEnd = endDate;

            boolean isLast = periodEnd.equals(endDate);

            long companyPayment = (!noCompanyPay && monthlyCompanyPay != null && monthlyCompanyPay.size() >= monthIdx)
                    ? nz(monthlyCompanyPay.get(monthIdx - 1)) : 0L;

            long base = computeGovBase(regularWage, monthIdx);
            long govPayment = calcGovPayment(base, companyPayment, periodStart, periodEnd, isLast);

            LocalDate paymentDate = periodEnd.withDayOfMonth(1).plusMonths(1);

            TermAmountDTO term = new TermAmountDTO();
            term.setStartMonthDate(Date.valueOf(periodStart));
            term.setEndMonthDate(Date.valueOf(periodEnd));
            term.setPaymentDate(Date.valueOf(paymentDate));
            term.setCompanyPayment(companyPayment);
            term.setGovPayment(govPayment);
            result.add(term);

            periodStart = periodEnd.plusDays(1);
            monthIdx++;
        }
        return result;
    }

    private long calcGovPayment(long base, long companyPayment, LocalDate start, LocalDate end, boolean isLast) {
        if (!isLast) return Math.max(0L, base - companyPayment);

        YearMonth endYm = YearMonth.from(end);
        long daysInTerm = ChronoUnit.DAYS.between(start, end) + 1;
        long daysInEndMonth = endYm.lengthOfMonth();
        double ratio = Math.max(0.0, Math.min(1.0, (double) daysInTerm / daysInEndMonth));
        long prorated = Math.round(base * ratio);
        return Math.max(0L, prorated - companyPayment);
    }

    private long computeGovBase(long regularWage, int monthIdx) {
        if (monthIdx <= 3) return Math.min(regularWage, 2_500_000L);
        if (monthIdx <= 6) return Math.min(regularWage, 2_000_000L);
        long eighty = Math.round(regularWage * 0.8);
        return Math.min(eighty, 1_600_000L);
    }
    
    @Transactional
    public void recalcAndReplaceTerms(long appNo,
                                      LocalDate start, LocalDate end,
                                      long regularWage,
                                      List<Long> monthlyCompanyPay,
                                      boolean noCompanyPay) {

        // 1) 기존 단위기간 삭제
        termAmountDAO.deleteTermsByAppNo(appNo);

        // 2) 새로 계산
        List<TermAmountDTO> terms = splitPeriodsAndCalc(
                start, end, regularWage, monthlyCompanyPay, noCompanyPay
        );
        for (TermAmountDTO t : terms) {
            t.setApplicationNumber(appNo);
        }

        // 3) 배치 저장 (비어있으면 스킵)
        if (!terms.isEmpty()) {
            termAmountDAO.insertBatch(terms);
        }
    }

    /* ============================================================
       조회
    ============================================================ */
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
    /* ============================================================
    신청서수정/삭제
 ============================================================ */
    
    @Transactional
    public long updateApplication(ApplicationDTO dto,
                                  List<Long> monthlyCompanyPay,
                                  boolean noCompanyPay,
                                  boolean recomputeTerms) {
        // 선택 암호화(값 전달된 경우만)
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

        // 도우미
        Predicate<String> blank = s -> (s == null || s.trim().isEmpty());
        BiConsumer<String,Object> req = (label, v) -> {
            if (v == null) errs.add(label);
            else if (v instanceof String && blank.test((String)v)) errs.add(label);
        };

        // 1) 기본 필드
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

        // 2) 날짜/상태 제약
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

        // 3) 자녀 정보
        // childBirthDate 는 무조건 필요
        req.accept("자녀 출생/예정일", app.getChildBirthDate());
        boolean bornMode = !blank.test(app.getChildName()) || !blank.test(app.getChildResiRegiNumber());
        if (bornMode) {
            req.accept("자녀 이름", app.getChildName());
            req.accept("자녀 주민등록번호", app.getChildResiRegiNumber());
        }
        // bornMode 가 아니면 출산예정일만으로 제출 가능(정책대로 유지)

        // 5) 금액/시간 유효값
        if (app.getRegularWage() != null && app.getRegularWage() <= 0) errs.add("통상임금(월)>0");
        if (app.getWeeklyHours() != null && app.getWeeklyHours() <= 0) errs.add("주당 소정근로시간>0");

        // 6) 단위기간 + 회사지급액
        if (terms == null || terms.isEmpty()) {
            errs.add("단위기간(월별 구간 없음)");
        } else {
            for (int i = 0; i < terms.size(); i++) {
                TermAmountDTO t = terms.get(i);
                if (t.getStartMonthDate() == null || t.getEndMonthDate() == null) {
                    errs.add("단위기간 " + (i+1) + "의 기간");
                }
                // 회사지급액은 null 금지(0 허용)
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


    /* ============================================================
       공통 유틸
    ============================================================ */
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
		
		// 이미 처리된 건인지 조건 추가하기
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

}
