<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="short icon" href="#">
<title>DevCommunity</title>
</head>
<body>
<c:if test="${not empty msg}">
<script type="text/javascript">
	alert(msg);
</script>
</c:if>
	<div align="center">
		<span>죄송합니다. 페이지를 표시할 수 없습니다.</span>
	</div>
</body>
</html>