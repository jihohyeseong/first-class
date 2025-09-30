package first.example.firstclass.dao;

import org.apache.ibatis.annotations.Mapper;

import first.example.firstclass.domain.JoinDTO;

@Mapper
public interface UserDAO {

	void save(JoinDTO joinDTO);

}
