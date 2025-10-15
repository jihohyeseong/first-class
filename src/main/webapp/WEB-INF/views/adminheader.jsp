<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<style>
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
    .header .logo img { 
        vertical-align: middle; 
    }
    .header nav { 
        display: flex; 
        align-items: center; 
        gap: 15px; 
    }
    .header .welcome-msg { 
        font-size: 16px; 
        color: var(--dark-gray-color); 
    }
    
</style>

<header class="header">
    <a href="${pageContext.request.contextPath}/admin/applications" class="logo"><img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" width="80" height="80"></a>
    <nav>
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