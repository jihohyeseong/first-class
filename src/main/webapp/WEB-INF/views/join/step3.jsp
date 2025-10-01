<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개인회원 가입 (3/4) - 정보 입력</title>
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
            --error-color: #dc3545;
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

        .content-box { padding: 40px 0; display: flex; flex-direction: column; align-items: center; }
        .content-box h2 { font-size: 24px; color: var(--dark-gray-color); margin-bottom: 40px; }

        .info-form { width: 100%; max-width: 550px; }
        .form-group { margin-bottom: 25px; }
        .form-group label { display: block; font-size: 16px; font-weight: 500; color: var(--dark-gray-color); margin-bottom: 8px; }
        .form-group input { width: 100%; padding: 12px 14px; font-size: 16px; border: 1px solid var(--border-color); border-radius: 6px; }
        .form-group input:focus { outline: none; border-color: var(--primary-color); box-shadow: 0 0 0 2px rgba(63, 88, 212, 0.15); }
        
        .input-group { display: flex; gap: 10px; }
        .input-group input { flex: 1; }
        .input-group .btn-sm { padding: 0 20px; font-size: 14px; background-color: var(--dark-gray-color); color: var(--white-color); border: none; border-radius: 6px; cursor: pointer; }
        
        .rrn-inputs { display: flex; align-items: center; gap: 10px; }
        .rrn-inputs .hyphen { font-size: 16px; color: var(--gray-color); }

        .message { font-size: 13px; margin-top: 8px; }
        .message.success { color: var(--success-color); }
        .message.error { color: var(--error-color); }
        
        .action-buttons { display: flex; justify-content: center; gap: 15px; margin-top: 40px; }
        .btn { padding: 14px 35px; font-size: 16px; font-weight: 500; border-radius: 8px; border: 1px solid var(--border-color); cursor: pointer; transition: all 0.3s ease; }
        .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
        .btn-primary:hover { background-color: #364ab1; }
        .btn-cancel { background-color: var(--white-color); color: var(--gray-color); }
        .btn-cancel:hover { background-color: var(--light-gray-color); }
        .btn-primary:disabled { background-color: #a0a0a0; border-color: #a0a0a0; cursor: not-allowed; }
    </style>
</head>
<body>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <div class="page-wrapper">
        <div class="signup-container">
            <h1 class="main-title">개인회원 가입</h1>

            <div class="progress-stepper">
                <div class="step">01. 본인 확인</div>
                <div class="step">02. 약관 동의</div>
                <div class="step active">03. 정보 입력</div>
                <div class="step">04. 가입 완료</div>
            </div>

            <div class="content-box">
                <h2>정보 입력</h2>
                <form class="info-form" action="${pageContext.request.contextPath}/joinProc" method="post">
                    <div class="form-group">
                        <label for="name">이름</label>
                        <input type="text" id="name" name="name" required>
                    </div>

                    <div class="form-group">
                        <label for="rrn1">주민등록번호</label>
                        <div class="rrn-inputs">
                            <input type="text" id="rrn1" maxlength="6" required>
                            <span class="hyphen">-</span>
                            <input type="password" id="rrn2" maxlength="7" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="userId">아이디</label>
                        <div class="input-group">
                            <input type="text" id="userId" name="username" required>
                            <button type="button" class="btn-sm">중복 확인</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">비밀번호</label>
                        <input type="password" id="password" name="password" required>
                    </div>

                    <div class="form-group">
                        <label for="passwordCheck">비밀번호 확인</label>
                        <input type="password" id="passwordCheck" required>
                        <p class="message" id="passwordMessage"></p>
                    </div>

                    <%-- ▼▼▼ 주소 입력 부분 수정 ▼▼▼ --%>
                    <div class="form-group">
                        <label for="postcode">주소</label>
                        <div class="input-group" style="margin-bottom: 8px;">
                            <input type="text" id="postcode" name="zipCode" placeholder="우편번호" readonly>
                            <button type="button" class="btn-sm" onclick="execDaumPostcode()">주소 검색</button>
                        </div>
                        <input type="text" id="baseAddress" name="addressBase" placeholder="기본주소" readonly style="margin-bottom: 8px;">
                        <input type="text" id="detailAddress" name="addressDetail" placeholder="상세주소">
                    </div>

                    <input type="hidden" id="registrationNumber" name="registrationNumber">

                    <div class="action-buttons">
                        <button type="button" class="btn btn-cancel" onclick="location.href='${pageContext.request.contextPath}/login'">취소</button>
                        <button type="button" id="submitBtn" class="btn btn-primary" disabled>가입 완료</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        const passwordInput = document.getElementById('password');
        const passwordCheckInput = document.getElementById('passwordCheck');
        const passwordMessage = document.getElementById('passwordMessage');
        const submitButton = document.getElementById('submitBtn'); // 'nextButton'에서 이름 변경
        const infoForm = document.querySelector('.info-form');

        function checkPasswords() {
            const password = passwordInput.value;
            const passwordCheck = passwordCheckInput.value;

            if (password && passwordCheck) {
                if (password === passwordCheck) {
                    passwordMessage.textContent = '비밀번호가 일치합니다.';
                    passwordMessage.className = 'message success';
                    submitButton.disabled = false;
                } else {
                    passwordMessage.textContent = '비밀번호가 일치하지 않습니다.';
                    passwordMessage.className = 'message error';
                    submitButton.disabled = true;
                }
            } else {
                passwordMessage.textContent = '';
                submitButton.disabled = true;
            }
        }

        passwordInput.addEventListener('keyup', checkPasswords);
        passwordCheckInput.addEventListener('keyup', checkPasswords);

        function execDaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    let addr = '';
                    if (data.userSelectedType === 'R') { // 도로명 주소 선택
                        addr = data.roadAddress;
                    } else { // 지번 주소 선택
                        addr = data.jibunAddress;
                    }
                    document.getElementById('postcode').value = data.zonecode;
                    document.getElementById("baseAddress").value = addr;
                    document.getElementById("detailAddress").focus();
                }
            }).open();
        }

        submitButton.addEventListener('click', function() {
            // 1. 주민등록번호 조합
            const rrn1 = document.getElementById('rrn1').value;
            const rrn2 = document.getElementById('rrn2').value;
            document.getElementById('registrationNumber').value = rrn1 + rrn2;

            // 2. 주소를 합치는 로직 제거
            // 각 주소 필드에 name 속성이 부여되어 있으므로, 폼 제출 시 자동으로 전송됩니다.
            
            // 3. 폼 제출
            infoForm.submit();
        });
    </script>
</body>
</html>