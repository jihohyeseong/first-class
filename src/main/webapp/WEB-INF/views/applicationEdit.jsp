<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>육아휴직 급여 신청 수정</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/global.css">
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
	
	input[type="text"], input[type="date"], input[type="number"],input[type="password"], select {
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

	#period-input-section { display: block; }
	.dynamic-form-container { margin-top: 20px; border-top: 1px solid var(--border-color); padding-top: 20px; }
	.dynamic-form-row {
		display: flex; align-items: center; gap: 15px; padding: 10px;
		border-radius: 6px; margin-bottom: 10px;
	}
	.dynamic-form-row:nth-child(odd) { background-color: var(--primary-light-color); }
	.date-range-display { font-weight: 500; flex-basis: 300px; flex-shrink: 0; text-align: center; }
	.payment-input-field{
		flex-grow: 1;
		display: flex;
		justify-content: flex-end;
	}
	
	button[name="action"][value="submit"]:disabled {
		opacity: .6; cursor: not-allowed;
	}
</style>
</head>
<body>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<%@ include file="header.jsp" %>

	<main class="main-container">
	<h1>육아휴직 급여 신청서 수정</h1>

	<form action="${pageContext.request.contextPath}/apply/edit" method="post">
		<input type="hidden" name="applicationNumber" value="${app.applicationNumber}">
		<sec:csrfInput/>
		<div class="form-section">

			<h2>신청인 정보</h2>
			<div class="form-group">
				<label class="field-title">이름</label>
				<div class="input-field">
					<input type="text" value="${userDTO.name}" readonly>
				</div>
			</div>
			<div class="form-group">
				<label class="field-title">주민등록번호</label>
				<div class="input-field">
					<c:set var="rrnRaw" value="${userDTO.registrationNumber}" />
					<c:set var="rrnDigits" value="${fn:replace(rrnRaw, '-', '')}" />
					<input type="text"
						value="${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,7)}******"
						readonly>
				</div>
			</div>
			<div class="form-group">
				<label class="field-title">주소</label>
				<div class="input-field">
					<input type="text"
						value="[${userDTO.zipNumber}] ${userDTO.addressBase} ${userDTO.addressDetail}"
						readonly>
				</div>
			</div>
			<div class="form-group">
				<label class="field-title">휴대전화번호</label>
				<div class="input-field">
					<input type="text" value="${userDTO.phoneNumber}" readonly>
				</div>
			</div>
		</div>

		<div class="form-section">
			<h2>사업장 정보</h2>

			<div class="form-group">
				<label class="field-title">사업장 동의여부</label>
				<div class="input-field radio-group">
					<input type="radio" id="consent-yes" name="businessAgree" value="Y"
						<c:if test="${app.businessAgree == 'Y'}">checked</c:if>> <label
						for="consent-yes">예</label> <input type="radio" id="consent-no"
						name="businessAgree" value="N"
						<c:if test="${app.businessAgree == 'N'}">checked</c:if>> <label
						for="consent-no">아니요</label>
				</div>
			</div>

			<div class="form-group">
				<label class="field-title">사업장 이름</label>
				<div class="input-field">
					<input type="text" name="businessName" value="${app.businessName}"
					placeholder="사업장 이름을 입력하세요">
				</div>
			</div>

			<div class="form-group">
				<label class="field-title">사업장 등록번호</label>
				<div class="input-field">
					<input type="text" id="businessRegiNumber"
						name="businessRegiNumber" inputmode="numeric" autocomplete="off"
						value="${app.businessRegiNumber}" placeholder="'-' 없이 숫자 10자리" />
				</div>
			</div>

			<div class="form-group">
				<label class="field-title">사업장 주소</label>
				<div class="input-field">
					<div class="addr-row" style="display: flex; gap: 8px;">
						<input type="text" id="biz-postcode" name="businessZipNumber"
							placeholder="우편번호" value="${app.businessZipNumber}" readonly>
						<button type="button" class="btn btn-secondary"
							onclick="execDaumPostcode('biz')" style="flex-shrink: 0;">주소 검색</button>
					</div>
					<input type="text" id="biz-base" name="businessAddrBase"
						placeholder="기본주소" value="${app.businessAddrBase}" readonly
						style="margin-top: 8px;">
					<input type="text" id="biz-detail" name="businessAddrDetail"
						placeholder="상세주소" value="${app.businessAddrDetail}"
						style="margin-top: 8px;">
				</div>
			</div>
		</div>

		<div class="form-section">
			<h2>급여 신청 기간</h2>
			<p style="color: #888; margin-top: -15px; margin-bottom: 20px;">
				※ 사업주로부터 부여받은 총 휴직 기간 중 급여를 지급받으려는 기간을 입력해 주세요.</p>
			
			<fmt:formatDate value="${app.startDate}" pattern="yyyy-MM-dd" var="startDateVal" />
			<fmt:formatDate value="${app.endDate}" pattern="yyyy-MM-dd" var="endDateVal" />

			<div class="form-group">
				<label class="field-title" for="start-date">① 육아휴직 시작일</label>
				<div class="input-field">
					<input type="date" id="start-date" name="startDate"
						value="${startDateVal}">
				</div>
			</div>

			<div id="period-input-section">
				<div class="form-group">
					<label class="field-title" for="end-date">② 육아휴직 종료일</label>
					<div class="input-field"
						style="display: flex; align-items: center; gap: 10px;">
						<input type="date" id="end-date" name="endDate"
							value="${endDateVal}" style="width: auto; flex-grow: 1;">
						<button type="button" id="generate-forms-btn"
							class="btn btn-primary">기간 생성</button>

						<c:set var="allZero" value="${true}" />
						<c:forEach var="t0" items="${terms}">
							<c:if
								test="${t0.companyPayment != null and t0.companyPayment != 0}">
								<c:set var="allZero" value="${false}" />
							</c:if>
						</c:forEach>

						<label id="no-payment-wrapper"
							style="display:flex; align-items:center; gap:6px; margin-left:8px;">
							<input type="checkbox" id="no-payment" name="noPayment"
							<c:if test="${allZero}">checked</c:if> /> 사업장 지급액 없음
						</label>
					</div>
				</div>
			</div>

			<div id="dynamic-forms-container" class="dynamic-form-container">
				<c:if test="${not empty terms}">
					<c:forEach var="t" items="${terms}" varStatus="st">
						<div class="dynamic-form-row">
							<div class="date-range-display">
								<div>
									<fmt:formatDate value="${t.startMonthDate}"
										pattern="yyyy.MM.dd" />
									&nbsp;~&nbsp;
									<fmt:formatDate value="${t.endMonthDate}" pattern="yyyy.MM.dd" />
								</div>
							</div>
							<div class="payment-input-field" style="margin-left: auto;">
								<input type="text" name="monthly_payment_${st.index + 1}"
									value="<c:out value='${t.companyPayment}'/>" autocomplete="off"
									placeholder="해당 기간의 사업장 지급액(원) 입력">
							</div>
						</div>
					</c:forEach>
				</c:if>
			</div>
		</div>

		<div class="form-group">
			<label class="field-title">통상임금(월)</label>
			<div class="input-field">
				<input type="text" id="regularWage" name="regularWage"
					value="${app.regularWage}" placeholder="숫자만 입력하세요"
					autocomplete="off">
			</div>
		</div>
		<div class="form-group">
			<label class="field-title">주당 소정근로시간</label>
			<div class="input-field">
				<input type="text" id="weeklyHours" name="weeklyHours"
					value="${app.weeklyHours}" inputmode="numeric" autocomplete="off"
					placeholder="숫자만 (최대 5자리)">
			</div>
		</div>

		<div class="form-section">
			<h2>자녀 정보</h2>

			<c:set var="isBorn"
				value="${not empty app.childName or not empty app.childResiRegiNumber}" />

			<div class="input-field radio-group" style="margin-bottom: 16px;">
				<input type="radio" name="birthType" value="born" id="bt-born"
					<c:if test="${isBorn}">checked</c:if>> <label for="bt-born">출생일</label>
				<input type="radio" name="birthType" value="expected"
					id="bt-expected" <c:if test="${!isBorn}">checked</c:if>> <label
					for="bt-expected">출산예정일</label>
			</div>

			<div id="born-fields" style="display: none;">
				<div class="form-group">
					<label class="field-title" for="child-name">자녀 이름</label>
					<div class="input-field">
						<input type="text" id="child-name" name="childName"
							value="${app.childName}" placeholder="자녀의 이름을 입력하세요">
					</div>
				</div>

				<div class="form-group">
					<label class="field-title" for="birth-date">출생일</label>
					<div class="input-field">
						<input type="date" id="birth-date"
							value="<c:if test='${isBorn}'><fmt:formatDate value='${app.childBirthDate}' pattern='yyyy-MM-dd'/></c:if>">
					</div>
				</div>

				<div class="form-group">
					<label class="field-title" for="child-rrn-a">자녀 주민등록번호</label>
					<div class="form-group">
						<div class="input-field"
							style="display: flex; align-items: center; gap: 10px;">
							<input type="text" id="child-rrn-a" maxlength="6"
								placeholder="생년월일 6자리"
								value="${fn:substring(app.childResiRegiNumber,0,6)}">
							<span class="hyphen">-</span>
							<input type="password" id="child-rrn-b" maxlength="7"
							value="${fn:substring(app.childResiRegiNumber,6,13)}" placeholder="뒤 7자리">
						</div>
						<input type="hidden" id="child-rrn-hidden">
					</div>
				</div>
			</div>

			<div id="expected-fields" style="display: none;">
				<div class="form-group">
					<label class="field-title" for="expected-date">출산예정일</label>
					<div class="input-field">
						<input type="date" id="expected-date"
							value="<c:if test='${!isBorn}'><fmt:formatDate value='${app.childBirthDate}' pattern='yyyy-MM-dd'/></c:if>">
					</div>
					<small style="color: #666;">※ 오늘 이후 날짜만 선택 가능</small>
				</div>
			</div>

			<input type="hidden" name="childBirthDate" id="childBirthDateHidden"
				value="<fmt:formatDate value='${app.childBirthDate}' pattern='yyyy-MM-dd'/>">
		</div>
		<div class="form-section">
			<h2>급여 입금 계좌정보</h2>
			<div class="form-group">
				<label class="field-title">은행</label>
				<div class="input-field">
					<select name="bankCode" id="bankCode"
						data-selected="${app.bankCode}">
						<option value="" disabled>은행 선택</option>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="field-title">계좌번호</label>
				<div class="input-field">
					<input type="text" id="accountNumber" name="accountNumber"
						inputmode="numeric" autocomplete="off" value="${app.accountNumber}"
						placeholder="'-' 없이 숫자만" />
				</div>
			</div>
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
			<div class="form-section">
				<h2>행정정보 공동이용 동의서</h2>

				<div class="info-box">
					본인은 이 건 업무처리와 관련하여 담당 공무원이 「전자정부법」 제36조제1항에 따른 행정정보의 공동이용을 통하여 ‘담당
					공무원 확인사항’을 확인하는 것에 동의합니다.<br> * 동의하지 않는 경우에는 신청(고)인이 직접 관련 서류를
					제출하여야 합니다.
				</div>
				<div
					style="display: flex; flex-direction: column; align-items: flex-end; text-align: right; margin-top: 16px;">
					<label class="field-title"
						style="width: auto; margin-bottom: 12px;">
						신청인&nbsp;:&nbsp;${userDTO.name} </label>
					<div class="radio-group"
						style="justify-content: flex-end; gap: 24px;">
						<input type="radio" id="gov-yes" name="govInfoAgree" value="Y"
							<c:if test="${app.govInfoAgree == 'Y'}">checked</c:if>> <label
							for="gov-yes">동의합니다.</label> <input type="radio" id="gov-no"
							name="govInfoAgree" value="N"
							<c:if test="${app.govInfoAgree == 'N'}">checked</c:if>> <label
							for="gov-no">동의하지 않습니다.</label>
					</div>
				</div>
			</div>
		</div>

		<div class="form-section">
			<div class="notice-box">
				<span class="notice-icon">⚠️</span>
				<div>
					<h3>부정수급 안내</h3>
					<p>위 급여신청서에 기재한 내용에 거짓이 있을 경우에는 급여의 지급이 중단되고 지급받은 급여액에 상당하는 금액을
						반환해야 합니다. 또한, 추가적인 반환금액이 발생할 수 있으며 경우에 따라서는 형사 처벌도 받을 수 있습니다.</p>
				</div>
			</div>
			<div class="checkbox-group"
				style="justify-content: center; margin-top: 20px;">
				<input type="checkbox" id="agree-notice" name="agreeNotice">
				<label for="agree-notice">위 안내사항을 모두 확인했으며, 신청서 내용에 거짓이 없음을
					확인합니다.</label>
			</div>
		</div>

		<div class="submit-button-container"
			style="display: flex; gap: 10px; justify-content: center;">
			<button type="submit" name="action" value="register"
				class="btn submit-button"
				style="background: #6c757d; border-color: #6c757d;">임시저장</button>
			<button type="submit" name="action" value="submit"
				class="btn submit-button" disabled>신청서 제출하기</button>
			<button type="button" class="btn btn-secondary"
				style="margin-left: 10px;"
				onclick="if(confirm('정말 삭제하시겠습니까? 삭제 시 단위기간도 함께 삭제됩니다.')) document.getElementById('deleteForm').submit();">
				삭제</button>
		</div>
	</form>
	</main>
	
	<form id="deleteForm"
		action="${pageContext.request.contextPath}/apply/delete" method="post"
		style="display: none;">
		<sec:csrfInput />
		<input type="hidden" name="appNo" value="${app.applicationNumber}" />
	</form>

	<footer class="footer">
		<p>&copy; 2025 육아휴직 서비스. All Rights Reserved.</p>
	</footer>

<script>
	const ORIGINAL_RRN = "${fn:escapeXml(app.childResiRegiNumber)}";

	document.addEventListener('DOMContentLoaded', function () {
		
		var startDateInput = document.getElementById('start-date');
		var endDateInput = document.getElementById('end-date');
		var periodInputSection = document.getElementById('period-input-section');
		var generateBtn = document.getElementById('generate-forms-btn');
		var formsContainer = document.getElementById('dynamic-forms-container');
		var noPaymentChk = document.getElementById('no-payment');
		var noPaymentWrapper = document.getElementById('no-payment-wrapper');
		
		function withCommas(s){ return String(s).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }
		function onlyDigits(s){ return (s||'').replace(/[^\d]/g,''); }

		function allowDigitsOnlyAndCommasDisplay(el, maxDigits) {
			function formatWithCaret(el) {
				const start = el.selectionStart, old = el.value;
				const digitsBefore = onlyDigits(old.slice(0, start)).length;
				let raw = onlyDigits(old);
				if (maxDigits) raw = raw.slice(0, maxDigits);
				el.value = withCommas(raw);
				let cur=0, pos=0;
				for (let i=0;i<el.value.length;i++){
					if (/\d/.test(el.value[i])) cur++;
					if (cur>=digitsBefore){ pos=i+1; break; }
				}
				el.setSelectionRange(pos,pos);
			}
			el.addEventListener('keydown', e=>{
				const k=e.key, ctrl=e.ctrlKey||e.metaKey;
				const edit=['Backspace','Delete','ArrowLeft','ArrowRight','ArrowUp','ArrowDown','Home','End','Tab'];
				if (ctrl && ['a','c','v','x','z','y'].includes(k.toLowerCase())) return;
				if (edit.includes(k)) return;
				if (/^\d$/.test(k)) return;
				e.preventDefault();
			});
			el.addEventListener('paste', e=>{
				e.preventDefault();
				let t=(e.clipboardData||window.clipboardData).getData('text')||'';
				let d=onlyDigits(t);
				if (maxDigits) d=d.slice(0,maxDigits);
				const s=el.selectionStart, en=el.selectionEnd, v=onlyDigits(el.value);
				const merged=(v.slice(0,s)+d+v.slice(en)).slice(0, maxDigits||Infinity);
				el.value = withCommas(merged);
				el.setSelectionRange(el.value.length, el.value.length);
			});
			el.addEventListener('drop', e=>e.preventDefault());
			el.addEventListener('input', e=>{ if(!e.isComposing) formatWithCaret(el); });
			el.addEventListener('blur', ()=>{
				let raw=onlyDigits(el.value);
				if (maxDigits) raw=raw.slice(0,maxDigits);
				el.value=withCommas(raw);
			});
			if (el.value){
				let raw=onlyDigits(el.value);
				if (maxDigits) raw=raw.slice(0,maxDigits);
				el.value=withCommas(raw);
			}
		}

		const wageEl = document.getElementById('regularWage');
		if (wageEl) allowDigitsOnlyAndCommasDisplay(wageEl, 19);

		const accEl = document.getElementById('accountNumber');
		if (accEl) {
			accEl.addEventListener('input', function(){ this.value = onlyDigits(this.value).slice(0, 14); });
		}

		const brnEl = document.getElementById('businessRegiNumber');
		if (brnEl) {
			brnEl.addEventListener('input', function(){
				const raw = onlyDigits(this.value).slice(0, 10);
				let pretty = raw;
				if (raw.length > 5) pretty = raw.slice(0,3) + '-' + raw.slice(3,5) + '-' + raw.slice(5);
				else if (raw.length > 3) pretty = raw.slice(0,3) + '-' + raw.slice(3);
				this.value = pretty;
			});
			brnEl.dispatchEvent(new Event('input'));
		}

		const weeklyEl = document.getElementById('weeklyHours');
		if (weeklyEl) {
			weeklyEl.addEventListener('input', function(){ this.value = onlyDigits(this.value).slice(0, 5); });
		}
		
		const rrnAEl = document.getElementById('child-rrn-a');
		const rrnBEl = document.getElementById('child-rrn-b');
		[rrnAEl, rrnBEl].forEach(el => {
			if(el) el.addEventListener('input', () => { el.value = onlyDigits(el.value); });
		});

		// ==============================================================================
		// 기간 생성 로직
		// ==============================================================================
		function formatDate(date) {
			var y = date.getFullYear();
			var m = String(date.getMonth() + 1).padStart(2, '0');
			var d = String(date.getDate()).padStart(2, '0');
			return y + '.' + m + '.' + d;
		}

		function getPeriodEndDate(originalStart, periodNumber) {
			let nextPeriodStart = new Date(
				originalStart.getFullYear(),
				originalStart.getMonth() + periodNumber,
				originalStart.getDate()
			);
			if (nextPeriodStart.getDate() !== originalStart.getDate()) {
				nextPeriodStart = new Date(
					originalStart.getFullYear(),
					originalStart.getMonth() + periodNumber + 1,
					1
				);
			}
			nextPeriodStart.setDate(nextPeriodStart.getDate() - 1);
			return nextPeriodStart;
		}

		generateBtn.addEventListener('click', function() {
			if (!startDateInput.value || !endDateInput.value) {
				alert('육아휴직 시작일과 종료일을 모두 선택해주세요.');
				return;
			}
			const originalStartDate = new Date(startDateInput.value + 'T00:00:00');
			const finalEndDate = new Date(endDateInput.value + 'T00:00:00');

			if (originalStartDate > finalEndDate) {
				alert('종료일은 시작일보다 빠를 수 없습니다.');
				return;
			}
			
			// [추가] 최소 1개월 이상이어야 하는 조건 추가
			const firstPeriodEndDate = getPeriodEndDate(originalStartDate, 1);
			if (finalEndDate < firstPeriodEndDate) {
				alert('신청 기간은 최소 1개월 이상이어야 합니다.');
				return;
			}
			
			let monthCount = (finalEndDate.getFullYear() - originalStartDate.getFullYear()) * 12;
			monthCount -= originalStartDate.getMonth();
			monthCount += finalEndDate.getMonth();
			if (finalEndDate.getDate() >= originalStartDate.getDate()) {
				monthCount++;
			}
			if (monthCount > 12) {
				alert('최대 12개월까지만 신청 가능합니다. 종료일을 조정해주세요.');
				return;
			}

			formsContainer.innerHTML = '';
			if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';

			let currentPeriodStart = new Date(originalStartDate);
			let monthIdx = 1;

			while (currentPeriodStart <= finalEndDate && monthIdx <= 12) {
				const theoreticalEndDate = getPeriodEndDate(originalStartDate, monthIdx);
				let actualPeriodEnd = new Date(theoreticalEndDate);
				if (actualPeriodEnd > finalEndDate) {
					actualPeriodEnd = new Date(finalEndDate);
				}
				if (currentPeriodStart > actualPeriodEnd) break;

				const rangeText = formatDate(currentPeriodStart) + ' ~ ' + formatDate(actualPeriodEnd);
				const row = document.createElement('div');
				row.className = 'dynamic-form-row';
				row.innerHTML =
					'<div class="date-range-display"><div>' + rangeText + '</div></div>' +
					'<div class="payment-input-field" style="margin-left:auto;">' +
					'<input type="text" name="monthly_payment_' + monthIdx + '" ' +
					'placeholder="해당 기간의 사업장 지급액(원) 입력" autocomplete="off">' +
					'</div>';
				formsContainer.appendChild(row);

				currentPeriodStart = new Date(actualPeriodEnd);
				currentPeriodStart.setDate(currentPeriodStart.getDate() + 1);
				monthIdx++;
			}

			if (noPaymentWrapper) noPaymentWrapper.style.display = 'flex';
			if (noPaymentChk) noPaymentChk.checked = false;
			applyNoPaymentState();
		});
		
		function applyNoPaymentState() {
			const inputs = formsContainer.querySelectorAll('input[name^="monthly_payment_"]');
			inputs.forEach(function(inp){
				if (noPaymentChk && noPaymentChk.checked) {
					inp.value = 0;
					inp.readOnly = true;
					inp.classList.add('readonly-like');
				} else {
					inp.readOnly = false;
					inp.classList.remove('readonly-like');
				}
			});
		}
		if (noPaymentChk) {
			noPaymentChk.addEventListener('change', applyNoPaymentState);
		}
		applyNoPaymentState(); 
		// ==============================================================================


		const hidden = document.getElementById('childBirthDateHidden');
		const bornWrap = document.getElementById('born-fields');
		const expWrap = document.getElementById('expected-fields');
		const birth = document.getElementById('birth-date');
		const exp = document.getElementById('expected-date');
		const radios = document.querySelectorAll('input[name="birthType"]');
		const rBorn = document.getElementById('bt-born');
		const rrnHidden = document.getElementById('child-rrn-hidden');
		
		if (exp) {
			const today = new Date();
			const min = new Date(today); min.setDate(min.getDate()+1);
			const yyyy = min.getFullYear();
			const mm = String(min.getMonth()+1).padStart(2,'0');
			const dd = String(min.getDate()).padStart(2,'0');
			exp.min = `${yyyy}-${mm}-${dd}`;
		}
		
		function setHiddenFrom(el) { if (hidden && el) hidden.value = el.value || ''; }

		function updateView() {
			const checked = document.querySelector('input[name="birthType"]:checked');
			if (!checked) {
				bornWrap.style.display = 'none'; expWrap.style.display = 'none';
				return;
			}
			if (checked.value === 'born') {
				bornWrap.style.display = ''; expWrap.style.display = 'none';
				setHiddenFrom(birth);
			} else {
				bornWrap.style.display = 'none'; expWrap.style.display = '';
				setHiddenFrom(exp);
			}
		}
		updateView();
		
		if (birth) birth.addEventListener('change', function(){ if(rBorn && rBorn.checked) setHiddenFrom(birth); });
		if (exp) exp.addEventListener('change', function(){ if(rBorn && !rBorn.checked) setHiddenFrom(exp); });
		radios.forEach(r => r.addEventListener('change', updateView));

		function countUnits(startStr, endStr) {
			if (!startStr || !endStr) return 0;
			const start = new Date(startStr);
			const end = new Date(endStr);
			if (isNaN(start) || isNaN(end) || start > end) return 0;

			let cnt = 0, cur = new Date(start), monthIdx = 1;
			while (cur <= end) {
				const e = getPeriodEndDate(start, monthIdx);
				let actualEnd = e > end ? new Date(end) : new Date(e);
				if(cur > actualEnd) break;
				cnt++;
				cur = new Date(actualEnd);
				cur.setDate(cur.getDate() + 1);
				monthIdx++;
				if (cnt > 13) break;
			}
			return cnt;
		}

		function isAllFilled() {
			const form = document.querySelector('form[action$="/apply/edit"]');
			if (!form) return false;

			const fields = [
				'start-date', 'end-date', 'businessName', 'businessRegiNumber',
				'biz-postcode', 'biz-base', 'biz-detail', 'regularWage',
				'weeklyHours', 'bankCode', 'accountNumber'
			];
			for (const id of fields) {
				const el = form.querySelector(`[name="${id}"], #${id}`);
				if (!el || !el.value?.trim()) return false;
			}
			
			const radios = ['businessAgree', 'govInfoAgree', 'birthType'];
			for(const name of radios) {
				if(!form.querySelector(`input[name="${name}"]:checked`)) return false;
			}

			if (onlyDigits(brnEl.value).length !== 10) return false;
			if (onlyDigits(accEl.value).length < 10) return false;
			if (Number(onlyDigits(wageEl.value)) <= 0) return false;

			const birthType = form.querySelector('input[name="birthType"]:checked').value;
			if(birthType === 'born') {
				if(!birth.value) return false;
			} else {
				if(!exp.value) return false;
			}
			
			const unitCount = countUnits(startDateInput.value, endDateInput.value);
			const payInputs = Array.from(document.querySelectorAll('input[name^="monthly_payment_"]'));
			if (unitCount === 0 || payInputs.length !== unitCount) return false;
			
			if (!noPaymentChk.checked) {
				for (const inp of payInputs) {
					if (!onlyDigits(inp.value)) return false;
				}
			}
			return true;
		}

		const agreeChk = document.getElementById('agree-notice');
		const submitBtn = document.querySelector('button[name="action"][value="submit"]');

		function refreshSubmitState() {
			if(!submitBtn) return;
			const ok = isAllFilled();
			const agree = !!(agreeChk && agreeChk.checked);
			submitBtn.disabled = !(ok && agree);
		}
		
		['input','change'].forEach(evt => document.querySelector('form').addEventListener(evt, refreshSubmitState));
		refreshSubmitState();

		const form = document.querySelector('form[action$="/apply/edit"]');
		if (form) {
			form.addEventListener('submit', function(e) {
				const action = e.submitter?.value;
				if (action === 'submit' && submitBtn.disabled) {
					e.preventDefault();
					alert('모든 필수 항목을 입력하고 안내사항에 동의해야 합니다.');
					return;
				}

				if (rBorn && rBorn.checked) {
					const a = onlyDigits(rrnAEl?.value);
					const b = onlyDigits(rrnBEl?.value);
					if (a.length === 6 && b.length === 7) {
						rrnHidden.value = a + b;
						rrnHidden.name = 'childResiRegiNumber';
					} else {
						rrnHidden.value = ORIGINAL_RRN;
						rrnHidden.name = 'childResiRegiNumber';
					}
				} else {
					if(ORIGINAL_RRN) {
						rrnHidden.value = ORIGINAL_RRN;
						rrnHidden.name = 'childResiRegiNumber';
					} else {
						rrnHidden.removeAttribute('name');
					}
				}

				[wageEl, accEl, brnEl, weeklyEl].forEach(el => {
					if(el) el.value = onlyDigits(el.value);
				});
				const payInputs = form.querySelectorAll('input[name^="monthly_payment_"]');
				payInputs.forEach(inp => { inp.value = onlyDigits(inp.value); });
			});
		}
	});

	$(function () {
		const $sel = $('#bankCode');
		const selected = String($sel.data('selected') || '');
		$.getJSON('${pageContext.request.contextPath}/codes/banks', function (list) {
			$sel.find('option:not([value=""])').remove();
			list.forEach(function (it) {
				$sel.append(new Option(it.name, String(it.code)));
			});
			if (selected) {
				$sel.val(selected);
			} else {
				$sel.prop('selectedIndex', 0);
			}
		});
	});
	
	function execDaumPostcode(prefix) {
		new daum.Postcode({
			oncomplete: function(data) {
				var addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
				document.getElementById(prefix + '-postcode').value = data.zonecode;
				document.getElementById(prefix + '-base').value = addr;
				document.getElementById(prefix + '-detail').focus();
			}
		}).open();
	}

	document.querySelector('form[action$="/apply/edit"]').addEventListener('keydown', function (e) {
		if (e.key === 'Enter' && e.target.type !== 'textarea' && e.target.type !== 'submit') {
			e.preventDefault();
		}
	});
</script>
</body>
</html>