<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>login page</h1>
    <hr>
    <form action="/loginProc" method="post" name="loginForm">
        <input id="username" type="text" name="username" placeholder="id"/>
        <input id="password" type="password" name="password" placeholder="password"/>
        <input type="submit" value="login"/>
    </form>
</body>
</html>