package first.example.firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import first.example.firstclass.domain.CodeDTO;

@Mapper
public interface CodeDAO {

	List<CodeDTO> findAllRejectCode();
}
