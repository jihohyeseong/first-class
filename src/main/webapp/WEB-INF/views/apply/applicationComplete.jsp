<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>육아휴직 급여 신청 완료</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
<style>
:root{
  --primary-color:#3f58d4;
  --primary-light-color:#f0f2ff;
  --white-color:#ffffff;
  --light-gray-color:#f8f9fa;
  --gray-color:#868e96;
  --dark-gray-color:#343a40;
  --border-color:#dee2e6;
  --success-color:#28a745;
  --shadow-sm:0 1px 3px rgba(0,0,0,0.05);
  --shadow-md:0 4px 8px rgba(0,0,0,0.07);
}

/* 기본 스타일 */
 * { margin: 0; padding: 0; box-sizing: border-box; }
   html { height: 100%; }
   body {
      display: flex; flex-direction: column; min-height: 100vh;
      font-family: 'Noto Sans KR', sans-serif; background-color: var(--light-gray-color);
      color: var(--dark-gray-color);
   }
   a { text-decoration: none; color: inherit; }
   
   .header, .footer {
      background-color: var(--white-color); padding: 15px 40px; border-bottom: 1px solid var(--border-color); box-shadow: var(--shadow-sm);
   }
   .footer { border-top: 1px solid var(--border-color); border-bottom: none; text-align: center; padding: 20px 0; }
   .header { display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 10; }
   .header nav { display: flex; align-items: center; gap: 15px; }
   .header .welcome-msg { font-size: 16px; }

.main-container{
  flex-grow:1;width:100%;max-width:850px;margin:40px auto;padding:40px;
  background-color:var(--white-color);border-radius:12px;box-shadow:var(--shadow-md);
  text-align:center;
}

/* 버튼 */
.btn{
  display:inline-block;padding:10px 20px;font-size:15px;font-weight:500;
  border-radius:8px;border:1px solid var(--border-color);cursor:pointer;
  transition:all .2s ease-in-out;text-align:center;
}
.btn-logout{background-color:var(--dark-gray-color);color:var(--white-color);border:none}
.btn-logout:hover{background-color:#555}
.btn-secondary{background-color:var(--white-color);color:var(--gray-color);border-color:var(--border-color)}
.btn-secondary:hover{background-color:var(--light-gray-color);color:var(--dark-gray-color);border-color:#ccc}
.btn-primary{background-color:var(--primary-color);color:var(--white-color);border-color:var(--primary-color)}
.btn-primary:hover{background-color:#364ab1;box-shadow:var(--shadow-md);transform:translateY(-2px)}

.info-table-container{width:100%;text-align:left;margin:0 auto 50px}
h2.section-title{
  font-size:20px;font-weight:700;color:var(--dark-gray-color);
  margin:25px 0 15px;padding-bottom:5px;border-bottom:2px solid var(--border-color);
  width:fit-content;
}

.info-table{
  width:100%;border-collapse:collapse;table-layout:fixed;
  border-top:2px solid var(--dark-gray-color);border-bottom:1px solid var(--border-color);
}
.info-table th,.info-table td{padding:12px 15px;border-bottom:1px solid var(--border-color);font-size:15px}
.info-table th{
  background-color:var(--light-gray-color);width:120px;font-weight:500;color:var(--gray-color);text-align:left;
}
.info-table td{color:var(--dark-gray-color);font-weight:400;word-break:break-all}
.info-table .data-title{width:150px;background-color:var(--light-gray-color);color:var(--gray-color);font-weight:500}

/* 2열 레이아웃 */
.table-2col th{width:120px}
.table-2col .data-title{width:120px}

/* 자세히 보기 버튼 */
.detail-btn{
  display:inline-block;padding:3px 8px;font-size:13px;font-weight:500;margin-left:10px;
  color:var(--primary-color);border:1px solid var(--primary-color);background-color:var(--primary-light-color);
  border-radius:4px;cursor:pointer;transition:all .2s;
}
.detail-btn:hover{background-color:var(--primary-color);color:var(--white-color)}


/* 성공 아이콘*/
.completion-icon {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background-color: var(--success-color);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 30px;
  animation: pop-in 0.5s ease-out forwards;
  margin: 0 auto 30px;
}

.completion-icon::after {
  content: '';
  width: 20px;
  height: 40px;
  border: solid var(--white-color);
  border-width: 0 8px 8px 0;
  transform: rotate(45deg);
}

/* 팝인 애니메이션 (가입완료 페이지와 동일) */
@keyframes pop-in {
  0%   { transform: scale(0);   opacity: 0; }
  80%  { transform: scale(1.1); opacity: 1; }
  100% { transform: scale(1);   opacity: 1; }
}

.main-container .button-container{
  display: flex;
  justify-content: center !important;
  align-items: center;
  gap: 16px;
  width: 100%; 
  margin-top: 50px;
  flex-wrap: wrap;
}

.main-container .button-container .btn{
  padding: 12px 30px;
  font-size: 1.1em;
}

</style>
</head>
<body>
<%@ include file="../header.jsp" %>

   
	<main class="main-container">                
	<div class="completion-icon"></div>
	       
	<div class="complete-message">신청이 정상적으로 완료되었습니다. </div>

	<div class="info-table-container">
		<h2 class="section-title">접수정보</h2>
		<table class="info-table">
			<tbody>
				<tr>
					<th class="data-title">접수번호</th>
					<td>${app.applicationNumber}</td>
					<th class="data-title">민원내용</th>
					<td>육아휴직 급여 신청</td>
				</tr>
				<tr>
					<th class="data-title">신청일</th>
					<td><fmt:formatDate value="${app.submittedDt}"
							pattern="yyyy-MM-dd" /></td>
					<th class="data-title">신청인</th>
					<td>${userDTO.name}</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="info-table-container">
		<h2 class="section-title">센터정보</h2>
		<table class="info-table table-2col">
			<tbody>
				<tr>
					<th class="data-title">센터명</th>
					<td colspan="3">서울 고용 복지 플러스 센터
						<button type="button" class="detail-btn" id="view-details-btn">자세히
							보기</button>
					</td>
				</tr>
				<tr>
					<th class="data-title">주소</th>
					<td colspan="3">서울 중구 삼일대로363 1층(장교동)</td>
				</tr>
				<tr>
					<th class="data-title">대표전화</th>
					<td>02-2004-7301</td>
				</tr>
			</tbody>
		</table>
	</div>
	                   
	<div class="button-container">
		<a href="/firstclass/main" class="btn btn-primary">확인 및 메인으로 이동</a> 
		<a href="${pageContext.request.contextPath}/apply/detail?appNo=${app.applicationNumber}"
			class="btn btn-secondary">신청 내용 상세 보기</a>
	</div>
	    </main>

	   
	<footer class="footer">
		<p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
	</footer>
</body>
</html>