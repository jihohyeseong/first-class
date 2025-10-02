package first.example.firstclass.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import first.example.firstclass.dao.UserDAO;
import first.example.firstclass.domain.UserDTO;
import first.example.firstclass.util.AES256Util;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {
	
    private final UserDAO userDAO;
    private final AES256Util aes256Util;
    
    @Transactional(readOnly = true)
    public UserDTO findByUsername(String username) {
    	UserDTO user = userDAO.findUserInfo(username);
    	try {
			user.setRegistrationNumber(aes256Util.decrypt(user.getRegistrationNumber()));
		} catch (Exception e) {
			e.printStackTrace();
		}
        return user;
    }
}
