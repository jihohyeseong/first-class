<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

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
	:root {
		--primary-color: #3f58d4;
		--primary-light-color: #f0f2ff;
		--white-color: #ffffff;
		--light-gray-color: #f8f9fa;
		--gray-color: #868e96;
		--dark-gray-color: #343a40;
		--border-color: #dee2e6;
		--shadow-md: 0 4px 12px rgba(0,0,0,0.08);
	}

	* { margin: 0; padding: 0; box-sizing: border-box; }
	html { height: 100%; }
	body {
		display: flex;
		flex-direction: column;
		min-height: 100vh;
		font-family: 'Noto Sans KR', sans-serif;
		background-color: var(--light-gray-color);
		color: var(--dark-gray-color);
	}
	a { text-decoration: none; color: inherit; }

	/* [수정됨] 컨테이너 기본 상태: 중앙 정렬 */
	.calculator-container {
		display: flex;
		justify-content: center; /* 자식 요소를 중앙에 배치 */
		align-items: flex-start;
		gap: 30px;
		max-width: 1200px; /* 너비를 조금 더 확보 */
		width: 100%;
		margin: 40px auto;
		padding: 0 20px; /* 좌우 여백 */
		transition: justify-content 0.6s ease-in-out;
	}

	/* [수정됨] 입력 패널 기본 상태: 넓게 중앙에 위치 */
	.input-panel {
		flex: 0 1 70%; /* 늘어나지 않음, 줄어들 수 있음, 기본 너비 70% */
		max-width: 700px; /* 너무 넓어지는 것을 방지 */
		background-color: var(--white-color);
		padding: 40px;
		border-radius: 16px;
		box-shadow: var(--shadow-md);
		transition: flex 0.6s ease-in-out, max-width 0.6s ease-in-out;
	}

	/* [수정됨] 결과 패널 기본 상태: 숨겨져 있고 너비가 없음 */
	.result-panel {
		flex: 0 0 0; /* 너비가 0 */
		opacity: 0;
		overflow: hidden; /* 내용이 넘치지 않도록 */
		background-color: var(--white-color);
		padding: 40px 0; /* 세로 패딩만 유지 */
		border-radius: 16px;
		box-shadow: var(--shadow-md);
		transition: flex 0.6s ease-in-out, opacity 0.4s 0.2s ease, padding 0.6s ease-in-out;
	}

	/* [추가됨] 계산 버튼 클릭 후 활성화 상태 */
	.calculator-container.results-shown {
		justify-content: space-between; /* 양쪽으로 정렬 */
	}
	.calculator-container.results-shown .input-panel {
		flex: 1 1 45%; /* 최종 너비 */
		max-width: none;
	}
	.calculator-container.results-shown .result-panel {
		flex: 1 1 55%; /* 최종 너비 */
		opacity: 1;
		padding: 40px; /* 가로 패딩 복원 */
	}


	.result-placeholder {
		text-align: center;
		color: var(--gray-color);
	}
	.result-placeholder .icon {
		font-size: 48px;
		margin-bottom: 15px;
		color: var(--primary-light-color);
	}

	h3 {
		font-size: 24px;
		font-weight: 700;
		color: var(--dark-gray-color);
		padding-bottom: 15px;
		margin-bottom: 25px;
		border-bottom: 2px solid var(--primary-color);
	}
	.info-text {
		font-size: 14px;
		line-height: 1.6;
		color: var(--gray-color);
		background-color: var(--light-gray-color);
		padding: 15px;
		border-radius: 8px;
		margin-bottom: 20px;
	}

	.input-group {
		margin-bottom: 20px;
	}
	.input-group label {
		display: block;
		margin-bottom: 8px;
		font-weight: 500;
		color: #495057;
	}
	.input-group input[type="date"], .input-group input[type="text"] {
		width: 100%;
		padding: 12px 15px;
		border: 1px solid var(--border-color);
		border-radius: 8px;
		font-size: 16px;
		transition: border-color 0.2s, box-shadow 0.2s;
	}
	.input-group input:focus {
		outline: none;
		border-color: var(--primary-color);
		box-shadow: 0 0 0 3px var(--primary-light-color);
	}

	.button-group {
		display: grid;
		grid-template-columns: 1fr 2fr;
		gap: 10px;
		margin-top: 30px;
	}
	.button-group button {
		padding: 14px 20px;
		border: none;
		border-radius: 8px;
		cursor: pointer;
		font-weight: 700;
		font-size: 16px;
		transition: all 0.2s ease-in-out;
	}
	.button-group button:hover {
		transform: translateY(-2px);
		box-shadow: 0 4px 8px rgba(0,0,0,0.1);
	}

	#calculate-btn {
		background-color: var(--primary-color);
		color: white;
	}
	#calculate-btn:hover { background-color: #3549b8; }

	#reset-btn {
		background-color: var(--light-gray-color);
		color: var(--dark-gray-color);
		border: 1px solid var(--border-color);
	}
	#reset-btn:hover { background-color: #e2e6ea; }

	#result-table {
		width: 100%;
		border-collapse: collapse;
	}
	#result-table caption {
		font-size: 1.5rem;
		font-weight: 700;
		text-align: left;
		margin-bottom: 20px;
		color: var(--primary-color);
	}
	#result-table th, #result-table td {
		border-bottom: 1px solid var(--border-color);
		padding: 16px;
		text-align: center;
	}
	#result-table thead th {
		background-color: var(--light-gray-color);
		font-weight: 500;
		color: var(--gray-color);
		font-size: 14px;
	}
	#result-table tbody td:first-child {
		font-weight: 500;
	}
	#result-table tfoot td {
		font-weight: 700;
		font-size: 1.1rem;
		color: var(--dark-gray-color);
	}
	#result-table tfoot #totalAmount {
		color: var(--primary-color);
		font-size: 1.25rem;
	}
	.note {
		color: #e63946;
		margin-top: 15px;
		font-size: 0.9rem;
		text-align: left;
		width: 100%;
	}
