package first.example.firstclass.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import first.example.firstclass.domain.CustomUserDetails;
import first.example.firstclass.domain.UserDTO;
import first.example.firstclass.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ApplicationController {

    private final UserService userService;
	
	@GetMapping("/apply")
	public String apply(@AuthenticationPrincipal CustomUserDetails userDetails , Model model)  {
		String username = userDetails.getUsername();
		UserDTO userDTO = userService.findByUsername(username);
		model.addAttribute("userDTO", userDTO);
		return "application";
	}
	
	@GetMapping("/apply/complete")
	public String applyComp() {
		
		return "applicationComplete";
	}
	
	@GetMapping("/apply/detail")
	public String applyDet() {
		
		return "applicationDetail";
	}

}
