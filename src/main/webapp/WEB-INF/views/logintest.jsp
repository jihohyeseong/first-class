<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>육아휴직 신청 서비스 - 로그인</title>
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
            overflow: hidden; /* 슬라이드 애니메이션을 위해 */
        }

        .login-wrapper {
            display: flex;
            width: 100%;
            height: 100%;
        }

        /* --- 왼쪽 패널 (애니메이션 추가) --- */
        .left-panel {
            flex: 1;
            background-color: var(--primary-color);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 40px;
            color: var(--white-color);
            position: relative; /* 자식 요소의 absolute 포지셔닝을 위해 */
            overflow: hidden;
            /* 등장 애니메이션 */
            animation: slideInFromLeft 1s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
        }
        
        /* CSS 애니메이션 배경 */
        .animation-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
        }

        .animation-bg span {
            position: absolute;
            bottom: -100px;
            background-color: rgba(255, 255, 255, 0.15);
            border-radius: 50%;
            animation: floatUp 20s linear infinite;
        }

        .animation-bg span:nth-child(1) { width: 40px; height: 40px; left: 10%; animation-duration: 25s; animation-delay: 0s; }
        .animation-bg span:nth-child(2) { width: 20px; height: 20px; left: 20%; animation-duration: 15s; animation-delay: 2s; }
        .animation-bg span:nth-child(3) { width: 60px; height: 60px; left: 35%; animation-duration: 30s; animation-delay: 7s; }
        .animation-bg span:nth-child(4) { width: 30px; height: 30px; left: 50%; animation-duration: 18s; animation-delay: 5s; }
        .animation-bg span:nth-child(5) { width: 50px; height: 50px; left: 65%; animation-duration: 22s; animation-delay: 1s; }
        .animation-bg span:nth-child(6) { width: 25px; height: 25px; left: 80%; animation-duration: 28s; animation-delay: 9s; }
        .animation-bg span:nth-child(7) { width: 35px; height: 35px; left: 90%; animation-duration: 20s; animation-delay: 4s; }


        .welcome-content {
            animation: fadeIn 1s ease-in-out 0.8s forwards;
            opacity: 0;
            text-align: center;
            position: relative; /* 캔버스 위에 위치하도록 */
            z-index: 2;
        }
        
        .welcome-content h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .welcome-content p {
            font-size: 16px;
            font-weight: 300;
            line-height: 1.6;
            max-width: 300px;
        }

        /* --- 오른쪽 패널 (애니메이션 추가) --- */
        .right-panel {
            flex: 1;
            background-color: var(--white-color);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px;
            /* 등장 애니메이션 */
            animation: slideInFromRight 1s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
        }

        .login-form {
            width: 100%;
            max-width: 380px;
        }
        
        /* 폼 요소 순차적 애니메이션 */
        .login-form > * {
            animation: fadeInUp 0.8s ease-out forwards;
            opacity: 0;
        }
        
        .login-form h2 { animation-delay: 0.5s; }
        .login-form p { animation-delay: 0.6s; }
        .login-form form { animation-delay: 0.7s; }
        .login-form .links { animation-delay: 0.8s; }


        .login-form h2 {
            font-size: 26px;
            font-weight: 700;
            color: var(--dark-gray-color);
            margin-bottom: 10px;
        }

        .login-form p {
            font-size: 15px;
            color: var(--gray-color);
            margin-bottom: 35px;
        }

        .input-group {
            position: relative; /* 하단 라인 애니메이션을 위해 */
            margin-bottom: 25px;
        }
        
        .input-group input {
            width: 100%;
            padding: 10px 5px;
            border: none;
            border-bottom: 2px solid var(--border-color);
            background-color: transparent;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }

        .input-group input:focus {
            outline: none;
            border-bottom-color: var(--primary-color);
        }

        .login-btn {
            width: 100%;
            padding: 14px;
            margin-top: 20px;
            border: none;
            border-radius: 8px;
            background-color: var(--primary-color);
            color: var(--white-color);
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(63, 88, 212, 0.2);
        }
        
        .login-btn:hover {
            background-color: #364ab1;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(63, 88, 212, 0.3);
        }
        
        .links {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

        .links a {
            color: var(--gray-color);
            text-decoration: none;
            margin: 0 10px;
            transition: color 0.3s ease;
        }

        .links a:hover {
            color: var(--primary-color);
        }
        
        /* --- 웨이브 애니메이션 --- */
        .waves {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 150px;
            z-index: 3; /* 3D 애니메이션 위에 위치 */
        }
        
        .wave {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 200%;
            height: 100%;
            background-repeat: repeat-x;
            background-position: 0 bottom;
            transform-origin: center bottom;
        }
        
        .wave1 {
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.2)" fill-opacity="1" d="M0,224L48,213.3C96,203,192,181,288,176C384,171,480,181,576,192C672,203,768,213,864,202.7C960,192,1056,160,1152,149.3C1248,139,1344,149,1392,154.7L1440,160L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
            animation: wave-animation 15s linear infinite;
        }
        
        .wave2 {
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.3)" fill-opacity="1" d="M0,192L48,197.3C96,203,192,213,288,229.3C384,245,480,267,576,250.7C672,235,768,181,864,176C960,171,1056,213,1152,224C1248,235,1344,213,1392,202.7L1440,192L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
            animation: wave-animation 10s linear infinite reverse;
        }

        /* --- 키프레임 애니메이션 --- */
        @keyframes slideInFromLeft {
            from { transform: translateX(-100%); }
            to { transform: translateX(0); }
        }
        @keyframes slideInFromRight {
            from { transform: translateX(100%); }
            to { transform: translateX(0); }
        }
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
        @keyframes wave-animation {
            from { background-position-x: 0; }
            to { background-position-x: -1440px; } /* SVG 가로 길이만큼 이동 */
        }
        
        @keyframes floatUp {
            from {
                transform: translateY(0);
                opacity: 1;
            }
            to {
                transform: translateY(-110vh);
                opacity: 0;
            }
        }

        /* --- 반응형 디자인 --- */
        @media (max-width: 768px) {
            .login-wrapper { flex-direction: column; }
            .left-panel, .right-panel {
                animation: none; /* 모바일에서는 슬라이드 애니메이션 제거 */
            }
            .left-panel { flex: 0.6; padding: 50px 20px; }
            .right-panel { flex: 1; }
            .animation-bg { display: none; } /* 모바일에서는 애니메이션 숨김 */
        }
    </style>
