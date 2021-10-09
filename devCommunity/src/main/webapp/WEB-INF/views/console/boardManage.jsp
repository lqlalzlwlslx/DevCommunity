<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<style>
	html, body{
		margin: 0;
		height: 100%;
		overflow: hidden;
	}
	div{height: 100%;}
	.flex_container{
		display: flex;
		flex-direction: row;
	}
	.flex_item1, .flex_item2{
		flex: 1;
		overflow: auto;
		align: center;
	}
</style>
<script type="text/javascript">
	<c:if test="${empty adminBean}">
		location.href="<%=request.getContextPath()%>/console/logout.do";
	</c:if>
	
	window.onload = function(){
		
	}
	<c:if test="${not empty bbList}">
		console.log("bbList is not empty");
		<c:forEach items="${bbList}" var="bblist" varStatus="bbStatus">
			console.log("${bblist}");
		</c:forEach>
	</c:if>
	<c:if test="${empty bbList}">
		console.log("bbList is empty");
	</c:if>
	
	<c:if test="${not empty abList}">
		console.log("abList is not empty");
		<c:forEach items="${abList}" var="ablist" varStatus="abStatus">
			console.log("${ablist}");
		</c:forEach>
	</c:if>
	
	
	
	
	function pageHandler(value){
		if(value == "communityStatus"){ //communityStatus.
			location.href="<%=request.getContextPath()%>/console/mainAdmin.do";
		} else if(value == "userStatus"){ //userStatus.
			location.href="<%=request.getContextPath()%>/console/user/userManage.do";
		} else if(value == "boardStatus"){
			// current page. nothing.
		} else { //communityManage.
			location.href="<%=request.getContextPath()%>/console/community/communityManage.do";
		}
	}
</script>
</head>
<body>
	


	<section id="header">
		<header>
		<c:if test="${ not empty adminBean }">
		<c:if test="${empty adminBean.profile_src}">
			<span class="image avatar"><img src="/resources/images/default_profile.png" alt="" /></span>
		</c:if>
		<c:if test="${not empty adminBean.profile_src }">
			<span class="image avatar"><img src="${contextPath}${userBean.profile_src}" alt="" /></span>
		</c:if>
		<h1 id="logo"><span id="loginbtn">${adminBean.nick_name}</span></h1><br />
		<div style="display:flex;" align="center">
			<p></p>
		</div>
		</c:if>
		</header>
		<c:if test="${not empty adminBean }">
		<nav id="nav">
			<ul>
				<li><a href="#" id="communityStatus" onclick="pageHandler(this.id);">커뮤니티 현황</a></li>
				<li><a href="#" id="userStatus" onclick="pageHandler(this.id);">회원정보 관리</a></li>
				<li><a href="#" id="boardStatus" onclick="paheHandler(this.id);">게시글 관리</a></li>
				<li><a href="#" id="communityManage" onclick="pageHandler(this.id);">커뮤니티 관리</a></li>
				<li><a href="#" onclick="logout();">로그아웃</a></li>
			</ul>
		</nav>
		</c:if>
	</section>
	
	<div id="wrapper">
		<!-- <h2>&nbsp;&nbsp;Developer Community</h2> -->
		<div id="main" class="flex_container" align="center">
			<div class="flex_item1">
				<div align="left">
					<span><b><font size="5">&nbsp; * &nbsp;차단게시글 현황</font></b></span><hr style="margin:1em;">
						<c:if test="${empty bbList}">
							현재 차단게시글이 없습니다.
						</c:if>
						<c:if test="${not empty bbList}">
						<table>
						</table>
				</c:if>
				</div>
			</div>
			<div class="flex_item2">
			
			</div>
		</div>
	
	</div>
</body>
</html>