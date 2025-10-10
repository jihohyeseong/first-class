package first.example.firstclass.controller;

import java.util.HashMap;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import first.example.firstclass.domain.JoinDTO;
import first.example.firstclass.domain.UsernameCheckDTO;
import first.example.firstclass.service.JoinService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@Validated
public class JoinController {
	
	private final JoinService joinService;

	// 회원가입 페이지 이동
	@GetMapping("/join")
	public String joinPage() {
		
		return "join/join";
	}
	
	// 개인 회원 가입 step1
	@GetMapping("/join/individual/1")
	public String individualJoinPage1() {
		
		return "join/step1";
	}
	
	// 개인 회원 가입 step2
	@GetMapping("/join/individual/2")
	public String individualJoinPage2(){
		
		return "join/step2";
	}
	
	// 개인 회원 가입 step3
	@GetMapping("/join/individual/3")
	public String individualJoinPage3(){
		
		return "join/step3";
	}
	
	// 회원가입 스텝 3 db저장후 완료
	@PostMapping("/joinProc")
    public String joinProcess(@Valid JoinDTO joinDTO, BindingResult bindingResult, Model model) {
		
		if (bindingResult.hasErrors()) {
            Map<String, String> errorsMap = new HashMap<>();
            for (FieldError error : bindingResult.getFieldErrors()) {
                errorsMap.put(error.getField(), error.getDefaultMessage());
            }
            model.addAttribute("errors", errorsMap);
            model.addAttribute("joinDTO", joinDTO);
            
            return "join/step3"; 
        }
		
		if(joinService.existsByUsername(joinDTO.getUsername())) {
			model.addAttribute("idDuplicate", "이미 사용중인 아이디입니다.");
			return "join/step3";
		}
		joinService.joinProcess(joinDTO);
		
		return "join/end";
	}
	
	// 아이디 중복 검사
	@GetMapping(value = "/join/id/check", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> idDuplicateCheck(@Valid UsernameCheckDTO usernameCheckDTO, BindingResult bindingResult) {
		if (bindingResult.hasErrors()) {
	        String msg = bindingResult.getFieldError().getDefaultMessage();
	        return ResponseEntity.badRequest().body(msg);
	    }
	    boolean exists = joinService.existsByUsername(usernameCheckDTO.getUsername());
	    if (exists)
	        return ResponseEntity.status(HttpStatus.CONFLICT).body("이미 사용중인 아이디입니다.");
	    else
	        return ResponseEntity.status(HttpStatus.OK).body("사용 가능한 아이디입니다.");
	}
	
	// 아이디, 비밀번호 찾기 페이지
	@GetMapping("/find/account")
	public String findAccountPage() {
		
		return "account/accountfind";
	}
	
	// 아이디찾기 페이지
	@GetMapping("/find/account/id")
	public String findAccountIdPage() {
		
		return "account/find_id";
	}
	
	// 비밀번호찾기 페이지
	@GetMapping("/find/account/password")
	public String findAccountPasswordPage() {
		
		return "account/find_password";
	}
	
	// 비밀번호 찾기
	@PostMapping("/find/password")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> findPassword(@RequestParam String username,
            												@RequestParam String phoneNumber){
		
		Map<String, Object> response = new HashMap<>();
        boolean userExists = joinService.checkUserExists(username, phoneNumber);

        if (userExists) {
            response.put("success", true);
            response.put("redirectUrl", "/find/reset/password");
            response.put("username", username);
        } 
        else {
            response.put("success", false);
            response.put("message", "입력하신 정보와 일치하는 회원이 없습니다.");
        }
        return ResponseEntity.status(HttpStatus.OK).body(response);
	}
	
	// 비밀번호 변경 페이지
	@GetMapping("/find/reset/password")
	public String passwordResetPage() {
		
		return "account/reset_password";
	}
	
	// 새 비밀번호 생성
	@PostMapping("/find/password/new")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> setNewPassword(@RequestParam String username,
															  @RequestParam String newPassword){

		Map<String, Object> response = new HashMap<>();
		boolean updateSuccess = joinService.updatePassword(username, newPassword);
		
		if (updateSuccess) {
			response.put("success", true);
			response.put("redirectUrl", "/login");
		} 
		else {
			response.put("success", false);
			response.put("message", "비밀번호는 최소 8자 이상이어야 하며, 특수문자 하나 이상을 포함해야 합니다.");
		}
		return ResponseEntity.status(HttpStatus.OK).body(response);
	}
	
}
