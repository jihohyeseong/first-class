package first.example.firstclass.dao;

import org.apache.ibatis.annotations.Mapper;

import first.example.firstclass.domain.JoinDTO;
import first.example.firstclass.domain.UserVO;
import first.example.firstclass.domain.UserDTO;

@Mapper
public interface UserDAO {

	void save(JoinDTO joinDTO);

	UserVO findByUsername(String username);
	
	UserDTO findUserInfo(String username);

}
