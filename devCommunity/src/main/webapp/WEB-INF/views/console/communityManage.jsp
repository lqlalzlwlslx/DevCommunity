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
	div  flex_item2{height: 100%;}
	.flex_container{
		display: flex;
		flex-direction: column;
	}
	.flex_item1, .flex_item2{
		flex: 1;
		overflow: auto;
		padding: 2% 0 2% 4%;
	}
</style>
<script type="text/javascript">
	<c:if test="${empty adminBean}">
		location.href="<%=request.getContextPath()%>/logout.do";
	</c:if>
	
	window.onload = function(){
		
	}
	
	function approval(status, value){
		//console.log(status);
		//console.log(value);
		if(status == "settle"){
			alert("승인");
		}
		if(status == "reject"){
			alert("반려");
		}
	}
	
	
	function pageHandler(value){
		console.log(value);
		if(value == "communityStatus"){ //communityStatus.
			location.href="<%=request.getContextPath()%>/console/mainAdmin.do";
		} else if(value == "userStatus"){ //userStatus.
			
		} else { //communityManage.
			//current page. nothing.
		}
	}
	
	<!--
	<c:if test="${not empty communityList}">
	console.log("not empty communityList.. value is : \n");
		<c:forEach items="${communityList}" var="commList" varStatus="status">
			console.log("${commList}");
		</c:forEach>
	</c:if>
	
	<c:if test="${not empty communityConfirmList}">
	console.log("not empty communityConfirmList.. value is : \n");
		<c:forEach items="${communityConfirmList}" var="ccList" varStatus="status">
			console.log("${ccList}");
		</c:forEach>
	</c:if>
	-->
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
		<h1 id="logo"><span id="loginbtn">${adminBean.nick_name} 님</span></h1><br />
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
				<li><a href="#" id="communityManage" onclick="pageHandler(this.id);">커뮤니티 관리</a></li>
				<li><a href="#" onclick="logout();">로그아웃</a></li>
			</ul>
		</nav>
		</c:if>
	</section>
	
	<div id="wrapper">
	
		<div id="main" class="flex_container" align="center">
			<div class="flex_item1">
				<div align="left">
				<span><b><font size="5">&nbsp; * &nbsp;커뮤니티 개설 신청 현황</font></b></span><hr style="margin:1em;">
				<c:if test="${empty communityConfirmList}">
					현재 커뮤니티 개설 신청 건이 없습니다.
				</c:if>
				<c:if test="${not empty communityConfirmList}">
					<table>
						<thead>
							<tr>
								<th>신청자</th>
								<th>커뮤니티명</th>
								<th>커뮤니티 타입</th>
								<th>신청사유</th>
								<th>신청일</th>
								<th></th>
								<th></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${communityConfirmList}" var="ccList" varStatus="status">
								<tr>
									<td>${ccList.manager_name}</td>
									<td>${ccList.comm_name}</td>
									<td>${ccList.comm_type_nm}</td>
									<td>${ccList.comm_reg_cont}</td>
									<td>${ccList.reg_date}</td>
									<td><span><a href="#" onclick="approval('settle', ${ccList.comm_idx});">승인</a></span></td>
									<td><span><a href="#" onclick="approval('reject', ${ccList.comm_idx});">반려</a></span></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:if>
				</div>
			</div>
			<div class="flex_item2">
				<div align="left">
				<span><b><font size="5">&nbsp; * &nbsp;커뮤니티 개설 현황</font></b></span><hr style="margin:1em;">
				<c:if test="${not empty communityList}">
					<table style="border:1px;">
						<colgroup>
						</colgroup>
						<thead>
							<tr>
								<th>커뮤니티명</th>
								<th>커뮤니티 관리자</th>
								<th>커뮤니티 타입</th>
								<th>커뮤니티 상태</th>
								<th>커뮤니티 개설일<th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${communityList}" var="commList" varStatus="status">
								<tr>
									<td>${commList.comm_name}</td>
									<td>${commList.manager_name}</td>
									<td>${commList.comm_type_nm}</td>
									<td>${commList.comm_stat_nm}</td>
									<td>${commList.reg_date}</td>
								</tr>
							</c:forEach>
						</tbody>
				</table>
				</c:if>
				</div>
			</div>
		</div>
	
	</div>
</body>
</html>