<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>육아휴직 서비스 - 메인</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #3f58d4;
            --primary-light-color: #f0f2ff;
            --white-color: #ffffff;
            --light-gray-color: #f8f9fa;
            --gray-color: #868e96;
            --dark-gray-color: #343a40;
            --border-color: #dee2e6;
            --status-submitted: #007bff;
            --status-processing: #ffc107;
            --status-approved: #28a745;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 8px rgba(0,0,0,0.07);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { height: 100%; }
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh; /* 화면 전체 높이를 차지하도록 설정 */
            font-family: 'Noto Sans KR', sans-serif;
            background-color: var(--light-gray-color);
            color: var(--dark-gray-color);
        }
        a { text-decoration: none; color: inherit; }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            font-size: 15px;
            font-weight: 500;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            text-align: center;
        }
        .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
        .btn-primary:hover { background-color: #364ab1; box-shadow: var(--shadow-md); transform: translateY(-2px); }
        .btn-logout { background-color: var(--dark-gray-color); color: var(--white-color); border: none; }
        .btn-logout:hover { background-color: #555; }
        .btn-secondary { background-color: var(--white-color); color: var(--gray-color); border-color: var(--border-color); }
        .btn-secondary:hover { background-color: var(--light-gray-color); color: var(--dark-gray-color); border-color: #ccc; }

        .header {
            background-color: var(--white-color);
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            box-shadow: var(--shadow-sm);
            position: sticky;
            top: 0;
            z-index: 10;
        }
        .header .logo img { vertical-align: middle; }
        .header nav { display: flex; align-items: center; gap: 15px; }
        .header .welcome-msg { font-size: 16px; color: var(--dark-gray-color); }
		
		.header-nav {
		    position: absolute;
		    left: 50%;
		    transform: translateX(-50%);
		    display: flex;
		    list-style: none;
		    margin: 0;
		    padding: 0;
		}
	
		.header-nav .nav-link {
		    display: block;
		    padding: 0.5rem 1rem;
		    border-radius: 0.5rem;
		    font-weight: 500;
		    color: #495057;
		    transition: all 0.3s ease-in-out;
		}
		.header-nav .nav-link:hover {
		    color: #3f58d4;
		    transform: translateY(-3px);
		    box-shadow: 0 4px 10px rgba(63, 88, 212, 0.3);
		}
		
        .main-container {
            flex-grow: 1; /* main 영역이 남은 공간을 모두 차지하도록 설정 */
            display: flex;
            flex-direction: column;
            width: 100%;
            max-width: 1200px;
            margin: 40px auto;
            padding: 40px;
            background-color: var(--white-color);
            border-radius: 12px;
            box-shadow: var(--shadow-md);
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid var(--primary-light-color);
        }
        .content-header h2 { font-size: 24px; font-weight: 700; }

        .empty-state-box {
            flex-grow: 1; /* .main-container 내부의 남은 공간을 채움 */
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            background-color: var(--primary-light-color);
            border-radius: 8px;
            padding: 60px 40px;
            color: var(--gray-color);
        }
        .empty-state-box .icon { font-size: 52px; margin-bottom: 20px; }
        .empty-state-box h3 { font-size: 22px; color: var(--dark-gray-color); margin-bottom: 15px; }
        .empty-state-box p { font-size: 16px; line-height: 1.6; margin-bottom: 25px; }

        .application-table {
            width: 100%;
            border-collapse: collapse;
        }
        .application-table th, .application-table td {
            padding: 18px 15px;
            text-align: center;
            border-bottom: 1px solid var(--border-color);
        }
        .application-table th {
            background-color: var(--light-gray-color);
            font-weight: 500;
            font-size: 14px;
            color: var(--gray-color);
            text-transform: uppercase;
        }
        .application-table td { font-size: 15px; }
        .application-table th:first-child, .application-table td:first-child { text-align: left; }
        .application-table tr:hover {
             background-color: #fcfdff; /* 마우스 올렸을 때 배경색 변경 */
        }
        .application-table .status {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 13px;
            font-weight: 500;
            color: var(--white-color);
        }
        .status.submitted { background-color: var(--status-submitted); }
        .status.processing { background-color: var(--status-processing); color: var(--dark-gray-color); }
        .status.approved { background-color: var(--status-approved); }

        .footer {
            text-align: center;
            padding: 20px 0;
            font-size: 14px;
            color: var(--gray-color);
        }
    </style>
</head>
<body>
    <header class="header">
        <a href="${pageContext.request.contextPath}/main" class="logo"><img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" width="80" height="80"></a>
        <nav>
        	<ul class="header-nav">
           		<li><a class="nav-link active" href="${pageContext.request.contextPath}/calc">모의 계산하기</a></li>
				<li><a class="nav-link active" href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
            </ul>
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

    <main class="main-container"> <c:choose>
		<c:when test="${empty applicationList}">
			<div class="content-header">
				<h2>
					<sec:authentication property="principal.username" />
					님의 신청 내역
				</h2>
			</div>
			<div class="empty-state-box">
				<div class="icon">📝</div>
				<h3>아직 신청 내역이 없으시네요.</h3>
				<p>소중한 자녀를 위한 첫걸음, 지금 바로 시작해보세요.</p>
				<a href="${pageContext.request.contextPath}/apply"
					class="btn btn-primary">육아휴직 신청하기</a>
			</div>
		</c:when>

		<c:otherwise>
			<div class="content-header">
				<h2>
					<sec:authentication property="principal.username" />
					님의 신청 내역
				</h2>
				<a href="${pageContext.request.contextPath}/apply"
					class="btn btn-primary">새로 신청하기</a>
			</div>
			<table class="application-table">
				<thead>
					<tr>
						<th>신청번호</th>
						<th>민원유형</th>
						<th>신청일</th>
						<th>상태</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="app" items="${applicationList}">
						<tr>
							<td>${app.applicationNumber}</td>
							<td>육아휴직 급여 신청</td>
							<td>${app.submittedDate}</td>
							<td>${app.statusName}</td>
							<td><a
								href="${pageContext.request.contextPath}/apply/detail?appNo=${app.applicationNumber}"
								class="btn btn-secondary">상세보기</a></td>
						</tr>
					</c:forEach>
				</tbody>

			</table>
		</c:otherwise>
	</c:choose>
    </main>

    <footer class="footer">
        <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
    </footer>
	<c:if test="${not empty error}">
    <script type="text/javascript">
        window.onload = function() {
            alert('${error}');
        };
    </script>
</c:if>
</body>
</html>