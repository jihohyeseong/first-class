package first.example.firstclass.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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
	public String apply(Model model)  {
		// 1. SecurityContextHolder에서 현재 인증 정보를 직접 가져옴
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    // 2. 인증 정보에서 우리가 만든 CustomUserDetails 객체를 꺼냄
	    CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
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
