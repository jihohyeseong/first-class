package first.example.firstclass.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import first.example.firstclass.dao.UserDAO;
import first.example.firstclass.domain.JoinDTO;
import first.example.firstclass.util.AES256Util;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class JoinService {

	private final UserDAO userDAO;
	private final BCryptPasswordEncoder bCryptPasswordEncoder;
	private final AES256Util aes256Util;

	public void joinProcess(JoinDTO joinDTO) {
		
		joinDTO.setPassword(bCryptPasswordEncoder.encode(joinDTO.getPassword()));
		try {
			joinDTO.setRegistrationNumber(aes256Util.encrypt(joinDTO.getRegistrationNumber()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		joinDTO.setRole("ROLE_USER");
		joinDTO.setDeltAt("N");
		
		userDAO.save(joinDTO);
	}

	public boolean existsByUsername(String username) {
		
		return userDAO.existsByUsername(username);
	}

	public boolean checkUserExists(String username, String phoneNumber) {
		
		return userDAO.existsByUsernameAndPhoneNumber(username, phoneNumber);
	}

	public boolean updatePassword(String username, String newPassword) {
		
		String regex = "^(?=.*[!@#$%^&*(),.?\":{}|<>])[A-Za-z\\d!@#$%^&*(),.?\":{}|<>]{8,}$";
	    if (newPassword == null || !newPassword.matches(regex))
	        return false;
		String password = bCryptPasswordEncoder.encode(newPassword);
		return userDAO.updatePasswordByUsername(username, password) > 0 ? true : false;
	}

	public String findUsername(String name, String phoneNumber) {
		
		return userDAO.findUsernameByNameAndPhoneNumber(name, phoneNumber);
	}
	
	
}
