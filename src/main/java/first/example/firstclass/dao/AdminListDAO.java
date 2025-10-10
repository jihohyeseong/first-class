package first.example.firstclass.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import first.example.firstclass.domain.AdminListDTO;
import first.example.firstclass.domain.PageDTO;

@Mapper
public interface AdminListDAO {
    //검색(이름, 상태) 조회
    List<AdminListDTO> selectApplicationList(@Param("keyword") String keyword, @Param("status") String status,
    		@Param("pageDTO") PageDTO pageDTO);

    //전체 조회
    int selectTotalCount(@Param("keyword") String keyword, @Param("status") String status);

    //처리 상태별 조회
    int selectStatusCount(@Param("statusCode") String statusCode);
    
    //대기중 합산
    int selectStatusCountIn(@Param("codes") List<String> codes);
}