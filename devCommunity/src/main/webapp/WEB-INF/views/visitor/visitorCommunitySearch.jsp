<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>

<%@ include file="/WEB-INF/views/include/header.jsp" %>
	
<style>
	#loginbtn:hover, .signUpCommunity:hover{cursor:pointer;}
	div.image.main{
		background-image: url(../../resources/images/banner.jpg);
		top: 0;
		display:flex;
	}
	.container{padding:0 !important;}
	.container-solid{border-top:solid 6px #f4f4f4; vertical-align:middle;}
	p{margin:0 0 1em 0;}
	table>tbody>tr>td{vertical-align:middle;}
	.replytb{padding:0; }
</style>

</head>
<body>

<script type="text/javascript">
	window.onload = function (){
		<c:if test="${not empty userBean}">
			location.href="<%=request.getContextPath()%>/user/mainUser.do";
		</c:if>
		const lb = document.querySelector("#loginbtn");
		lb.addEventListener('click',() => {
			location.href="<%=request.getContextPath()%>/loginFrm.do";
		});
		
		const searchButton = document.querySelector("#searchBtn");
		searchButton.addEventListener("click", function(){
			searchCondition();
		});
	}
	
</script>

		<!-- Header -->
			<section id="header">
				<header>
					<c:if test="${ empty userBean }">
					<span class="image avatar"><img src="/resources/images/avatar.jpg" alt="" /></span>
					<h1 id="logo"><span id="loginbtn">로그인</span></h1><br />
					<br />
					<div onclick="kakaoLogin();" style="cursor:pointer;"><span><img src="<%=request.getContextPath()%>/resources/images/kakao_login_medium_narrow.png" /></span></div>
					<br />
					<div style="display:flex;" align="center">
					<p></p>
						<div style="width:35%;" align="right"><a href="#" onclick="signUp();">회원가입</a></div>
						<!-- <div style="width:2%;"></div> -->
						<div style="width:60%;" onclick="findPasswd();"><a href="#">비밀번호 찾기</a></div>
					</div>
					</c:if>
				</header>
				<!-- <nav id="nav">
					<ul>
						<li><a href="#one" class="active">About</a></li>
						<li><a href="#two">Things I Can Do</a></li>
						<li><a href="#three">A Few Accomplishments</a></li>
						<li><a href="#four">Contact</a></li>
					</ul>
				</nav>
				<footer>
					<ul class="icons">
						<li><a href="#" class="icon brands fa-twitter"><span class="label">Twitter</span></a></li>
						<li><a href="#" class="icon brands fa-facebook-f"><span class="label">Facebook</span></a></li>
						<li><a href="#" class="icon brands fa-instagram"><span class="label">Instagram</span></a></li>
						<li><a href="#" class="icon brands fa-github"><span class="label">Github</span></a></li>
						<li><a href="#" class="icon solid fa-envelope"><span class="label">Email</span></a></li>
					</ul>
				</footer> -->
			</section>

		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Main -->
					<div id="main">

						<!-- One -->
							<section id="one">
								<div class="image main" data-position="center">
									<!-- <img src="/resources/images/banner.jpg" alt="" /> -->
									<div style="width:15%;"></div>
									<div style="width:25%; margin:auto;">
										<select id="searchTxt">
											<option value="0">=== 선택 ===</option>
											<option value="board_content">내용</option>
											<option value="board_title">제목</option>
											<option value="board_writer">작성자</option>
											<option value="community">커뮤니티</option>
										</select>
									</div>
									<div style="width:2%;"></div>
									<div style="width:40%; margin:auto;">
										<input type="text" id="searchInputTxt" onKeyPress="if(event.keyCode==13) searchCondition();" placeholder="검색할 단어를 입력하세요." />
									</div>
									<div style="width:2%;"></div>
									<div style="width:20%; margin:auto;">
										<input type="button" id="searchBtn" value="검색" />
									</div>
								</div>
								<div class="container">
									<header class="major">
										<h2 style="font-size:3.5em;">DevCommunity</h2>
										<p>DevCoummunity에 오신 것을 환영합니다.<!-- <br />
										이용 수칙에 관해 잘 읽어주시고 활동해주세요. --></p>
									</header>
									<!-- <p style="margin:-1em 0 1em 0;">
									1. 다른 회원을 비하하는 내용의 게시글은 차단대상입니다.<br />
									2. 사이트 내 운영방침과 관계없는 게시글은 차단대상입니다.<br />
									3. 
									</p> -->
								</div>
							</section>
							
							
						<div class="main-content-area">
							<c:if test="${not empty vcList}">
								<c:forEach items="${vcList}" var="vcList" varStatus="vcStatus">
									<div class="container container-solid">
										<header class='major'>
											<span style="color:#4acaa8; font-size:3em; line-height:1.5em;">${vcList.comm_name}</span>
											<span class="signUpCommunity" onclick="signUpCommunity('${vcList.comm_idx}');" style="float:right; margin-top:2.5em;">커뮤니티 가입신청</span>
										</header>
										<br />
										<table>
											<tbody>
												<tr>
													<td>커뮤니티 관리자</td>
													<td>${vcList.manager_name}</td>
													<td>개설일</td>
													<td>${fn:substring(vcList.reg_date, 2, 16)}</td>
													<td>회원수</td>
													<td>${vcList.total_member} 명</td>
												</tr>
												<tr>
													<td>소개글</td>
													<c:if test="${empty vcList.comm_intro}"><td colspan="3"> * 소개글이 없습니다.</td></c:if>
													<c:if test="${not empty vcList.comm_intro}"><td colspan="3">${vcList.comm_intro}</td></c:if>
													<td>게시글 수</td>
													<td>${vcList.total_board} 개</td>
												</tr>
											</tbody>
										</table>
									</div>
								</c:forEach>
							</c:if>
						</div>
					</div>

				<!-- Footer -->
				<section id="footer" >
					<div class="container" align="center">
						<ul class="copyright">
							<li>&copy;2021 DevCommunity.</li>
						</ul>
					</div>
				</section>
			</div>
			
	<script type="text/javascript">
		
		function replyInsert(bidx){
			<c:if test="${empty userBean}">
				alert("로그인이 필요한 서비스입니다.");
				return;
			</c:if>
		}
		
	</script>
</body>
</html>