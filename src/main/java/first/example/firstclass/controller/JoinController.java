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

	@GetMapping("/join")
	public String joinPage() {
		
		return "join";
	}
	
	@PostMapping("/joinProc")
    public String joinProcess(JoinDTO joinDTO) {
		
		joinService.joinProcess(joinDTO);
		
		return "redirect:/join/end";
	}
	
}
