<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>육아휴직 급여 신청서 상세 보기</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
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
  --warning-bg-color:#fff3cd;
  --warning-border-color:#ffeeba;
  --warning-text-color:#856404;
  --shadow-sm:0 1px 3px rgba(0,0,0,0.05);
  --shadow-md:0 4px 8px rgba(0,0,0,0.07);
}

/* 기본 스타일 */
*{margin:0;padding:0;box-sizing:border-box}
html{height:100%}
body{
  display:flex;flex-direction:column;min-height:100vh;
  font-family:'Noto Sans KR',sans-serif;background-color:var(--light-gray-color);
  color:var(--dark-gray-color);
}
a{text-decoration:none;color:inherit}

.header,.footer{
  background-color:var(--white-color);padding:15px 40px;border-bottom:1px solid var(--border-color);box-shadow:var(--shadow-sm);
}
.footer{border-top:1px solid var(--border-color);border-bottom:none;text-align:center;padding:20px 0;margin-top:auto}
.header{display:flex;justify-content:space-between;align-items:center;position:sticky;top:0;z-index:10}
.header nav{display:flex;align-items:center;gap:15px}
.header .welcome-msg{font-size:16px}

.main-container{
  flex-grow:1;width:100%;max-width:850px;margin:40px auto;padding:40px;
  background-color:var(--white-color);border-radius:12px;box-shadow:var(--shadow-md);
}

h1{text-align:center;margin-bottom:10px;font-size:28px}
h2{
  color:var(--primary-color);border-bottom:2px solid var(--primary-light-color);
  padding-bottom:10px;margin-bottom:25px;font-size:20px;
}

/* 섹션 타이틀 */
.section-title{
  font-size:20px;font-weight:700;color:var(--dark-gray-color);
  margin-bottom:15px;border-left:4px solid var(--primary-color);padding-left:10px;
}

