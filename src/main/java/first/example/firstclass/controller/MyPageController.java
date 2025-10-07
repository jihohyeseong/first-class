package first.example.firstclass.controller;

import java.security.Principal;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import first.example.firstclass.domain.UserDTO;
import first.example.firstclass.service.MyPageService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class MyPageController {
    private final MyPageService myPageService;
    
    //마이페이지 조회
    @GetMapping
    public String showMyPage(Principal principal, Model model) {
        if (principal == null) {
            return "redirect:/login";
        }
        
        String username = principal.getName();
        UserDTO userInfo = myPageService.getUserInfoByUserName(username);
        
        if (userInfo == null) {
            System.out.println("사용자 정보를 불러올 수 없음");
            return "redirect:/main"; 
        }
        
        model.addAttribute("user", userInfo);
        return "mypage";
    }
    
    //마이페이지 수정
    @PostMapping("/updateAddress")
    public String updateAddress(Principal principal,
                                @ModelAttribute UserDTO userDTO,
                                Model model) {
        if(principal == null) {
            return "redirect:/login";
        }
        
        userDTO.setUserName(principal.getName());
        boolean success = myPageService.updateUserAddress(userDTO);
        
        if(success) {
            model.addAttribute("message", "주소가 성공적으로 수정되었습니다!");
        } else {
            model.addAttribute("message", "주소 수정에 실패하였습니다.");
        }
        return "redirect:/mypage";
    }
}