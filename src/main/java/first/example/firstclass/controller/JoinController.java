package first.example.firstclass.controller;

import java.util.HashMap;
import java.util.Map;

import javax.validation.Valid;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

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
	public ResponseEntity<String> idDuplicateCheck(@NotEmpty(message = "아이디를 입력해주세요.")
												   @Size(min = 5, max = 20, message = "아이디는 최소 5자 이상 최대 20자 이하여야 합니다.")
												   @Pattern(regexp = "^[a-zA-Z0-9]+$", message = "아이디는 영문자와 숫자만 사용할 수 있습니다.")
												   @RequestParam String username) {
		
	    boolean exists = joinService.existsByUsername(username);
	    if (exists)
	        return ResponseEntity.status(HttpStatus.CONFLICT).body("이미 사용중인 아이디입니다.");
	    else
	        return ResponseEntity.status(HttpStatus.OK).body("사용 가능한 아이디입니다.");
	}
	
}
