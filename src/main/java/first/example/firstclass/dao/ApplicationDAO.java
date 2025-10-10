package first.example.firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import first.example.firstclass.domain.ApplicationDTO;
import first.example.firstclass.domain.ApplicationListDTO;
import first.example.firstclass.domain.CodeDTO;

@Mapper
public interface ApplicationDAO {
    int insertApplication(ApplicationDTO dto);
    int updateSubmittedNow(@Param("appNo") long appNo);
    ApplicationDTO selectApplicationById(long appNo);
    
    List<ApplicationListDTO> selectListByUserId(@Param("userId") long userId);
    
    List<CodeDTO> selectBankCode();

}
