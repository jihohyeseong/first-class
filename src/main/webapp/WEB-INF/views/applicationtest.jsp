<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>아이곁에 | 육아휴직 전자신청</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Brand font (선택) -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Chiron+GoRound+TC:wght@400;700&display=swap" rel="stylesheet">

  <style>
    :root{
      --brand:#3f58d4;
    }
    body{ background:#f7f9fc; }
    .brand{ color:var(--brand); }
    .brand-bg{ background:var(--brand); color:#fff; }
    .card{ border:0; box-shadow:0 8px 24px rgba(0,0,0,.06); border-radius:16px; }
    .card h5{ font-weight:700; color:#1f2937; }
    .section-badge{ font-size:.85rem; font-weight:700; letter-spacing:.02em; color:var(--brand); }
    .req::after{ content:" *"; color:#dc3545; }
    .kicker{ font-family:"Chiron GoRound TC", system-ui, -apple-system, Segoe UI, Roboto, "Noto Sans KR", sans-serif; }
    .divider{ border-top:1px dashed #e5e7eb; margin:1.25rem 0; }
    .form-text small{ color:#6b7280; }
    .btn-brand{ background:var(--brand); color:#fff; border:none; }
    .btn-brand:hover{ background:#3147b3; color:#fff; }
    .help{ font-size:.9rem; color:#6b7280; }
  </style>
</head>
<body>
  <header class="py-4 mb-3 border-bottom bg-white">
    <div class="container d-flex align-items-center gap-3">
      <div class="rounded-circle brand-bg d-inline-flex justify-content-center align-items-center" style="width:40px;height:40px;font-weight:700;">아</div>
      <div>
        <div class="kicker fw-bold brand">아이곁에</div>
        <div class="small text-muted">육아휴직 전자신청 (간소화·통합 양식)</div>
      </div>
    </div>
  </header>

  <main class="container mb-5">
    <form method="post" action="/apply/parental-leave/submit" id="applyForm" novalidate>
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

      <!-- 1. 신청 정보 -->
      <div class="card mb-4">
        <div class="card-body">
          <div class="section-badge mb-2">① 신청 정보</div>
          <h5 class="mb-3">육아휴직 기간 및 급여 관련</h5>

          <div class="row g-3">
            <div class="col-md-4">
              <label class="form-label req">육아휴직 시작일</label>
              <input type="date" name="leaveStart" class="form-control" required>
            </div>
            <div class="col-md-4">
              <label class="form-label req">육아휴직 종료일</label>
              <input type="date" name="leaveEnd" class="form-control" required>
            </div>
            <div class="col-md-4">
              <label class="form-label">총 기간(자동)</label>
              <input type="text" class="form-control" id="leaveSpan" placeholder="개월/일 자동 계산" readonly>
            </div>

            <div class="col-12 divider"></div>

            <div class="col-md-4">
              <label class="form-label req">통상임금 산정기준</label>
              <select class="form-select" name="wageBaseType" required>
                <option value="">선택</option>
                <option value="hourly">시급</option>
                <option value="daily">일급</option>
                <option value="weekly">주급</option>
                <option value="monthly">월급</option>
                <option value="regular">통상임금</option>
              </select>
            </div>
            <div class="col-md-4">
              <label class="form-label req">통상임금(원)</label>
              <input type="number" min="0" step="1000" name="regularWage" class="form-control" placeholder="예: 3,000,000" required>
              <div class="form-text">세전 기준</div>
            </div>
            <div class="col-md-4">
              <label class="form-label">주당 소정근로시간</label>
              <div class="input-group">
                <input type="number" min="0" step="1" name="weeklyHours" class="form-control" placeholder="예: 40">
                <span class="input-group-text">시간</span>
              </div>
            </div>

            <div class="col-12 divider"></div>

            <div class="col-md-6">
              <label class="form-label req">육아휴직 중 급여지급 내역(있으면 기재)</label>
              <input type="text" name="incomeDuringLeave" class="form-control" placeholder="예: 무급 / 유급 50% / 회사별도수당 등" required>
            </div>
            <div class="col-md-6">
              <label class="form-label">주 15시간 이상 취업/소득 발생 여부</label>
              <select class="form-select" name="otherIncomeFlag">
                <option value="N" selected>아니오</option>
                <option value="Y">예</option>
              </select>
            </div>
          </div>
        </div>
      </div>

      <!-- 2. 근로자/자녀 정보 (통합) -->
      <div class="card mb-4">
        <div class="card-body">
          <div class="section-badge mb-2">② 근로자 · 자녀 정보</div>
          <h5 class="mb-3">신청자 및 대상 자녀</h5>

          <div class="row g-3">
            <div class="col-md-4">
              <label class="form-label req">근로자 성명</label>
              <input type="text" name="workerName" class="form-control" required>
            </div>
            <div class="col-md-4">
              <label class="form-label req">주민등록번호(앞자리)</label>
              <input type="text" name="workerRRN1" class="form-control" maxlength="6" inputmode="numeric" required>
            </div>
            <div class="col-md-4">
              <label class="form-label req">주민등록번호(뒷자리)</label>
              <input type="password" name="workerRRN2" class="form-control" maxlength="7" inputmode="numeric" required>
            </div>

            <div class="col-12 divider"></div>

            <div class="col-md-4">
              <label class="form-label req">자녀 성명</label>
              <input type="text" name="childName" class="form-control" required>
            </div>
            <div class="col-md-4">
              <label class="form-label req">자녀 주민등록번호(앞자리)</label>
              <input type="text" name="childRRN1" class="form-control" maxlength="6" inputmode="numeric" required>
            </div>
            <div class="col-md-4">
              <label class="form-label req">자녀 주민등록번호(뒷자리)</label>
              <input type="password" name="childRRN2" class="form-control" maxlength="7" inputmode="numeric" required>
            </div>

            <div class="col-md-4">
              <label class="form-label">출산(예정)일</label>
              <input type="date" name="dueDate" class="form-control">
              <div class="form-text">임신 중 육아휴직 사용 시 입력</div>
            </div>
            <div class="col-md-4">
              <label class="form-label">배우자 동시 사용 여부</label>
              <select class="form-select" name="spouseUsingFlag">
                <option value="N" selected>아니오</option>
                <option value="Y">예(3+3 부분 해당 가능)</option>
              </select>
            </div>
          </div>
        </div>
      </div>

      <!-- 3. 사업장 정보 -->
      <div class="card mb-4">
        <div class="card-body">
          <div class="section-badge mb-2">③ 사업장 정보</div>
          <h5 class="mb-3">근무처(사업장) 기본</h5>

          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label req">사업장관리번호 / 사업자등록번호</label>
              <div class="input-group">
                <input type="text" name="bizNo" class="form-control" placeholder="예: 123-45-67890" required>
                <button class="btn btn-outline-secondary" type="button" onclick="alert('검색 API 연동 예정');">검색</button>
              </div>
            </div>
            <div class="col-md-6">
              <label class="form-label req">사업장명</label>
              <input type="text" name="bizName" class="form-control" required>
            </div>

            <div class="col-md-8">
              <label class="form-label req">주소</label>
              <input type="text" name="bizAddress" class="form-control" placeholder="도로명 주소" required>
            </div>
            <div class="col-md-4">
              <label class="form-label">우편번호</label>
              <input type="text" name="bizZip" class="form-control" inputmode="numeric" maxlength="5">
            </div>

            <div class="col-md-4">
              <label class="form-label">대표전화</label>
              <input type="tel" name="bizPhone" class="form-control" placeholder="예: 02-000-0000">
            </div>
            <div class="col-md-4">
              <label class="form-label">담당자 성명</label>
              <input type="text" name="managerName" class="form-control">
            </div>
            <div class="col-md-4">
              <label class="form-label">담당자 연락처</label>
              <input type="tel" name="managerMobile" class="form-control" placeholder="예: 010-0000-0000">
            </div>
            <div class="col-md-6">
              <label class="form-label">담당자 이메일</label>
              <div class="input-group">
                <input type="email" name="managerEmail" class="form-control" placeholder="example@company.com">
                <select class="form-select" onchange="applyDomain(this)">
                  <option value="">직접입력</option>
                  <option value="@gmail.com">@gmail.com</option>
                  <option value="@naver.com">@naver.com</option>
                  <option value="@daum.net">@daum.net</option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 4. 지급 계좌 -->
      <div class="card mb-4">
        <div class="card-body">
          <div class="section-badge mb-2">④ 급여 지급계좌</div>
          <h5 class="mb-3">본인 명의 계좌 입력</h5>

          <div class="row g-3">
            <div class="col-md-4">
              <label class="form-label req">지급은행</label>
              <select name="bank" class="form-select" required>
                <option value="">선택</option>
                <option>국민</option><option>신한</option><option>우리</option>
                <option>하나</option><option>기업</option><option>농협</option>
                <option>카카오뱅크</option><option>토스뱅크</option>
              </select>
            </div>
            <div class="col-md-5">
              <label class="form-label req">계좌번호</label>
              <input type="text" name="accountNo" class="form-control" inputmode="numeric" required>
            </div>
            <div class="col-md-3">
              <label class="form-label req">예금주</label>
              <input type="text" name="accountHolder" class="form-control" required>
            </div>
          </div>
          <div class="form-text mt-2 help">
            ※ 잘못된 계좌 입력으로 인한 지급 지연을 방지하기 위해 정확히 입력해주세요.
          </div>
        </div>
      </div>

      <!-- 5. 확인 / 동의 -->
      <div class="card mb-4">
        <div class="card-body">
          <div class="section-badge mb-2">⑤ 확인 · 동의</div>
          <h5 class="mb-3">신청 유의사항</h5>
          <ul class="small text-muted mb-3">
            <li>허위 기재 시 지급 중단 및 환수 등 법적 책임이 발생할 수 있습니다.</li>
            <li>필요 시 추가 증빙서류 제출을 요구할 수 있습니다.</li>
          </ul>

          <div class="form-check mb-2">
            <input class="form-check-input" type="checkbox" value="Y" id="agree1" required>
            <label class="form-check-label" for="agree1">부정수급 관련 안내사항을 모두 읽고 동의합니다.</label>
          </div>
          <div class="form-check mb-2">
            <input class="form-check-input" type="checkbox" value="Y" id="agree2" required>
            <label class="form-check-label" for="agree2">개인정보 수집·이용·제공에 동의합니다.</label>
          </div>
        </div>
      </div>

      <!-- Submit -->
      <div class="d-flex gap-2 justify-content-end">
        <a href="/apply/parental-leave" class="btn btn-outline-secondary">취소</a>
        <button type="submit" class="btn btn-brand">전자신청 제출</button>
      </div>
    </form>
  </main>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    // 이메일 도메인 선택기
    function applyDomain(sel){
      const input = sel.previousElementSibling;
      if(!input) return;
      const val = sel.value;
      if(!val) return; // 직접입력
      const [local] = (input.value || "").split("@");
      input.value = (local || "") + val;
    }

    // 기간 자동 계산
    const startEl = document.querySelector('input[name="leaveStart"]');
    const endEl   = document.querySelector('input[name="leaveEnd"]');
    const spanEl  = document.getElementById('leaveSpan');

    function calcSpan(){
      if(!startEl.value || !endEl.value) { spanEl.value=""; return; }
      const s = new Date(startEl.value);
      const e = new Date(endEl.value);
      if(isNaN(s) || isNaN(e) || e < s){ spanEl.value="기간 확인 필요"; return; }
      const days = Math.floor((e - s) / (1000*60*60*24)) + 1;
      const months = Math.floor(days / 30);
      const rest   = days % 30;
      spanEl.value = `${months}개월 ${rest}일 (총 ${days}일)`;
    }
    startEl.addEventListener('change', calcSpan);
    endEl.addEventListener('change', calcSpan);

    // 클라이언트 간단 검증
    document.getElementById('applyForm').addEventListener('submit', function(e){
      if(!this.checkValidity()){
        e.preventDefault();
        e.stopPropagation();
        this.classList.add('was-validated');
        window.scrollTo({top:0, behavior:'smooth'});
      }
    }, false);
  </script>
</body>
</html>