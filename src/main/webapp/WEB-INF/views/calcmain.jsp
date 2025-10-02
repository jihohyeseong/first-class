<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL 태그는 사용하지 않으므로 주석 처리 상태 유지 --%>
<%-- <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> --%>
<%-- <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> --%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>육아휴직 급여 간편 모의계산</title>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">
<style>

body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #f8f9fa;
	padding: 20px;
}

.container {
	max-width: 800px;
	margin: auto;
	background: #fff;
	padding: 30px;
	border-radius: 8px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h3 {
	border-bottom: 2px solid #3f58d4;
	padding-bottom: 10px;
	margin-bottom: 20px;
	color: #3f58d4;
}

.input-group {
	margin-bottom: 15px;
	display: flex;
	align-items: center;
}

.input-group label {
	width: 120px;
	font-weight: 500;
	color: #495057;
}

.input-group input[type="date"], .input-group input[type="text"] {
	padding: 8px;
	border: 1px solid #ced4da;
	border-radius: 4px;
	flex-grow: 1;
}

.input-group span {
	margin: 0 10px;
	color: #6c757d;
}

.button-group {
	text-align: right;
	margin-top: 20px;
}

.button-group button {
	padding: 10px 20px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-weight: 700;
	margin-left: 10px;
	transition: background-color 0.2s;
}

#calculate-btn {
	background-color: #3f58d4;
	color: white;
}

#calculate-btn:hover {
	background-color: #3549b8;
}

#reset-btn {
	background-color: #f1f3f5;
	color: #495057;
}

#reset-btn:hover {
	background-color: #e2e6ea;
}

#result-table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 30px;
}

#result-table caption {
	font-size: 1.2rem;
	font-weight: 700;
	text-align: left;
	margin-bottom: 15px;
	color: #3f58d4;
}

#result-table th, #result-table td {
	border: 1px solid #dee2e6;
	padding: 12px;
	text-align: center;
}

#result-table thead th {
	background-color: #e9ecef;
	font-weight: 700;
}

#result-table tbody td:nth-child(1) {
	font-weight: 500;
	background-color: #f8f9fa;
}

#result-table tfoot td {
	font-weight: 700;
	background-color: #dee2e6;
}

