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
	
	// 개인 회원 가입페이지 이동
	@GetMapping("/join/individual/1")
	public String individualJoinPage1() {
		
		return "join/step1";
	}
	
	// 회원가입 스텝 4
	@PostMapping("/joinProc")
    public String joinProcess(JoinDTO joinDTO) {
		
		joinService.joinProcess(joinDTO);
		
		return "redirect:/join/end";
	}
	
}
