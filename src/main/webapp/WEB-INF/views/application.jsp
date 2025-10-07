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
   input[readonly], input.readonly-like { background-color: var(--light-gray-color); cursor: not-allowed; }
   
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

   #period-input-section { display: none; }
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
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
 <header class="header">
        <a href="${pageContext.request.contextPath}/main" class="logo"><img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" width="80" height="80"></a>
        <nav>
            <sec:authorize access="isAnonymous()">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">로그인</a>
            </sec:authorize>
            <sec:authorize access="isAuthenticated()">
                <span class="welcome-msg">
                    <sec:authentication property="principal.username"/>님, 환영합니다.
                </span>
                <form id="logout-form" action="${pageContext.request.contextPath}/logout" method="post" style="display: none;">
                    <sec:csrfInput/>
                </form>
                <a href="#" onclick="document.getElementById('logout-form').submit(); return false;" class="btn btn-logout">로그아웃</a>
            </sec:authorize>
        </nav>
    </header>


   <main class="main-container">
      <h1>육아휴직 급여 신청</h1>

      <form action="${pageContext.request.contextPath}/apply" method="post">
      <sec:csrfInput/>
         <div class="form-section">
    <h2>신청인 정보</h2>
    <div class="form-group">
      <label class="field-title">이름</label>
      <div class="input-field"><input type="text" value="${userDTO.name}" readonly></div>
    </div>
    <div class="form-group">
      <label class="field-title">주민등록번호</label>
      <div class="input-field"><input type="text" value="${userDTO.registrationNumber}" readonly></div>
    </div>
    <div class="form-group">
      <label class="field-title">주소</label>
      <div class="input-field"><input type="text" value="${userDTO.zipNumber} ${userDTO.addressBase} ${userDTO.addressDetail}" readonly></div>
    </div>
    <div class="form-group">
      <label class="field-title">휴대전화번호</label>
      <div class="input-field"><input type="text" value="010-1234-5678" readonly></div>
    </div>
  </div>

  <!-- ===== 사업장 정보 ===== -->
  <div class="form-section">
    <h2>사업장 정보</h2>

    <!-- 사업장 동의여부 → businessAgree: Y/N -->
    <div class="form-group">
      <label class="field-title">사업장 동의여부</label>
      <div class="input-field radio-group">
        <input type="radio" id="consent-yes" name="businessAgree" value="Y">
        <label for="consent-yes">예</label>
        <input type="radio" id="consent-no" name="businessAgree" value="N">
        <label for="consent-no">아니요</label>
      </div>
    </div>

    <div class="form-group">
      <label class="field-title">사업장 이름</label>
      <div class="input-field">
        <input type="text" name="businessName" placeholder="사업장 이름을 입력하세요">
      </div>
    </div>
    <div class="form-group">
      <label class="field-title">사업장 등록번호</label>
      <div class="input-field">
        <input type="text" name="businessRegiNumber" placeholder="'-' 없이 숫자만 입력하세요">
      </div>
    </div>
    <div class="form-group">
      <label class="field-title">사업장 주소</label>
      <div class="input-field">
        <div class="addr-row">
          <input type="text" id="biz-postcode" name="businessZipNumber" placeholder="우편번호" value="${applicationDTO.businessZipNumber}" readonly>
          <button type="button" class="btn btn-secondary btn-sm" onclick="execDaumPostcode('biz')">주소 검색</button>
        </div>
        <input type="text" id="biz-base" name="businessAddrBase" placeholder="기본주소" value="${applicationDTO.businessAddrBase}" readonly style="margin-top: 8px;">
        <input type="text" id="biz-detail" name="businessAddrDetail" placeholder="상세주소" value="${applicationDTO.businessAddrDetail}" style="margin-top: 8px;">
      </div>
    </div>
  </div>

  <!-- ===== 급여 신청 기간 ===== -->
		<div class="form-section">
			<h2>급여 신청 기간</h2>
			<p style="color: #888; margin-top: -15px; margin-bottom: 20px;">※
				사업주로부터 부여받은 총 휴직 기간 중 급여를 지급받으려는 기간을 입력해 주세요.</p>

			<!-- startDate / endDate: DTO 필드명과 일치 -->
			<div class="form-group">
				<label class="field-title" for="start-date">① 육아휴직 시작일</label>
				<div class="input-field">
					<input type="date" id="start-date" name="startDate">
				</div>
			</div>

			<div id="period-input-section">
				<div class="form-group">
					<label class="field-title" for="end-date">② 육아휴직 종료일</label>
					<div class="input-field"
						style="display: flex; align-items: center; gap: 10px;">
						<input type="date" id="end-date" name="endDate"
							style="width: auto; flex-grow: 1;">
						<button type="button" id="generate-forms-btn"
							class="btn btn-primary">기간 생성</button>

						<!-- 회사지급 없음 체크 → name 추가! -->
						<label id="no-payment-wrapper"
							style="display: none; align-items: center; gap: 6px; margin-left: 8px;">
							<input type="checkbox" id="no-payment" name="noPayment" /> 사업장
							지급액 없음
						</label>
					</div>
				</div>
			</div>

			<!-- JS가 monthly_payment_1..N 입력을 생성 -->
			<div id="dynamic-forms-container" class="dynamic-form-container"></div>
		</div>

		<!-- ===== 통상임금 / 주당시간 ===== -->
		<div class="form-group">
			<label class="field-title">통상임금(월)</label>
			<div class="input-field">
				<input type="number" name="regularWage" placeholder="숫자만 입력하세요">
			</div>
		</div>
		<div class="form-group">
			<label class="field-title">주당 소정근로시간</label>
			<div class="input-field">
				<input type="number" name="weeklyHours" placeholder="숫자만 입력하세요">
			</div>
		</div>

		<!-- ===== 자녀 정보 ===== -->
		<div class="form-section">
			<h2>자녀 정보</h2>

			<!-- 서버로 제출될 "단 하나"의 필드 -->
			<input type="hidden" name="childBirthDate" id="childBirthDateHidden">

			<div class="input-field radio-group">
				<input type="radio" name="birthType" value="born" id="bt-born"><label
					for="bt-born">출생일</label> <input type="radio" name="birthType"
					value="expected" id="bt-expected"><label for="bt-expected">출산예정일</label>
			</div>

			<div id="born-fields" style="display: none;">
				<div class="form-group">
					<label class="field-title" for="child-name">자녀 이름</label>
					<div class="input-field">
						<input type="text" id="child-name" name="childName"
							placeholder="자녀의 이름을 입력하세요">
					</div>
				</div>
				<div class="form-group">
					<label class="field-title" for="child-rrn">자녀 주민등록번호</label>
					<div class="input-field">
						<input type="text" id="child-rrn" name="childResiRegiNumber"
							placeholder="예: 250101-3******">
					</div>
				</div>
				<div class="form-group">
					<label class="field-title" for="birth-date">출생일</label>
					<div class="input-field">
						<!-- name 제거! 제출 안 됨 -->
						<input type="date" id="birth-date">
					</div>
				</div>
			</div>

			<div id="expected-fields" style="display: none;">
				<div class="form-group">
					<label class="field-title" for="expected-date">출산예정일</label>
					<div class="input-field">
						<!-- name 제거! 제출 안 됨 -->
						<input type="date" id="expected-date">
					</div>
					<small style="color: #666;">※ 오늘 이후 날짜만 선택 가능</small>
				</div>
			</div>
		</div>
		<!-- ===== 입금 계좌 ===== -->
		<div class="form-section">
			<h2>급여 입금 계좌정보</h2>
			<div class="form-group">
				<label class="field-title">은행</label>
				<div class="input-field">
					<!-- bankCode로 서버에 전송 -->
					<select name="bankCode">
						<option value="">은행 선택</option>
						<option value="011">NH 농협</option>
						<option value="004">KB 국민</option>
						<option value="090">카카오뱅크</option>
						<option value="088">신한</option>
						<option value="020">우리</option>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="field-title">계좌번호</label>
				<div class="input-field">
					<input type="text" name="accountNumber"
						placeholder="'-' 없이 숫자만 입력하세요">
				</div>
			</div>
			<!-- 접수센터선택은 아직 아무것도 안됨 선택하는척 하는곳 -->
			<div class="form-section">
				<h2>접수 센터 선택</h2>
				<div class="form-group">
					<label class="field-title">접수센터 기준</label>
					<div class="input-field radio-group">
						<input type="radio" id="center-addr" name="center" value="addr"><label
							for="center-addr">민원인 주소</label> <input type="radio"
							id="center-work" name="center" value="work"><label
							for="center-work">사업장 주소</label>
						<button type="button" class="btn btn-secondary"
							style="margin-left: 10px;">센터 찾기</button>
					</div>
				</div>
				<div class="info-box">
					<p>
						<strong>관할센터:</strong> 서울 고용 복지 플러스 센터
					</p>
					<p>
						<strong>대표전화:</strong> 02-2004-7301
					</p>
					<p>
						<strong>주소:</strong> 서울 중구 삼일대로363 1층 (장교동)
					</p>
				</div>
			</div>
			<!-- 행정정보 공동이용 동의 → govInfoAgree: Y/N -->
			<div class="form-group">
				<label class="field-title">행정정보 공동이용 동의</label>
				<div class="input-field radio-group">
					<input type="radio" id="gov-yes" name="govInfoAgree" value="Y"><label
						for="gov-yes">동의</label> <input type="radio" id="gov-no"
						name="govInfoAgree" value="N"><label for="gov-no">비동의</label>
				</div>
			</div>
		</div>

		<!-- ===== 안내/동의 ===== -->
  <div class="form-section">
    <div class="notice-box">
      <span class="notice-icon">⚠️</span>
      <div>
        <h3>부정수급 안내</h3>
        <p>위 급여신청서에 기재한 내용에 거짓이 있을 경우에는 급여의 지급이 중단되고 지급받은 급여액에 상당하는 금액을 반환해야 합니다. 또한, 추가적인 반환금액이 발생할 수 있으며 경우에 따라서는 형사 처벌도 받을 수 있습니다.</p>
      </div>
    </div>
    <div class="checkbox-group" style="justify-content:center; margin-top:20px;">
      <input type="checkbox" id="agree-notice" name="agreeNotice">
      <label for="agree-notice">위 안내사항을 모두 확인했으며, 신청서 내용에 거짓이 없음을 확인합니다.</label>
    </div>
  </div>

  <!-- ===== 제출/임시저장 버튼 (action 값으로 구분) ===== -->
  <div class="submit-button-container" style="display:flex; gap:10px; justify-content:center;">
    <button type="submit" name="action" value="register" class="btn submit-button" style="background:#6c757d; border-color:#6c757d;">임시저장</button>
    <button type="submit" name="action" value="submit"   class="btn submit-button">신청서 제출하기</button>
  </div>
