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
		overflow: hidden;
		vertical-align: center;
	}
</style>
<script type="text/javascript">
	<c:if test="${empty adminBean}">
		location.href="<%=request.getContextPath()%>/console/logout.do";
	</c:if>
	
	window.onload = function(){
		getCommunityStatus();
	}
	
	function getCommunityStatus(){
		fetch("/console/community/communityStatus")
			.then(res => res.json())
			.then(data => {
				drawPieChart(data);
				drawBarChart(data);
			});
	}
	
	function drawPieChart(res){
		//console.log(res);
		var pieElement = document.querySelector(".flex_item1");
		pieElement.innerHTML = "<canvas id='pieChart' style='width: 100%; height: 100%; margin: auto; padding: auto;'></canvas>";
		
		new Chart(document.getElementById("pieChart"), {
			type: 'pie',
			data: {
				labels: ["Java", "C", "Python", "Database"],
				datasets: [{
					//label: ["JAVA"],
					backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9"],
					data: [res.comm_type_j, res.comm_type_c, res.comm_type_p, res.comm_type_d]
				}]
			},
			options: {
				legend: {display: true },
				title: {
					display: true,
					text: "커뮤니티 카테고리별 개설 현황"
				},
				//maintainAspectRatio: false,
				responsive: false
			}
		});
			
	}
	
	function drawBarChart(res){
		//console.log(res);
		var barElement = document.querySelector(".flex_item2");
		barElement.innerHTML = "<canvas id='barChart' style='width: 100%; height: 100%; margin: auto; padding: auto;'></canvas>";
		
		new Chart(document.getElementById("barChart"),{
			type: 'bar',
			data: {
				labels: ["Java", "C", "Python", "Database"],
				datasets: [{
					//label: "커뮤니티 카테고리 별 개설 현황",
					backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9"],
					data: [res.comm_type_j, res.comm_type_c, res.comm_type_p, res.comm_type_d]
				}]
			},
			options: {
				legend: {display: false },
				title: {
					display: true,
					text: "커뮤니티 카테고리별 개설 현황"
				},
				//maintainAspectRatio: false,
				responsive: false
			}
			
		});
	}
	
	function pageHandler(value){
		if(value == "communityStatus"){ //communityStatus.
			//current page. nothing.
		} else if(value == "inquiryStatus"){
			location.href="<%=request.getContextPath()%>/console/board/inquiryManage.do";
		} else if(value == "userStatus"){ //userStatus.
			location.href="<%=request.getContextPath()%>/console/user/userManage.do";
		} else if(value == "boardStatus"){
			location.href="<%=request.getContextPath()%>/console/board/boardManage.do";
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
				<li><a href="#" id="inquiryStatus" onclick="pageHandler(this.id);">1:1 문의 관리</a></li>
				<li><a href="#" id="userStatus" onclick="pageHandler(this.id);">회원정보 관리</a></li>
				<li><a href="#" id="boardStatus" onclick="pageHandler(this.id);">게시글 관리</a></li>
				<li><a href="#" id="communityManage" onclick="pageHandler(this.id);">커뮤니티 관리</a></li>
				<li><a href="#" onclick="logout();">로그아웃</a></li>
			</ul>
		</nav>
		</c:if>
	</section>
	
	<div id="wrapper">
		<!-- <h2>&nbsp;&nbsp;Developer Community</h2> -->
		<div id="main" class="flex_container" align="center">
			<div class="flex_item1"></div>
			<div class="flex_item2"></div>
		</div>
	
	</div>
</body>
</html>