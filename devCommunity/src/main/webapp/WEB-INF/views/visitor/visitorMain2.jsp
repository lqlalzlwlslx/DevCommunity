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
						<c:if test="${not empty vbList}">
							<c:forEach items="${vbList}" var="vbList" varStatus="vbStatus">
								<div class="container container-solid">
									<div class='content_inner' style="display:flex;">
										<div style="width:45em;">
											<header class='major'>
												<h2>${vbList.board_title}</h2>
											</header>
										</div>
										<div style="width:17em;">
											<span style="float:right;">커뮤니티 &nbsp;&nbsp;${vbList.comm_name}<br />작성일 &nbsp;&nbsp;${fn:substring(vbList.reg_date, 2, 16)}<br />작성자 &nbsp;&nbsp;${vbList.writer_nick}</span>
										</div>
									</div>
									<div class="content-area">
										<p>${vbList.board_content}</p>
									</div>
									<div class="container_outer">
										<table style="margin:0 0 1.25em 0;"><tbody><tr>
											<td style="width:12%;" align="center">댓글<br />작성</td>
											<td><textarea id="txtArea_${vbList.board_idx}" name="replyTxtArea" style="resize:none; max-height:5em; overflow:hidden;" placeholder="댓글 작성은 회원만 가능합니다."></textarea></td>
											<td class="replyBtn" style="width:15%;" onclick="replyInsert('${vbList.board_idx}');"><input type="button" value="등록" /></td>
										</tr></tbody></table>
									</div>
									<c:if test="${empty vbList.replyList}">
										<div style="padding-bottom:1em;"><span> * 작성된 댓글이 없습니다. </span></div>
									</c:if>
									<c:if test="${not empty vbList.replyList}">
										<div class="replyDiv" style="padding-bottom:1em;">
											<c:forEach items="${vbList.replyList}" var="vbBoardReply" varStatus="vbReplyStatus">
												<table style="margin:0.25em;">
													<tbody>
														<tr style="vertical-align:middle;">
															<c:if test="${empty vbBoardReply.reply_res_path}"><td rowspan="2" class="replytb" style="width:5%;"><span><img src='/resources/images/default_profile.png' style='width:25px; height:25px;'/></span></td></c:if>
															<c:if test="${not empty vbBoardReply.reply_res_path}"><td rowspan="2" class="replytb" style="width:5%;"><span><img src="${vbBoardReply.reply_res_path}" style="width:25px; height:25px;" /></span></td></c:if>
															<td rowspan="2" class="replytb" style="width:15%;">${vbBoardReply.reply_nick}</td>
															<td rowspan="2" class="replytb" style="width:auto;"><span name="replys" id="replyContent_${vbBoardReply.reply_idx}">${vbBoardReply.reply_content}</span></td>
															
															<td colspan="2" align="center" class="replytb" name="replyblank" id="replyblank_${vbBoardReply.reply_idx}" style="width:7%;"><span>&nbsp;</span></td>
															<td colspan="2" align="center" class="replytb" name="replyblank2" id="replyblacks_${vbBoardReply.reply_idx}" style="width:7%;"><span>&nbsp;</span></td>
														</tr>
														<tr>
															<c:if test="${empty vbBoardReply.modify_date}"><td class="replytb" colspan="4" align="center" style="background-color:#fafafa;"><span style="font-size:0.75em;">${fn:substring(vbBoardReply.reg_date, 2, 16)}</span></td></c:if>
															<c:if test="${not empty vbBoardReply.modify_date}"><td class="replytb" colspan="4" align="center" style="background-color:#fafafa;"><span style="font-size:0.75em;">${fn:substring(vbBoardReply.modify_date, 2, 16)}</span></td></c:if>
														</tr>
													</tbody>
												</table>
											</c:forEach>
										</div>
									</c:if>
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