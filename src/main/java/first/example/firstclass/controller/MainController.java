package first.example.firstclass.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

	@GetMapping("/main")
	public String mainPage() {
		
		return "main";
	}
	
	@GetMapping("/calc")
	public String caculatorMain() {
		
		return "calcmain";
	}
}
