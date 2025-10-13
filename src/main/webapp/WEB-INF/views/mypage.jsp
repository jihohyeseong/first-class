<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
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
     --shadow-md: 0 4px 8px rgba(0,0,0,0.07);
   }

   * { margin: 0; padding: 0; box-sizing: border-box; }
   html { height: 100%; }
   body {
     display: flex; flex-direction: column; min-height: 100vh;
     font-family: 'Noto Sans KR', sans-serif;
     background-color: var(--light-gray-color);
     color: var(--dark-gray-color);
   }
   a { text-decoration: none; color: inherit; }

   .main-container {
     flex-grow: 1;
     width: 100%;
     max-width: 900px;
     margin: 40px auto;
     padding: 40px 50px;
     background-color: var(--white-color);
     border-radius: 16px;
     box-shadow: var(--shadow-md);
   }

   h2 {
     text-align: center;
     font-size: 28px;
     color: var(--dark-gray-color);
     margin-bottom: 40px;
     padding-bottom: 20px;
     border-bottom: 2px solid var(--primary-light-color);
   }

    /* [추가] 2열 배치를 위한 스타일 */
    .form-row {
        display: flex;
        gap: 25px; /* 좌우 입력창 사이의 간격 */
    }
    .form-row .form-group {
        flex: 1; /* 양쪽이 동일한 너비를 갖도록 함 */
    }
    /* --- */

   .form-group {
     margin-bottom: 25px;
   }
   label {
     display: block;
     font-weight: 500;
     margin-bottom: 8px;
     font-size: 16px;
   }
   input[type="text"] {
     width: 100%;
     padding: 12px 15px;
     border: 1px solid var(--border-color);
     border-radius: 8px;
     transition: all 0.2s ease-in-out;
     font-size: 16px;
   }
   input:focus {
     border-color: var(--primary-color);
     box-shadow: 0 0 0 3px rgba(63, 88, 212, 0.15);
     outline: none;
   }
   input[readonly] {
     background-color: var(--light-gray-color);
     cursor: not-allowed;
   }
   
    .btn {
        display: inline-block;
        padding: 10px 20px;
        font-size: 15px;
        font-weight: 500;
        border-radius: 8px;
        border: 1px solid var(--border-color);
        cursor: pointer;
        transition: all 0.2s ease-in-out;
        text-align: center;
    }
   .btn-primary { background-color: var(--primary-color); color: var(--white-color); border-color: var(--primary-color); }
   .btn-primary:hover { background-color: #364ab1; box-shadow: var(--shadow-md); transform: translateY(-2px); }
   
   .btn-search {
     padding: 12px 20px;
     background-color: var(--white-color);
     color: var(--dark-gray-color);
     border: 1px solid var(--border-color);
   }
   .btn-search:hover {
     background-color: var(--primary-light-color);
     color: var(--primary-color);
     border-color: var(--primary-color);
   }

   .submit-button-container {
     text-align: center;
     margin-top: 40px;
   }
   .submit-button-container .btn-primary {
       padding: 12px 40px;
       font-size: 16px;
   }
   
   .footer {
       text-align: center;
       padding: 20px 0;
       font-size: 14px;
       color: var(--gray-color);
   }
</style>
</head>

<body>
   <%@ include file="header.jsp" %>
 
   <main class="main-container">
     <h2>마이페이지</h2>
     <form action="${pageContext.request.contextPath}/mypage/updateAddress" method="post">
       
       <input type="hidden" name="id" value="${user.id}" />
       
       <div class="form-row">
           <div class="form-group">
             <label>이름</label>
             <input type="text" name="name" value="${user.name}" readonly />
           </div>
           <div class="form-group">
             <label>전화번호</label>
             <input type="text" name="phoneNumber" value="${user.phoneNumber}" readonly />
           </div>
       </div>
       
       <div class="form-row">
           <div class="form-group">
             <label>주민등록번호</label>
             <c:set var="rrnRaw" value="${user.registrationNumber}" />
             <c:set var="rrnDigits" value="${fn:replace(rrnRaw, '-', '')}" />
             <input type="text" value="${fn:substring(rrnDigits,0,6)}-${fn:substring(rrnDigits,6,7)}******" readonly>
           </div>
           <div class="form-group">
             <label>아이디</label>
             <input type="text" name="username" value="${user.username}" readonly />
           </div>
       </div>
       <hr style="margin: 35px 0; border: none; border-top: 1px solid var(--border-color);">

       <div class="form-group">
         <label>우편번호</label>
         <div style="display: flex; gap: 10px; align-items: center;">
           <input type="text" id="zipNumber" name="zipNumber" value="${user.zipNumber}" readonly style="flex:1;">
           <button type="button" class="btn btn-search" onclick="execDaumPostcode()">주소검색</button>
         </div>
       </div>

       <div class="form-group">
         <label>기본주소</label>
         <input type="text" id="addressBase" name="addressBase" value="${user.addressBase}" readonly />
       </div>

       <div class="form-group">
         <label>상세주소</label>
         <input type="text" id="addressDetail" name="addressDetail" value="${user.addressDetail}" />
       </div>

       <div class="submit-button-container">
         <button type="submit" class="btn btn-primary">주소 수정</button>
       </div>
     </form>
   </main>

   <footer class="footer">
     <p>© 2025 FirstClass. All rights reserved.</p>
   </footer>

   <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
   <script>
     function execDaumPostcode() {
       new daum.Postcode({
         oncomplete: function(data) {
           document.getElementById("zipNumber").value = data.zonecode;
           document.getElementById("addressBase").value = data.address;
           document.getElementById("addressDetail").focus();
         }
       }).open();
     }
   </script>
</body>
</html>