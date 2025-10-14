package first.example.firstclass.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import first.example.firstclass.dao.AdminListDAO;
import first.example.firstclass.domain.AdminListDTO;
import first.example.firstclass.domain.ApplicationSearchDTO;
import first.example.firstclass.domain.PageDTO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminListService {

    private final AdminListDAO adminListDAO;

    public Map<String, Object> getPagedApplicationsAndCounts(String keyword, String status, String date,
    		PageDTO pageDTO) {
        Map<String, Object> result = new HashMap<>();
        
        // 검색 조건에 맞는 게시물 조회
        int totalCnt = adminListDAO.selectTotalCount(keyword, status, date);
        pageDTO.setTotalCnt(totalCnt); // PageDTO에 총 개수 설정 -> 페이징 계산 완료
        
        // DTO로 묶어서 전달
        ApplicationSearchDTO search = new ApplicationSearchDTO();
        search.setKeyword(keyword);
        search.setStatus(status);
        search.setDate(date);
        search.setPageDTO(pageDTO);

        List<AdminListDTO> applicationList = adminListDAO.selectApplicationList(search);

        // 상태별 건수 조회
        Map<String, Integer> counts = new HashMap<>();
        
        // 전체 신청 건수
        counts.put("total", adminListDAO.selectTotalCount(null, null, null));

        // 대기 건수 ='제출'(ST_20) + '심사중'(ST_30)
        List<String> pendingStatusCodes = Arrays.asList("ST_20", "ST_30");
        counts.put("pending", adminListDAO.selectStatusCountIn(pendingStatusCodes));
        
        // 승인/반려
        counts.put("approved", adminListDAO.selectStatusCount("ST_40", "Y"));
        counts.put("rejected", adminListDAO.selectStatusCount("ST_40", "N")); 
        
        //결과 반환
        result.put("list", applicationList);
        result.put("pageDTO", pageDTO);
        result.put("counts", counts);

        return result;
    }
}