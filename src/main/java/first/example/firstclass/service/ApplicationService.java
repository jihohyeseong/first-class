package first.example.firstclass.service;

import first.example.firstclass.dao.ApplicationDAO;
import first.example.firstclass.dao.TermAmountDAO;
import first.example.firstclass.domain.ApplicationDTO;
import first.example.firstclass.domain.ApplicationListDTO;
import first.example.firstclass.domain.TermAmountDTO;
import first.example.firstclass.util.AES256Util;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ApplicationService {

    private final ApplicationDAO applicationDAO;
    private final TermAmountDAO termAmountDAO;
    private final AES256Util aes256Util;

    /* ============================================================
       육아휴직 신청 등록 + 단위기간 계산 + 암호화
    ============================================================ */
    @Transactional
    public long createAllWithComputedPayment(ApplicationDTO dto,
                                             List<Long> monthlyCompanyPay,
                                             boolean noCompanyPay) {
        // 민감 정보 암호화
    	try {
    		dto.setChildResiRegiNumber(aes256Util.encrypt(dto.getChildResiRegiNumber()));
    	} catch (Exception e) {
    	    e.printStackTrace();
    	}

    	try {
    		dto.setAccountNumber(aes256Util.encrypt(dto.getAccountNumber()));
    	} catch (Exception e) {
    	    e.printStackTrace();
    	}
    	

        LocalDate start = toLocal(dto.getStartDate());
        LocalDate end   = toLocal(dto.getEndDate());
/*        if (start == null || end == null) {
            throw new IllegalArgumentException("신청 시작일 또는 종료일이 비어 있습니다.");
        }*/

        long regularWage = nz(dto.getRegularWage());

        // 1) 단위기간 계산 및 지급액 산출
        List<TermAmountDTO> terms = splitPeriodsAndCalc(start, end, regularWage, monthlyCompanyPay, noCompanyPay);

        // 2) 총 정부 지급액
        long totalGov = terms.stream()
                .mapToLong(t -> nz(t.getGovPayment()))
                .sum();
        dto.setPayment(totalGov);

        // 3) 신청서 저장
        applicationDAO.insertApplication(dto);
        long appNo = dto.getApplicationNumber();

        // 4) 단위기간 금액 저장
        if (!terms.isEmpty()) {
            for (TermAmountDTO t : terms) t.setApplicationNumber(appNo);
            termAmountDAO.insertBatch(terms);
        }

        // 5) 제출 상태(ST_20)일 경우 제출일시 업데이트
        if ("ST_20".equals(dto.getStatusCode())) {
            applicationDAO.updateSubmittedNow(appNo);
        }

        return appNo;
    }

    /* ============================================================
       단위기간 및 정부/회사 지급액 계산
    ============================================================ */
    private List<TermAmountDTO> splitPeriodsAndCalc(LocalDate startDate,
                                                    LocalDate endDate,
                                                    long regularWage,
                                                    List<Long> monthlyCompanyPay,
                                                    boolean noCompanyPay) {
        if (endDate.isBefore(startDate)) {
            throw new IllegalArgumentException("종료일이 시작일보다 빠릅니다.");
        }

        List<TermAmountDTO> result = new ArrayList<>();
        LocalDate periodStart = startDate;
        int monthIdx = 1;

        while (!periodStart.isAfter(endDate)) {
            LocalDate periodEnd = periodStart.plusMonths(1).minusDays(1);
            if (periodEnd.isAfter(endDate)) periodEnd = endDate;

            boolean isLast = periodEnd.equals(endDate);

            long companyPayment = (!noCompanyPay && monthlyCompanyPay != null && monthlyCompanyPay.size() >= monthIdx)
                    ? nz(monthlyCompanyPay.get(monthIdx - 1))
                    : 0L;

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

    /* 정부 지급액 계산 */
    private long calcGovPayment(long base, long companyPayment, LocalDate start, LocalDate end, boolean isLast) {
        if (!isLast) return Math.max(0L, base - companyPayment);

        YearMonth endYm = YearMonth.from(end);
        long daysInTerm = ChronoUnit.DAYS.between(start, end) + 1;
        long daysInEndMonth = endYm.lengthOfMonth();
        double ratio = Math.max(0.0, Math.min(1.0, (double) daysInTerm / daysInEndMonth));
        long prorated = Math.round(base * ratio);
        return Math.max(0L, prorated - companyPayment);
    }

    /* 정부 기본 지급액 */
    private long computeGovBase(long regularWage, int monthIdx) {
        if (monthIdx <= 3) return Math.min(regularWage, 2_500_000L);
        if (monthIdx <= 6) return Math.min(regularWage, 2_000_000L);
        long eighty = Math.round(regularWage * 0.8);
        return Math.min(eighty, 1_600_000L);
    }

    /* ============================================================
       조회 및 복호화
    ============================================================ */
    public ApplicationDTO findById(long appNo) {
        ApplicationDTO dto = applicationDAO.selectApplicationById(appNo);
        
    	try {
    		dto.setChildResiRegiNumber(aes256Util.decrypt(dto.getChildResiRegiNumber()));
    	} catch (Exception e) {
    	    e.printStackTrace();
    	}

    	try {
    		dto.setAccountNumber(aes256Util.decrypt(dto.getAccountNumber()));
    	} catch (Exception e) {
    	    e.printStackTrace();
    	}
        return dto;
    }

    public List<ApplicationListDTO> findListByUser(long userId) {
        return applicationDAO.selectListByUserId(userId);
    }

    public List<TermAmountDTO> findTerms(long appNo) {
        return termAmountDAO.selectByApplicationNumber(appNo);
    }

    /* ============================================================
       공통 유틸 메서드
    ============================================================ */
    private static long nz(Long v) { return v == null ? 0L : v; }

    private static LocalDate toLocal(Date d) {
        return (d == null) ? null : d.toLocalDate();
    }

}
