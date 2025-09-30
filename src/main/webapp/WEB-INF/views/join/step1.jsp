<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개인회원 가입 (1/4) - 본인 확인</title>
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
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body, html {
            height: 100%;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: var(--light-gray-color);
        }
        
        /* [수정 1] 페이지를 더 넓고 꽉 차게 보이도록 수정 */
        .page-wrapper {
            padding: 50px 20px; /* 좌우 여백 추가 */
        }

        .signup-container {
            width: 100%;
            max-width: 1200px; /* 최대 너비를 1200px로 늘림 */
            margin: 0 auto;
            background-color: var(--white-color);
            padding: 60px 70px; /* 내부 여백 늘림 */
            border: 1px solid var(--border-color); /* 테두리 추가 */
            border-radius: 8px; /* 살짝 둥글게 */
            animation: fadeIn 0.6s ease-in-out;
        }

        .main-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--dark-gray-color);
            text-align: center;
            margin-bottom: 50px;
        }
        
        .progress-stepper {
            display: flex;
            justify-content: center;
            list-style: none;
            padding: 0;
            margin-bottom: 60px;
        }

        .step {
            flex: 1;
            padding: 12px;
            text-align: center;
            background-color: var(--light-gray-color);
            color: var(--gray-color);
            font-weight: 500;
            font-size: 16px;
            position: relative;
            transition: all 0.3s ease;
        }

        .step:not(:last-child)::after {
            content: '';
            position: absolute;
            right: -12px;
            top: 50%;
            transform: translateY(-50%);
            width: 0;
            height: 0;
            border-top: 22px solid transparent;
            border-bottom: 22px solid transparent;
            border-left: 12px solid var(--light-gray-color);
            z-index: 2;
            transition: all 0.3s ease;
        }

        .step.active {
            background-color: var(--primary-color);
            color: var(--white-color);
        }

        .step.active::after {
            border-left-color: var(--primary-color);
        }

        /* [수정 2] 본인확인 폼 스타일 */
        .content-box {
            padding: 40px 0; /* 상하 여백 조정 */
            min-height: 300px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .content-box h2 {
            font-size: 24px;
            color: var(--dark-gray-color);
            margin-bottom: 40px;
            animation: fadeInUp 0.5s ease-out forwards;
            opacity: 0;
        }
        
        .auth-form {
            width: 100%;
            max-width: 450px; /* 폼 너비 고정 */
        }
        
        .form-group {
            margin-bottom: 25px;
            text-align: left;
            opacity: 0; /* 애니메이션을 위해 초기 투명도 0 */
            animation: fadeInUp 0.5s ease-out forwards;
        }
        
        /* [수정 3] 애니메이션 효과를 위해 지연 시간 추가 */
        .form-group:nth-of-type(1) { animation-delay: 0.2s; }
        .form-group:nth-of-type(2) { animation-delay: 0.3s; }
        .form-action             { animation-delay: 0.4s; }


        .form-group label {
            display: block;
            font-size: 16px;
            font-weight: 500;
            color: var(--dark-gray-color);
            margin-bottom: 10px;
        }

        .form-group input {
            width: 100%;
            padding: 14px 16px;
            font-size: 16px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(63, 88, 212, 0.15);
        }

        .rrn-inputs {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .rrn-inputs .hyphen {
            font-size: 18px;
            color: var(--gray-color);
        }
        
        .form-action {
            margin-top: 40px;
            opacity: 0;
            animation: fadeInUp 0.5s ease-out forwards;
        }
        
        .form-action .btn {
            width: 100%;
            padding: 15px;
            font-size: 18px;
        }

        /* 하단 버튼 */
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 60px;
        }

        .btn {
            padding: 14px 35px;
            font-size: 16px;
            font-weight: 500;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
        .btn-primary:hover { background-color: #364ab1; }
        
        .btn-cancel { background-color: var(--white-color); color: var(--gray-color); }
        .btn-cancel:hover { background-color: var(--light-gray-color); }

        .btn-next:disabled { background-color: #a0a0a0; border-color: #a0a0a0; cursor: not-allowed; }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

    </style>
</head>
<body>
    
    <div class="page-wrapper">
        <div class="signup-container">
            <h1 class="main-title">개인회원 가입</h1>

            <div class="progress-stepper">
                <div class="step active">01. 본인 확인</div>
                <div class="step">02. 약관 동의</div>
                <div class="step">03. 정보 입력</div>
                <div class="step">04. 가입 완료</div>
            </div>

            <div class="content-box">
                <h2>본인확인</h2>
                
                <form class="auth-form">
                    <div class="form-group">
                        <label for="username">이름</label>
                        <input type="text" id="username" name="username" placeholder="성명을 입력하세요">
                    </div>
                    <div class="form-group">
                        <label for="rrn1">주민등록번호</label>
                        <div class="rrn-inputs">
                            <input type="text" id="rrn1" name="rrn1" maxlength="6" pattern="\d{6}" title="주민등록번호 앞 6자리를 입력하세요." required placeholder="앞 6자리">
                            <span class="hyphen">-</span>
                            <input type="password" id="rrn2" name="rrn2" maxlength="7" pattern="\d{7}" title="주민등록번호 뒤 7자리를 입력하세요." required placeholder="뒤 7자리">
                        </div>
                    </div>
                    <div class="form-action">
                        <button type="button" class="btn btn-primary">확인</button>
                    </div>
                </form>
            </div>

            <div class="action-buttons">
                <button type="button" class="btn btn-cancel" onclick="location.href='/signup'">취소</button>
                <button type="submit" class="btn btn-primary" disabled>다음</button>
            </div>
        </div>
    </div>

</body>
</html>