</form>
   </main>

   <footer class="footer">
      <p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
   </footer>

<script>
document.addEventListener('DOMContentLoaded', function () {
  // ===== DOM 참조 =====
  var startDateInput = document.getElementById('start-date');
  var endDateInput = document.getElementById('end-date');
  var periodInputSection = document.getElementById('period-input-section');
  var generateBtn = document.getElementById('generate-forms-btn');
  var formsContainer = document.getElementById('dynamic-forms-container');
  var noPaymentChk = document.getElementById('no-payment');
  var noPaymentWrapper = document.getElementById('no-payment-wrapper');

  // ===== 유틸/헬퍼 =====
  function formatDate(date) {
    var y = date.getFullYear();
    var m = String(date.getMonth() + 1).padStart(2, '0');
    var d = String(date.getDate()).padStart(2, '0');
    return y + '.' + m + '.' + d;
  }
  // 월 더하기 (없는 일자는 그 달의 말일로 클램프) — Java LocalDate.plusMonths와 동일 동작
  function plusMonthsClamp(date, months) {
    var y = date.getFullYear(), m = date.getMonth(), d = date.getDate();
    var targetM = m + months;
    var targetY = y + Math.floor(targetM / 12);
    var normM   = ((targetM % 12) + 12) % 12;
    var last    = new Date(targetY, normM + 1, 0).getDate(); // 다음달 0일 = 말일
    var day     = Math.min(d, last);
    return new Date(targetY, normM, day);
  }
  // 단위기간 종료일 = 다음달 같은 날 - 1일
  function endOfUnit(start) {
    var nextSame = plusMonthsClamp(start, 1);
    var e = new Date(nextSame.getTime());
    e.setDate(e.getDate() - 1);
    return e;
  }

  function getPaymentInputs() {
    return formsContainer.querySelectorAll('input[name^="monthly_payment_"]');
  }
  function applyNoPaymentState() {
    var inputs = getPaymentInputs();
    inputs.forEach(function(inp){
      if (noPaymentChk && noPaymentChk.checked) {
        inp.value = 0;
        inp.readOnly = true;
        inp.classList.add('readonly-like');
      } else {
        inp.readOnly = false;
        inp.classList.remove('readonly-like');
        if (inp.value === '0') inp.value = '';
      }
    });
  }

  // ===== 날짜 입력 보이기/초기화 =====
  startDateInput.addEventListener('change', function() {
    if (startDateInput.value) {
      periodInputSection.style.display = 'block';
      endDateInput.min = startDateInput.value;
      formsContainer.innerHTML = '';
      if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
    } else {
      periodInputSection.style.display = 'none';
    }
  });
  endDateInput.addEventListener('change', function () {
    formsContainer.innerHTML = '';
    if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';
  });
  if (noPaymentChk) noPaymentChk.addEventListener('change', applyNoPaymentState);

  // ===== 기간 생성: DB splitPeriodsAndCalc와 동일 경계 =====
  generateBtn.addEventListener('click', function() {
    if (!startDateInput.value || !endDateInput.value) {
      alert('육아휴직 시작일과 종료일을 모두 선택해주세요.');
      return;
    }

    var startDate = new Date(startDateInput.value + 'T00:00:00');
    var endDate   = new Date(endDateInput.value   + 'T00:00:00');

    if (startDate > endDate) {
      alert('종료일은 시작일보다 빠를 수 없습니다.');
      return;
    }

    // (선택) 최대 12개월 제한 — 시작월~종료월 포함 개수 기준
    var monthCount = 0;
    var mc = new Date(startDate.getFullYear(), startDate.getMonth(), 1);
    var endMonth = new Date(endDate.getFullYear(), endDate.getMonth(), 1);
    while (mc <= endMonth) { monthCount++; mc.setMonth(mc.getMonth() + 1); }
    if (monthCount > 12) {
      alert('최대 12개월까지만 신청 가능합니다. 종료일을 조정해주세요.');
      return;
    }

    // UI 초기화
    formsContainer.innerHTML = '';
    if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';

    // 단위기간 생성
    var currentStartDate = new Date(startDate.getTime());
    var i = 1;

    while (currentStartDate <= endDate) {
      // DB 동일: periodEnd = min(endOfUnit(currentStartDate), endDate)
      var candidateEnd = endOfUnit(currentStartDate);
      var displayEnd   = (candidateEnd > endDate) ? new Date(endDate.getTime()) : candidateEnd;

      // 표시 텍스트(지급일은 참고용, 필요 없으면 주석)
      var rangeText = formatDate(currentStartDate) + ' ~ ' + formatDate(displayEnd);

      // 행 추가
      var row = document.createElement('div');
      row.className = 'dynamic-form-row';
      row.innerHTML =
        '<div class="date-range-display">' +
          '<div>' + rangeText + '</div>' +
        '<div class="payment-input-field">' +
          '<input type="number" name="monthly_payment_' + i + '" placeholder="해당 기간의 사업장 지급액(원) 입력">' +
        '</div>';
      formsContainer.appendChild(row);

      // 다음 구간 시작 = 이번 구간 끝 + 1일
      currentStartDate = new Date(displayEnd.getTime());
      currentStartDate.setDate(currentStartDate.getDate() + 1);
      i++;

       if (i > 13) { alert('최대 12개월(12구간)까지만 신청 가능합니다.'); formsContainer.innerHTML = ''; return; }
    }

    if (noPaymentWrapper) {
      noPaymentWrapper.style.display = 'flex';
      applyNoPaymentState();
    }
  });

  // ===== 자녀정보: 보이기/숨기기 + hidden 미러링 =====
  const hidden   = document.getElementById('childBirthDateHidden');
  const bornWrap = document.getElementById('born-fields');
  const expWrap  = document.getElementById('expected-fields');
  const birth    = document.getElementById('birth-date');     // 출생일 date (name 없음)
  const exp      = document.getElementById('expected-date');  // 예정일 date (name 없음)
  const radios   = document.querySelectorAll('input[name="birthType"]');
  const rBorn    = document.getElementById('bt-born');
  const rExp     = document.getElementById('bt-expected');

  // 예정일: 오늘 이후만 선택 가능
  if (exp) {
    const today = new Date(); today.setHours(0,0,0,0);
    const min = new Date(today); min.setDate(min.getDate()+1);
    const mm = String(min.getMonth()+1).padStart(2,'0');
    const dd = String(min.getDate()).padStart(2,'0');
    exp.min = `${min.getFullYear()}-${mm}-${dd}`;
  }

  function setHiddenFrom(el) { if (hidden && el) hidden.value = el.value || ''; }
  function setBornRequired(on) {
    const name = document.getElementById('child-name');
    const rrn  = document.getElementById('child-rrn');
    if (name)  name.required  = on;
    if (rrn)   rrn.required   = on;
    if (birth) birth.required = on;
  }
  function setExpectedRequired(on) { if (exp) exp.required = on; }
  function clearBorn() {
    const name = document.getElementById('child-name');
    const rrn  = document.getElementById('child-rrn');
    if (name)  name.value = '';
    if (rrn)   rrn.value  = '';
    if (birth) birth.value = '';
  }
  function clearExpected() { if (exp) exp.value = ''; }

  function updateView() {
    const checked = document.querySelector('input[name="birthType"]:checked');
    if (!checked) {
      bornWrap.style.display = 'none';
      expWrap.style.display  = 'none';
      setBornRequired(false);
      setExpectedRequired(false);
      if (hidden) hidden.value = '';
      return;
    }
    if (checked.value === 'born') {
      bornWrap.style.display = '';
      expWrap.style.display  = 'none';
      setBornRequired(true);
      setExpectedRequired(false);
      clearExpected();
      setHiddenFrom(birth);
    } else {
      bornWrap.style.display = 'none';
      expWrap.style.display  = '';
      setBornRequired(false);
      setExpectedRequired(true);
      clearBorn();
      setHiddenFrom(exp);
    }
  }

  if (birth) birth.addEventListener('change', function(){
    if (rBorn && rBorn.checked) setHiddenFrom(birth);
  });
  if (exp) exp.addEventListener('change', function(){
    if (rExp && rExp.checked) setHiddenFrom(exp);
  });
  radios.forEach(r => r.addEventListener('change', updateView));
  updateView();

  // 제출 직전 동기화
  const form = document.querySelector('form[action$="/apply"]');
  if (form) {
    form.addEventListener('submit', function() {
      const checked = document.querySelector('input[name="birthType"]:checked');
      if (checked && checked.value === 'born')  setHiddenFrom(birth);
      if (checked && checked.value === 'expected') setHiddenFrom(exp);
    });
  }
}); // DOMContentLoaded 끝

// ===== 다음 주소 API =====
function execDaumPostcode(prefix) {
  new daum.Postcode({
    oncomplete: function(data) {
      var addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
      var $zip    = document.getElementById(prefix + '-postcode');
      var $base   = document.getElementById(prefix + '-base');
      var $detail = document.getElementById(prefix + '-detail');
      if ($zip)    $zip.value = data.zonecode;
      if ($base)   $base.value = addr;
      if ($detail) $detail.focus();
    }
  }).open();
}
</script>

</body>
</html>