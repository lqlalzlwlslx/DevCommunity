<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DevCommunity</title>
<link rel="short icon" href="#">
</head>
<body>
	<c:set var="contextPath" value="${pageContext.servletContext.contextPath}" scope="application" />
	<script type="text/javascript">location.href="<%=request.getContextPath()%>/visitorMain.do";</script>
</body>
</html>