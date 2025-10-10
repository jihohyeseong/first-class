<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- JSTL 태그 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 신청 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
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
      display: flex; flex-direction: column; min-height: 100vh;
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
        
        /* 레이아웃 */
        .content-container {
            margin-left: 0px;
            width: 100%;
        }
        .main-content {
            padding: 2rem;
        }

		/* 검색바 */
		.search-box {
		    position: relative;
		    width: 400px;
		    margin-right: 1.5rem;
		}
        .search-box input {
            width: 100%;
            padding: 0.5rem 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 0.375rem;
        }
        .search-box .bi-search {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }

        /* 메인 콘텐츠 */
        .page-title {
            margin-bottom: 1.5rem;
            font-weight: 700;
        }

        /* 처리상태 카드 */
        .stat-cards-container {
            display: flex;
            gap: 1.5rem;
            margin-bottom: 3rem;
        }
        .stat-card {
            flex: 1;
            background-color: #fff;
            padding: 1.25rem;
            border: 1px solid #e9ecef;
            border-radius: 0.75rem;
            transition: all 0.2s ease-in-out;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .stat-card.active {
            border-left: 5px solid #3f58d4;
        }
        .stat-card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        .stat-card h6 {
            color: #6c757d;
            font-weight: 700;
            font-size: 0.9rem;
        }
        .stat-card h1 {
            color: #3f58d4;
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0.5rem 0;
        }
        .stat-card small {
            color: #6c757d;
            font-size: 0.85rem;
        }
        .stat-card .bi {
            font-size: 1.8rem;
            color: #adb5bd;
        }

        /* Table Wrapper */
        .table-wrapper {
            background-color: #fff;
            padding: 1.5rem;
            border-radius: 0.75rem;
            border: 1px solid #e9ecef;
        }
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        .table-header h4 {
            font-weight: 700;
            margin: 0;
        }
        .table-filters {
            display: flex;
            gap: 0.75rem;
            margin-bottom: 1rem;
        }
        .table-filters input, .table-filters select {
            padding: 0.5rem 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 0.375rem;
            font-size: 0.9rem;
        }
        .table-filters input { flex: 2; }
        .table-filters select { flex: 1; }

        /* Table */
        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        .data-table th, .data-table td {
            padding: 1rem;
            vertical-align: middle;
            border-bottom: 1px solid #dee2e6;
        }
        .data-table thead th {
            background-color: #f8f9fa;
            font-weight: 700;
            color: #495057;
        }
        .data-table tbody tr:hover {
            background-color: #f1f3f5;
        }
		
        /* 재사용 컴포넌트 */
        .badge {
            display: inline-block;
            padding: 0.4em 0.7em;
            font-size: 0.8rem;
            font-weight: 500;
            border-radius: 50rem;
            color: #fff;
        }
        .badge-wait { background-color: #3f58d4; color: #fff; }
        .badge-approved { background-color: #3f58d4; color: #fff; }
        .badge-rejected { background-color: #3f58d4; color: #fff; }

        .table-btn {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 0.375rem;
            background-color: #fff;
            cursor: pointer;
            text-align: center;
            transition: background-color 0.15s ease-in-out;
        }
        .table-btn:hover {
            background-color: #e9ecef;
        }
        .btn-refresh {
            border: none;
            background: none;
            font-size: 1.2rem;
        }
        /* 페이징 네비게이션 스타일 */
		.pagination {
		    display: flex;
		    justify-content: center;
		    align-items: center;
		    margin-top: 2rem;
		    gap: 0.5rem;
		}
		.pagination a, .pagination span {
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    width: 38px;
		    height: 38px;
		    border: 1px solid var(--border-color);
		    border-radius: 8px;
		    background-color: var(--white-color);
		    color: var(--dark-gray-color);
		    font-weight: 500;
		    transition: all 0.2s ease-in-out;
		}
		.pagination a:hover {
		    background-color: var(--primary-light-color);
		    border-color: var(--primary-color);
		    color: var(--primary-color);
		}
		.pagination .active {
		    background-color: var(--primary-color);
		    border-color: var(--primary-color);
		    color: var(--white-color);
		    cursor: default;
		}
		.pagination .disabled {
		    color: #ced4da;
		    background-color: #f8f9fa;
		    pointer-events: none;
		}
    </style>
</head>
<body>

    <div class="content-container">
        <header class="header">
	        <a href="#" class="logo"><img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" width="80" height="80"></a>
	        <nav>
	        	<ul class="header-nav">
	           		<li><a class="nav-link active" href="${pageContext.request.contextPath}/calc">육아휴직 신청현황</a></li>
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

        <main class="main-content">
            <h2 class="page-title">관리자 신청 목록</h2>

            <div class="stat-cards-container">
                <div class="stat-card active">
                    <div class="stat-card-header">
                        <div>
                            <h6>대기 중 신청</h6><h1>${counts.pending}</h1><small>현재 검토가 필요한 신청</small>
                        </div>
                        <i class="bi bi-clock-history"></i>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-header">
                        <div>
                            <h6>승인된 신청</h6><h1>${counts.approved}</h1><small>성공적으로 승인된 신청</small>
                        </div>
                        <i class="bi bi-check-circle" style="color: #198754;"></i>
                    </div>
                </div>
                <div class="stat-card">
                     <div class="stat-card-header">
                        <div>
                            <h6>반려된 신청</h6><h1>${counts.rejected}</h1><small>문제가 있어 반려된 신청</small>
                        </div>
                        <i class="bi bi-x-circle" style="color: #dc3545;"></i>
                    </div>
                </div>
                <div class="stat-card">
                     <div class="stat-card-header">
                        <div>
                            <h6>총 신청 수</h6><h1>${counts.total}</h1><small>모든 육아휴직 신청 수</small>
                        </div>
                        <i class="bi bi-files" style="color: #0dcaf0;"></i>
                    </div>
                </div>
            </div>

            <div class="table-wrapper">
                <div class="table-header">
                    <h4>모든 육아휴직 신청</h4>
                    <button class="table-btn btn-refresh"><i class="bi bi-arrow-clockwise"></i></button>
                </div>

                <form action="${pageContext.request.contextPath}/admin/applications" method="get" class="table-filters">
                    <div class="search-box">
                        <input type="text" name="keyword" placeholder="직원 이름 또는 ID로 검색..." value="${keyword}">
                        <button type="submit" style="background:none; border:none; position:absolute; right:10px; top:50%; transform:translateY(-50%); cursor:pointer;">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                    <%-- status 필터 --%>
                    <select name="status" onchange="this.form.submit()">
                        <option value="">모든 상태</option>
                        <option value="ST_20" ${status == 'ST_20' ? 'selected' : ''}>대기</option>
                        <option value="ST_40" ${status == 'ST_40' ? 'selected' : ''}>처리완료</option>
                    </select>
                    
                </form>

                <table class="data-table">
                    <thead>
                        <tr>
                            <th>신청 번호</th>
                            <th>직원 이름</th>
                            <th>신청일</th>
                            <th>상태</th>
                            <th>검토</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty applicationList}">
                                <c:forEach var="app" items="${applicationList}">
                                    <tr>
                                        <td>${app.applicationNumber}</td>
                                        <td>${app.name} (ID: ${app.userId})</td>
                                        <td>${app.submittedDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${app.statusName == '대기'}">
                                                    <span class="badge badge-wait">${app.statusName}</span>
                                                </c:when>
                                                <c:when test="${app.statusName == '승인'}">
                                                    <span class="badge badge-approved">${app.statusName}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-rejected">${app.statusName}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/application-detail?appNo=${app.applicationNumber}" class="table-btn btn-secondary">상세보기</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5" style="text-align: center;">조회된 신청 내역이 없습니다.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                <div class="pagination">
				    <c:if test="${pageDTO.startPage > 1}">
				        <a href="${pageContext.request.contextPath}/admin/applications?page=${pageDTO.startPage - 1}&keyword=${keyword}&status=${status}">&laquo;</a>
				    </c:if>
				
				    <c:forEach begin="${pageDTO.paginationStart}" end="${pageDTO.paginationEnd}" var="p">
				        <a href="${pageContext.request.contextPath}/admin/applications?page=${p}&keyword=${keyword}&status=${status}" 
				           class="${p == pageDTO.pageNum ? 'active' : ''}">
				            ${p}
				        </a>
				    </c:forEach>
				
				    <c:if test="${pageDTO.endPage > pageDTO.paginationEnd}">
				        <a href="${pageContext.request.contextPath}/admin/applications?page=${pageDTO.paginationEnd + 1}&keyword=${keyword}&status=${status}">&raquo;</a>
				    </c:if>
				</div>
            </div>
        </main>
    </div>
</body>
</html>