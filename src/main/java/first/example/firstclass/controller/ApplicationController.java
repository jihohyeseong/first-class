package first.example.firstclass.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ApplicationController {
	
	@GetMapping("/application")
	public String Apply() {
		
		return "applicationtest";
	}
	
	@GetMapping("/applicationComplete")
	public String ApplyComp() {
		
		return "applicationComplete";
	}
	
	@GetMapping("/applicationDetail")
	public String ApplyDet() {
		
		return "applicationDetail";
	}

}
