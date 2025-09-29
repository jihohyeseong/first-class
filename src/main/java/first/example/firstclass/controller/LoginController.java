package first.example.firstclass.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {

	@GetMapping("/login")
	public String loginPage() {
		
		return "login";
	}
	
	@GetMapping("/admin")
	public String adminTestPage() {
		
		return "admintest";
	}
}
