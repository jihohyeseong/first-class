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

	.calculator-container {
		display: flex;
		justify-content: center;
		align-items: flex-start;
		gap: 30px;
		max-width: 1200px;
		width: 100%;
		margin: 40px auto;
		padding: 0 20px;
		transition: justify-content 0.6s ease-in-out;
	}

	.input-panel {
		flex: 0 1 70%;
		max-width: 700px;
		background-color: var(--white-color);
		padding: 40px;
		border-radius: 16px;
		box-shadow: var(--shadow-md);
		transition: flex 0.6s ease-in-out, max-width 0.6s ease-in-out;
	}

	.result-panel {
		flex: 0 0 0;
		opacity: 0;
		overflow: hidden;
		background-color: var(--white-color);
		padding: 40px 0;
		border-radius: 16px;
		box-shadow: var(--shadow-md);
		transition: flex 0.6s ease-in-out, opacity 0.4s 0.2s ease, padding 0.6s ease-in-out;
	}

	.calculator-container.results-shown {
		justify-content: space-between;
	}
	.calculator-container.results-shown .input-panel {
		flex: 1 1 45%;
		max-width: none;
	}
	.calculator-container.results-shown .result-panel {
		flex: 1 1 55%;
		opacity: 1;
		padding: 40px;
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
							<th>개월차 및 기간</th>
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
			let value = e.target.value.replace(/[^\d]/g, ''); // 숫자 외에 제거
			e.target.value = value ? parseInt(value, 10).toLocaleString('ko-KR') : ''; // 1,000,000처럼 천 단위 콤마(,) 형식으로 변환
		});
		
		const formatCurrency = function(number) {
			if (isNaN(number)) return '0';
			const flooredToTen = Math.floor(number / 10) * 10; // 10원 단위로 버림 처리
			return flooredToTen.toLocaleString('ko-KR');
		};

		const formatDate = function(date) {
			const y = date.getFullYear();
			const m = String(date.getMonth() + 1).padStart(2, '0'); // 두 자리로 맞추기 위해 앞에 0을 채워줌
			const d = String(date.getDate()).padStart(2, '0');
			return y + '.' + m + '.' + d;
		};

		function getPeriodEndDate(originalStart, periodNumber) {
			// 다음 기간이 시작되는 날을 먼저 계산 (최초 시작일 + N개월)
			let nextPeriodStart = new Date(
				originalStart.getFullYear(),
				originalStart.getMonth() + periodNumber,
				originalStart.getDate()
			);

			// 날짜를 더했을 때 월이 자동으로 넘어가는 경우 (예: 1월 31일 + 1개월 -> 3월 3일)
			// 이는 해당 월에 그 날짜가 없다는 의미 (예: 2월 31일은 없음)
			if (nextPeriodStart.getDate() !== originalStart.getDate()) {
				// 이 경우, 다음 기간의 시작일은 그 다음달 1일이 됨 (예: 3월 1일)
				nextPeriodStart = new Date(
					originalStart.getFullYear(),
					originalStart.getMonth() + periodNumber + 1,
					1
				);
			}
			
			// 현재 기간의 종료일은 다음 기간 시작일의 바로 전날임
			nextPeriodStart.setDate(nextPeriodStart.getDate() - 1);
			return nextPeriodStart;
		}

		// 기간 분할 및 급여 계산 메인 함수
		function splitPeriodsAndCalc(startDateStr, endDateStr, regularWage) {
			const results = [];
			const originalStartDate = new Date(startDateStr); // 육아휴직 시작일
			let currentPeriodStart = new Date(originalStartDate); // 단위기간 시작일
			const finalEndDate = new Date(endDateStr); // 육아휴직 종료일
			let monthIdx = 1;

			while (currentPeriodStart <= finalEndDate && monthIdx <= 12) {
				// 헬퍼 함수를 이용해 현재 개월차의 이론적인 종료일을 계산
				const theoreticalEndDate = getPeriodEndDate(originalStartDate, monthIdx); // 단위기간 예정 종료일

				// 실제 종료일은 이론적 종료일과 전체 휴직 종료일 중 더 빠른 날짜
				let actualPeriodEnd = new Date(theoreticalEndDate); // 단위기간 실제 종료일
				if (actualPeriodEnd > finalEndDate) {
					actualPeriodEnd = new Date(finalEndDate);
				}
				
				// 마지막달이 비정상적으로 계산되는 것을 방지
				if (currentPeriodStart > actualPeriodEnd) {
					break;
				}

				const govBase = computeGovBase(regularWage, monthIdx); // 받을 최대 금액
				const govPayment = calcGovPayment(govBase, currentPeriodStart, actualPeriodEnd, theoreticalEndDate); // 실제 받을 금액

				results.push({
					month: monthIdx, // n개월차
					startDate: new Date(currentPeriodStart), // 시작일
					endDate: new Date(actualPeriodEnd), // 종료일
					govPayment: govPayment // 실제 지급액
				});

				// 다음 개월차의 시작일은 현재 종료일 + 1일
				currentPeriodStart = new Date(actualPeriodEnd);
				currentPeriodStart.setDate(currentPeriodStart.getDate() + 1);
				
				monthIdx++;
			}
			return results;
		}

		function computeGovBase(regularWage, monthIdx) {
		    if (monthIdx <= 3) return Math.min(regularWage, 2500000); // 3개월까지 최대 현재임금 or 250만중 작은값
		    if (monthIdx <= 6) return Math.min(regularWage, 2000000); // 6개월까지 최대 현재임금 or 200만중 작은값
		    const eighty = Math.round(regularWage * 0.8);
		    return Math.min(eighty, 1600000); // 그 이후 최대 현재임금의 80% or 160만중 작은 값
		}
		
		function calcGovPayment(base, startDate, endDate, theoreticalFullEndDate) {
			const getDaysBetween = (d1, d2) => Math.round((d2.getTime() - d1.getTime()) / (1000 * 60 * 60 * 24)) + 1;
			
			const daysInTerm = getDaysBetween(startDate, endDate); // 실제 현재 단위기간중 육아휴직 기간
			
			// 이론적인 한달 시작일은 현재 기간의 시작일
			let theoreticalFullStartDate = new Date(startDate);
			const daysInFullMonth = getDaysBetween(theoreticalFullStartDate, theoreticalFullEndDate); // 단위기간 한달 꽉 채웠을때
		
			if (daysInTerm >= daysInFullMonth) { // 이론적으로 == 이지만 미세한 오차때문에 >=로 설정
				return base;
			}
			
			const ratio = daysInTerm / daysInFullMonth; // 전체 단위기간 중 실제 육아휴직 비율
			return Math.floor(base * ratio);
		}

		// 1년 초과하는지 체크하는 함수
		function getRawLeaveMonths(start, end) {
			const startDate = new Date(start);
			const endDate = new Date(end);
			let months = (endDate.getFullYear() - startDate.getFullYear()) * 12 - startDate.getMonth() + endDate.getMonth();
			if (endDate.getDate() >= startDate.getDate()) months++;
			return months;
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

		    const terms = splitPeriodsAndCalc(startDateInput.value, endDateInput.value, salary);

		    resultTbody.innerHTML = "";
		    let total = 0;

		    terms.forEach(term => {
		        total += term.govPayment;
		        const row = resultTbody.insertRow();
				
		        const monthCell = row.insertCell();
				monthCell.innerHTML = term.month + '개월차' +
					'<br><span style="font-size: 0.8em; color: var(--gray-color);">' +
					formatDate(term.startDate) + ' ~ ' + formatDate(term.endDate) +
					'</span>';

				const payCell = row.insertCell();
				payCell.innerHTML = formatCurrency(term.govPayment) + '원' + 
					'<br><span style="font-size: 0.8em; color: var(--gray-color);">(0원)</span>';
		    });

			totalAmount.innerHTML = formatCurrency(total) + '원' +
				'<br><span style="font-size: 0.8em; color: var(--gray-color);">(0원)</span>';
		    
		    calculatorContainer.classList.add('results-shown');
		    resultPlaceholder.style.display = 'none';
		    resultSection.style.display = 'block';
		}
		
		function resetForm() {
			startDateInput.value = '';
			endDateInput.value = '';
			salaryInput.value = '';
			
			calculatorContainer.classList.remove('results-shown');
			
			setTimeout(function() {
				resultSection.style.display = 'none';
				resultPlaceholder.style.display = 'block';
				resultTbody.innerHTML = '';
				totalAmount.textContent = '';
			}, 300);
		}
	</script>

</body>
</html>