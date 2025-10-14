package first.example.firstclass.controller;

import java.beans.PropertyEditorSupport;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import first.example.firstclass.domain.AdminJudgeDTO;
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

    /* ===== 바인딩: "", "4,534" -> null/숫자로 변환 ===== */
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        // java.sql.Date
        binder.registerCustomEditor(java.sql.Date.class, new PropertyEditorSupport() {
            @Override public void setAsText(String text) {
                if (text == null || text.trim().isEmpty()) { setValue(null); return; }
                setValue(Date.valueOf(text.trim())); // yyyy-MM-dd 기대
            }
        });
        // Long
        binder.registerCustomEditor(Long.class, new PropertyEditorSupport() {
            @Override public void setAsText(String text) {
                if (text == null || text.trim().isEmpty()) { setValue(null); return; }
                setValue(Long.parseLong(text.replaceAll(",", "")));
            }
        });
        // Integer
        binder.registerCustomEditor(Integer.class, new PropertyEditorSupport() {
            @Override public void setAsText(String text) {
                if (text == null || text.trim().isEmpty()) { setValue(null); return; }
                setValue(Integer.parseInt(text.replaceAll(",", "")));
            }
        });
    }

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
    public String detail(@RequestParam long appNo, Model model, RedirectAttributes redirectAttributes) {
        // 1) 로그인 확인
        UserDTO loginUser = currentUserOrNull();
        if (loginUser == null) return "redirect:/login";

        // 2) 신청서 조회
        ApplicationDTO app = applicationService.findById(appNo);
        if (app == null) {
            redirectAttributes.addFlashAttribute("error", "존재하지 않는 신청입니다.");
            return "redirect:/main";
        }

        // 3) 권한 체크 (신청자 본인 or 관리자)
        boolean isAdmin = hasRole("ROLE_ADMIN");
        if (!app.getUserId().equals(loginUser.getId()) && !isAdmin) {
            redirectAttributes.addFlashAttribute("error", "해당 신청 정보를 조회할 권한이 없습니다.");
            return "redirect:/main";
        }

        // 4) 신청자 정보 조회 (appNo로 조인 조회 or app.getUserId()로 조회)
        UserDTO user = applicationService.findApplicantByAppNo(appNo);
        // 마스킹은 화면에 표시할 user에 적용
        if (user != null && user.getRegistrationNumber() != null) {
            user.setRegistrationNumber(maskRrn(user.getRegistrationNumber()));
        }

        // 5) 단위기간 조회
        List<TermAmountDTO> terms = applicationService.findTerms(appNo);
        
        boolean isSubmitted =
        	    app.getSubmittedDt() != null ||
        	    "ST_20".equals(app.getStatusCode()) || // 제출완료
        	    "ST_30".equals(app.getStatusCode()) || // 심사중
        	    "ST_40".equals(app.getStatusCode());   // 심사완료 등

        // 6) 모델 바인딩
        model.addAttribute("app", app);
        model.addAttribute("terms", terms);
        model.addAttribute("isSubmitted", isSubmitted);
        model.addAttribute("userDTO", user);
        model.addAttribute("isAdmin", isAdmin);

        return "applicationDetail";
    }
    private String maskRrn(String rrn) {
        return (rrn != null && rrn.length() >= 8) ? rrn.substring(0, 7) + "******" : rrn;
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
        // 로그인 사용자
        UserDTO loginUser = currentUserOrNull();
        if (loginUser == null || loginUser.getId() == null) {
            ra.addFlashAttribute("error", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        form.setUserId(loginUser.getId());

        // 액션 분기
        String act = (action == null) ? "register" : action.toLowerCase();
        boolean isSubmit = "submit".equals(act);

        // 동의값: 임시저장에서는 값이 있을 때만 세팅(없으면 null 유지)
        String bizAgreeParam = request.getParameter("businessAgree");
        if (bizAgreeParam != null) form.setBusinessAgree(yn(bizAgreeParam));

        String govAgreeParam = request.getParameter("govInfoAgree");
        if (govAgreeParam != null) form.setGovInfoAgree(yn(govAgreeParam));

        // ===== 임시저장 분기 =====
        if (!isSubmit) {
            form.setStatusCode("ST_10");
            try {
                List<Long> monthlyCompanyPay = collectMonthlyCompanyPays(request); // <- 이 줄 추가
                long appNo = applicationService.saveDraftAndMaybeTerms(form, monthlyCompanyPay, noPayment);
                ra.addFlashAttribute("message", "임시저장 완료 (접수번호: " + appNo + ")");
                return "redirect:/apply/detail?appNo=" + appNo;
            } catch (Exception e) {
                log.error("임시저장 오류", e);
                ra.addFlashAttribute("error", "임시저장 중 오류: " + e.toString());
                return "redirect:/apply";
            }
        }

        // ===== 제출(SUBMIT) 분기: 엄격 검증 =====
        if (binding.hasErrors()) {
            ra.addFlashAttribute("error", "입력값 형식 오류: " + binding.getAllErrors());
            return "redirect:/apply";
        }

        // 제출은 동의 필수
/*        form.setBusinessAgree(ynRequired(request.getParameter("businessAgree")));
        form.setGovInfoAgree(ynRequired(request.getParameter("govInfoAgree")));*/

        // 자녀 출생/예정 날짜 보정
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

        // 출생 vs 예정 (제출 시 엄격)
        String childName = trimToEmpty(form.getChildName());
        String childRRN  = trimToEmpty(form.getChildResiRegiNumber());
        boolean isBorn   = (!childName.isEmpty() || !childRRN.isEmpty());
        if (isBorn) {
            if (childName.isEmpty() || childRRN.isEmpty()) {
                ra.addFlashAttribute("error", "출산으로 판단되었지만 자녀 이름/주민등록번호가 부족합니다.");
                return "redirect:/apply";
            }
            form.setChildName(childName);
            form.setChildResiRegiNumber(childRRN);
        } else {
            form.setChildName(null);
            form.setChildResiRegiNumber(null);
        }

        // 제출 상태
        form.setStatusCode("ST_20");

        // 월별 회사지급액
        List<Long> monthlyCompanyPay = collectMonthlyCompanyPays(request);

        try {
            long appNo = applicationService.createAllWithComputedPayment(form, monthlyCompanyPay, noPayment);
            ra.addFlashAttribute("appNo", appNo);
            ra.addFlashAttribute("message", "제출 완료 (접수번호: " + appNo + ")");
            return "redirect:/apply/complete?appNo=" + appNo;
        } catch (Exception e) {
            log.error("제출 저장 오류", e);
            ra.addFlashAttribute("error", "저장 중 오류: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            return "redirect:/apply";
        }
    }
    
    /* ======= 신청서 수정/삭제 ======= */
    @GetMapping("/apply/edit")
    public String edit(@RequestParam long appNo, Model model, RedirectAttributes ra) {
        UserDTO login = currentUserOrNull();
        if (login == null) return "redirect:/login";

        ApplicationDTO app = applicationService.findById(appNo);
        if (app == null) { ra.addFlashAttribute("error", "존재하지 않는 신청입니다."); return "redirect:/main"; }

        boolean isAdmin = hasRole("ROLE_ADMIN");
        if (!app.getUserId().equals(login.getId()) && !isAdmin) {
            ra.addFlashAttribute("error", "권한이 없습니다.");
            return "redirect:/main";
        }

        UserDTO user = applicationService.findApplicantByAppNo(appNo);
        if (user != null && user.getRegistrationNumber() != null) {
            user.setRegistrationNumber(maskRrn(user.getRegistrationNumber()));
        }
        
        List<TermAmountDTO> terms = applicationService.findTerms(appNo);

        model.addAttribute("app", app);
        model.addAttribute("userDTO", user);
        model.addAttribute("isAdmin", isAdmin);
        model.addAttribute("terms", terms);
        return "applicationEdit";
    }

    @PostMapping("/apply/edit")
    public String update(
            @ModelAttribute ApplicationDTO form,
            BindingResult binding,
            HttpServletRequest request,
            @RequestParam(name="action", required=false) String action,
            @RequestParam(name="noPayment", defaultValue="false") boolean noPayment,
            @RequestParam(name="recomputeTerms", defaultValue="true") boolean recomputeTerms,
            RedirectAttributes ra
    ) {
        UserDTO login = currentUserOrNull();
        if (login == null) {
            ra.addFlashAttribute("error","로그인이 필요합니다.");
            return "redirect:/login";
        }

        String bizAgree = request.getParameter("businessAgree");
        if (bizAgree != null) form.setBusinessAgree(yn(bizAgree));
        String govAgree = request.getParameter("govInfoAgree");
        if (govAgree != null) form.setGovInfoAgree(yn(govAgree));

        List<Long> monthlyCompanyPay = collectMonthlyCompanyPays(request);

        try {
            long appNo;

            if ("register".equals(action)) {
                // 🟢 임시저장
                appNo = applicationService.updateApplication(form, monthlyCompanyPay, noPayment, recomputeTerms);
                ra.addFlashAttribute("message", "임시저장 완료");
                return "redirect:/apply/detail?appNo=" + appNo;

            } else if ("submit".equals(action)) {
                appNo = applicationService.submitApplication(form, monthlyCompanyPay, noPayment, recomputeTerms);
                ra.addFlashAttribute("appNo", appNo);
                ra.addFlashAttribute("message", "제출이 완료되었습니다.");
                return "redirect:/apply/complete?appNo=" + appNo;

            } else {
                appNo = applicationService.updateApplication(form, monthlyCompanyPay, noPayment, recomputeTerms);
                ra.addFlashAttribute("message", "수정 완료");
                return "redirect:/apply/detail?appNo=" + appNo;
            }

        } catch (Exception e) {
            log.error("수정 오류", e);
            ra.addFlashAttribute("error", "수정 중 오류: " + e.getMessage());
            return "redirect:/apply/edit?appNo=" + form.getApplicationNumber();
        }
    }



    @PostMapping("/apply/delete")
    public String delete(@RequestParam long appNo, RedirectAttributes ra) {
        UserDTO login = currentUserOrNull();
        if (login == null) return "redirect:/login";

        ApplicationDTO app = applicationService.findById(appNo);
        if (app == null) { ra.addFlashAttribute("error", "이미 삭제되었거나 존재하지 않습니다."); return "redirect:/main"; }

        boolean isAdmin = hasRole("ROLE_ADMIN");
        if (!app.getUserId().equals(login.getId()) && !isAdmin) {
            ra.addFlashAttribute("error","권한이 없습니다.");
            return "redirect:/main";
        }

        applicationService.deleteApplication(appNo);
        ra.addFlashAttribute("message","삭제되었습니다.");
        return "redirect:/main";
    }

    /* ======= 공통 유틸 ======= */

    private UserDTO currentUserOrNull() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
            return null;
        }
        CustomUserDetails ud = (CustomUserDetails) auth.getPrincipal();
        return userService.findByUsername(ud.getUsername());
    }

    private boolean hasRole(String roleName) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) return false;
        return authentication.getAuthorities().stream()
                .anyMatch(ga -> ga.getAuthority().equals(roleName));
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

    private static String ynRequired(String v) {
        if (v == null) throw new IllegalArgumentException("동의 여부는 필수입니다.");
        return yn(v);
    }

    @GetMapping("/codes/banks")
    @ResponseBody
    public List<CodeDTO> banks() {
        return applicationService.getBanks();
    }
    
    // 관리자 지급
    @PostMapping("/admin/judge/approve")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> adminApprove(@RequestBody AdminJudgeDTO adminJudgeDTO){
    	
    	Map<String, Object> response = new HashMap<>();
    	UserDTO userDTO = currentUserOrNull();
        if (userDTO == null) {
        	response.put("success", false);
			response.put("message", "로그인 해주세요.");
			response.put("redirectUrl", "/login");
        }
        
        boolean updateSuccess = applicationService.adminApprove(adminJudgeDTO, userDTO.getId());
    	
    	if (updateSuccess) {
			response.put("success", true);
			response.put("redirectUrl", "/admin/applications");
		} 
		else {
			response.put("success", false);
			response.put("message", "이미 처리된 신청서입니다.");
			response.put("redirectUrl", "/admin/applications");
		}
    	
		return ResponseEntity.status(HttpStatus.OK).body(response);
    }
    
    // 관리자 부지급
    @PostMapping("/admin/judge/reject")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> adminReject(@RequestBody AdminJudgeDTO adminJudgeDTO){
    	
    	Map<String, Object> response = new HashMap<>();
    	UserDTO userDTO = currentUserOrNull();
        if (userDTO == null) {
        	response.put("success", false);
			response.put("message", "로그인 해주세요.");
			response.put("redirectUrl", "/login");
        }
    	
    	boolean updateSuccess = applicationService.adminReject(adminJudgeDTO, userDTO.getId());
    	
    	if (updateSuccess) {
			response.put("success", true);
			response.put("redirectUrl", "/admin/applications");
		} 
		else {
			response.put("success", false);
			response.put("message", "거절 사유를 선택해주세요.");
		}
    	
		return ResponseEntity.status(HttpStatus.OK).body(response);
    }
    
    @PostMapping("/apply/submit")
    public String submitDraft(@RequestParam("appNo") long appNo, RedirectAttributes ra) {
        System.out.println(">>> /apply/submit hit, appNo=" + appNo);

        String redirect;
        try {
            // 1) 로그인/권한
            UserDTO login = currentUserOrNull();
            if (login == null) {
                ra.addFlashAttribute("error", "로그인이 필요합니다.");
                redirect = "redirect:/login";
                System.out.println("[return] login==null -> " + redirect);
                return redirect;
            }

            ApplicationDTO app = applicationService.findById(appNo);
            if (app == null) {
                ra.addFlashAttribute("error", "존재하지 않는 신청입니다.");
                redirect = "redirect:/main";
                System.out.println("[return] app==null -> " + redirect);
                return redirect;
            }

            System.out.println("[check] owner: app.userId=" + app.getUserId() + ", login.id=" + login.getId());
            if (!Objects.equals(app.getUserId(), login.getId())) {
                ra.addFlashAttribute("error", "권한이 없습니다.");
                redirect = "redirect:/main";
                System.out.println("[return] owner mismatch -> " + redirect);
                return redirect;
            }

            System.out.println("[check] status=" + app.getStatusCode());
            if (!"ST_10".equals(app.getStatusCode())) {
                ra.addFlashAttribute("error", "이미 제출되었거나 제출할 수 없는 상태입니다.");
                redirect = "redirect:/apply/detail?appNo=" + appNo;
                System.out.println("[return] not ST_10 -> " + redirect);
                return redirect;
            }

            // 2) 단위기간 포함 검증
            List<TermAmountDTO> terms = applicationService.findTerms(appNo);
            System.out.println("[check] terms.size=" + (terms == null ? 0 : terms.size()));
            List<String> missing = applicationService.validateForSubmit(app, terms);
            if (!missing.isEmpty()) {
                ra.addFlashAttribute("error", "제출 불가: " + String.join(", ", missing));
                redirect = "redirect:/apply/detail?appNo=" + appNo;
                System.out.println("[return] missing -> " + missing + " / " + redirect);
                return redirect;
            }

            // 3) 제출 처리 (영향 행수 확인)
            int updated = applicationService.submitAndReturnCount(appNo);
            System.out.println("[update] submitted rows=" + updated);
            if (updated == 0) {
                ra.addFlashAttribute("error", "제출 처리 대상이 없습니다(이미 제출되었거나 submitted_dt NOT NULL).");
                redirect = "redirect:/apply/detail?appNo=" + appNo;
                System.out.println("[return] updated=0 -> " + redirect);
                return redirect;
            }

            ra.addFlashAttribute("message", "제출이 완료되었습니다.");
            redirect = "redirect:/apply/complete?appNo=" + appNo;
            System.out.println("[return] OK -> " + redirect);
            return redirect;

        } catch (Exception e) {
            ra.addFlashAttribute("error", "제출 중 오류: " + e.getMessage());
            redirect = "redirect:/apply/detail?appNo=" + appNo;
            System.out.println("[catch] " + e.getClass().getSimpleName() + ": " + e.getMessage());
            System.out.println("[return] catch -> " + redirect);
            return redirect;

        } finally {
            System.out.println("<<< /apply/submit finally appNo=" + appNo);
        }
    }



}
