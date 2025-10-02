package first.example.firstclass.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminListController {
	
	@GetMapping("/adminlist")
	public String adminListShow() {
		
		return "adminlist";
	}

}
