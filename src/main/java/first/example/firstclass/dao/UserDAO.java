package first.example.firstclass.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import first.example.firstclass.domain.JoinDTO;
import first.example.firstclass.domain.UserDTO;
import first.example.firstclass.domain.UserVO;

@Mapper
public interface UserDAO {

	void save(JoinDTO joinDTO);

	UserVO findByUsername(String username);
	
	UserDTO findUserInfo(String username);

	boolean existsByUsername(String username);
	
	UserDTO findById(Long id);

	boolean existsByUsernameAndPhoneNumber(@Param("username")String username, @Param("phoneNumber")String phoneNumber);

	int updatePasswordByUsername(@Param("username")String username, @Param("password")String password);

	String findUsernameByNameAndPhoneNumber(@Param("name")String name, @Param("phoneNumber")String phoneNumber);

}
