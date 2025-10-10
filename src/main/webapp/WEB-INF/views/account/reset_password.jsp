<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 재설정</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root { --primary-color: #3f58d4; --white-color: #ffffff; --light-gray-color: #f0f2f5; --gray-color: #888; --dark-gray-color: #333; --border-color: #e0e0e0; }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body, html { height: 100%; font-family: 'Noto Sans KR', sans-serif; background-color: var(--primary-color); overflow-x: hidden; }
        .background-wrapper { position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 1; }
        .animation-bg span { position: absolute; bottom: -100px; background-color: rgba(255, 255, 255, 0.15); border-radius: 50%; animation: floatUp 20s linear infinite; }
        .animation-bg span:nth-child(1) { width: 40px; height: 40px; left: 10%; animation-duration: 25s; }
        .animation-bg span:nth-child(2) { width: 20px; height: 20px; left: 20%; animation-duration: 15s; animation-delay: 2s; }
        .animation-bg span:nth-child(3) { width: 60px; height: 60px; left: 35%; animation-duration: 30s; animation-delay: 7s; }
        .animation-bg span:nth-child(4) { width: 30px; height: 30px; left: 50%; animation-duration: 18s; animation-delay: 5s; }
        .waves { position: absolute; bottom: 0; left: 0; width: 100%; height: 150px; }
        .wave { position: absolute; bottom: 0; left: 0; width: 200%; height: 100%; background-repeat: repeat-x; background-position: 0 bottom; }
        .wave1 { background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.2)" fill-opacity="1" d="M0,224L48,213.3C96,203,192,181,288,176C384,171,480,181,576,192C672,203,768,213,864,202.7C960,192,1056,160,1152,149.3C1248,139,1344,149,1392,154.7L1440,160L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>'); animation: wave-animation 15s linear infinite; }
        .wave2 { background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.3)" fill-opacity="1" d="M0,192L48,197.3C96,203,192,213,288,229.3C384,245,480,267,576,250.7C672,235,768,181,864,176C960,171,1056,213,1152,224C1248,235,1344,213,1392,202.7L1440,192L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>'); animation: wave-animation 10s linear infinite reverse; }
        .reset-container { position: relative; z-index: 2; display: flex; flex-direction: column; justify-content: center; align-items: center; min-height: 100vh; padding: 40px 20px; }
        .reset-header { text-align: center; margin-bottom: 40px; color: var(--white-color); animation: fadeInUp 0.8s ease-out forwards; opacity: 0; }
        .reset-header h1 { font-size: 32px; font-weight: 700; margin-bottom: 10px; }
        .reset-header p { font-size: 16px; font-weight: 300; opacity: 0.9; }
        .reset-form-card { background-color: var(--white-color); border-radius: 12px; box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1); width: 100%; max-width: 450px; padding: 40px; animation: fadeInUp 1s ease-out 0.2s forwards; opacity: 0; }
        .reset-form-card h2 { text-align: center; font-size: 22px; font-weight: 700; margin-bottom: 30px; color: var(--dark-gray-color); }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 14px; font-weight: 500; color: var(--dark-gray-color); margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 12px 15px; border: 1px solid var(--border-color); border-radius: 8px; font-size: 16px; }
        .submit-btn { width: 100%; padding: 14px; border: none; border-radius: 8px; font-size: 16px; font-weight: 700; color: var(--white-color); background-color: var(--primary-color); cursor: pointer; }
        @keyframes wave-animation { from { background-position-x: 0; } to { background-position-x: -1440px; } }
        @keyframes floatUp { from { transform: translateY(0); opacity: 1; } to { transform: translateY(-110vh); opacity: 0; } }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
    <div class="background-wrapper">
        <div class="animation-bg">
            <span></span><span></span><span></span><span></span><span></span>
        </div>
        <div class="waves">
            <div class="wave wave1"></div>
            <div class="wave wave2"></div>
        </div>
    </div>

    <div class="reset-container">
        <div class="reset-header">
            <h1>비밀번호 재설정</h1>
            <p>새로운 비밀번호를 입력해주세요.</p>
        </div>
        <div class="reset-form-card">
            <h2>새 비밀번호 입력</h2>
            <form id="resetPasswordForm" action="${pageContext.request.contextPath}/find/password/new" method="post">
                <input type="hidden" name="username" value="${username}">
                <div class="form-group">
                    <label for="newPassword">새 비밀번호</label>
                    <input type="password" id="newPassword" name="newPassword" placeholder="8자 이상, 특수문자 포함" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">새 비밀번호 확인</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="비밀번호를 다시 한번 입력하세요" required>
                </div>
                <button type="submit" class="submit-btn">비밀번호 변경</button>
            </form>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#resetPasswordForm').on('submit', function(e) {
                // 1. 기본 폼 전송을 막습니다.
                e.preventDefault();

                var newPassword = $('#newPassword').val();
                var confirmPassword = $('#confirmPassword').val();

                // 2. 비밀번호 일치 여부 검사
                if (newPassword !== confirmPassword) {
                    alert('입력하신 비밀번호가 일치하지 않습니다.');
                    $('#newPassword').focus();
                    return; // 함수 종료
                }

                // 3. 비밀번호 정책 검사 (최소 8자, 특수문자 1개 이상)
                var passwordPolicy = /^(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$/;
                if (!passwordPolicy.test(newPassword)) {
                    alert('비밀번호는 최소 8자 이상이어야 하며, 특수문자를 하나 이상 포함해야 합니다.');
                    $('#newPassword').focus();
                    return; // 함수 종료
                }

                // 4. AJAX 통신
                var formData = $(this).serialize();
                var actionUrl = $(this).attr('action');

                $.ajax({
                    type: 'POST',
                    url: actionUrl,
                    data: formData,
                    dataType: 'json',
                    success: function(response) {
                        if (response.success) {
                            alert('비밀번호가 성공적으로 변경되었습니다. 로그인 페이지로 이동합니다.');
                            window.location.href = '${pageContext.request.contextPath}' + response.redirectUrl;
                        } else {
                            alert(response.message);
                        }
                    },
                    error: function() {
                        alert('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                    }
                });
            });
        });
    </script>
</body>
</html>