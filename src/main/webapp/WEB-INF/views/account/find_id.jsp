<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디 찾기</title>
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
        .waves { position: absolute; bottom: 0; left: 0; width: 100%; height: 150px; }
        .wave { position: absolute; bottom: 0; left: 0; width: 200%; height: 100%; background-repeat: repeat-x; background-position: 0 bottom; }
        .wave1 { background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 M 0 1440 320"><path fill="rgba(255,255,255,0.2)" fill-opacity="1" d="M0,224L48,213.3C96,203,192,181,288,176C384,171,480,181,576,192C672,203,768,213,864,202.7C960,192,1056,160,1152,149.3C1248,139,1344,149,1392,154.7L1440,160L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>'); animation: wave-animation 15s linear infinite; }
        .wave2 { background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.3)" fill-opacity="1" d="M0,192L48,197.3C96,203,192,213,288,229.3C384,245,480,267,576,250.7C672,235,768,181,864,176C960,171,1056,213,1152,224C1248,235,1344,213,1392,202.7L1440,192L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>'); animation: wave-animation 10s linear infinite reverse; }
        .find-container { position: relative; z-index: 2; display: flex; flex-direction: column; justify-content: center; align-items: center; min-height: 100vh; padding: 40px 20px; }
        .find-header { text-align: center; margin-bottom: 40px; color: var(--white-color); animation: fadeInUp 0.8s ease-out forwards; opacity: 0; }
        .find-header h1 { font-size: 32px; font-weight: 700; margin-bottom: 10px; }
        .find-header p { font-size: 16px; font-weight: 300; opacity: 0.9; }
        .find-form-card { background-color: var(--white-color); border-radius: 12px; box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1); width: 100%; max-width: 450px; padding: 40px; animation: fadeInUp 1s ease-out 0.2s forwards; opacity: 0; }
        .find-form-card h2 { text-align: center; font-size: 22px; font-weight: 700; margin-bottom: 30px; color: var(--dark-gray-color); }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 14px; font-weight: 500; color: var(--dark-gray-color); margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 12px 15px; border: 1px solid var(--border-color); border-radius: 8px; font-size: 16px; text-align: center; }
        .submit-btn { display: block; text-align: center; width: 100%; padding: 14px; border: none; border-radius: 8px; font-size: 16px; font-weight: 700; color: var(--white-color); background-color: var(--primary-color); cursor: pointer; text-decoration: none; }
        .links-wrapper { margin-top: 30px; text-align: center; animation: fadeInUp 1s ease-out 0.4s forwards; opacity: 0; }
        .links-wrapper a { color: rgba(255, 255, 255, 0.8); text-decoration: none; font-size: 14px; margin: 0 10px; }
        
        .found-id-display { background-color: var(--light-gray-color); border: 1px solid var(--border-color); border-radius: 8px; padding: 20px; font-size: 20px; font-weight: 700; color: var(--primary-color); margin: 25px 0; letter-spacing: 1px; }
        .action-buttons { margin-top: 30px; display: flex; flex-direction: column; gap: 15px; }
        .phone-input-group { display: flex; align-items: center; gap: 10px; }
        .phone-input-group input { flex: 1; min-width: 0; }
        .phone-input-group span { font-size: 16px; color: var(--gray-color); }

        @keyframes wave-animation { from { background-position-x: 0; } to { background-position-x: -1440px; } }
        @keyframes floatUp { from { transform: translateY(0); opacity: 1; } to { transform: translateY(-110vh); opacity: 0; } }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
    <div class="background-wrapper">
        <div class="animation-bg">
            <span></span>
        </div>
        <div class="waves">
            <div class="wave wave1"></div>
            <div class="wave wave2"></div>
        </div>
    </div>
    <div class="find-container">
        <div class="find-header">
            <h1>아이디 찾기</h1>
            <p>가입 시 등록한 이름과 휴대폰 번호를 입력해주세요.</p>
        </div>
        <div class="find-form-card">
            <div id="cardContent">
                <h2>본인 정보 입력</h2>
                <form id="findIdForm" action="${pageContext.request.contextPath}/find/id" method="post">
                    <div class="form-group">
                        <label for="name">이름</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="phone1">휴대폰 번호</label>
                        <div class="phone-input-group">
                            <input type="tel" id="phone1" maxlength="3" required>
                            <span>-</span>
                            <input type="tel" id="phone2" maxlength="4" required>
                            <span>-</span>
                            <input type="tel" id="phone3" maxlength="4" required>
                        </div>
                    </div>
                    <button type="submit" class="submit-btn">아이디 찾기</button>
                </form>
            </div>
        </div>
        <div class="links-wrapper">
            <a href="${pageContext.request.contextPath}/find/account/password">비밀번호 찾기</a> | <a href="${pageContext.request.contextPath}/login">로그인</a>
        </div>
    </div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script>
    $(document).ready(function() {
        $('.phone-input-group input').on('input', function() {
            if (this.value.length >= this.maxLength) {
                $(this).nextAll('input').first().focus();
            }
        });

        $('#cardContent').on('submit', '#findIdForm', function(event) {
            event.preventDefault();

            var name = $('#name').val();
            var phone1 = $('#phone1').val();
            var phone2 = $('#phone2').val();
            var phone3 = $('#phone3').val();
            
            var fullPhoneNumber = phone1 + '-' + phone2 + '-' + phone3;
            
            var requestData = {
                name: name,
                phoneNumber: fullPhoneNumber
            };
            
            var formUrl = $(this).attr('action');

            $.ajax({
                type: 'POST',
                url: formUrl,
                data: requestData,
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        var username = response.username;
                        
                        var maskedUsername = username.substring(0, 3) + '***' + username.substring(6);

                        $('.find-header h1').text('아이디 찾기 완료');
                        $('.find-header p').text('회원님의 아이디를 찾았습니다.');

                        var resultHtml = 
                            '<div style="text-align: center;">' +
                            '    <h2>조회 결과</h2>' +
                            '    <p style="color: var(--gray-color); font-size: 14px;">개인정보 보호를 위해 아이디의 일부를<br> \'*\'로 표시합니다.</p>' +
                            '    <div class="found-id-display">' + maskedUsername + '</div>' +
                            '    <div class="action-buttons">' +
                            '        <a href="' + '${pageContext.request.contextPath}/login' + '" class="submit-btn">확인</a>' +
                            '    </div>' +
                            '</div>';

                        $('#cardContent').html(resultHtml);
                        $('.links-wrapper a:first').text('비밀번호가 기억나지 않으세요?');
                        
                    } else {
                        alert(response.message);
                    }
                },
                error: function() {
                    alert('오류가 발생했습니다. 다시 시도해주세요.');
                }
            });
        });
    });
</script>

</body>
</html>