</style>
</head>
<body>
	<%@ include file="header.jsp" %>
	
	<div class="calculator-container" id="calculator-container">

		<div class="input-panel">
			<h3>육아휴직급여 모의계산</h3>
			<div class="info-text">
				사용자가 입력한 값을 토대로 계산되므로 실제 수급액과 차이가 있을 수 있습니다.<br>
				정확한 내용은 가까운 고용센터로 문의하시기 바랍니다.
			</div>
			
			<div class="input-group">
				<label for="startDate">휴직 시작일</label> 
				<input type="date" id="startDate" required>
			</div>
			<div class="input-group">
				<label for="endDate">휴직 종료일</label> 
				<input type="date" id="endDate" required>
			</div>
			<div class="input-group">
				<label for="salary">통상임금 (월)</label> 
				<input type="text" id="salary" inputmode="numeric" required>
			</div>
			<div class="button-group">
				<button id="reset-btn" onclick="resetForm()">초기화</button>
				<button id="calculate-btn" onclick="calculateLeaveBenefit()">계산하기</button>
			</div>
		</div>

		<div class="result-panel" id="result-panel">
			<div class="result-placeholder" id="result-placeholder">
				<div class="icon">📊</div>
				<h4>계산 결과를 기다리고 있어요.</h4>
				<p>정보를 입력하고 [계산하기] 버튼을 눌러주세요.</p>
			</div>

			<div id="result-section" style="display: none; width: 100%;">
				<table id="result-table">
					<caption>육아휴직 급여 계산 결과</caption>
					<thead>
						<tr>
							<th>개월차</th>
							<th>예상 지급액</th>
						</tr>
					</thead>
					<tbody>
					</tbody>
					<tfoot>
						<tr>
							<td>총합</td>
							<td id="totalAmount"></td>
						</tr>
					</tfoot>
				</table>
				<p class="note">(*) 괄호 안 금액은 복직 6개월 후 지급되는 사후지급금액입니다.</p>
			</div>
		</div>

	</div>

	<script>
		// [추가됨] 메인 컨테이너 변수
		const calculatorContainer = document.getElementById("calculator-container");

		const startDateInput = document.getElementById("startDate");
		const endDateInput = document.getElementById("endDate");
		const salaryInput = document.getElementById("salary");
		
		const resultPanel = document.getElementById("result-panel");
		const resultPlaceholder = document.getElementById("result-placeholder");
		const resultSection = document.getElementById("result-section");
		const resultTbody = document.querySelector("#result-table tbody");
		const totalAmount = document.getElementById("totalAmount");
		
		salaryInput.addEventListener('input', function(e) {
			let value = e.target.value.replace(/[^\d]/g, '');
			e.target.value = value ? parseInt(value, 10).toLocaleString('ko-KR') : '';
		});
		
		const formatCurrency = function(number) {
			return isNaN(number) ? '0' : Math.round(number).toLocaleString('ko-KR');
		};
		
		function getRawLeaveMonths(start, end) {
			const startDate = new Date(start);
			const endDate = new Date(end);
			let months = (endDate.getFullYear() - startDate.getFullYear()) * 12 - startDate.getMonth() + endDate.getMonth();
			if (endDate.getDate() >= startDate.getDate()) months++;
			return months;
		}

		function getLeaveMonths(start, end) {
			const rawMonths = getRawLeaveMonths(start, end);
			return Math.max(0, Math.min(rawMonths, 12));
		}
		
		function calculateMonthlyBenefit(salary, month) {
			let rate, cap;
			if (month >= 1 && month <= 3) {
				rate = 1.0; cap = 2500000;
			} else if (month >= 4 && month <= 6) {
				rate = 1.0; cap = 2000000;
			} else {
				rate = 0.8; cap = 1600000;
			}
			return Math.min(salary * rate, cap);
		}
		
		function addRowToTable(month, pay) {
			const residualPay = 0;
			const row = resultTbody.insertRow();
			
			row.insertCell().textContent = month + '개월';
			const payCell = row.insertCell();
			payCell.innerHTML = 
				formatCurrency(pay) + '원 ' +
				'<br><span style="font-size: 0.8em; color: var(--gray-color);">(' + formatCurrency(residualPay) + '원)</span>';
		}

		function calculateLeaveBenefit() {
			const salary = parseInt(salaryInput.value.replace(/,/g, ''), 10);
			
			if (!startDateInput.value || !endDateInput.value || !salaryInput.value) {
				alert("휴직 시작일, 종료일, 통상임금을 모두 입력해주세요.");
				return;
			}
			if (new Date(startDateInput.value) >= new Date(endDateInput.value)) {
				alert("휴직 종료일은 시작일보다 이후여야 합니다.");
				return;
			}
			if (isNaN(salary) || salary <= 0) {
				alert("통상임금은 유효한 숫자만 입력해주세요.");
				return;
			}

			const rawMonths = getRawLeaveMonths(startDateInput.value, endDateInput.value);
			if (rawMonths > 12) {
				alert("휴직 기간은 최대 12개월까지 선택할 수 있습니다.");
				return;
			}

			const leaveMonths = getLeaveMonths(startDateInput.value, endDateInput.value);
			
			resultTbody.innerHTML = "";
			let total = 0;

			const endDate = new Date(endDateInput.value);
			const daysInLastMonth = new Date(endDate.getFullYear(), endDate.getMonth() + 1, 0).getDate();
			const lastMonthDays = endDate.getDate();

			for (let month = 1; month <= leaveMonths; month++) {
				let monthlyPay = calculateMonthlyBenefit(salary, month);
				
				if (month === leaveMonths && lastMonthDays < daysInLastMonth) {
					monthlyPay = monthlyPay * (lastMonthDays / daysInLastMonth);
				}
				
				total += monthlyPay;
				addRowToTable(month, monthlyPay);
			}

			const totalResidualPay = 0;
			totalAmount.innerHTML = 
				formatCurrency(total) + '원 ' +
				'<br><span style="font-size: 0.8em; color: var(--gray-color);">(' + formatCurrency(totalResidualPay) + '원)</span>';
			
			// [수정됨] 클래스를 추가하여 애니메이션 트리거
			calculatorContainer.classList.add('results-shown');

			resultPlaceholder.style.display = 'none';
			resultSection.style.display = 'block';
		}
		
		function resetForm() {
			startDateInput.value = '';
			endDateInput.value = '';
			salaryInput.value = '';
			
			// [수정됨] 클래스를 제거하여 애니메이션 트리거
			calculatorContainer.classList.remove('results-shown');
			
			// 결과 영역의 내용을 애니메이션 시간 후에 초기화
			setTimeout(function() {
				resultSection.style.display = 'none';
				resultPlaceholder.style.display = 'block';
				resultTbody.innerHTML = '';
				totalAmount.textContent = '';
			}, 300); // CSS transition 시간보다 짧게 설정 가능
		}
	</script>

</body>
</html>