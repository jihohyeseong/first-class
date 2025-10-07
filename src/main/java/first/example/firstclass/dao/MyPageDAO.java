package first.example.firstclass.dao;

import org.apache.ibatis.annotations.Mapper;

import first.example.firstclass.domain.JoinDTO;
import first.example.firstclass.domain.UserVO;
import first.example.firstclass.domain.UserDTO;

@Mapper
public interface MyPageDAO {
	//사용자 정보 조회
	UserDTO findByUserName(String username);
	//주소 정보 수정
	int updateAddress(UserDTO userDTO);

}
