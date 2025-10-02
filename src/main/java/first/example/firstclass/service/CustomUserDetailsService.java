package first.example.firstclass.service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import first.example.firstclass.dao.UserDAO;
import first.example.firstclass.domain.CustomUserDetails;
import first.example.firstclass.domain.UserVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserDAO userDAO;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
    	
    	System.out.println("=============== 로그인 시도: " + username + " ===============");
        UserVO userData = userDAO.findByUsername(username);
        
        if (userData == null) {
            System.out.println(">>> DAO 결과: NULL (DB에서 사용자를 찾지 못함)");
            System.out.println("=====================================================");
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);
        } else {
            System.out.println(">>> DAO 결과: " + userData.toString());
            System.out.println("=====================================================");
        }

        return new CustomUserDetails(userData);
    }
    
    
}
