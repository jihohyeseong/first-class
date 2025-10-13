<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- [추가] JSTL core 및 functions 태그 라이브러리를 사용합니다. --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%-- [추가] 현재 페이지의 URI를 변수에 저장합니다. --%>
<c:set var="currentURI" value="${pageContext.request.requestURI}" />

<style>
    /* ========== Header & Navigation Styles ========== */
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
        transition: color 0.3s ease-in-out;
        position: relative;
    }
    .header-nav .nav-link::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 50%;
        transform: translateX(-50%);
        width: 0;
        height: 2px;
        background-color: var(--primary-color);
        transition: width 0.3s ease;
    }
    .header-nav .nav-link:hover,
    .header-nav .nav-link.active {
        color: var(--primary-color);
    }
    .header-nav .nav-link:hover::after,
    .header-nav .nav-link.active::after {
        width: 100%;
    }
    
    /* ========== Button Styles (Used in Header) ========== */
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
</style>

<header class="header">
    <a href="${pageContext.request.contextPath}/main" class="logo"><img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" width="80" height="80"></a>
    <nav>
        <ul class="header-nav">
            <%-- [수정됨] 현재 URI에 '/main'이 포함되어 있으면 'active' 클래스를 추가합니다. --%>
            <li><a class="nav-link ${fn:contains(currentURI, '/main') ? 'active' : ''}" href="${pageContext.request.contextPath}/main">신청내역</a></li>
            <%-- [수정됨] 현재 URI에 '/calc'가 포함되어 있으면 'active' 클래스를 추가합니다. --%>
            <li><a class="nav-link ${fn:contains(currentURI, '/calc') ? 'active' : ''}" href="${pageContext.request.contextPath}/calc">모의 계산하기</a></li>
            <%-- [수정됨] 현재 URI에 '/mypage'가 포함되어 있으면 'active' 클래스를 추가합니다. --%>
            <li><a class="nav-link ${fn:contains(currentURI, '/mypage') ? 'active' : ''}" href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
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