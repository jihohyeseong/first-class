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
<!-- Google Font -->
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

   * { margin: 0; padding: 0; box-sizing: border-box; }
   html { height: 100%; }
   body {
      display: flex; flex-direction: column; min-height: 100vh;
      font-family: 'Noto Sans KR', sans-serif;
      background-color: var(--light-gray-color);
      color: var(--dark-gray-color);
   }
   a { text-decoration: none; color: inherit; }
	
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
    .btn-logout { background-color: var(--dark-gray-color); color: var(--white-color); border: none; }
    .btn-logout:hover { background-color: #555; }
    .btn-secondary { background-color: var(--white-color); color: var(--gray-color); border-color: var(--border-color); }
    .btn-secondary:hover { background-color: var(--light-gray-color); color: var(--dark-gray-color); border-color: #ccc; }
   
   .header {
            background-color: var(--white-color);
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            box-shadow: var(--shadow-sm);
            position: sticky;
            top: 0;
            z-index: 10;
        }
    .header .logo img { vertical-align: middle; }
    .header nav { display: flex; align-items: center; gap: 15px; }
    .header .welcome-msg { font-size: 16px; color: var(--dark-gray-color); }
		
	.header-nav {
		    position: absolute;
		    left: 50%;
		    transform: translateX(-50%);
		    display: flex;
		    list-style: none;
		    margin: 0;
		    padding: 0;
		}
	
	.header-nav .nav-link {
		    display: block;
		    padding: 0.5rem 1rem;
		    border-radius: 0.5rem;
		    font-weight: 500;
		    color: #495057;
		    transition: all 0.3s ease-in-out;
		}
	.header-nav .nav-link:hover {
		    color: #3f58d4;
		    transform: translateY(-3px);
		    box-shadow: 0 4px 10px rgba(63, 88, 212, 0.3);
		}

   .main-container {
      flex-grow: 1;
      width: 100%;
      max-width: 700px;
      margin: 40px auto;
      padding: 40px;
      background-color: var(--white-color);
      border-radius: 12px;
      box-shadow: var(--shadow-md);
   }

   h2 {
      text-align: center;
      color: var(--primary-color);
      margin-bottom: 30px;
   }

   .form-group {
      margin-bottom: 20px;
   }
   label {
      display: block;
      font-weight: 500;
      margin-bottom: 6px;
   }
   input[type="text"] {
      width: 100%;
      padding: 10px;
      border: 1px solid var(--border-color);
      border-radius: 6px;
      transition: all 0.2s ease-in-out;
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
   .btn-primary {
      background-color: var(--primary-color);
      color: var(--white-color);
      border-color: var(--primary-color);
   }
   .btn-primary:hover {
      background-color: #364ab1;
      box-shadow: var(--shadow-md);
      transform: translateY(-2px);
   }
   .btn-search {
      margin-top: 10px;
      background-color: var(--white-color);
      color: var(--dark-gray-color);
      border: 1px solid var(--border-color);
   }
   .btn-search:hover {
      background-color: var(--primary-light-color);
      color: var(--primary-color);
   }

   .submit-button-container {
      text-align: center;
      margin-top: 30px;
   }
</style>
</head>

<body>
   <header class="header">
        <a href="#" class="logo"><img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" width="80" height="80"></a>
        <nav>
        	<ul class="header-nav">
           		<li><a class="nav-link active" href="${pageContext.request.contextPath}/calc">모의 계산하기</a></li>
				<li><a class="nav-link active" href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
            </ul>
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
      <h2>마이페이지</h2>
      <form action="${pageContext.request.contextPath}/mypage/updateAddress" method="post">
         
         <input type="hidden" name="id" value="${user.id}" />
         
         <div class="form-group">
            <label>이름</label>
            <input type="text" name="name" value="${user.name}" readonly />
         </div>
         
		<div class="form-group">
            <label>전화번호</label>
            <input type="text" name="phoneNumber" value="${user.phoneNumber}" readonly />
         </div>
         
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

         <hr style="margin: 25px 0;">

         <div class="form-group">
            <label>우편번호</label>
            <div style="display: flex; gap: 10px;">
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

   <!-- Daum 주소검색 API -->
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