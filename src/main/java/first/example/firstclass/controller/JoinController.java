package first.example.firstclass.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import first.example.firstclass.domain.JoinDTO;
import first.example.firstclass.service.JoinService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
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
    public String joinProcess(JoinDTO joinDTO) {
		
		joinService.joinProcess(joinDTO);
		
		return "join/end";
	}
	
}
