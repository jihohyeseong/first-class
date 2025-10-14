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

   #period-input-section { display: none; }
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
	
	/* toast */
	.toast {
	  position: fixed; left: 50%; bottom: 40px; transform: translateX(-50%);
	  min-width: 260px; max-width: 90vw;
	  background: rgba(33, 37, 41, .95); color: #fff;
	  padding: 12px 16px; border-radius: 10px;
	  box-shadow: 0 6px 16px rgba(0,0,0,.2);
	  opacity: 0; pointer-events: none; transition: opacity .2s ease, transform .2s ease;
	  z-index: 9999; font-size: 14px;
	}
	.toast.show { opacity: 1; transform: translateX(-50%) translateY(-6px); }
	.toast.success { background: #28a745; }
	.toast.warn    { background: #dc3545; }
	.toast > strong { font-weight: 700; margin-right: 6px; }
	
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

		<!-- ===== 사업장 정보 ===== -->
		<div class="form-section">
			<h2>사업장 정보</h2>

			<!-- 사업장 동의여부 → businessAgree: Y/N -->
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
					<input type="text" name="businessName" value="${form.businessName}" 
					placeholder="사업장 이름을 입력하세요">
					<c:if test="${not empty errors.businessName}">
						<p class="message error">${errors.businessName}</p>
					</c:if>
				</div>
			</div>

			<div class="form-group">
				<label class="field-title">사업장 등록번호</label>
				<div class="input-field">
					<input type="text" id="businessRegiNumber"
						name="businessRegiNumber" inputmode="numeric" autocomplete="off"
						value="${app.businessRegiNumber}" placeholder="'-' 없이 숫자 10자리"
						pattern="^\d{3}-?\d{2}-?\d{5}$"
						title="사업자등록번호(예: 123-45-67890 또는 1234567890)" />


				</div>
			</div>

			<div class="form-group">
				<label class="field-title">사업장 주소</label>
				<div class="input-field">
					<div class="addr-row">
						<input type="text" id="biz-postcode" name="businessZipNumber"
							placeholder="우편번호" value="${app.businessZipNumber}" readonly>
						<button type="button" class="btn btn-secondary btn-sm"
							onclick="execDaumPostcode('biz')">주소 검색</button>
					</div>
					<input type="text" id="biz-base" name="businessAddrBase"
						placeholder="기본주소" value="${app.businessAddrBase}" readonly
						style="margin-top: 8px;"> 
					<input type="text" id="biz-detail" name="businessAddrDetail"
						placeholder="상세주소" value="${app.businessAddrDetail}"
						style="margin-top: 8px;">
					<c:if test="${not empty errors.businessAddrDetail}">
						<p class="message error">${errors.businessAddrDetail}</p>
					</c:if>

				</div>
			</div>
		</div>

<!-- ===== 급여 신청 기간 ===== -->
		<div class="form-section">
			<h2>급여 신청 기간</h2>
			<p style="color: #888; margin-top: -15px; margin-bottom: 20px;">
				※ 사업주로부터 부여받은 총 휴직 기간 중 급여를 지급받으려는 기간을 입력해 주세요.</p>

			<c:if test="${empty app.startDate and not empty terms}">
				<c:set var="startFromTerms" value="${terms[0].startMonthDate}" />
			</c:if>
			<c:if test="${empty app.endDate and not empty terms}">
				<c:set var="endFromTerms"
					value="${terms[fn:length(terms)-1].endMonthDate}" />
			</c:if>

			<c:set var="startDateVal" value="" />
			<c:set var="endDateVal" value="" />

			<c:choose>
				<c:when test="${not empty app.startDate}">
					<fmt:formatDate value="${app.startDate}" pattern="yyyy-MM-dd"
						var="startDateVal" />
				</c:when>
				<c:when test="${not empty startFromTerms}">
					<fmt:formatDate value="${startFromTerms}" pattern="yyyy-MM-dd"
						var="startDateVal" />
				</c:when>
			</c:choose>

			<c:choose>
				<c:when test="${not empty app.endDate}">
					<fmt:formatDate value="${app.endDate}" pattern="yyyy-MM-dd"
						var="endDateVal" />
				</c:when>
				<c:when test="${not empty endFromTerms}">
					<fmt:formatDate value="${endFromTerms}" pattern="yyyy-MM-dd"
						var="endDateVal" />
				</c:when>
			</c:choose>

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
							value="${endDateVal}">
						<button type="button" id="generate-forms-btn"
							class="btn btn-primary">기간 생성</button>

						<%-- (2) allZero 및 표시 여부 계산 --%>
						<c:set var="allZero" value="${true}" />
						<c:forEach var="t0" items="${terms}">
							<c:if
								test="${t0.companyPayment != null and t0.companyPayment != 0}">
								<c:set var="allZero" value="${false}" />
							</c:if>
						</c:forEach>
						<c:set var="npDisplay" value="${empty terms ? 'none' : 'flex'}" />

						<label id="no-payment-wrapper"
							style="display:${npDisplay}; align-items:center; gap:6px; margin-left:8px;">
							<input type="checkbox" id="no-payment" name="noPayment"
							<c:if test="${allZero}">checked</c:if> /> 사업장 지급액 없음
						</label>
					</div>
				</div>
			</div>

			<!-- (3) 서버가 단위기간을 바로 렌더 -->
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
									value="<c:out value='${t.companyPayment}'/>" autocomplete="off">
							</div>
						</div>
					</c:forEach>
				</c:if>
			</div>
		</div>

		<!-- ===== 통상임금 / 주당시간 ===== -->
		<div class="form-group">
			<label class="field-title">통상임금(월)</label>
			<div class="input-field">
				<input type="text" id="regularWage" name="regularWage"
					value="${app.regularWage}" placeholder="숫자만 입력하세요"
					autocomplete="off">
				<c:if test="${not empty errors.regularWage}">
					<p class="message error">${errors.regularWage}</p>
				</c:if>
			</div>
		</div>
		<div class="form-group">
			<label class="field-title">주당 소정근로시간</label>
			<div class="input-field">
				<input type="text" id="weeklyHours" name="weeklyHours"
					value="${app.weeklyHours}" inputmode="numeric" autocomplete="off"
					placeholder="숫자만 (최대 5자리)">
				<c:if test="${not empty errors.weeklyHours}">
					<p class="message error">${errors.weeklyHours}</p>
				</c:if>
			</div>
		</div>

		<!-- ===== 자녀 정보 ===== -->
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
						<c:if test="${not empty errors.childName}">
							<p class="message error">${errors.childName}</p>
						</c:if>
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
						<input type="hidden" name="childResiRegiNumber"
							id="child-rrn-hidden">
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

			<!-- 서버로 보낼 유일한 생일 필드 -->
			<input type="hidden" name="childBirthDate" id="childBirthDateHidden"
				value="${app.childBirthDate}">
		</div>
		<!-- ===== 입금 계좌 ===== -->
		<div class="form-section">
			<h2>급여 입금 계좌정보</h2>
			<div class="form-group">
				<label class="field-title">은행</label>
				<div class="input-field">
					<!-- bankCode로 서버에 전송 -->
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
			<!-- 행정정보 공동이용 동의 -->
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

		<!-- ===== 안내/동의 ===== -->
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

		<!-- ===== 제출/임시저장 버튼 (action 값으로 구분) ===== -->
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
</script>
	<script>
	  window.EXISTING_TERMS = [
	  <c:forEach var="t" items="${terms}" varStatus="st">
	    {
	      start: "<fmt:formatDate value='${t.startMonthDate}' pattern='yyyy-MM-dd'/>",
	      end:   "<fmt:formatDate value='${t.endMonthDate}'   pattern='yyyy-MM-dd'/>",
	      companyPayment: ${t.companyPayment == null ? 0 : t.companyPayment}
	    }<c:if test="${!st.last}">,</c:if>
	  </c:forEach>
	  ];
	    
	  document.addEventListener('DOMContentLoaded', function () {

		  var FIRST_LOAD = true;
		  // ===== DOM 참조 =====
		  var startDateInput     = document.getElementById('start-date');
		  var endDateInput       = document.getElementById('end-date');
		  var periodInputSection = document.getElementById('period-input-section');
		  var generateBtn        = document.getElementById('generate-forms-btn');
		  var formsContainer     = document.getElementById('dynamic-forms-container');
		  var noPaymentChk       = document.getElementById('no-payment');
		  var noPaymentWrapper   = document.getElementById('no-payment-wrapper');
		  
		// 공통 유틸
		  function withCommas(s){ return String(s).replace(/\B(?=(\d{3})+(?!\d))/g, ','); }
		  function onlyDigits(s){ return (s||'').replace(/[^\d]/g,''); }

		  // 자리수 제한 + 콤마 표시 헬퍼 (이미 위에 있던 'maxDigits' 버전만 남기세요)
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

		  /* ====== 여기부터 필드 바인딩 ====== */

		  // 통상임금: 숫자 + 최대 19자리 + 콤마
		  const wageEl = document.getElementById('regularWage');
		  if (wageEl) allowDigitsOnlyAndCommasDisplay(wageEl, 19);

		  // 계좌번호: 숫자만 최대 14자리
		  const accEl = document.getElementById('accountNumber');
		  if (accEl) {
		    accEl.addEventListener('input', function(){
		      this.value = onlyDigits(this.value).slice(0, 14);
		    });
		  }

		  // 사업자등록번호: 숫자만 최대 10자리 + 즉시 하이픈(3-2-5)
		  const brnEl = document.getElementById('businessRegiNumber');
		  if (brnEl) {
		    brnEl.addEventListener('input', function(){
		      const raw = onlyDigits(this.value).slice(0, 10);
		      let pretty = raw;
		      if (raw.length > 5)      pretty = raw.slice(0,3) + '-' + raw.slice(3,5) + '-' + raw.slice(5);
		      else if (raw.length > 3) pretty = raw.slice(0,3) + '-' + raw.slice(3);
		      this.value = pretty;
		    });
		  }

		  // 주당 소정근로시간: 숫자만 최대 5자리
		  const weeklyEl = document.getElementById('weeklyHours');
		  if (weeklyEl) {
		    weeklyEl.addEventListener('input', function(){
		      this.value = onlyDigits(this.value).slice(0, 5);
		    });
		  }

		  /* ====== 제출 직전 정리 ====== */
		  const form = document.querySelector('form[action$="/apply"], form[action$="/apply/edit"]');
		  if (form) {
		    form.addEventListener('submit', function(){
		      // BRN/계좌는 서버로 숫자만
		      if (brnEl) brnEl.value = onlyDigits(brnEl.value).slice(0,10);
		      if (accEl) accEl.value = onlyDigits(accEl.value).slice(0,14);
		      if (wageEl) wageEl.value = onlyDigits(wageEl.value).slice(0,19);
		      if (weeklyEl) weeklyEl.value = onlyDigits(weeklyEl.value).slice(0,5);
		    });
		  }

		  

		  // ===== 유틸 =====
		  function formatDate(date) {
		    var y = date.getFullYear();
		    var m = String(date.getMonth() + 1).padStart(2, '0');
		    var d = String(date.getDate()).padStart(2, '0');
		    return y + '.' + m + '.' + d;
		  }
		  function plusMonthsClamp(date, months) {
		    var y = date.getFullYear(), m = date.getMonth(), d = date.getDate();
		    var targetM = m + months, targetY = y + Math.floor(targetM / 12);
		    var normM   = ((targetM % 12) + 12) % 12;
		    var last    = new Date(targetY, normM + 1, 0).getDate();
		    var day     = Math.min(d, last);
		    return new Date(targetY, normM, day);
		  }
		  function endOfUnit(start) {
		    var originalDay = start.getDate();
		    var nextSame    = plusMonthsClamp(start, 1);
		    var lastOfNext  = new Date(nextSame.getFullYear(), nextSame.getMonth() + 1, 0).getDate();
		    var clamped     = originalDay > lastOfNext;
		    var e = new Date(nextSame.getTime());
		    if (!clamped) e.setDate(e.getDate() - 1);
		    return e;
		  }
		  function getPaymentInputs() {
		    return formsContainer.querySelectorAll('input[name^="monthly_payment_"]');
		  }
		  function applyNoPaymentState(init=false) {
			  var inputs = getPaymentInputs();
			  inputs.forEach(function(inp){
			    if (noPaymentChk && noPaymentChk.checked) {
			      if (!init) { // 초기 호출이면 값은 그대로 둔다
			        inp.value = 0;
			      }
			      inp.readOnly = true;
			      inp.classList.add('readonly-like');
			    } else {
			      inp.readOnly = false;
			      inp.classList.remove('readonly-like');
			    }
			  });
			}

			// 체크박스는 사용자 토글 때만 0 채우도록
			if (noPaymentChk) {
			  noPaymentChk.addEventListener('change', function () {
			    applyNoPaymentState(false); // 이때만 0 대입 허용
			  });
			}

			generateBtn.addEventListener('click', function() {
			  if (!startDateInput.value || !endDateInput.value) {
			    alert('육아휴직 시작일과 종료일을 모두 선택해주세요.');
			    return;
			  }

			  var startDate = new Date(startDateInput.value + 'T00:00:00');
			  var endDate   = new Date(endDateInput.value   + 'T00:00:00');
			  if (startDate > endDate) { alert('종료일은 시작일보다 빠를 수 없습니다.'); return; }

			  // 최대 12개월 제한
			  var monthCount = 0;
			  var mc = new Date(startDate.getFullYear(), startDate.getMonth(), 1);
			  var endMonth = new Date(endDate.getFullYear(), endDate.getMonth(), 1);
			  while (mc <= endMonth) { monthCount++; mc.setMonth(mc.getMonth() + 1); }
			  if (monthCount > 13) { alert('최대 12개월까지만 신청 가능합니다. 종료일을 조정해주세요.'); return; }

			  // UI 초기화
			  formsContainer.innerHTML = '';
			  if (noPaymentWrapper) noPaymentWrapper.style.display = 'none';

			  // 단위기간 생성
			  var currentStartDate = new Date(startDate.getTime());
			  var i = 1;
			  while (currentStartDate <= endDate) {
			    var candidateEnd = endOfUnit(currentStartDate);
			    var displayEnd   = (candidateEnd > endDate) ? new Date(endDate.getTime()) : candidateEnd;

			    var row = document.createElement('div');
			    row.className = 'dynamic-form-row';
			    row.innerHTML =
			      '<div class="date-range-display"><div>' +
			        formatDate(currentStartDate) + ' ~ ' + formatDate(displayEnd) +
			      '</div></div>' +
			      '<div class="payment-input-field" style="margin-left:auto;">' +
			        // 기본값은 빈칸으로 두기 (자동 0 방지)
			        '<input type="text" name="monthly_payment_' + i + '" placeholder="해당 기간의 사업장 지급액(원) 입력" autocomplete="off">' +
			      '</div>';
			    formsContainer.appendChild(row);

			    currentStartDate = new Date(displayEnd.getTime());
			    currentStartDate.setDate(currentStartDate.getDate() + 1);
			    i++;
			    if (i > 13) { alert('최대 12개월(12구간)까지만 신청 가능합니다.'); formsContainer.innerHTML = ''; return; }
			  }

			  // 새로 생성한 경우: 자동 체크 금지, 표시만 하고 초기 상태 적용(값 보존)
			  if (noPaymentWrapper) {
			    noPaymentWrapper.style.display = 'flex';
			  }
			  if (noPaymentChk) {
			    noPaymentChk.checked = false;
			  }
			  applyNoPaymentState(true);
			});



		  // ===== 자녀정보(출생/예정) hidden 동기화 =====
		  const hidden   = document.getElementById('childBirthDateHidden');
		  const bornWrap = document.getElementById('born-fields');
		  const expWrap  = document.getElementById('expected-fields');
		  const birth    = document.getElementById('birth-date');
		  const exp      = document.getElementById('expected-date');
		  const radios   = document.querySelectorAll('input[name="birthType"]');
		  const rBorn    = document.getElementById('bt-born');
		  const rExp     = document.getElementById('bt-expected');

		  const rrnA = document.getElementById('child-rrn-a');
		  const rrnB = document.getElementById('child-rrn-b');
		  const rrnHidden = document.getElementById('child-rrn-hidden');
		  
		  if (rrnHidden) {
			  rrnHidden.value = (typeof ORIGINAL_RRN === 'string' ? ORIGINAL_RRN : '') || '';
			  rrnHidden.name  = 'childResiRegiNumber';
			  }

		  if (exp) {
		    const today = new Date(); today.setHours(0,0,0,0);
		    const min = new Date(today); min.setDate(min.getDate()+1);
		    const mm = String(min.getMonth()+1).padStart(2,'0');
		    const dd = String(min.getDate()).padStart(2,'0');
		    exp.min = `${min.getFullYear()}-${mm}-${dd}`;
		  }
		  function setHiddenFrom(el) { if (hidden && el) hidden.value = el.value || ''; }

		  function fillRrnFromBirth() {
			  if (!birth || !rrnA) return;
			  if (!rBorn || !rBorn.checked) return;
			  if (!birth.value) { return; }

			  if ((rrnA.value && rrnA.value.trim() !== '') || (rrnB && rrnB.value && rrnB.value.trim() !== '')) {
			    setHiddenFrom(birth);
			    return;
			  }

			  var parts = birth.value.split('-');
			  if (parts.length !== 3) return;
			  rrnA.value = (parts[0].slice(-2) + parts[1] + parts[2]).slice(0,6);
			  if (rrnA.value.length === 6 && rrnB) rrnB.focus();
			  setHiddenFrom(birth);
			}
		  
		  function setBornRequired(on) {}
		  function setExpectedRequired(on) {}
		  function clearBorn() {}
		  function clearExpected() {}


		  // 기존 updateView 수정
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
		      if (!FIRST_LOAD) fillRrnFromBirth();
		    } else {
		      bornWrap.style.display = 'none';
		      expWrap.style.display  = '';
		      setBornRequired(false);
		      setExpectedRequired(true);
		      clearBorn();
		      setHiddenFrom(exp);
		    }
		  }

		  updateView();
		  FIRST_LOAD = false;

		  // 출생일이 바뀔 때만 자동 채움
		  if (birth) birth.addEventListener('change', fillRrnFromBirth);

		  if (exp)   exp.addEventListener('change', function(){ if (rExp && rExp.checked) setHiddenFrom(exp); });
		  radios.forEach(r => r.addEventListener('change', updateView));

		  function formatWithCaret(el) {
		    const start = el.selectionStart, old = el.value;
		    const digitsBefore = onlyDigits(old.slice(0, start)).length;
		    const raw = onlyDigits(old), pretty = withCommas(raw);
		    el.value = pretty;
		    let curDigits = 0, newPos = 0;
		    for (let i = 0; i < el.value.length; i++) {
		      if (/\d/.test(el.value[i])) curDigits++;
		      if (curDigits >= digitsBefore) { newPos = i + 1; break; }
		    }
		    el.setSelectionRange(newPos, newPos);
		  }

		  // ===== 검증 =====
		  function countUnits(startStr, endStr) {
		    if (!startStr || !endStr) return 0;
		    const start = new Date(startStr + 'T00:00:00');
		    const end   = new Date(endStr   + 'T00:00:00');
		    if (isNaN(start) || isNaN(end) || start > end) return 0;

		    function endOfUnitLocal(s) {
		      const originalDay = s.getDate();
		      const nextSame = plusMonthsClamp(s, 1);
		      const lastOfNext = new Date(nextSame.getFullYear(), nextSame.getMonth()+1, 0).getDate();
		      const clamped = originalDay > lastOfNext;
		      const e = new Date(nextSame.getTime());
		      if (!clamped) e.setDate(e.getDate()-1);
		      return e;
		    }

		    let cnt = 0, cur = start;
		    while (cur <= end) {
		      let e = endOfUnitLocal(cur);
		      if (e > end) e = end;
		      cnt++;
		      cur = new Date(e.getTime()); cur.setDate(cur.getDate()+1);
		      if (cnt > 13) break;
		    }
		    return cnt;
		  }

		  function isAllFilled() {
			const form = document.querySelector('form[action$="/apply/edit"]');
		    if (!form) return false;

		    const startDate = document.getElementById('start-date')?.value?.trim();
		    const endDate   = document.getElementById('end-date')?.value?.trim();

		    const businessAgree = form.querySelector('input[name="businessAgree"]:checked')?.value;
		    const businessName  = form.querySelector('input[name="businessName"]')?.value?.trim();
		    const businessRegi  = form.querySelector('input[name="businessRegiNumber"]')?.value?.trim();
		    const bizZip        = document.getElementById('biz-postcode')?.value?.trim();
		    const bizBase       = document.getElementById('biz-base')?.value?.trim();
		    const bizDetail     = document.getElementById('biz-detail')?.value?.trim();

		    const regularWage   = onlyDigits(document.getElementById('regularWage')?.value || '');
		    const weeklyHours   = form.querySelector('input[name="weeklyHours"]')?.value?.trim();

		    const bankCode      = document.getElementById('bankCode')?.value;
		    const accountNumber = form.querySelector('input[name="accountNumber"]')?.value?.trim();

		    const govAgree      = form.querySelector('input[name="govInfoAgree"]:checked')?.value;

		    const birthType     = form.querySelector('input[name="birthType"]:checked')?.value;
		    const birthDate     = document.getElementById('birth-date')?.value?.trim();
		    const expectedDate  = document.getElementById('expected-date')?.value?.trim();

		    const noPayment     = document.getElementById('no-payment')?.checked;
		    const unitCount     = countUnits(startDate, endDate);
		    const payInputs     = Array.from(document.querySelectorAll('input[name^="monthly_payment_"]'));

		    const bizDigits = onlyDigits(businessRegi);
		    if (bizDigits.length !== 10) return false;

		    const accDigits = onlyDigits(accountNumber);
		    if (accDigits.length < 10) return false;
		    
		    if (!startDate || !endDate) return false;
		    if (new Date(startDate) > new Date(endDate)) return false;

		    let monthCount = 0;
		    let mc = new Date(new Date(startDate).getFullYear(), new Date(startDate).getMonth(), 1);
		    const endMonth = new Date(new Date(endDate).getFullYear(), new Date(endDate).getMonth(), 1);
		    while (mc <= endMonth) { monthCount++; mc.setMonth(mc.getMonth()+1); }
		    if (monthCount > 12) return false;

		    if (!businessAgree) return false;
		    if (!businessName || !businessRegi || !bizZip || !bizBase || !bizDetail) return false;

		    if (!regularWage || Number(regularWage) <= 0) return false;
		    if (!weeklyHours || Number(weeklyHours) <= 0) return false;

		    if (!birthType) return false;
		    if (birthType === 'born') {
		      if (!birthDate) return false;
		    } else {
		      if (!expectedDate) return false;
		    }

		    if (!bankCode || !accountNumber) return false;
		    if (!govAgree) return false;

		    if (unitCount === 0) return false;
		    if (!noPayment) {
		      if (payInputs.length !== unitCount) return false;
		      for (const inp of payInputs) {
		        const v = onlyDigits(inp.value || '');
		        if (!v) return false;
		        if (Number(v) < 0) return false;
		      }
		    }
		    return true;
		  }

		  // ===== 제출 버튼 활성화/제출 훅 =====
		  (function wireSubmitControl(){
			const form = document.querySelector('form[action$="/apply/edit"]');
		    if (!form) return;
		    const agreeChk  = document.getElementById('agree-notice');
		    const submitBtn = document.querySelector('button[name="action"][value="submit"]');
		    const draftBtn  = document.querySelector('button[name="action"][value="register"]');

		    if (draftBtn) draftBtn.disabled = false;
		    if (submitBtn) submitBtn.disabled = true;

		    function refreshSubmitState() {
		      const ok = isAllFilled();
		      const agree = !!(agreeChk && agreeChk.checked);
		      if (submitBtn) submitBtn.disabled = !(ok && agree);
		    }
		    ['input','change'].forEach(evt=> form.addEventListener(evt, refreshSubmitState));
		    if (agreeChk) agreeChk.addEventListener('change', refreshSubmitState);
		    refreshSubmitState();

		    form.addEventListener('submit', function(e) {
		      const action = (e.submitter && e.submitter.name === 'action') ? e.submitter.value : null;
		      
		      const rrnA = document.getElementById('child-rrn-a');
		      const rrnB = document.getElementById('child-rrn-b');
		      const rrnHidden = document.getElementById('child-rrn-hidden');
		      const rBorn = document.getElementById('bt-born');
		      const onlyDigits = s => (s||'').replace(/[^\d]/g,'');

		      if (rrnHidden) {
		    	  if (rBorn && rBorn.checked) {
		    	  const a = onlyDigits(rrnA ? rrnA.value : '');
		    	  const b = onlyDigits(rrnB ? rrnB.value : '');
		    	  if (a.length === 6 && b.length === 7) {
		    	    rrnHidden.value = a + b;                 // 새 값으로 교체
		    	    rrnHidden.name  = 'childResiRegiNumber';
		    	  } else if (ORIGINAL_RRN) {
		    	    rrnHidden.value = ORIGINAL_RRN;          // 불완전하면 원본 유지
		    	    rrnHidden.name  = 'childResiRegiNumber';
		    	  } else {
		    	    rrnHidden.removeAttribute('name');       // 정말 아무 값도 없을 때만 제외
		    	  }
		    	  } else {
		    	  if (ORIGINAL_RRN) {
		    	     rrnHidden.value = ORIGINAL_RRN;
		    	     rrnHidden.name  = 'childResiRegiNumber';
		    	  } else {
		    	     rrnHidden.removeAttribute('name');
		    	  }
		    	  }
		    	  }
		      
		      if (action !== 'register') {
		        if (!isAllFilled()) { e.preventDefault(); alert('모든 값을 입력해야 제출할 수 있습니다.'); return; }
		        if (!(agreeChk && agreeChk.checked)) { e.preventDefault(); alert('안내사항에 동의해야 제출할 수 있습니다.'); return; }
		      }
		      // 숫자만 서버로
		      const wageEl = document.getElementById('regularWage');
		      if (wageEl) wageEl.value = (wageEl.value || '').replace(/[^\d]/g,'');
		      const payInputs = form.querySelectorAll('input[name^="monthly_payment_"]');
		      payInputs.forEach(inp => { inp.value = (inp.value || '').replace(/[^\d]/g,''); });
		    });
		  })();

		  // ===== 기존 단위기간 렌더 또는 자동생성 =====
		  const alreadyRendered = document.querySelectorAll('#dynamic-forms-container input[name^="monthly_payment_"]').length > 0;
		  const termsExist = Array.isArray(window.EXISTING_TERMS) && window.EXISTING_TERMS.length > 0;
		  
		   if (alreadyRendered && generateBtn) {
			     generateBtn.disabled = true;
			     generateBtn.title = '이미 서버에서 단위기간이 생성되어 있습니다.';
			     generateBtn.addEventListener('click', function(e){ e.preventDefault(); /* toast 등 */ }, { once:true });
			   }

		  function renderExistingTermsOrAutoGenerate() {
		    if (startDateInput && startDateInput.value) {
		      periodInputSection.style.display = 'block';
		      if (endDateInput) endDateInput.min = startDateInput.value;
		    }

		    // 서버가 이미 렌더했으면 아무 것도 안 함
		    if (alreadyRendered || termsExist) {
		      if (noPaymentWrapper) noPaymentWrapper.style.display = 'flex';
		      applyNoPaymentState(true); 
		      return;
		    }
		  }
		  renderExistingTermsOrAutoGenerate();
		  
		  if (alreadyRendered && Array.isArray(window.EXISTING_TERMS)) {
			  window.EXISTING_TERMS.forEach(function(term, index) {
			    const input = document.querySelector('input[name="monthly_payment_' + (index+1) + '"]');
			    if (!input) return;
			    // 서버가 value를 이미 넣었으므로 "덮어쓰기" 말고 포맷만 적용
			    input.value = withCommas(onlyDigits(input.value || String(term.companyPayment || '')));
			  });
			}
		  
		  document.addEventListener('DOMContentLoaded', function () {
			  const form = document.querySelector('form[action$="/apply/edit"]');
			  const submitBtn = document.querySelector('button[name="action"][value="submit"]');
			  const agreeChk = document.getElementById('agree-notice');

			  function refreshSubmitState() {
			    const ok = isAllFilled();
			    const agree = !!(agreeChk && agreeChk.checked);
			    if (submitBtn) submitBtn.disabled = !(ok && agree);
			  }

			  // 입력이 바뀔 때마다 즉시 검증
			  form.addEventListener('input', refreshSubmitState);
			  form.addEventListener('change', refreshSubmitState);
			  if (agreeChk) agreeChk.addEventListener('change', refreshSubmitState);

			  // 최초 로드시 1회 검사
			  refreshSubmitState();
			});
		  
		// 날짜 입력 보이기/초기화
		  startDateInput.addEventListener('change', function () {
		    if (startDateInput.value) {
		      periodInputSection.style.display = 'block';
		      if (endDateInput) endDateInput.min = startDateInput.value;
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
		});

		
		$(function () {
			  const $sel = $('#bankCode');
			  const selected = String($sel.data('selected') || '');

			  $.getJSON('${pageContext.request.contextPath}/codes/banks', function (list) {
			    // placeholder(빈 값) 제외하고 기존 옵션 제거
			    $sel.find('option:not([value=""])').remove();

			    // 옵션 채우기
			    list.forEach(function (it) {
			      $sel.append(new Option(it.name, String(it.code)));
			    });

			    if (selected) {
			      $sel.val(selected);
			    } else {
			      $sel.prop('selectedIndex', 0);
			    }
			  }).fail(function (xhr, status, err) {
			    console.error('은행코드 목록 로딩 실패:', status, err);
			  });
			});
		
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
		<script>
	  // apply/edit 폼에서 Enter로 자동 제출되는 걸 막기
	  (function preventEnterSubmit() {
	    const form = document.querySelector('form[action$="/apply/edit"]');
	    if (!form) return;
	
	    form.addEventListener('keydown', function (e) {
	      if (e.key !== 'Enter') return;
	
	      const el   = e.target;
	      const tag  = el.tagName.toLowerCase();
	      const type = (el.type || '').toLowerCase();
	
	      const isTextArea = tag === 'textarea';
	      const isButton   = tag === 'button' || (tag === 'input' && (type === 'submit' || type === 'button'));
	      const allowAttr  = el.closest('[data-allow-enter="true"]');
	
	      // 버튼이나 textarea, 또는 명시적으로 허용한 영역이 아니면 Enter 제출 막기
	      if (!isTextArea && !isButton && !allowAttr) {
	        e.preventDefault();
	      }
	    });
	  })();
	</script>


</body>
</html>