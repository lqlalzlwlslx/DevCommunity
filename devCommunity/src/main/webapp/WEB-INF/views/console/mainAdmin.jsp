<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<style>
	.flex_container{
		display: flex;
		flex-direction: row;
		height: 100%;
	}
	.flex_item1, .flex_item2{
		flex: 1;
		overflow: auto;
		align: center;
		height: 100%;
	}
</style>
<script type="text/javascript">
	<c:if test="${empty adminBean}">
		location.href="<%=request.getContextPath()%>/logout.do";
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
		console.log(res);
		if(res.result == true){
			var typej = res.comm_type_j;
			var typec = res.comm_type_c;
			var typep = res.comm_type_p;
			var typed = res.comm_type_d;
			
			var pieElement = document.querySelector(".flex_item1");
			pieElement.innerHTML = "<canvas id='pie-chart' style='width: 100%; height: 100%; margin: auto;'></canvas>";
			
			new Chart(document.getElementById("pie-chart"), {
				type: 'pie',
				data: {
					labels: ['Java', 'C', 'Python', 'Database'],
					datasets: [{
						label: 'label',
						data: {typej, typec, typep, typed}
					}]
				},
				options: {
					title: {
						display: true
					},
					legend: {display: false},
					maintainAspectRatio: true
				}
			});
			
		}
	}
	
	function drawBarChart(res){
		var barElement = document.querySelector(".flex_item2");
		barElement.innerHTML = "<canvas id='barChart' style='width: 100%; height: 100%; margin: auto; padding: auto;'></canvas>";
		
		new Chart(document.getElementById("barChart"),{
			type: 'bar',
			data: {
				labels: ['Java', 'C', 'Python', 'Database'],
				datasets: [{
					label: 'Java',
					data: [res.typej, res.typec, res.typep, res.typed],
					backgroundColor: [
						'rgba(54, 162, 235, 0.2)',
						'rgba(255, 99, 132, 0.2)',
						'rgba(255, 206, 86, 0.2)',
						'rgba(255, 159, 64, 0.2)'
					],
					borderColor: [
						'rgba(54, 162, 235, 0.2)',
						'rgba(255, 99, 132, 0.2)',
						'rgba(255, 206, 86, 0.2)',
						'rgba(255, 159, 64, 0.2)'
					],
					borderWidth: 1
			}],
			},
			options: {
				maintainAspectRatio: true,
				title: {display: true},
				legend:{display: false}
			}
		});
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
		<h1 id="logo"><span id="loginbtn">${adminBean.nick_name} 님</span></h1><br />
		<div style="display:flex;" align="center">
			<p></p>
		</div>
		</c:if>
		</header>
		<c:if test="${not empty adminBean }">
		<nav id="nav">
			<ul>
				<li><a href="#" id="communityStatus">커뮤니티 현황</a></li>
				<li id="ucLi"><a href="#" id="ucListView">회원정보 관리</a></li>
				<li id="communityFrm"><a href="#">커뮤니티 관리</a></li>
				<li><a href="#" onclick="logout();">로그아웃</a></li>
			</ul>
		</nav>
		</c:if>
	</section>
	
	<div id="wrapper">
	
		<div id="main" class="flex_container" align="center">
			<div class="flex_item1"></div>
			<div class="flex_item2"></div>
		</div>
	
	</div>
</body>
</html>