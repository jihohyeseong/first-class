package first.example.firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import first.example.firstclass.domain.AdminJudgeDTO;
import first.example.firstclass.domain.ApplicationDTO;
import first.example.firstclass.domain.ApplicationListDTO;
import first.example.firstclass.domain.CodeDTO;
import first.example.firstclass.domain.UserDTO;

@Mapper
public interface ApplicationDAO {
    int insertApplication(ApplicationDTO dto);
    int updateSubmittedNow(@Param("appNo") long appNo);
    ApplicationDTO selectApplicationById(@Param("appNo") long appNo);
    
    List<ApplicationListDTO> selectListByUserId(@Param("userId") long userId);
    
    List<CodeDTO> selectBankCode();
    UserDTO selectUserByAppNo(@Param("appNo") long appNo);
    
	int updateApplicationJudge(AdminJudgeDTO adminJudgeDTO);
	
	int updateApplicationSelective(ApplicationDTO dto);
    int softDeleteApplication(@Param("appNo") long appNo);
	int existsByApplicationNumber(Long applicationNumber);
	void updateStatusCode(Long appNo);
}
