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
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.0/jquery.js"></script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />

<link rel="short icon" href="#">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-/bQdsTh/da6pkI1MST/rWKFNjaCP5gBSY4sEBT38Q/9RBh9AH40zEOg7Hlq2THRZ" crossorigin="anonymous"></script>


<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/assets/css/main.css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/chart.min.js"></script>

<script type="text/javascript" src="https://developers.kakao.com/sdk/js/kakao.js" ></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/js/common.js"></script>

<script type="text/javascript" src="<%=request.getContextPath()%>/resources/summernote/summernote-lite.js" ></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/summernote/lang/summernote-ko-KR.js"></script>
<link rel="stylesheet" href="<%=request.getContextPath()%>/resources/summernote/summernote-lite.css" />


 

 
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
		const sBox = document.querySelector("#searchTxt");
		let condition = sBox.options[sBox.selectedIndex].value;
		let searchValue = document.querySelector("#searchInputTxt").value;
		
		if(condition == "0"){ alert("검색할 항목을 선택해주세요."); return; }
		if(!searchValue){ alert("검색할 단어를 입력해주세요."); return; }
		
		<c:if test="${empty userBean}">
			location.href="<%=request.getContextPath()%>/visitor/community/searchAsValues.do?condition="+condition+"&searchValue="+searchValue;
		</c:if>
		<c:if test="${not empty userBean}">
			location.href="<%=request.getContextPath()%>/community/userSearchAsValues.do?condition="+condition+"&searchValue="+searchValue;
		</c:if>
	}
	
	function signUpCommunity(idx){
		<c:if test="${empty userBean}">
			if(confirm("커뮤니티 가입은 회원전용 서비스입니다.\n회원가입창으로 이동하시겠습니까?")){
				location.href="<%=request.getContextPath()%>/signUpFrm.do";
			}
		</c:if>
		// not empty userBean resource...
		<c:if test="${not empty userBean}">
			if(confirm(name +" 커뮤니티에 가입신청 하시겠습니까?")){
				const uid = "${userBean.user_idx}";
				const comm_idx = idx;
				const commSignData = {
						method: "POST",
						headers: {"Content-Type": "application/json"},
						body: JSON.stringify({uid, comm_idx})
				};
				fetch("/user/communitySignUp", commSignData)
					.then(res => res.json())
					.then((data) => {
						if(data.result == true){
							alert(data.msg);
							location.reload();
						}
					});
				
			}
		</c:if>
	}
	
	function signCancel(cidx){
		if(confirm("신청을 취소하시겠습니까?")){
			const uid = "${userBean.user_idx}";
			const comm_idx = cidx;
			const commCancelData = {
					method: "POST",
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({uid, comm_idx})
			};
			fetch("/user/communitySignCancel.do", commCancelData)
				.then(res => res.json())
				.then((data) => {
					if(data.result){
						location.reload();
					}
				});
		}
	}
	
	
	function logout(){
		<c:if test="${not empty adminBean}">
			location.href="<%=request.getContextPath()%>/console/logout.do";
		</c:if>
		<c:if test="${not empty userBean}">
			location.href="<%=request.getContextPath()%>/logout.do";
		</c:if>
	}
	
	function moveToMain(){
		<c:if test="${not empty userBean}">
			location.href="<%=request.getContextPath()%>/user/mainUser.do";
		</c:if>
		<c:if test="${empty userBean}">
			location.href="<%=request.getContextPath()%>/";
		</c:if>
	}
	
	function moveToFaQ(){
		<c:if test="${not empty userBean}">
			location.href="<%=request.getContextPath()%>/user/inquiryToAdmin.do";
		</c:if>
		<c:if test="${empty userBean}">
			location.href="<%=request.getContextPath()%>/";
		</c:if>
	}
	
	function findPasswd(){
		location.href="<%=request.getContextPath()%>/findPasswd.do";
	}
	
	function allCommunityView(){
		location.href="<%=request.getContextPath()%>/community/allCommunityView.do";
	}
</script>
	
	
