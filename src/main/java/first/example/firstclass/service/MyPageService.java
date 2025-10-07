package first.example.firstclass.service;

import org.springframework.stereotype.Service;

import first.example.firstclass.dao.MyPageDAO;
import first.example.firstclass.domain.UserDTO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MyPageService {
	
	private final MyPageDAO mypageDAO;
	
	//유저 정보 조회
	public UserDTO getUserInfoByUserName(String username) {
		return mypageDAO.findByUserName(username);
	}
	//주소 수정
	public boolean updateUserAddress(UserDTO userDTO) {
		int result = mypageDAO.updateAddress(userDTO);
		return result > 0; //수정 성공시 true
	}
}
