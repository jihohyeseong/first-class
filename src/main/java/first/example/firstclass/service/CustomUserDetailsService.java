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
    	
        UserVO userData = userDAO.findByUsername(username);
        if (userData == null)
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다: " + username);

        return new CustomUserDetails(userData);
    }
    
    
}
