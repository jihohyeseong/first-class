<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>육아휴직 급여 신청</title>
<style>
    /* 기본 스타일링 */
    body {
        font-family: 'Malgun Gothic', sans-serif;
        color: #333;
        margin: 0;
        padding: 20px;
        background-color: #f4f4f4;
    }
    .container {
        width: 100%;
        max-width: 800px;
        margin: 20px auto;
        padding: 30px;
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    h1 {
        color: #333;
        text-align: center;
    }
    h2 {
        /* ▼ 메인 컬러 적용 */
        color: #3f58d4;
        border-bottom: 2px solid #eaeaea;
        padding-bottom: 10px;
        margin-bottom: 20px;
    }
    .form-section {
        margin-bottom: 30px;
    }
    .form-group {
        display: flex;
        align-items: center;
        margin-bottom: 15px;
    }
    .form-group label {
        width: 180px;
        font-weight: bold;
        color: #555;
        flex-shrink: 0;
    }
    .form-group .input-field {
        flex-grow: 1;
    }
    input[type="text"],
    input[type="password"],
    input[type="date"],
    input[type="number"],
    select {
        width: 100%;
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }
    input:focus, select:focus {
        /* ▼ 메인 컬러 적용 (포커스 효과) */
        border-color: #3f58d4;
        box-shadow: 0 0 0 2px rgba(63, 88, 212, 0.2);
        outline: none;
    }
    button {
        padding: 8px 15px;
        border: none;
        /* ▼ 메인 컬러 적용 */
        background-color: #3f58d4;
        color: white;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        margin-left: 10px;
        transition: background-color 0.2s; /* 부드러운 색상 전환 효과 */
    }
    button:hover {
        /* ▼ 메인 컬러의 어두운 버전 적용 */
        background-color: #3145a9;
    }
    .info-box {
        background-color: #f9f9f9;
        border: 1px solid #eee;
        padding: 15px;
        margin-top: 10px;
        border-radius: 4px;
    }
    .notice-box {
        border: 1px solid #a2bfe0;
        background-color: #f0f8ff;
        padding: 20px;
        margin-top: 20px;
        border-radius: 5px;
        display: flex;
        align-items: center;
    }
    .notice-icon {
        font-size: 2em;
        margin-right: 15px;
        /* ▼ 메인 컬러 적용 */
        color: #3f58d4;
    }
    .submit-button-container {
        text-align: center;
        margin-top: 30px;
    }
    .submit-button {
        padding: 12px 30px;
        font-size: 1.1em;
        background-color: #2ecc71; /* 제출 버튼은 강조를 위해 다른 색상 유지 */
    }
    .submit-button:hover {
        background-color: #27ae60;
    }
</style>
</head>
<body>

    <div class="container">
        <h1>육아휴직 급여 신청</h1>

        <form action="#" method="post" onsubmit="return false;">
            <div class="form-section">
                <h2>신청인 정보</h2>
                <div class="form-group">
                    <label>이름</label>
                    <div class="input-field">
                        <input type="text" value="김신청" readonly> </div>
                </div>
                <div class="form-group">
                    <label>주민등록번호</label>
                    <div class="input-field">
                        <input type="text" value="900101-1******" readonly>
                    </div>
                </div>
                <div class="form-group">
                    <label>주소</label>
                    <div class="input-field">
                        <input type="text" value="서울특별시 종로구 세종대로 175" readonly>
                    </div>
                </div>
                <div class="form-group">
                    <label>휴대전화번호</label>
                    <div class="input-field">
                        <input type="text" value="010-1234-5678" readonly>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <h2>사업장 정보</h2>
                <div class="form-group">
                    <label>사업장 동의여부</label>
                    <div class="input-field radio-group">
                        <input type="radio" id="consent-yes" name="consent" value="yes" checked>
                        <label for="consent-yes">예</label>
                        <input type="radio" id="consent-no" name="consent" value="no">
                        <label for="consent-no">아니요</label>
                        </div>
                </div>
                <div class="form-group">
                    <label>사업장 이름</label>
                    <div class="input-field">
                        <input type="text" placeholder="사업장 이름을 입력하세요">
                    </div>
                </div>
                <div class="form-group">
                    <label>사업장 등록번호</label>
                    <div class="input-field">
                        <input type="text" placeholder="'-' 없이 숫자만 입력하세요">
                    </div>
                </div>
                <div class="form-group">
                    <label>사업장 주소</label>
                    <div class="input-field">
                        <input type="text" placeholder="사업장 주소를 입력하세요">
                    </div>
                </div>
            </div>

            <div class="form-section">
                <h2>급여 신청 기간</h2>
				<p style="color: #888; margin-top: -15px; margin-bottom: 15px;">※
					사업주로부터 부여받은 총 휴직 기간 중 급여를 지급받으려는 기간 (1개월 단위)</p>
				<div class="form-group">
					<label>육아휴직 시작일</label>
					<div class="input-field">
						<input type="date" id="start-date" name="start-date">
					</div>
				</div>
				<div class="form-group">
					<label>휴직 개월 수</label>
					<div class="input-field"
						style="display: flex; align-items: center; gap: 10px;">
						<input type="number" id="leave-months" name="leave-months" min="1"
							placeholder="개월 수 입력" style="width: 120px; flex-grow: 0;">
						<span id="calculated-period"
							style="font-weight: bold; color: #3498db;"></span>
					</div>
				</div>
				<div class="form-group">
					<label>통상임금</label>
					<div class="input-field">
						<input type="text" placeholder="월 통상임금을 입력하세요 (원)">
					</div>
				</div>
				<div class="form-group">
                    <label>월 소정근로시간</label>
                    <div class="input-field">
                         <input type="text" placeholder="예: 209"> 시간
                    </div>
                </div>
                <div class="form-group">
                    <label></label>
                    <div class="input-field">
                        <button type="button">육아휴직 지급금액 계산기</button> </div>
                </div>
            </div>

            <div class="form-section">
                <h2>급여 입금 계좌정보</h2>
                <div class="form-group">
                    <label>은행</label>
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
                    <label>계좌번호</label>
                    <div class="input-field">
                        <input type="text" placeholder="'-' 없이 숫자만 입력하세요">
                    </div>
                </div>
                <div class="form-group">
                    <label>예금주 이름</label>
                    <div class="input-field">
                        <input type="text" placeholder="예금주 실명을 입력하세요">
                         </div>
                </div>
            </div>
            
            <div class="form-section">
                <h2>자녀 정보</h2>
                 <div class="form-group">
                    <label>자녀 이름</label>
                    <div class="input-field">
                        <input type="text" placeholder="자녀의 이름을 입력하세요">
                    </div>
                </div>
                <div class="form-group">
                    <label>자녀 주민등록번호</label>
                    <div class="input-field">
                        <input type="text" placeholder="예: 250101-3******">
                    </div>
                </div>
                 <div class="form-group">
                    <label></label>
                    <div class="input-field checkbox-group">
                        <input type="checkbox" id="no-rrn">
                        <label for="no-rrn">해외출생 등으로 주민등록번호가 없는 경우</label>
                    </div>
                </div>
                <div class="form-group">
                    <label>출산(예정)일</label>
                    <div class="input-field">
                        <input type="date" id="birth-date" name="birth-date">
                    </div>
                    </div>
            </div>
            
            <div class="form-section">
                <h2>접수 센터 선택</h2>
                <div class="form-group">
                    <label>접수센터</label>
                    <div class="input-field radio-group">
                        <input type="radio" id="center-addr" name="center" value="addr"> <label for="center-addr">민원인 주소</label>
                        <input type="radio" id="center-work" name="center" value="work" checked> <label for="center-work">사업장 주소</label>
                        <input type="radio" id="center-exist" name="center" value="exist"> <label for="center-exist">기존 처리센터</label>
                        <input type="radio" id="center-etc" name="center" value="etc"> <label for="center-etc">기타</label>
                        <button type="button">센터 선택</button> </div>
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
                <div class="checkbox-group" style="text-align:center; margin-top: 15px;">
                    <input type="checkbox" id="agree-notice" name="agree-notice">
                    <label for="agree-notice">위 부정수급과 관련된 안내사항을 모두 읽고 이해했으며, 이번 신청서에 기재한 내용에 거짓이 없음을 확인합니다.</label>
                    </div>
            </div>
            
            <div class="submit-button-container">
                <button type="submit" class="submit-button">신청하기</button>
            </div>
            
        </form>
    </div>

</body>
</html>