<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>육아휴직 신청 서비스 - 계정 찾기</title>
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

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body, html { height: 100%; font-family: 'Noto Sans KR', sans-serif; background-color: var(--primary-color); overflow-x: hidden; }
        .background-wrapper { position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 1; }
        .animation-bg span { position: absolute; bottom: -100px; background-color: rgba(255, 255, 255, 0.15); border-radius: 50%; animation: floatUp 20s linear infinite; }
        .animation-bg span:nth-child(1) { width: 40px; height: 40px; left: 10%; animation-duration: 25s; }
        .animation-bg span:nth-child(2) { width: 20px; height: 20px; left: 20%; animation-duration: 15s; animation-delay: 2s; }
        .animation-bg span:nth-child(3) { width: 60px; height: 60px; left: 35%; animation-duration: 30s; animation-delay: 7s; }
        .animation-bg span:nth-child(4) { width: 30px; height: 30px; left: 50%; animation-duration: 18s; animation-delay: 5s; }
        .animation-bg span:nth-child(5) { width: 50px; height: 50px; left: 65%; animation-duration: 22s; animation-delay: 1s; }
        .waves { position: absolute; bottom: 0; left: 0; width: 100%; height: 150px; }
        .wave { position: absolute; bottom: 0; left: 0; width: 200%; height: 100%; background-repeat: repeat-x; background-position: 0 bottom; }
        .wave1 { background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.2)" fill-opacity="1" d="M0,224L48,213.3C96,203,192,181,288,176C384,171,480,181,576,192C672,203,768,213,864,202.7C960,192,1056,160,1152,149.3C1248,139,1344,149,1392,154.7L1440,160L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>'); animation: wave-animation 15s linear infinite; }
        .wave2 { background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.3)" fill-opacity="1" d="M0,192L48,197.3C96,203,192,213,288,229.3C384,245,480,267,576,250.7C672,235,768,181,864,176C960,171,1056,213,1152,224C1248,235,1344,213,1392,202.7L1440,192L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>'); animation: wave-animation 10s linear infinite reverse; }
        
        .find-container { position: relative; z-index: 2; display: flex; flex-direction: column; justify-content: center; align-items: center; min-height: 100vh; padding: 40px 20px; }
        .find-header { text-align: center; margin-bottom: 40px; color: var(--white-color); animation: fadeInUp 0.8s ease-out forwards; opacity: 0; }
        .find-header h1 { font-size: 32px; font-weight: 700; margin-bottom: 10px; }
        .find-header p { font-size: 16px; font-weight: 300; opacity: 0.9; }

        .find-options-wrapper { display: flex; justify-content: center; gap: 30px; flex-wrap: wrap; }
        .find-option-card { background-color: var(--white-color); border-radius: 12px; box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1); width: 400px; padding: 30px; text-align: center; transition: all 0.3s ease; cursor: pointer; text-decoration: none; color: var(--dark-gray-color); display: flex; flex-direction: column; }
        .find-option-card:nth-child(1) { animation: fadeInUp 1s ease-out 0.2s forwards; opacity: 0; }
        .find-option-card:nth-child(2) { animation: fadeInUp 1s ease-out 0.4s forwards; opacity: 0; }
        .find-option-card:hover { transform: translateY(-10px); box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15); }

        .icon-wrapper { width: 80px; height: 80px; border-radius: 50%; margin: 0 auto 20px; display: flex; justify-content: center; align-items: center; background-color: var(--light-gray-color); }
        .find-option-card h2 { font-size: 22px; font-weight: 700; margin-bottom: 15px; }
        .card-description { font-size: 14px; color: var(--gray-color); margin-bottom: 30px; flex-grow: 1; min-height: 40px; }

        .select-btn { display: inline-block; width: 100%; padding: 12px; border: 1px solid var(--border-color); border-radius: 8px; font-size: 16px; font-weight: 500; transition: all 0.3s ease; color: var(--primary-color); background-color: var(--white-color); }
        .find-option-card:hover .select-btn { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
        
        .back-link { margin-top: 40px; text-align: center; animation: fadeInUp 1s ease-out 0.6s forwards; opacity: 0; }
        .back-link a { color: rgba(255, 255, 255, 0.8); text-decoration: none; font-size: 14px; transition: color 0.3s ease; }
        .back-link a:hover { color: var(--white-color); text-decoration: underline; }

        @keyframes wave-animation { from { background-position-x: 0; } to { background-position-x: -1440px; } }
        @keyframes floatUp { from { transform: translateY(0); opacity: 1; } to { transform: translateY(-110vh); opacity: 0; } }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
        @media (max-width: 900px) { .find-options-wrapper { flex-direction: column; align-items: center; gap: 25px; } .find-option-card { width: 100%; max-width: 450px; } }
    </style>
</head>
<body>

    <div class="background-wrapper">
        <div class="animation-bg">
            <span></span><span></span><span></span><span></span><span></span><span></span><span></span>
        </div>
        <div class="waves">
            <div class="wave wave1"></div>
            <div class="wave wave2"></div>
        </div>
    </div>
    
    <div class="find-container">
        <div class="find-header">
            <h1>계정 정보 찾기</h1>
            <p>아이디 또는 비밀번호를 잊으셨나요? 원하시는 항목을 선택해주세요.</p>
        </div>

        <div class="find-options-wrapper">
            <a href="${pageContext.request.contextPath}/find/account/id" class="find-option-card">
                <div class="icon-wrapper">
                    <svg xmlns="http://www.w3.org/2000/svg" height="50px" viewBox="0 0 24 24" width="50px" fill="#3f58d4">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
                </div>
                <h2>아이디 찾기</h2>
                <p class="card-description">가입 시 등록한 이름과 주민등록 번호로<br>계정 아이디를 찾습니다.</p>
                <div class="select-btn">아이디 찾기 바로가기</div>
            </a>

            <a href="${pageContext.request.contextPath}/find/account/password" class="find-option-card">
                <div class="icon-wrapper">
                     <svg xmlns="http://www.w3.org/2000/svg" height="50px" viewBox="0 0 24 24" width="50px" fill="#3f58d4">
                        <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1s3.1 1.39 3.1 3.1v2z"/>
                    </svg>
                </div>
                <h2>비밀번호 찾기</h2>
                <p class="card-description">가입 시 등록한 이름과 아이디로<br>비밀번호를 재설정합니다.</p>
                <div class="select-btn">비밀번호 찾기 바로가기</div>
            </a>
        </div>

        <div class="back-link">
            <a href="${pageContext.request.contextPath}/login">로그인 페이지로 돌아가기</a>
        </div>
    </div>

</body>
</html>