.note {
	color: red;
	margin-bottom: 10px;
	font-size: 0.9rem;
}
</style>
</head>
<body>
	
	<hr>
	<div class="container">
		<h3>미리 알아보는 나의 육아휴직급여 모의계산</h3>
		<p>“육아휴직급여에 관한 급여모의계산은 고용보험에 가입해 있는 피보험자가 육아휴직급여를 받게될 경우 받게 될 <br>
		육아휴직급여를 계산해 볼 수 있는 것을 목적으로 합니다. ”<br><br>
		(주의 사항) 여기에서 계산된 내용은 사용자가 입력한 값을 토대로 작성이 되므로 실제 수급일정 및 수급액과는<br>차이가 있을 수 있습니다.<br><br>
			특히 근무기간이 6∼7개월인 경우 피보험단위기간(무급휴일 제외) 180일 요건을 충족하지 못하여 수급자격이<br>인정되지 않을 수 있으므로 
			정확한 수급가능 여부는 가까운 고용센터로 문의하시기 바랍니다.</p>
		<p class="note">(*)괄호 안 금액은 잔여지급금으로, 복직 후 6개월 뒤 지급되는 금액입니다.</p>

		<div id="input-section">
			<div class="input-group">
				<label for="startDate">휴직 시작일</label> <input type="date"
					id="startDate" required>
			</div>
			<div class="input-group">
				<label for="endDate">휴직 종료일</label> <input type="date" id="endDate"
				 required>
			</div>
			<div class="input-group">
				<label for="salary">통상임금</label> <input type="text" id="salary"
					 placeholder="숫자만 입력" required> <span>원</span>
			</div>
			<div class="button-group">
				<button id="reset-btn" onclick="resetForm()">초기화</button>
				<button id="calculate-btn" onclick="calculateLeaveBenefit()">계산</button>
			</div>
		</div>

		<div id="result-section" style="display: none;">
			<table id="result-table">
				<caption>육아휴직 급여 계산 결과</caption>
				<thead>
					<tr>
						<th rowspan="2">개월</th>
						<th colspan="1">일반육아휴직</th>
					</tr>
					<tr>
						<th>지급액</th>
					</tr>
				</thead>
				<tbody> <!-- 지급액 출력 -->
				</tbody>
				<tfoot>
					<tr>
						<td>총합</td>
						<td id="totalAmount"></td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>

	<script>
		//입력 요소 변수
        const startDateInput = document.getElementById("startDate");
		const endDateInput = document.getElementById("endDate");
		const salaryInput = document.getElementById("salary");
		//결과 출력 영역
		const resultSection = document.getElementById("result-section");
		const resultTbody = document.querySelector("#result-table tbody");
		const totalAmount = document.getElementById("totalAmount");
		
		// 통화 형식 포맷 함수
        const formatCurrency = (number) => {
            if (number === null || number === undefined || isNaN(number)) return '0';
            return Math.round(number).toLocaleString('ko-KR');
        };
        
        // 휴직 기간을 개월 수로 계산 
        function getLeaveMonths(start, end) {
        	const startDate = new Date(start);
        	const endDate = new Date(end);
        	
			// 날짜 간의 월 차이 계산 
            let months;
			months = (endDate.getFullYear()-startDate.getFullYear())*12;
			months -= startDate.getMonth();
		    months += endDate.getMonth();
            // 종료일이 시작일보다 길면 1개월로 계산
            if(endDate.getDate() >= startDate.getDate()) {
            	months += 1;
            }
            // 최대 12개월 제한
        	return Math.min(months, 12);
        }
     	
        // 메인 계산 로직
        function calculateMonthlyBenefit(salary, month) {
        	const totalMonths = getLeaveMonths(startDateInput.value, endDateInput.value);
        	let rate, cap;
        	
        	if(totalMonths === 0){return;}
        	//1~3개월 (상한 250만원, 통상임금 100%), 4~6개월 (상한 200만원, 통상임금 100%), 7개월~ (상한 160만원, 통상임금 80%)
        	switch(true) {
        	case(month >= 1 && month <=3):
        		rate=1.0;
        		cap=2500000;
        		break;
        	
	        case(month >= 4 && month <=6):
	    		rate=1.0;
	    		cap=2000000;
	    		break;
	    	
        	default:
        		rate=0.8;
        		cap=1600000;
        	}

        	return Math.min(salary*rate, cap);
        }
     	// 테이블에 행 추가
        function addRowToTable(month, pay) {
			// 잔여지급금은 일단 0으로 고정
            const residualPay = 0; 
            
            const row = resultTbody.insertRow();
            
            // 첫 번째 셀(개월)
			const monthCell = row.insertCell();
			monthCell.textContent = month + "개월";
            
            // 두 번째 셀: 지급액 (현재 지급액 + 잔여 지급액)
			const payCell = row.insertCell();
            payCell.innerHTML = 
                formatCurrency(pay) + 
                '<br><span style="font-size: 0.8em;">(' + formatCurrency(residualPay) + ')</span>';
		}

        // 계산 함수
		function calculateLeaveBenefit() { 
			// 입력값 검증
			const salaryValue = salaryInput.value.replace(/,/g, ''); 
			const salary = parseInt(salaryValue, 10);
            
			if (!startDateInput.value || !endDateInput.value || !salaryValue) {
				alert("휴직 시작일, 종료일, 통상임금을 모두 입력해주세요.");
				return;
			}

			if (isNaN(salary) || salary <= 0) {
				alert("통상임금은 유효한 숫자만 입력해주세요.");
				return;
			}

			const leaveMonths = getLeaveMonths(startDateInput.value, endDateInput.value);
            
			if (leaveMonths <= 0) {
				alert("휴직 기간이 유효하지 않거나 종료일이 시작일보다 빠릅니다.");
				return;
			}
			// 종료일과 해당 달의 총 일수 계산
		    const endDate = new Date(endDateInput.value);
		    const daysInLastMonth = new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0).getDate();
		    const lastMonthDays = endDate.getDate();
		    
			// 테이블 초기화
			resultTbody.innerHTML = "";
			let total = 0;

			// 월별 계산 테이블 출력
			for (let month = 1; month <= leaveMonths; month++) {
				let monthlyPay = calculateMonthlyBenefit(salary, month);
				// 마지막 달이면 일할 계산 적용
		        if (month === leaveMonths && lastMonthDays < daysInLastMonth) {
		            monthlyPay = monthlyPay * (lastMonthDays / daysInLastMonth);
		        }
				total += monthlyPay;
				addRowToTable(month, monthlyPay);
			}

			// 총합 및 결과 섹션 표시
			totalAmount.textContent = formatCurrency(total);
			resultSection.style.display = "block";
		}
        // 초기화 버튼 함수
        function resetForm() {
        	document.getElementById('startDate').value = '';
            document.getElementById('endDate').value = '';
            document.getElementById('salary').value = '';
            document.querySelector('#result-table tbody').innerHTML = '';
            document.getElementById('totalAmount').textContent = '';
            document.getElementById('result-section').style.display = 'none';
        }
    </script>

</body>
</html>