package first.example.firstclass.domain;

import lombok.Data;

@Data
public class PageDTO {
	 private int pageNum; // 현재 페이지 번호
	    private int listSize; // 페이지당 보여질 게시물 수
	    private int startList; // 시작 게시물 번호
	    private int endList; // 끝 게시물 번호
	    private int totalCnt; // 총 게시물 수

	    public PageDTO(int pageNum, int listSize) {
	        this.pageNum = pageNum;
	        this.listSize = listSize;
	        this.startList = (pageNum - 1) * listSize; 
	    }
	    
	    public int startPage;  // 페이지네이션 시작 페이지 번호
	    public int endPage;	   // 전체 페이지 개수
	    
	    public int paginationStart;
	    public int paginationEnd;
	    
	    public void setTotalCnt(int totalCnt) {
	        this.totalCnt = totalCnt;
	        int endPage = (int) Math.ceil((double) totalCnt / listSize);
	        if (endPage == 0) endPage = 1;  	// 전체 페이지가 0일 경우 최소 1페이지는 잇다고 보여줌 
	        int startPage = (pageNum - 1) / 10 * 10 + 1;
	        this.endPage = endPage;
	        this.startPage = startPage;
	        
	     // 현재 페이지에서의 마지막 게시물 번호
	        this.endList = Math.min(startList + listSize, totalCnt);
	     // 앞 뒤 2개씩 보여 주기 
	        int range = 2;
	        int start = pageNum - range;
	        int end = pageNum + range;
	        if(start<1) {
	        	end +=(1-start);
	        	start = 1;
	        }
	        if(end > endPage) {
	        	start -= (end-endPage);
	        	end = endPage;
	        	
	        	if (start < 1) {
	                   start = 1;
	               }
	        }
	        
	        this.paginationStart = start;
	        this.paginationEnd = end;
	    }
}
