package first.example.firstclass.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import first.example.firstclass.dao.UserDAO;
import first.example.firstclass.domain.UserDTO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {
	
    private final UserDAO userDAO;
    
    @Transactional(readOnly = true)
    public UserDTO findByUsername(String username) {
        return userDAO.findUserInfo(username);
    }
}
