<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개인회원 가입 (4/4) - 가입 완료</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #3f58d4;
            --white-color: #ffffff;
            --light-gray-color: #f0f2f5;
            --gray-color: #888;
            --dark-gray-color: #333;
            --border-color: #e0e0e0;
            --success-color: #28a745;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body, html { height: 100%; font-family: 'Noto Sans KR', sans-serif; background-color: var(--light-gray-color); }
        .page-wrapper { padding: 50px 20px; }

        .signup-container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            background-color: var(--white-color);
            padding: 60px 70px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
        }

        .main-title { font-size: 32px; font-weight: 700; color: var(--dark-gray-color); text-align: center; margin-bottom: 50px; }
        
        .progress-stepper { display: flex; justify-content: center; list-style: none; padding: 0; margin-bottom: 60px; }
        .step { flex: 1; padding: 12px; text-align: center; background-color: var(--light-gray-color); color: var(--gray-color); font-weight: 500; font-size: 16px; position: relative; transition: all 0.3s ease; }
        .step:not(:last-child)::after { content: ''; position: absolute; right: -12px; top: 50%; transform: translateY(-50%); width: 0; height: 0; border-top: 22px solid transparent; border-bottom: 22px solid transparent; border-left: 12px solid var(--light-gray-color); z-index: 2; transition: all 0.3s ease; }
        .step.active { background-color: var(--primary-color); color: var(--white-color); }
        .step.active::after { border-left-color: var(--primary-color); }

        .content-box {
            padding: 80px 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        /* [추가] 완료 아이콘 스타일 */
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
        }
        .completion-icon::after {
            content: '';
            width: 20px;
            height: 40px;
            border: solid var(--white-color);
            border-width: 0 8px 8px 0;
            transform: rotate(45deg);
        }

        .content-box h2 { font-size: 28px; color: var(--dark-gray-color); margin-bottom: 15px; }
        .content-box p { font-size: 16px; color: var(--gray-color); margin-bottom: 40px; }
        
        .action-buttons { display: flex; justify-content: center; gap: 15px; margin-top: 20px; }
        .btn { padding: 14px 35px; font-size: 16px; font-weight: 500; border-radius: 8px; border: 1px solid var(--border-color); cursor: pointer; transition: all 0.3s ease; text-decoration: none; }
        .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
        .btn-primary:hover { background-color: #364ab1; }
        .btn-secondary { background-color: var(--white-color); color: var(--dark-gray-color); border-color: var(--dark-gray-color); }
        .btn-secondary:hover { background-color: var(--dark-gray-color); color: var(--white-color); }
        
        @keyframes pop-in {
            0% { transform: scale(0); opacity: 0; }
            80% { transform: scale(1.1); opacity: 1; }
            100% { transform: scale(1); opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <div class="signup-container">
            <h1 class="main-title">개인회원 가입</h1>

            <div class="progress-stepper">
                <div class="step">01. 본인 확인</div>
                <div class="step">02. 약관 동의</div>
                <div class="step">03. 정보 입력</div>
                <div class="step active">04. 가입 완료</div>
            </div>

            <div class="content-box">
                <div class="completion-icon"></div>
                <h2>회원가입이 완료되었습니다!</h2>
                <p>가입을 축하합니다. 지금 바로 로그인하여 모든 서비스를 이용해 보세요.</p>
                
                <div class="action-buttons">
                    <a href="/main" class="btn btn-secondary">메인으로</a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">로그인</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>