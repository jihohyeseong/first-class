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
<%-- =============================================== --%>
<%-- ============= [추가] jQuery CDN 링크 ============ --%>
<%-- =============================================== --%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
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

/* 모달 스타일 */
.modal-overlay{
    position:fixed;top:0;left:0;width:100%;height:100%;
    background-color:rgba(0,0,0,0.5);display:flex;
    justify-content:center;align-items:center;z-index:1000;
    transition: opacity 0.2s ease-in-out;
}
.modal-content{
    background-color:var(--white-color);padding:30px 40px;
    border-radius:12px;width:100%;max-width:500px;
    box-shadow:var(--shadow-md);
    transform: scale(0.95);
    transition: transform 0.2s ease-in-out;
}
.modal-overlay.visible .modal-content {
    transform: scale(1);
}
.modal-content h2{
    margin-top:0;text-align:center;color:var(--dark-gray-color);
    border-bottom:none;padding-bottom:0;margin-bottom:25px;
    font-size: 22px;
}
.form-group{margin-bottom:20px}
.form-group label{
    display:block;font-weight:500;margin-bottom:8px;font-size:16px;
}
.form-control{
    width:100%;padding:10px;font-size:15px;
    border:1px solid var(--border-color);border-radius:8px;
    font-family: 'Noto Sans KR', sans-serif;
}
textarea.form-control {
    resize: vertical;
}
.modal-buttons{
    display:flex;justify-content:flex-end;gap:10px;margin-top:30px;
}
</style>
</head>
<body>
	<header class="header">
		<a href="${pageContext.request.contextPath}${isAdmin ? '/admin/applications' : '/main'}" class="logo"><img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" width="80" height="80"></a>
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
					<td><c:out value="${userDTO.username}"/></td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="info-table-container">
		<h2 class="section-title">신청인 정보 (육아휴직자)</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>이름</th>
					<td colspan="3"><c:out value="${userDTO.name}" /></td>
				</tr>
				<tr>
					<th>주민등록번호</th>
					<td colspan="3"><c:set var="rrnRaw"
							value="${userDTO.registrationNumber}" /> <c:set var="rrnDigits"
							value="${fn:replace(fn:replace(fn:trim(rrnRaw), '-', ''), ' ', '')}" />
						${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,7)}******
					</td>
				</tr>
				<tr>
					<th>휴대전화번호</th>
					<td colspan="3"><c:out value="${userDTO.phoneNumber}" /></td>
				</tr>
				<tr>
					<th>주소</th>
					<td colspan="3"><c:out
							value="${userDTO.zipNumber} ${userDTO.addressBase} ${userDTO.addressDetail}" /></td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="info-table-container">
		<h2 class="section-title">사업장 정보 (회사)</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>사업장 <br>동의여부</th>
					<td><c:choose>
							<c:when test="${app.businessAgree == 'Y'}">예</c:when>
							<c:when test="${app.businessAgree == 'N'}">아니요</c:when>
							<c:otherwise>미선택</c:otherwise>
						</c:choose></td>
					<th>사업장 이름</th>
					<td>${empty app.businessName ? '미입력' : app.businessName}</td>
				</tr>
				<tr>
					<th>사업장 <br>등록번호</th>
					<td>${empty app.businessRegiNumber ? '미입력' : app.businessRegiNumber}</td>
					
					<th>인사담당자 <br>연락처</th>
					<td>02-9876-5432</td>
				</tr>
				<tr>
					<th>사업장 주소</th>
					<td colspan="3">
						<c:choose>
							<c:when test="${empty app.businessZipNumber and empty app.businessAddrBase and empty app.businessAddrDetail}">
								미입력
							</c:when>
							<c:otherwise>
								<c:if test="${not empty app.businessZipNumber}">
									(${app.businessZipNumber})&nbsp;
								</c:if>
								<c:out value="${app.businessAddrBase}"/>
								<c:if test="${not empty app.businessAddrDetail}">
									&nbsp;<c:out value="${app.businessAddrDetail}"/>
								</c:if>
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="info-table-container">
		<h2 class="section-title">급여 신청 기간 및 월별 내역</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>육아휴직 <br>시작일</th>
					<td>${empty app.startDate ? '미입력' : app.startDate}</td>
					<th>총 휴직 기간</th>
					<td>(${empty app.startDate ? '미입력' : app.startDate} ~ ${empty app.endDate ? '미입력' : app.endDate})</td>
				</tr>
				<tr>
					<th>월별 분할 <br>신청 여부</th>
					<td colspan="3">아니오 (일괄 신청)</td>
				</tr>
			</tbody>
		</table>

		<h3 class="section-title" style="font-size: 16px; margin-top: 25px;">월별 지급 내역</h3>
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
						<td><c:out value="${t.startMonthDate}" /> ~ <c:out value="${t.endMonthDate}" /></td>
						<td><fmt:formatNumber value="${t.companyPayment}" type="number" /></td>
						<td><fmt:formatNumber value="${t.govPayment}" type="number" /></td>
						<td><c:out value="${t.paymentDate}" /></td>
					</tr>
				</c:forEach>

				<c:if test="${empty terms}">
					<tr>
						<td colspan="5" style="text-align: center; color: #888;">단위기간 내역이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>

	</div>

	<div class="info-table-container">
		<h2 class="section-title">자녀 정보 (육아 대상)</h2>
		<table class="info-table table-4col">
			<tbody>
				<c:choose>
					<c:when test="${empty app.childName and empty app.childResiRegiNumber}">
						<tr>
							<th>출산예정일</th>
							<td colspan="3">
								<c:choose>
									<c:when test="${empty app.childBirthDate}">미입력</c:when>
									<c:otherwise>
										<fmt:formatDate value="${app.childBirthDate}" pattern="yyyy.MM.dd"/>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr>
							<th>자녀 이름</th>
							<td><c:out value="${app.childName}" /></td>
							<th>출산일</th>
							<td>
								<c:choose>
									<c:when test="${empty app.childBirthDate}">미입력</c:when>
									<c:otherwise>
										<fmt:formatDate value="${app.childBirthDate}" pattern="yyyy.MM.dd"/>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th>주민등록번호</th>
							<td colspan="3"><c:choose>
									<c:when test="${not empty app.childResiRegiNumber}">
										<c:out value="${fn:substring(app.childResiRegiNumber, 0, 7)}" />******
									</c:when>
									<c:otherwise>미입력</c:otherwise>
								</c:choose></td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>

	<div class="info-table-container">
		<h2 class="section-title">급여 입금 계좌정보</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>은행</th>
					<td><c:out value="${app.bankName}" default="미입력"/></td>
					<th>계좌번호</th>
					<td>
						<c:choose>
							<c:when test="${not empty app.accountNumber}">
								<c:set var="acc" value="${app.accountNumber}"/>
								<c:set var="len" value="${fn:length(acc)}"/>
								****<c:out value="${fn:substring(acc, len - 4, len)}"/>
							</c:when>
							<c:otherwise>미입력</c:otherwise>
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

	<div class="info-table-container">
		<h2 class="section-title">행정정보 공동이용 동의</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>동의 여부</th>
					<td colspan="3"><c:choose>
							<c:when test="${app.govInfoAgree == 'Y'}">예</c:when>
							<c:when test="${app.govInfoAgree == 'N'}">아니요</c:when>
							<c:otherwise>미선택</c:otherwise>
						</c:choose></td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="info-table-container">
		<h2 class="section-title">최종 동의 및 확인</h2>
		<table class="info-table table-4col">
			<tbody>
				<tr>
					<th>부정수급 <br>안내 확인</th>
					<td colspan="3"><span class="success-text">확인 및 동의 완료</span>
						(2025.10.02)</td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="button-container">
		<c:choose>
			<c:when test="${isAdmin}">
				<button type="button" class="btn bottom-btn btn-primary approve-btn">지급</button>

				<form id="reject-form"
					action="${pageContext.request.contextPath}/apply/reject"
					method="post" style="display: inline;">
					<sec:csrfInput />
					<input type="hidden" name="appNo" value="${app.applicationNumber}" />
					<input type="hidden" name="rejectCode" id="hidden-reject-code" /> <input
						type="hidden" name="rejectDetail" id="hidden-reject-detail" />
					<button type="button" id="reject-btn"
						class="btn bottom-btn btn-secondary" style="margin-left: 15px;">부지급</button>
				</form>
			</c:when>

			<c:otherwise>
				<a href="${pageContext.request.contextPath}/main"
					class="btn bottom-btn btn-secondary">목록으로 돌아가기</a>

				<c:choose>
					<c:when test="${isSubmitted}">
						<button class="btn bottom-btn btn-secondary"
							style="margin-left: 15px;" disabled>제출 완료</button>
					</c:when>
					<c:otherwise>
						<!-- 임시저장 상태(ST_10)에서만 노출되는 버튼들 -->
						<a
							href="${pageContext.request.contextPath}/apply/edit?appNo=${app.applicationNumber}"
							class="btn bottom-btn btn-primary" style="margin-left: 15px;">신청
							내용 수정</a>

						<form action="${pageContext.request.contextPath}/apply/submit"
							method="post" style="display: inline;">
							<sec:csrfInput />
							<input type="hidden" name="appNo"
								value="${app.applicationNumber}" />
							<button type="submit" class="btn bottom-btn btn-primary"
								style="margin-left: 15px;">제출하기</button>
						</form>

						<form action="${pageContext.request.contextPath}/apply/delete"
							method="post" style="display: inline;">
							<sec:csrfInput />
							<input type="hidden" name="appNo"
								value="${app.applicationNumber}" />
							<button type="submit" class="btn bottom-btn btn-secondary"
								style="margin-left: 15px;"
								onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
						</form>
					</c:otherwise>
				</c:choose>
			</c:otherwise>

		</c:choose>
	</div>
