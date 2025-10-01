<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>육아휴직 급여 신청</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<style>
    :root {
        --primary-color: #3f58d4;
        --primary-light-color: #f0f2ff;
        --white-color: #ffffff;
        --light-gray-color: #f8f9fa;
        --gray-color: #868e96;
        --dark-gray-color: #343a40;
        --border-color: #dee2e6;
        --success-color: #28a745;
        --warning-bg-color: #fff3cd;
        --warning-border-color: #ffeeba;
        --warning-text-color: #856404;
        --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
        --shadow-md: 0 4px 8px rgba(0,0,0,0.07);
    }

    /* 기본 스타일 */
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html { height: 100%; }
    body {
        display: flex; flex-direction: column; min-height: 100vh;
        font-family: 'Noto Sans KR', sans-serif; background-color: var(--light-gray-color);
        color: var(--dark-gray-color);
    }
    a { text-decoration: none; color: inherit; }
    
    .header, .footer {
        background-color: var(--white-color); padding: 15px 40px; border-bottom: 1px solid var(--border-color); box-shadow: var(--shadow-sm);
    }
    .footer { border-top: 1px solid var(--border-color); border-bottom: none; text-align: center; padding: 20px 0; }
    .header { display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 10; }
    .header nav { display: flex; align-items: center; gap: 15px; }
    .header .welcome-msg { font-size: 16px; }

    .main-container {
        flex-grow: 1; width: 100%; max-width: 850px; margin: 40px auto; padding: 40px;
        background-color: var(--white-color); border-radius: 12px; box-shadow: var(--shadow-md);
    }

    h1 { text-align: center; margin-bottom: 30px; font-size: 28px; }
    h2 {
        color: var(--primary-color); border-bottom: 2px solid var(--primary-light-color);
        padding-bottom: 10px; margin-bottom: 25px; font-size: 20px;
    }

    .form-section { margin-bottom: 40px; }
    .form-group { display: flex; align-items: center; margin-bottom: 18px; gap: 20px; }
    .form-group label.field-title { width: 160px; font-weight: 500; color: #555; flex-shrink: 0; }
    .form-group .input-field { flex-grow: 1; }
    
    input[type="text"], input[type="date"], input[type="number"], select {
        width: 100%; padding: 10px; border: 1px solid var(--border-color);
        border-radius: 6px; transition: all 0.2s ease-in-out;
    }
    input:focus, select:focus {
        border-color: var(--primary-color); box-shadow: 0 0 0 3px rgba(63, 88, 212, 0.15); outline: none;
    }
    input[readonly] { background-color: var(--light-gray-color); cursor: not-allowed; }
    
    .btn {
        display: inline-block; padding: 10px 20px; font-size: 15px; font-weight: 500;
        border-radius: 8px; border: 1px solid var(--border-color); cursor: pointer;
        transition: all 0.2s ease-in-out; text-align: center;
    }
    .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
    .btn-primary:hover { background-color: #364ab1; box-shadow: var(--shadow-md); transform: translateY(-2px); }
    .btn-secondary { background-color: var(--white-color); color: var(--gray-color); border-color: var(--border-color); }
    .btn-secondary:hover { background-color: var(--light-gray-color); color: var(--dark-gray-color); border-color: #ccc; }
    .btn-logout { background-color: var(--dark-gray-color); color: var(--white-color); border: none; }
    .btn-logout:hover { background-color: #555; }

    /* ▼▼▼ 수정된 버튼 스타일 ▼▼▼ */
    .submit-button {
        padding: 12px 30px;
        font-size: 1.1em;
        background-color: var(--primary-color);
        border-color: var(--primary-color);
        color: white;
    }
    .submit-button:hover {
        background-color: #364ab1;
        border-color: #364ab1;
        transform: translateY(-2px);
    }
    .submit-button-container { text-align: center; margin-top: 30px; }
    
    .radio-group, .checkbox-group { display: flex; align-items: center; gap: 15px; }
    .radio-group input[type="radio"], .checkbox-group input[type="checkbox"] { margin-right: -10px; }
    
    .info-box {
        background-color: var(--primary-light-color); border: 1px solid #d1d9ff; padding: 15px;
        margin-top: 10px; border-radius: 6px; font-size: 14px;
    }
    .info-box p { margin: 5px 0; }

    .notice-box {
        border: 1px solid var(--warning-border-color); background-color: var(--warning-bg-color);
        color: var(--warning-text-color); padding: 20px; margin-top: 20px;
        border-radius: 8px; display: flex; align-items: flex-start;
    }
    .notice-icon { font-size: 1.8em; margin-right: 15px; margin-top: -2px; }
    .notice-box h3 { margin: 0 0 8px 0; }

    #months-input-section { display: none; }
    .dynamic-form-container { margin-top: 20px; border-top: 1px solid var(--border-color); padding-top: 20px; }
    .dynamic-form-row {
        display: flex; align-items: center; gap: 15px; padding: 10px;
        border-radius: 6px; margin-bottom: 10px;
    }
    .dynamic-form-row:nth-child(odd) { background-color: var(--primary-light-color); }
    .date-range-display { font-weight: 500; flex-basis: 300px; flex-shrink: 0; text-align: center; }
    .payment-input-field { flex-grow: 1; }
</style>
</head>
<body>
    <header class="header">
        <a href="#" class="logo"><img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" width="80" height="80"></a>
        <nav>
            <span class="welcome-msg">김신청님, 환영합니다.</span>
            <a href="#" class="btn btn-logout">로그아웃</a>
        </nav>
    </header>

    <main class="main-container">
        <h1>육아휴직 급여 신청</h1>

        <form action="#" method="post" onsubmit="return false;">
            <div class="form-section">
                <h2>신청인 정보</h2>
                <div class="form-group">
                    <label class="field-title">이름</label>
                    <div class="input-field"><input type="text" value="김신청" readonly></div>
                </div>
                <div class="form-group">
                    <label class="field-title">주민등록번호</label>
                    <div class="input-field"><input type="text" value="900101-1******" readonly></div>
                </div>
                <div class="form-group">
                    <label class="field-title">주소</label>
                    <div class="input-field"><input type="text" value="서울특별시 종로구 세종대로 175" readonly></div>
                </div>
                <div class="form-group">
                    <label class="field-title">휴대전화번호</label>
                    <div class="input-field"><input type="text" value="010-1234-5678" readonly></div>
                </div>
            </div>

            <div class="form-section">
                <h2>사업장 정보</h2>
                <div class="form-group">
                    <label class="field-title">사업장 동의여부</label>
                    <div class="input-field radio-group">
                        <input type="radio" id="consent-yes" name="consent" value="yes" checked><label for="consent-yes">예</label>
                        <input type="radio" id="consent-no" name="consent" value="no"><label for="consent-no">아니요</label>
                    </div>
                </div>
                <div class="form-group">
                    <label class="field-title">사업장 이름</label>
                    <div class="input-field"><input type="text" placeholder="사업장 이름을 입력하세요"></div>
                </div>
                <div class="form-group">
                    <label class="field-title">사업장 등록번호</label>
                    <div class="input-field"><input type="text" placeholder="'-' 없이 숫자만 입력하세요"></div>
                </div>
                <div class="form-group">
                    <label class="field-title">사업장 주소</label>
                    <div class="input-field"><input type="text" placeholder="사업장 주소를 입력하세요"></div>
                </div>
            </div>

            <div class="form-section">
                <h2>급여 신청 기간</h2>
                <p style="color: #888; margin-top: -15px; margin-bottom: 20px;">
                    ※ 사업주로부터 부여받은 총 휴직 기간 중 급여를 지급받으려는 기간을 입력해 주세요.
                </p>
			<div class="form-group">
				<label class="field-title" for="start-date">① 육아휴직 시작일</label>
				<div class="input-field">
					<input type="date" id="start-date" name="start-date">
				</div>
			</div>
			<div id="months-input-section">
				<div class="form-group">
					<label class="field-title" for="leave-months">② 휴직 개월 수</label>
					<div class="input-field"
						style="display: flex; align-items: center; gap: 10px;">
						<input type="number" id="leave-months" name="leave-months" min="1"
							max="12" placeholder="최대 12개월"
							style="width: 150px; flex-grow: 0;">
						<button type="button" id="generate-forms-btn"
							class="btn btn-primary">확인</button>

						<label id="no-payment-wrapper"
							style="display: none; align-items: center; gap: 6px; margin-left: 8px;">
							<input type="checkbox" id="no-payment" /> 사업장 지급액 없음
						</label>
					</div>
				</div>
			</div>
			<div id="dynamic-forms-container" class="dynamic-form-container"></div>
		</div>
            
            <div class="form-section">
                <h2>자녀 정보</h2>
                 <div class="form-group">
                    <label class="field-title">자녀 이름</label>
                    <div class="input-field"><input type="text" placeholder="자녀의 이름을 입력하세요"></div>
                </div>
                <div class="form-group">
                    <label class="field-title">자녀 주민등록번호</label>
                    <div class="input-field"><input type="text" placeholder="예: 250101-3******"></div>
                </div>
                <div class="form-group">
                    <label class="field-title"></label>
                    <div class="input-field checkbox-group">
                        <input type="checkbox" id="no-rrn"><label for="no-rrn">해외출생 등으로 주민등록번호가 없는 경우</label>
                    </div>
                </div>
                <div class="form-group">
                    <label class="field-title" for="birth-date">출산(예정)일</label>
                    <div class="input-field"><input type="date" id="birth-date" name="birth-date"></div>
                </div>
            </div>

            <div class="form-section">
                <h2>급여 입금 계좌정보</h2>
                <div class="form-group">
                    <label class="field-title">은행</label>
                    <div class="input-field">
                        <select name="bank">
                            <option value="">은행 선택</option>
                            <option value="nh">농협</option>
                            <option value="kb">KB 국민</option>
                            <option value="kakao">카카오뱅크</option>
                            <option value="shinhan">신한</option>
                            <option value="woori">우리</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label class="field-title">계좌번호</label>
                    <div class="input-field"><input type="text" placeholder="'-' 없이 숫자만 입력하세요"></div>
                </div>
                <div class="form-group">
                    <label class="field-title">예금주 이름</label>
                    <div class="input-field"><input type="text" placeholder="예금주 실명을 입력하세요"></div>
                </div>
            </div>
            
            <div class="form-section">
                <h2>접수 센터 선택</h2>
                <div class="form-group">
                    <label class="field-title">접수센터 기준</label>
                    <div class="input-field radio-group">
                        <input type="radio" id="center-addr" name="center" value="addr"><label for="center-addr">민원인 주소</label>
                        <input type="radio" id="center-work" name="center" value="work" checked><label for="center-work">사업장 주소</label>
                        <button type="button" class="btn btn-secondary" style="margin-left: 10px;">센터 찾기</button>
                    </div>
                </div>
                <div class="info-box">
                    <p><strong>관할센터:</strong> 서울 혜화 고용센터</p>
                    <p><strong>대표전화:</strong> 02-2077-6000</p>
                    <p><strong>주소:</strong> (03086) 서울특별시 종로구 창경궁로 112-7 (인의동)</p>
                </div>
            </div>
            
            <div class="form-section">
                <div class="notice-box">
                    <span class="notice-icon">⚠️</span>
                    <div>
                        <h3>부정수급 안내</h3>
                        <p>위 급여신청서에 기재한 내용에 거짓이 있을 경우에는 급여의 지급이 중단되고 지급받은 급여액에 상당하는 금액을 반환해야 합니다. 또한, 추가적인 반환금액이 발생할 수 있으며 경우에 따라서는 형사 처벌도 받을 수 있습니다.</p>
                    </div>
                </div>
                <div class="checkbox-group" style="justify-content: center; margin-top: 20px;">
                    <input type="checkbox" id="agree-notice" name="agree-notice">
                    <label for="agree-notice">위 안내사항을 모두 확인했으며, 신청서 내용에 거짓이 없음을 확인합니다.</label>
                </div>
            </div>
            
            <div class="submit-button-container">
                <button type="submit" class="btn submit-button">신청서 제출하기</button>
            </div>
        </form>
    </main>

    <footer class="footer">
        <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
    </footer>

    <script>
        var startDateInput = document.getElementById('start-date');
        var monthsInputSection = document.getElementById('months-input-section');
        var monthsInput = document.getElementById('leave-months');
        var generateBtn = document.getElementById('generate-forms-btn');
        var formsContainer = document.getElementById('dynamic-forms-container');
        var noPaymentChk = document.getElementById('no-payment'); 

        startDateInput.addEventListener('change', function() {
            if (startDateInput.value) {
                monthsInputSection.style.display = 'block';
                formsContainer.innerHTML = '';
            } else {
                monthsInputSection.style.display = 'none';
            }
        });
        
        function getPaymentInputs() {
        	  return formsContainer.querySelectorAll('input[name^="monthly_payment_"]');
        	}
        
        function applyNoPaymentState() {
        	  var inputs = getPaymentInputs();
        	  inputs.forEach(function(inp){
        	    if (noPaymentChk.checked) {
        	      // 체크 상태 → 0으로 고정
        	      inp.value = 0;
        	      inp.readOnly = true;
        	      inp.classList.add('readonly-like');
        	    } else {
        	      // 해제 상태 → 다시 입력 가능 + 값 비우기
        	      inp.readOnly = false;
        	      inp.classList.remove('readonly-like');
        	      inp.value = '';   // ★ 해제 시 입력값 없게 만들기
        	    }
        	  });
        	}
        noPaymentChk.addEventListener('change', applyNoPaymentState);

        generateBtn.addEventListener('click', function() {
            var startDate = new Date(startDateInput.value);
            var months = parseInt(monthsInput.value, 10);

            if (!startDateInput.value) {
                alert('육아휴직 시작일을 먼저 선택해주세요.');
                return;
            }
            if (isNaN(months) || months < 1 || months > 12) {
                alert('휴직 개월 수는 1에서 12 사이의 숫자로 입력해주세요.');
                return;
            }

            formsContainer.innerHTML = '';
            
            var currentStartDate = new Date(startDate.getTime());

            for (var i = 1; i <= months; i++) {
                var periodEndDate = new Date(currentStartDate.getTime());
                periodEndDate.setMonth(periodEndDate.getMonth() + 1);
                periodEndDate.setDate(periodEndDate.getDate() - 1);

                var formatDate = function(date) {
                    var y = date.getFullYear();
                    var m = String(date.getMonth() + 1).padStart(2, '0');
                    var d = String(date.getDate()).padStart(2, '0');
                    return y + '.' + m + '.' + d;
                };
                
                var dateRangeText = formatDate(currentStartDate) + ' ~ ' + formatDate(periodEndDate);
                var formRow = document.createElement('div');
                formRow.className = 'dynamic-form-row';
                
                formRow.innerHTML =
                    '<div class="date-range-display">' + dateRangeText + '</div>' +
                    '<div class="payment-input-field">' +
                        '<input type="number" name="monthly_payment_' + i + '" placeholder="해당 월의 사업장 지급액(원) 입력">' +
                    '</div>';
                
                formsContainer.appendChild(formRow);
                currentStartDate = new Date(periodEndDate.getTime());
                currentStartDate.setDate(currentStartDate.getDate() + 1);
            }
            
            document.getElementById('no-payment-wrapper').style.display = 'flex';
            applyNoPaymentState();
        });
    </script>
</body>
</html>