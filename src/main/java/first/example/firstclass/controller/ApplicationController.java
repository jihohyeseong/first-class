package first.example.firstclass.controller;

import java.sql.Date;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import first.example.firstclass.domain.ApplicationDTO;
import first.example.firstclass.domain.CodeDTO;
import first.example.firstclass.domain.CustomUserDetails;
import first.example.firstclass.domain.TermAmountDTO;
import first.example.firstclass.domain.UserDTO;
import first.example.firstclass.service.ApplicationService;
import first.example.firstclass.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ApplicationController {

    private final UserService userService;
    private final ApplicationService applicationService;

    @GetMapping("/apply")
    public String apply(Model model) {
        UserDTO userDTO = currentUserOrNull();
        if (userDTO == null) return "redirect:/login";
        model.addAttribute("userDTO", userDTO);
        return "application";
    }

    @GetMapping("/apply/complete")
    public String complete(@RequestParam long appNo, Model model) {
        ApplicationDTO app = applicationService.findById(appNo);
        if (app == null) return "redirect:/main";
        model.addAttribute("app", app);
        return "applicationComplete";
    }

    @GetMapping("/apply/detail")
    public String detail(@RequestParam long appNo, Model model) {
        UserDTO loginUser = currentUserOrNull();
        if (loginUser == null) return "redirect:/login";

        ApplicationDTO app = applicationService.findById(appNo);
        List<TermAmountDTO> terms = applicationService.findTerms(appNo);

        if (loginUser.getRegistrationNumber() != null) {
            loginUser.setRegistrationNumber(maskRrn(loginUser.getRegistrationNumber()));
        }

        model.addAttribute("app", app);
        model.addAttribute("terms", terms);
        model.addAttribute("isSubmitted", "ST_20".equals(app.getStatusCode()));
        model.addAttribute("userDTO", loginUser);

        return "applicationDetail";
    }

    private String maskRrn(String rrn) {
        return (rrn != null && rrn.length() >= 8) ? rrn.substring(0,7) + "******" : rrn;
    }


    @GetMapping({"/", "/main"})
    public String main(Model model) {
        UserDTO user = currentUserOrNull();
        if (user != null && user.getId() != null) {
            model.addAttribute("applicationList", applicationService.findListByUser(user.getId()));
        }
        return "main";
    }

    @PostMapping("/apply")
    public String submit(
            @ModelAttribute ApplicationDTO form,
            BindingResult binding,
            HttpServletRequest request,
            @RequestParam(name = "noPayment", defaultValue = "false") boolean noPayment,
            @RequestParam(name = "action", required = false) String action,
            RedirectAttributes ra
    ) {
        // 1) 기본 검증
        if (binding.hasErrors()) {
            ra.addFlashAttribute("error", "입력값 형식 오류: " + binding.getAllErrors());
            return "redirect:/apply";
        }

        // 2) 로그인 사용자 매핑
        UserDTO loginUser = currentUserOrNull();
        if (loginUser == null || loginUser.getId() == null) {
            ra.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        form.setUserId(loginUser.getId());

        // 3) 자녀 정보 판별(출산 vs 예정)
        String childName = trimToEmpty(form.getChildName());
        String childRRN  = trimToEmpty(form.getChildResiRegiNumber());
        boolean isBorn   = (!childName.isEmpty() || !childRRN.isEmpty());

        // 4) 날짜 바인딩 보정(yyyy-MM-dd 가정, DTO는 java.sql.Date)
        if (form.getChildBirthDate() == null) {
            String birthStr = trimOrNull(request.getParameter("childBirthDate"));
            if (birthStr != null && !birthStr.isEmpty()) {
                try {
                    form.setChildBirthDate(Date.valueOf(birthStr));
                } catch (Exception e) {
                    ra.addFlashAttribute("error", "날짜 형식이 올바르지 않습니다(예: 2025-10-23).");
                    return "redirect:/apply";
                }
            }
        }
        if (form.getChildBirthDate() == null) {
            ra.addFlashAttribute("error", "자녀(출산/예정) 날짜를 입력하세요.");
            return "redirect:/apply";
        }

        if (isBorn) {
            if (childName.isEmpty() || childRRN.isEmpty()) {
                ra.addFlashAttribute("error", "출산으로 판단되었지만 자녀 이름/주민등록번호가 부족합니다.");
                return "redirect:/apply";
            }
            form.setChildName(childName);
            form.setChildResiRegiNumber(childRRN);
        } else {
            // 예정: 이름/주민번호는 null 처리
            form.setChildName(null);
            form.setChildResiRegiNumber(null);
        }

        // 5) 상태 코드 결정
        String act = (action == null) ? "register" : action.toLowerCase();
        form.setStatusCode("submit".equals(act) ? "ST_20" : "ST_10");

        // 6) 월별 회사지급액 수집
        List<Long> monthlyCompanyPay = collectMonthlyCompanyPays(request);

        // 7) 동의값
        form.setBusinessAgree(yn(request.getParameter("businessAgree")));
        form.setGovInfoAgree(yn(request.getParameter("govInfoAgree")));

        // 8) 서비스 호출(암호화 + 계산 + 저장 모두 서비스에 위임)
        try {
            long appNo = applicationService.createAllWithComputedPayment(form, monthlyCompanyPay, noPayment);

            ra.addFlashAttribute("appNo", appNo);
            ra.addFlashAttribute("message",
                    ("submit".equals(act) ? "제출 완료" : "임시저장 완료") + " (접수번호: " + appNo + ")");

            return "submit".equals(act)
                    ? "redirect:/apply/complete?appNo=" + appNo
                    : "redirect:/apply/detail?appNo=" + appNo;

        } catch (Exception e) {
            log.error("신청 저장 오류", e);
            ra.addFlashAttribute("error", "저장 중 오류: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            return "redirect:/apply";
        }
    }

    /* ===================== 유틸/헬퍼 ===================== */

    private UserDTO currentUserOrNull() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return null;
        }
        CustomUserDetails ud = (CustomUserDetails) auth.getPrincipal();
        return userService.findByUsername(ud.getUsername());
    }

    private static final Pattern DIGITS = Pattern.compile("\\d+");

    private static List<Long> collectMonthlyCompanyPays(HttpServletRequest request) {
        final String PREFIX = "monthly_payment_";
        List<String> keys = request.getParameterMap().keySet().stream()
                .filter(k -> k.startsWith(PREFIX))
                .filter(k -> DIGITS.matcher(k.substring(PREFIX.length())).matches())
                .sorted(Comparator.comparingInt(k -> Integer.parseInt(k.substring(PREFIX.length()))))
                .collect(Collectors.toList());

        List<Long> list = new ArrayList<>(keys.size());
        for (String k : keys) {
            String v = request.getParameter(k);
            try {
                list.add((v == null || v.trim().isEmpty()) ? 0L : Long.parseLong(v.replaceAll(",", "")));
            } catch (NumberFormatException e) {
                list.add(0L);
            }
        }
        return list;
    }

    private static String trimToEmpty(String s) { return s == null ? "" : s.trim(); }
    private static String trimOrNull(String s) { return s == null ? null : s.trim(); }
    private static String yn(String v) {
        if (v == null) return "N";
        String s = v.trim().toLowerCase();
        return ("y".equalsIgnoreCase(v) || "on".equals(s) || "true".equals(s) || "1".equals(s)) ? "Y" : "N";
    }
    
    @GetMapping("/codes/banks")
    @ResponseBody
    public List<CodeDTO> banks() {
        return applicationService.getBanks();
    }
    
    
}