</head>
<body>
    
    <div class="login-wrapper">
        <div class="left-panel">
            <div class="animation-bg">
                <span></span>
                <span></span>
                <span></span>
                <span></span>
                <span></span>
                <span></span>
                <span></span>
            </div>
            <div class="welcome-content">
                <h1>육아휴직 신청 서비스</h1>
                <p>소중한 시간을 위한 첫걸음, 간편하게 신청하고 관리하세요.</p>
            </div>
            <div class="waves">
                <div class="wave wave1"></div>
                <div class="wave wave2"></div>
            </div>
        </div>
        <div class="right-panel">
            <div class="login-form">
                <h2>로그인</h2>
                <p>가입하신 아이디와 비밀번호를 입력해주세요.</p>
                <form action="/loginProc" method="post">
                    <div class="input-group">
                        <input type="text" id="username" name="username" required placeholder="아이디">
                    </div>
                    <div class="input-group">
                        <input type="password" id="password" name="password" required placeholder="비밀번호">
                    </div>
                    <button type="submit" class="login-btn">로그인</button>
                </form>
                <div class="links">
                    <a href="${pageContext.request.contextPath}/join">회원가입</a> | <a href="#">아이디/비밀번호 찾기</a>
                </div>
            </div>
        </div>
    </div>
    
</body>
</html>