</main>

<%-- 부지급 사유 모달 --%>
<div id="reject-modal" class="modal-overlay" style="display:none;">
    <div class="modal-content">
        <h2>부지급 사유 입력</h2>
        <div class="form-group">
            <label for="reject-code">거절 사유</label>
            <select id="reject-code" name="rejectCode" class="form-control" required>
                <option value="">사유를 선택하세요</option>
            </select>
        </div>
        <div class="form-group">
            <label for="reject-detail">상세 사유</label>
            <textarea id="reject-detail" name="rejectDetail" class="form-control" rows="5" placeholder="상세 거절 사유를 입력하세요. (선택사항)"></textarea>
        </div>
        <div class="modal-buttons">
            <button type="button" id="cancel-reject-btn" class="btn btn-secondary">취소</button>
            <button type="button" id="confirm-reject-btn" class="btn btn-primary">확인</button>
        </div>
    </div>
</div>

<footer class="footer">
	<p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
</footer>

<script>
	$(function() {
	    const rejectModal = $('#reject-modal');
	    const rejectForm = $('#reject-form');
		
	    // 지급
	    $('.approve-btn').on('click', function() {
	        
	        if (confirm('지급확정하시겠습니까?')) {
	            const applicationNumber = ${param.appNo};

	            const requestData = {
	                applicationNumber: applicationNumber
	            };

	            $.ajax({
	                url: '${pageContext.request.contextPath}/admin/judge/approve',
	                type: 'POST',
	                contentType: 'application/json',
	                data: JSON.stringify(requestData),
	                success: function(data) {
	                    if (data.message) {
	                        alert(data.message);
	                    }

	                    if (data.redirectUrl) {
	                        window.location.href = '${pageContext.request.contextPath}' + data.redirectUrl;
	                    }
	                },
	                error: function(xhr, status, error) {
	                    console.error('Error:', error);
	                    alert('오류가 발생했습니다. 다시 시도해주세요.');
	                }
	            });
	        }
	    });
	    
	    // '부지급' 버튼 클릭 이벤트
	    $('#reject-btn').on('click', function(event) {
	        event.preventDefault();
	
	        $.ajax({
	            url: '${pageContext.request.contextPath}/code/reject',
	            type: 'GET',
	            dataType: 'json',
	            success: function(data) {
	                const rejectCodeSelect = $('#reject-code');
	                rejectCodeSelect.html('<option value="">사유를 선택하세요</option>'); // 기존 옵션 초기화
	
	                $.each(data, function(index, item) {
	                    rejectCodeSelect.append($('<option>', {
	                        value: item.code,
	                        text: item.name
	                    }));
	                });
	
	                rejectModal.css('display', 'flex');
	                setTimeout(() => rejectModal.addClass('visible'), 10);
	            },
	            error: function(xhr, status, error) {
	                console.error("AJAX Error: ", status, error);
	                alert('거절 사유 목록을 불러오는 데 실패했습니다. 잠시 후 다시 시도해주세요.');
	            }
	        });
	    });
	
	    $('#confirm-reject-btn').on('click', function() {
	        const selectedCode = $('#reject-code').val();
	        const detailReason = $('#reject-detail').val();
	
	        const applicationNumber = ${param.appNo};
	
	        const requestData = {
	            applicationNumber: applicationNumber,
	            rejectionReasonCode: selectedCode,
	            rejectComment: detailReason
	        };
	
	        // AJAX POST 요청
	        $.ajax({
	            url: '${pageContext.request.contextPath}/admin/judge/reject',
	            type: 'POST',
	            contentType: 'application/json',
	            data: JSON.stringify(requestData),
	            dataType: 'json',
	            success: function(response) {
	                if (response.success) {
	                    alert('부지급 처리가 완료되었습니다.');
	                    window.location.href = '${pageContext.request.contextPath}' + response.redirectUrl;
	                } else {
	                	console.log(response);
	                    let errorMessage = response.message || '처리 중 오류가 발생했습니다.';
	                    alert(errorMessage);
	                    if (response.redirectUrl) {
	                        window.location.href = '${pageContext.request.contextPath}' + response.redirectUrl;
	                    }
	                }
	            },
	            error: function(xhr, status, error) {
	                console.error("부지급 처리 AJAX Error: ", status, error);
	                alert('서버와의 통신 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
	            }
	        });
	    });
	
	    // 모달 '취소' 버튼 이벤트
	    $('#cancel-reject-btn').on('click', function() {
	        closeModal();
	    });
	
	    // 모달 외부 영역 클릭 시 닫기
	    rejectModal.on('click', function(event) {
	        if (event.target === this) {
	            closeModal();
	        }
	    });
	
	    // 모달 닫기 함수
	    function closeModal() {
	        rejectModal.removeClass('visible');
	        setTimeout(() => {
	            rejectModal.css('display', 'none');
	        }, 200);
	    }
	});
</script>

</body>
</html>