package first.example.firstclass.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import first.example.firstclass.domain.PageDTO;
import first.example.firstclass.service.AdminListService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminListController {

    private final AdminListService adminListService; 

    @GetMapping("/applications")
    public String showApplicationList(@RequestParam(value= "page", defaultValue="1") int page,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "status", required = false) String status,
            @RequestParam(value = "date", required = false) String date,
            Model model) {
    	
    	//페이징 DTO 생성
    	int pageSize = 10;
 		PageDTO pageDTO = new PageDTO(page, pageSize); 	// 10개씩 보여줌 
 		//서비스 호출
 		Map<String, Object> result = adminListService.getPagedApplicationsAndCounts(keyword, status, date, pageDTO);

	    model.addAttribute("applicationList", result.get("list"));
	    model.addAttribute("pageDTO", result.get("pageDTO"));
	    model.addAttribute("counts", result.get("counts"));
        
        // 사용자가 입력한 검색어와 상태를 다시 화면에 전달하여 유지시킴
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("date", date);

        return "adminlist";
    }
}