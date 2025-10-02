<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- JSTL 태그 --%>
<%-- <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> --%>
<%-- <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> --%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 신청 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f8f9fa;
            color: #212529;
        }
        a {
            text-decoration: none;
            color: inherit;
        }
        
        /* 레이아웃 */
        .content-container {
            margin-left: 0px;
            width: 100%;
        }
        .main-content {
            padding: 2rem;
        }

        /* 헤더 */
		.top-header {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    background-color: #fff;
		    padding: 1rem 2rem;
		    border-bottom: 1px solid #dee2e6;
		    height: 65px;
		    position: relative; 
		}

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
        .badge-wait { background-color: #ffc107; color: #000; }
        .badge-approved { background-color: #198754; }
        .badge-rejected { background-color: #dc3545; }

        .btn {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 0.375rem;
            background-color: #fff;
            cursor: pointer;
            text-align: center;
            transition: background-color 0.15s ease-in-out;
        }
        .btn:hover {
            background-color: #e9ecef;
        }
        .btn-refresh {
            border: none;
            background: none;
            font-size: 1.2rem;
        }
    </style>
</head>
<body>

    <div class="content-container">
        <header class="top-header">
        	<a href="main.jsp"><h4> 아이곁에 <span style="font-size: 1rem; font-weight: 300;">관리자</span></h4></a>
           <ul class="header-nav">
           		<li><a class="nav-link active" href="#">육아 휴직 신청 현황</a></li>
           </ul>
        </header>

        <main class="main-content">
            <h2 class="page-title">관리자 신청 목록</h2>

            <div class="stat-cards-container">
                <div class="stat-card active">
                    <div class="stat-card-header">
                        <div>
                            <h6>대기 중 신청</h6><h1>4</h1><small>현재 검토가 필요한 신청</small>
                        </div>
                        <i class="bi bi-clock-history"></i>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-card-header">
                        <div>
                            <h6>승인된 신청</h6><h1>3</h1><small>성공적으로 승인된 신청</small>
                        </div>
                        <i class="bi bi-check-circle" style="color: #198754;"></i>
                    </div>
                </div>
                <div class="stat-card">
                     <div class="stat-card-header">
                        <div>
                            <h6>반려된 신청</h6><h1>1</h1><small>문제가 있어 반려된 신청</small>
                        </div>
                        <i class="bi bi-x-circle" style="color: #dc3545;"></i>
                    </div>
                </div>
                <div class="stat-card">
                     <div class="stat-card-header">
                        <div>
                            <h6>총 신청 수</h6><h1>8</h1><small>모든 육아휴직 신청 수</small>
                        </div>
                        <i class="bi bi-files" style="color: #0dcaf0;"></i>
                    </div>
                </div>
            </div>

            <div class="table-wrapper">
                <div class="table-header">
                    <h4>모든 육아휴직 신청</h4>
                    <button class="btn-refresh"><i class="bi bi-arrow-clockwise"></i></button>
                </div>

                <div class="table-filters">
                	<div class="search-box">
                    <input type="text" placeholder="직원 이름 또는 ID로 검색..."><i class="bi bi-search"></i>
                    </div>
                    <select><option selected>모든 상태</option><option>대기 중</option><option>승인</option><option>반려</option></select>
                </div>

                <table class="data-table">
                    <thead>
                        <tr>
                            <th>신청 ID</th>
                            <th>직원 이름</th>
                            <th>신청일<i class="bi bi-arrow-down-up"></i></th>
                            <th>상태</th>
                            <th>작업</th>
                        </tr>
                    </thead>
                    <tbody>
                        
                         <tr>
                            <td>PL-2023-001</td>
                            <td>김민준</td>
                            <td>2023-10-26</td>
                            <td><span class="badge badge-approved">승인</span></td>
                            <td><a href="admin_detail.jsp" class="btn"><i class="bi bi-eye"></i></a></td>
                        </tr>
                        <tr>
                            <td>PL-2023-002</td>
                            <td>이지영</td>
                            <td>2023-10-27</td>
                            <td><span class="badge badge-wait">대기 중</span></td>
                            <td><a href="admin_detail.jsp" class="btn"><i class="bi bi-eye"></i></a></td>
                        </tr>
                        <tr>
                            <td>PL-2023-003</td>
                            <td>박서준</td>
                            <td>2023-10-28</td>
                            <td><span class="badge badge-rejected">반려</span></td>
                            <td><a href="admin_detail.jsp" class="btn"><i class="bi bi-eye"></i></a></td>
                        </tr>
                        <tr>
                            <td>PL-2023-004</td>
                            <td>최유나</td>
                            <td>2023-10-29</td>
                            <td><span class="badge badge-wait">대기 중</span></td>
                            <td><a href="admin_detail.jsp" class="btn"><i class="bi bi-eye"></i></a></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

</body>
</html>