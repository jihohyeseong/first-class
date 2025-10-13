package first.example.firstclass.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import first.example.firstclass.domain.TermAmountDTO;

@Mapper
public interface TermAmountDAO {
    int insertBatch(List<TermAmountDTO> list);
    
    List<TermAmountDTO> selectByApplicationNumber(@Param("appNo") long appNo);
    int deleteTermsByAppNo(@Param("appNo") long appNo);

}
