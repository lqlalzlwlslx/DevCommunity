<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="f" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@ page import="com.dev.comm.util.Constants" %>
<%@ page import="com.dev.comm.user.vo.User" %>
<%@ page import="com.dev.comm.util.StringUtils" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>


<!-- <link rel="stylesheet" src="<%=request.getContextPath()%>/resources/assets/css/bootstrap-5.1.1.min.css" >
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/bootstrap-5.1.1.bundle.min.js" ></script> -->


<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/assets/css/main.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/chart.min.js"></script>
<script type="text/javascript" src="https://developers.kakao.com/sdk/js/kakao.js" ></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/common.js"></script>

<!-- 
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/assets/css/bootstrap.3.4.1.min.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/jquery.3.5.1.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/bootstrap.3.4.1.min.js" ></script>
 -->

 

 

 
<title>DevCommunity</title>

<%
	User admin = (User)session.getAttribute(Constants.ADMIN_SESSION_KEY);
	User user = (User)session.getAttribute(Constants.USER_SESSION_KEY);
%>

<c:set var="adminBean" value="<%=admin%>" />
<c:set var="userBean" value="<%=user%>" />

<script type="text/javascript">
	function signUp(){
		location.href="<%=request.getContextPath()%>/signUpFrm.do";
	}
	
	function searchCondition(){
		//console.log("header in searchCondition!");
		const sBox = document.querySelector("#searchTxt");
		const condition = sBox.options[sBox.selectedIndex].value;
		const searchValue = document.querySelector("#searchInputTxt").value;
		console.log(condition);
		console.log(searchValue);
	}
	
	function logout(){
		location.href="<%=request.getContextPath()%>/logout.do";
	}
</script>
	
	
