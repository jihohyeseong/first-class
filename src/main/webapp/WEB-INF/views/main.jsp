<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>육아휴직 서비스 - 나의 신청내역</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        /* ========== Global & Layout Styles ========== */
        :root {
            --primary-color: #3f58d4; /* '등록' 상태에 사용할 파란색 */
            --primary-light-color: #f0f2ff;
            --white-color: #ffffff;
            --light-gray-color: #f9fafb;
            --gray-color: #6b7280;
            --dark-gray-color: #1f2937;
            --border-color: #e5e7eb;
            --status-saved: #6c757d;
            --status-processing: #ffc107; /* '심사중' 상태에 사용할 노란색 */
            --status-approved: #28a745;   /* '처리완료' 상태에 사용할 초록색 */
            --status-rejected: #dc3545;
            --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
            --shadow-lg: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { height: 100%; }
        
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f3f5f9;
            color: var(--dark-gray-color);
            position: relative;
            overflow-x: hidden;
        }
        
        body::before, body::after {
            content: '';
            position: absolute;
            z-index: 0;
            border-radius: 50%;
            filter: blur(120px);
            opacity: 0.2;
        }
        
        body::before { width: 450px; height: 450px; background: #a9c0ff; top: -150px; left: -150px; }
        body::after { width: 500px; height: 500px; background: #fbc2eb; bottom: -200px; right: -150px; }

        a { text-decoration: none; color: inherit; }

        /* ========== Main Content Styles ========== */
        .main-container {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            width: 100%;
            max-width: 1100px;
            margin: 60px auto;
            padding: 0 20px;
            position: relative;
            z-index: 1;
        }

        .content-wrapper {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            background-color: var(--white-color);
            border-radius: 20px;
            padding: 40px;
            box-shadow: var(--shadow-lg);
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 25px;
            border-bottom: 1px solid var(--border-color);
        }
        .content-header h2 { font-size: 24px; font-weight: 700; color: var(--dark-gray-color);}
        
        /* ========== Empty State ========== */
        .empty-state-box {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background-color: var(--light-gray-color);
            border: 1px dashed var(--border-color);
            border-radius: 12px;
            text-align: center;
        }
        .empty-state-box .icon { font-size: 52px; margin-bottom: 20px; line-height: 1; }
        .empty-state-box h3 { font-size: 24px; color: var(--dark-gray-color); margin-bottom: 15px; font-weight: 700; }
        .empty-state-box p { font-size: 16px; line-height: 1.6; margin-bottom: 30px; color: var(--gray-color); }
        
        /* ========== Card Layout ========== */
        .application-cards-container {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }
        
        .application-card {
            background-color: var(--white-color);
            border: 1px solid var(--border-color);
            border-top: 4px solid var(--primary-color);
            border-radius: 16px;
            transition: all 0.2s ease-in-out;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
        }
        .application-card:hover {
            transform: translateY(-5px);
            border-color: var(--primary-color);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        
        .card-body {
            padding: 30px 25px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px 20px;
        }
        .info-item {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }
        .info-item .label { font-size: 14px; color: var(--gray-color); margin-bottom: 8px; }
        .info-item .value { font-size: 18px; font-weight: 500; color: var(--dark-gray-color); }
        
        .card-footer {
            padding: 20px 25px;
            background-color: var(--light-gray-color);
            text-align: right;
            border-top: 1px solid var(--border-color);
        }
        
        /* ========== Status Badge Styles [수정] ========== */
        .status {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 13px;
            font-weight: 700;
            min-width: 80px;
            text-align: center;
            background-color: var(--border-color);
            color: var(--dark-gray-color);
        }
        /* [추가] 등록 상태 (파란색) */
        .status.registered { background-color: var(--primary-color); color: var(--white-color); }
        .status.processing { background-color: var(--status-processing); color: var(--dark-gray-color); }
        .status.approved { background-color: var(--status-approved); color: var(--white-color); }
        /* 기타 상태들 */
        .status.saved { background-color: var(--status-saved); color: var(--white-color); }
        .status.rejected { background-color: var(--status-rejected); color: var(--white-color); }

        .footer {
            text-align: center;
            padding: 20px 0;
            position: relative;
            z-index: 1;
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <main class="main-container"> 
        <div class="content-wrapper">
            <div class="content-header">
                <h2>
                    <sec:authentication property="principal.username" /> 님의 신청 내역
                </h2>
                <a href="${pageContext.request.contextPath}/apply" class="btn btn-primary">새로 신청하기</a>
            </div>
            
            <c:choose>
                <c:when test="${empty applicationList}">
                    <div class="empty-state-box">
                        <div class="icon">📄</div>
                        <h3>아직 신청 내역이 없으시네요.</h3>
                        <p>소중한 자녀를 위한 첫걸음, 지금 바로 시작해보세요.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="application-cards-container">
                        <c:forEach var="app" items="${applicationList}">
                            
                            <%-- [수정] 상태값에 따라 CSS 클래스를 동적으로 부여 --%>
                            <c:set var="statusClass" value=""/>
                            <c:if test="${app.statusName == '등록'}"><c:set var="statusClass" value="registered"/></c:if>
                            <c:if test="${app.statusName == '심사중'}"><c:set var="statusClass" value="processing"/></c:if>
                            <c:if test="${app.statusName == '처리완료'}"><c:set var="statusClass" value="approved"/></c:if>
                            
                            <%-- 기타 다른 상태값도 처리 (예시) --%>
                            <c:if test="${app.statusName == '임시저장'}"><c:set var="statusClass" value="saved"/></c:if>
                            <c:if test="${app.statusName == '부지급결정'}"><c:set var="statusClass" value="rejected"/></c:if>
                            
                            <div class="application-card">
                                <div class="card-body">
                                    <div class="info-item">
                                        <span class="label">신청번호</span>
                                        <span class="value">${app.applicationNumber}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="label">민원유형</span>
                                        <span class="value">육아휴직 급여 신청</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="label">신청일</span>
                                        <span class="value">
                                            ${not empty app.submittedDate ? app.submittedDate : '-'}
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <span class="label">상태</span>
                                        <span class="status ${statusClass}">${app.statusName}</span>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <a href="${pageContext.request.contextPath}/apply/detail?appNo=${app.applicationNumber}" class="btn btn-secondary">상세보기</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
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