/* 테이블 */
.info-table-container{margin-bottom:30px}
.info-table{
  width:100%;border-collapse:collapse;
  border-top:2px solid var(--border-color);
  border-left:none;border-right:none;
}
.info-table th,.info-table td{
  padding:12px 15px;border:1px solid var(--border-color);
  text-align:left;font-size:15px;
}
.info-table th{
  background-color:var(--light-gray-color);
  font-weight:500;width:150px;color:var(--dark-gray-color);
}
.info-table td{background-color:var(--white-color);color:#333}
.info-table.table-4col th{width:120px;background-color:var(--light-gray-color)}
.info-table.table-4col td{width:auto}
.info-table.table-4col th,.info-table.table-4col td{border-top:none}
.info-table tr:first-child th,.info-table tr:first-child td{border-top:1px solid var(--border-color)}

/* 버튼 */
.btn{
  display:inline-block;padding:10px 20px;font-size:15px;font-weight:500;
  border-radius:8px;border:1px solid var(--border-color);cursor:pointer;
  transition:all .2s ease-in-out;text-align:center;
}
.btn-primary{background-color:var(--primary-color);color:#fff;border-color:var(--primary-color)}
.btn-primary:hover{background-color:#364ab1;box-shadow:var(--shadow-md);transform:translateY(-2px)}
.btn-secondary{background-color:var(--white-color);color:var(--gray-color);border-color:var(--border-color)}
.btn-secondary:hover{background-color:var(--light-gray-color);color:var(--dark-gray-color);border-color:#ccc}
.btn-logout{background-color:var(--dark-gray-color);color:#fff;border:none}
.btn-logout:hover{background-color:#555}

/* 하단 버튼 컨테이너 */
.button-container{text-align:center;margin-top:50px}
.bottom-btn{padding:12px 30px;font-size:1.1em}
#edit-btn{background-color:var(--primary-color);color:#fff;border-color:var(--primary-color)}
#edit-btn:hover{background-color:#364ab1;border-color:#364ab1;transform:translateY(-2px)}

.data-title{font-weight:500}
.detail-btn{
  border:1px solid var(--primary-color);color:var(--primary-color);
  background-color:var(--white-color);padding:3px 8px;font-size:14px;
  margin-left:10px;border-radius:4px;cursor:pointer;transition:background-color .1s;
}
.detail-btn:hover{background-color:var(--primary-light-color)}
.success-text{color:var(--success-color);font-weight:500}
</style>
</head>
<body>
 <header class="header">
        <a href="${pageContext.request.contextPath}/main" class="logo"><img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" width="80" height="80"></a>
        <nav>
            <sec:authorize access="isAnonymous()">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">로그인</a>
            </sec:authorize>
            <sec:authorize access="isAuthenticated()">
                <span class="welcome-msg">
                    <sec:authentication property="principal.username"/>님, 환영합니다.
                </span>
                <form id="logout-form" action="${pageContext.request.contextPath}/logout" method="post" style="display: none;">
                    <sec:csrfInput/>
                </form>
                <a href="#" onclick="document.getElementById('logout-form').submit(); return false;" class="btn btn-logout">로그아웃</a>
            </sec:authorize>
        </nav>
    </header>

<main class="main-container">
  <h1>육아휴직 급여 신청서 상세 보기</h1>

  <!-- 접수정보 -->
  <div class="info-table-container">
    <h2 class="section-title">접수정보</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th class="data-title">접수번호</th>
					<td><c:out value="${app.applicationNumber}" /></td>
					<th class="data-title">민원내용</th>
					<td>육아휴직 급여 신청</td>
				</tr>
				<tr>
					<th class="data-title">신청일</th>
					<td><c:choose>
							<c:when test="${not empty app.submittedDt}">
								<fmt:formatDate value="${app.submittedDt}" pattern="yyyy-MM-dd" />
							</c:when>
							<c:otherwise>미신청</c:otherwise>
						</c:choose></td>
					<th class="data-title">신청인</th>
					<td><sec:authentication property="principal.username" /></td>
				</tr>
			</tbody>
		</table>
	</div>

  <!-- 신청인 정보 -->
  <div class="info-table-container">
    <h2 class="section-title">신청인 정보 (육아휴직자)</h2>
    <table class="info-table table-4col">
      <tbody>
        <tr>
          <th>이름</th>
          <td><c:out value="${userDTO.name}"/></td>
          <th>주민등록번호</th>
          <td><c:out value="${userDTO.registrationNumber}"/></td>
        </tr>
        <tr>
          <th>휴대전화번호</th>
          <td><c:out value="${userDTO.phoneNumber}"/></td>
        </tr>
        <tr>
          <th>주소</th>
          <td colspan="3"><c:out value="${userDTO.zipNumber} ${userDTO.addressBase} ${userDTO.addressDetail}"/></td>
        </tr>
      </tbody>
    </table>
  </div>

  <!-- 사업장 정보 -->
	<div class="info-table-container">
		<h2 class="section-title">사업장 정보 (회사)</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>사업장 동의여부</th>
					<td><c:choose>
							<c:when test="${app.businessAgree == 'Y'}">예</c:when>
							<c:when test="${app.businessAgree == 'N'}">아니요</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
					<th>사업장 이름</th>
					<td>${app.businessName}</td>
				</tr>
				<tr>
					<th>사업장 등록번호</th>
					<td>${app.businessRegiNumber}</td>
					
					<th>인사담당자 연락처</th>
					<td>02-9876-5432</td>
				</tr>
				<tr>
					<th>사업장 주소</th>
					<td colspan="3">(${app.businessZipNumber})
						${app.businessAddrBase} ${app.businessAddrDetail}</td>
				</tr>
			</tbody>
		</table>
	</div>

	<!-- 급여 신청 기간 -->
	<div class="info-table-container">
		<h2 class="section-title">급여 신청 기간 및 월별 내역</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>육아휴직 시작일</th>
					<td>2025.01.01</td>
					<th>총 휴직 기간</th>
					<td>6개월 (2025.01.01 ~ 2025.06.30)</td>
				</tr>
				<tr>
					<th>월별 분할 신청 여부</th>
					<td colspan="3">아니오 (일괄 신청)</td>
				</tr>
			</tbody>
		</table>

		<h3 class="section-title" style="font-size: 16px; margin-top: 25px;">월별
			지급 내역</h3>
		<table class="info-table table-4col">
			<thead>
				<tr>
					<th>회차</th>
					<th>기간</th>
					<th>사업장 지급액</th>
					<th>정부 지급액</th>
					<th>지급예정일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="t" items="${terms}" varStatus="st">
					<tr>
						<td><c:out value="${st.index + 1}" />개월차</td>
						<td><c:out value="${t.startMonthDate}" /> ~ <c:out
								value="${t.endMonthDate}" /></td>
						<td><fmt:formatNumber value="${t.companyPayment}"
								type="number" /></td>
						<td><fmt:formatNumber value="${t.govPayment}" type="number" /></td>
						<td><c:out value="${t.paymentDate}" /></td>
					</tr>
				</c:forEach>

				<c:if test="${empty terms}">
					<tr>
						<td colspan="5" style="text-align: center; color: #888;">단위기간
							내역이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>

	</div>

	<!-- 자녀 정보 -->
	<div class="info-table-container">
		<h2 class="section-title">자녀 정보 (육아 대상)</h2>
		<table class="info-table table-4col">
			<tbody>
				<c:choose>
					<c:when
						test="${empty app.childName and empty app.childResiRegiNumber}">
						<tr>
							<th>출산예정일</th>
							<td colspan="3"><fmt:formatDate
									value="${app.childBirthDate}" pattern="yyyy.MM.dd" /></td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr>
							<th>자녀 이름</th>
							<td><c:out value="${app.childName}" /></td>
							<th>출산(예정)일</th>
							<td><fmt:formatDate value="${app.childBirthDate}"
									pattern="yyyy.MM.dd" /></td>
						</tr>
						<tr>
							<th>주민등록번호</th>
							<td colspan="3"><c:choose>
									<c:when test="${not empty app.childResiRegiNumber}">
										<c:out value="${fn:substring(app.childResiRegiNumber, 0, 7)}" />******
                </c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose></td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>

	<!-- 계좌 정보 -->
	<div class="info-table-container">
  <h2 class="section-title">급여 입금 계좌정보</h2>
  <table class="info-table table-4col">
    <tbody>
      <tr>
        <th>은행</th>
          <td><c:out value="${app.bankName}"/></td>
        <th>계좌번호</th>
        <td>
          <c:choose>
            <c:when test="${not empty app.accountNumber}">
              <c:set var="acc" value="${app.accountNumber}"/>
              <c:set var="len" value="${fn:length(acc)}"/>
              ****<c:out value="${fn:substring(acc, len - 4, len)}"/>
            </c:when>
            <c:otherwise>-</c:otherwise>
          </c:choose>
        </td>
      </tr>
      
      <tr>
        <th>예금주 이름</th>
        <td colspan="3">
          <c:out value="${userDTO.name}"/>
        </td>
      </tr>
    </tbody>
  </table>
</div>

	<!-- 센터 정보 -->
	<div class="info-table-container">
		<h2 class="section-title">접수 처리 센터 정보</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>관할센터</th>
					<td>서울 고용 복지 플러스 센터 <a
						href="https://www.work.go.kr/seoul/main.do"
						class="detail-btn">자세히 보기</a>
					</td>
					<th>대표전화</th>
					<td>02-2004-7301</td>
				</tr>
				<tr>
					<th>주소</th>
					<td colspan="3">서울 중구 삼일대로363 1층 (장교동)</td>
				</tr>
			</tbody>
		</table>
	</div>

	<!-- 행정정보 공동이용 동의 -->
	<div class="info-table-container">
		<h2 class="section-title">행정정보 공동이용 동의</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>동의 여부</th>
					<td colspan="3"><c:choose>
							<c:when test="${app.govInfoAgree == 'Y'}">예</c:when>
							<c:when test="${app.govInfoAgree == 'N'}">아니요</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
				</tr>
			</tbody>
		</table>
	</div>

	<!-- 최종 동의 -->
	<div class="info-table-container">
		<h2 class="section-title">최종 동의 및 확인</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>부정수급 안내 확인</th>
					<td colspan="3"><span class="success-text">확인 및 동의 완료</span>
						(2025.10.02)</td>
				</tr>
			</tbody>
		</table>
	</div>

	<!-- 하단 버튼 -->
<div class="button-container">
  <a href="${pageContext.request.contextPath}/apply/edit?appNo=${app.applicationNumber}"
     class="btn bottom-btn btn-primary">신청 내용 수정</a>

  <a href="${pageContext.request.contextPath}/main"
     class="btn bottom-btn btn-secondary" style="margin-left:15px;">목록으로 돌아가기</a>

  <c:choose>
    <c:when test="${isSubmitted}">
      <button class="btn bottom-btn btn-secondary" style="margin-left:15px;" disabled>제출 완료</button>
    </c:when>
    <c:otherwise>
      <form action="${pageContext.request.contextPath}/apply/submit" method="post" style="display:inline;">
        <sec:csrfInput/>
        <input type="hidden" name="appNo" value="${app.applicationNumber}"/>
        <button type="submit" class="btn bottom-btn btn-primary" style="margin-left:15px;">제출하기</button>
      </form>
    </c:otherwise>
  </c:choose>
</div>


<footer class="footer">
  <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>
</body>
</html>
