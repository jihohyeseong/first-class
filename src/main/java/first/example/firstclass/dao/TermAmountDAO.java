package first.example.firstclass.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import first.example.firstclass.domain.TermAmountDTO;

@Mapper
public interface TermAmountDAO {
    int insertBatch(List<TermAmountDTO> rows);
    
    List<TermAmountDTO> selectByApplicationNumber(@Param("appNo") long appNo);
}
