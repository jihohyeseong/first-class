package first.example.firstclass.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import first.example.firstclass.dao.UserDAO;
import first.example.firstclass.domain.JoinDTO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class JoinService {

	private final UserDAO userDAO;
	private final BCryptPasswordEncoder bCryptPasswordEncoder;

	public void joinProcess(JoinDTO joinDTO) {
		
		joinDTO.setPassword(bCryptPasswordEncoder.encode(joinDTO.getPassword()));
		joinDTO.setRole("ROLE_USER");
		joinDTO.setDeltAt("N");
		
		userDAO.save(joinDTO);
	}
	
	
}
