package first.example.firstclass.service;

import org.springframework.stereotype.Service;

import first.example.firstclass.dao.MyPageDAO;
import first.example.firstclass.domain.UserDTO;
import first.example.firstclass.util.AES256Util;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MyPageService {
	
	private final MyPageDAO mypageDAO;
	private final AES256Util aes256Util;
	
	//유저 정보 조회
	public UserDTO getUserInfoByUserName(String username) {
		UserDTO user = mypageDAO.findByUserName(username);
		// 주민번호 복호화
		try {
			user.setRegistrationNumber(aes256Util.decrypt(user.getRegistrationNumber()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}
	//주소 수정
	public boolean updateUserAddress(UserDTO userDTO) {
		int result = mypageDAO.updateAddress(userDTO);
		return result > 0; //수정 성공시 true
	}
}
