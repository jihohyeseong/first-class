<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>육아휴직 서비스 - 나의 신청내역</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        /* ========== Global & Layout Styles ========== */
        :root {
            --primary-color: #3f58d4; /* 모든 단계에서 사용할 통일된 파란색 */
            --white-color: #ffffff;
            --light-gray-color: #f9fafb;
            --gray-color: #6b7280;
            --dark-gray-color: #1f2937;
            --border-color: #e5e7eb;
            --shadow-lg: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { height: 100%; }
        
        body {
            display: flex; flex-direction: column; min-height: 100vh;
            font-family: 'Noto Sans KR', sans-serif; background-color: #f3f5f9;
            color: var(--dark-gray-color); position: relative; overflow-x: hidden;
        }
        
        body::before, body::after {
            content: ''; position: absolute; z-index: 0; border-radius: 50%;
            filter: blur(120px); opacity: 0.2;
        }
        body::before { width: 450px; height: 450px; background: #a9c0ff; top: -150px; left: -150px; }
        body::after { width: 500px; height: 500px; background: #fbc2eb; bottom: -200px; right: -150px; }

        a { text-decoration: none; color: inherit; }

        /* ========== Main Content Styles ========== */
        .main-container {
            flex-grow: 1; display: flex; flex-direction: column;
            width: 100%; max-width: 1100px; margin: 60px auto; padding: 0 20px;
            position: relative; z-index: 1;
        }

        .content-wrapper {
            flex-grow: 1; display: flex; flex-direction: column;
            background-color: var(--white-color); border-radius: 20px; padding: 40px;
            box-shadow: var(--shadow-lg);
        }

        .content-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 40px; padding-bottom: 25px;
            border-bottom: 1px solid var(--border-color);
        }
        .content-header h2 { font-size: 24px; font-weight: 700; }
        
        .empty-state-box {
            flex-grow: 1; display: flex; flex-direction: column;
            justify-content: center; align-items: center;
            background-color: var(--light-gray-color); border: 1px dashed var(--border-color);
            border-radius: 12px; text-align: center;
        }
        
        /* ========== Segmented Card Design ========== */
        .card-list {
            display: flex; flex-direction: column; gap: 30px;
        }

        .application-card {
            background-color: var(--white-color); border: 1px solid var(--border-color);
            border-radius: 16px; overflow: hidden;
            transition: all 0.2s ease-in-out;
        }
        .application-card:hover {
            transform: translateY(-5px); box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border-color: var(--primary-color);
        }
        
        .card-header {
            display: flex; justify-content: space-between; align-items: center;
            padding: 20px 25px;
        }
        .card-title { font-size: 18px; font-weight: 700; }

        .card-body { padding: 0 25px 25px 25px; }

        .segmented-progress {
            display: flex; border: 1px solid var(--border-color);
            border-radius: 12px; overflow: hidden;
        }

        .step {
            flex: 1; display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            padding: 15px 10px; text-align: center;
            background-color: var(--light-gray-color);
            color: var(--gray-color);
            border-right: 1px solid var(--border-color);
            transition: all 0.3s ease;
        }
        .step:last-child { border-right: none; }
        
        .step i { font-size: 18px; margin-bottom: 8px; }
        .step .step-label { font-size: 13px; font-weight: 500; }

        /* [수정] 모든 상태 색상을 파란색으로 통일 */
        .step.completed {
            color: var(--primary-color);
        }
        
        .step.active {
            background-color: var(--primary-color);
            color: var(--white-color);
        }
        
        .footer {
            text-align: center; padding: 20px 0;
            position: relative; z-index: 1;
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
                        <h3>아직 신청 내역이 없으시네요.</h3>
                        <p>소중한 자녀를 위한 첫걸음, 지금 바로 시작해보세요.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card-list">
                        <c:forEach var="app" items="${applicationList}">
                            
                            <c:set var="currentStep" value="0"/>
                            <c:if test="${app.statusName == '등록'}"><c:set var="currentStep" value="1"/></c:if>
                            <c:if test="${app.statusName == '제출'}"><c:set var="currentStep" value="2"/></c:if>
                            <c:if test="${app.statusName == '심사중'}"><c:set var="currentStep" value="3"/></c:if>
                            <c:if test="${app.statusName == '처리완료'}"><c:set var="currentStep" value="4"/></c:if>
                            
                            <div class="application-card">
                                <div class="card-header">
                                    <div>
                                        <div class="card-title">신청번호: ${app.applicationNumber}</div>
                                        <div class="meta-info" style="font-size:14px; color: var(--gray-color);">
                                            신청일: ${not empty app.submittedDate ? app.submittedDate : '-'}
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/apply/detail?appNo=${app.applicationNumber}" class="btn btn-secondary">상세보기</a>
                                </div>
                                <div class="card-body">
                                    <div class="segmented-progress">
                                        
                                        <div class="step ${currentStep >= 1 ? 'completed' : ''} ${currentStep == 1 ? 'active' : ''}">
                                            <i class="fa-solid fa-floppy-disk"></i>
                                            <span class="step-label">등록(임시저장)</span>
                                        </div>

                                        <div class="step ${currentStep >= 2 ? 'completed' : ''} ${currentStep == 2 ? 'active' : ''}">
                                            <i class="fa-solid fa-paper-plane"></i>
                                            <span class="step-label">제출</span>
                                        </div>

                                        <div class="step ${currentStep >= 3 ? 'completed' : ''} ${currentStep == 3 ? 'active' : ''}">
                                            <i class="fa-solid fa-hourglass-half"></i>
                                            <span class="step-label">심사중</span>
                                        </div>

                                        <div class="step ${currentStep >= 4 ? 'completed' : ''} ${currentStep == 4 ? 'active' : ''}">
                                            <i class="fa-solid fa-check-circle"></i>
                                            <span class="step-label">처리완료</span>
                                        </div>
                                    </div>
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