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
	
	document.addEventListener("DOMContentLoaded", function(){
		getVisitorBoardList();
	});
	
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
							<div class="container container-solid">
								<header class="major">
									<h2>board_title</h2>
									<!-- <p>DevCoummunity에 오신 것을 환영합니다.<br />
									이용 수칙에 관해 잘 읽어주시고 활동해주세요.</p> -->
								</header>
								<p>board_content</p>
							</div>
						</div>
					</div>

				<!-- Footer -->
				<section id="footer" >
					<div class="container" align="center">
						<ul class="copyright">
							<li>&copy; Untitled. All rights reserved.</li><li>Design: <a href="http://html5up.net">HTML5 UP</a></li>
						</ul>
					</div>
				</section>
			</div>
			
	<script type="text/javascript">
		function vSearch(list){
			var contentArea = document.querySelector(".main-content-area");
			var output;
			var reqDate;
			contentArea.innerHTML = "";
			for(var i = 0; i < list.length; i++){
				reqDate = list[i].reg_date.split(" ")[0];
				output = "";
				output += "<div class='container container-solid'>";
				output += "<header class='major'>";
				output += "<span style='color:#4acaa8; font-size:3em; line-height:1.5em;'>"+list[i].comm_name+"</span>";
				output += "<span class='signUpCommunity' onclick='signUpCommunity("+list[i].comm_idx+");' style='float:right; margin-top:2.5em;'>커뮤니티 가입신청</span>";
				output += "</header><br />";
				//output += "<p>소개글 : "+list[i].comm_intro+"</p>";
				output += "<table><tbody>"
				output += "<tr><td>커뮤니티 관리자</td><td>"+list[i].manager_name+"</td>";
				output += "<td>개설일</td><td>"+reqDate+"</td>";
				output += "<td>회원수</td><td>"+list[i].total_member+" 명</td></tr>";
				if(list[i].comm_intro == null){
					output += "<tr><td>소개글</td><td colspan='3'> * 소개글이 없습니다. </td><td>게시글 수</td><td>"+list[i].total_board+" 개</td></tr>";
				}else{
					output += "<tr><td>소개글</td><td colspan='3'>"+list[i].comm_intro+"</td><td>게시글 수</td><td>"+list[i].total_board+" 개</td></tr>";
				}
				output += "</tbody></table>";
				output += "</div>";
				contentArea.innerHTML += output;
			}
		}
		
		let contentArea = document.querySelector(".main-content-area");
		contentArea.innerHTML = "";
		let output = "";
		function getVisitorBoardList(){
			fetch("/board/visitMainBoardList.do")
				.then(res => res.json())
				.then((data) => {
					let vbList = data.vbList;
					let vbReplyList;
					if(data.result == true){
						const login_id = "${userBean.login_id}";
						const user_idx = "${userBean.user_idx}";
						let board_writerId;
						let boardReplyList;
						for(let i = 0; i < vbList.length; i++){
							vbReplyList = vbList[i].replyList;
							output = "";
							output += "<div class='container container-solid'>";
							output += "<div class='content_inner' style='display:flex;'>";
							output += "<div style='width:22em;'>";
							output += "<header class='major'>";
							output += "<h2>"+vbList[i].board_title+"</h2>";
							output += "</header>";
							output += "</div>";
							output += "<div style='width:23em;'>";
							output += "<span style='float:right;'>커뮤니티 &nbsp;&nbsp;"+vbList[i].comm_name+"<br />작성일 &nbsp;&nbsp;"+vbList[i].reg_date+"<br />작성자 &nbsp;&nbsp;"+vbList[i].writer_nick+"</span>";
							output += "</div>";
							output += "</div>";	//content_inner.
							output += "<div class='content-area'><p>"+vbList[i].board_content+"</p></div>";
							output += "<div class='container_outer'>";
							output += "<table><tbody><tr>";
							output += "<td style='width:12%' align='center'>댓글<br />작성</td>";
							output += "<td><textArea id='txtArea_"+vbList[i].board_idx+"' name='replyTxtArea' style='resize:none; max-height:5em; overflow:hidden;' placeholder='댓글 작성은 회원만 가능합니다.'></textarea></td>";
							output += "<td class='replyBtn' style='width:15%;' onclick='replyInsert("+vbList[i].board_idx+");'><input type='button' value='등록' /></td>";
							output += "</tr></tboby></table>";
							output += "</div>";	//container_outer.
							if(vbReplyList.length > 0){
								output += "<div class='replyDiv'>";
								for(let j = 0; j < vbReplyList.length; j++){
									output += "<table style='margin:0.25em;'><tbody>";
									output += "<tr style='vertical-align:middle;'>";
									if(vbReplyList[j].reply_res_path == null){
										output += "<td rowspan='2' class='replytb' style='width:5%;'><span><img src='/resources/images/default_profile.png' style='width:25px; height:25px;'/></span></td>";
									}else{
										output += "<td rowspan='2' class='replytb' style='width:5%;'><span><img src='"+vbReplyList[j].reply_res_path+"' style='width:25px; height:25px;' /></span></td>";
									}
									output += "<td rowspan='2' class='replytb' style='width:15%;'>"+vbReplyList[j].reply_nick+"</td>";
									output += "<td rowspan='2' class='replytb' style='width:auto;'><span name='replys' id='replyContent_"+vbReplyList[j].reply_idx+"'>"+vbReplyList[j].reply_content+"</span></td>";
									if(vbReplyList[j].reply_uidx == user_idx){
										output += "<td align='center' class='replytb replyModify' name='replyModis' id='replyModify_"+vbReplyList[j].reply_idx+"' style='width:7%;' onclick='replyModify("+vbReplyList[j].reply_idx+");'><span><a>수정</a></span></td>";
										output += "<td align='center' class='replytb replyModifySave' name='replyModiSaves' id='replyModifySave_"+vbReplyList[j].reply_idx+"' style='width:7%; display:none;' onclick='replyModifySave("+vbReplyList[j].reply_idx+");'><span><a>저장</a></span></td>";
										output += "<td align='center' class='replytb replyDelete' name='replyDels' id='replyDelete_"+vbReplyList[j].reply_idx+"' style='width:7%;' onclick='replyDelete("+vbReplyList[j].reply_idx+");'><span><a>삭제</a></span></td>";
										output += "<td align='center' class='replytb replyCancel' name='replyCans' id='replyCancel_"+vbReplyList[j].reply_idx+"' style='width:7%; display:none;' onclick='replyCancel("+vbReplyList[j].reply_idx+");'><span><a>취소</a></span></td>";
									}else{
										output += "<td colspan='2' align='center' class='replytb' name='replyblank' id='replyblank_"+vbReplyList[j].reply_idx+"' style='width:7%;'><span>&nbsp;</span></td>";
										output += "<td colspan='2' align='center' class='replytb' name='replyblank2' id='replyblanks_"+vbReplyList[j].reply_idx+"' style='width:7%;'><span>&nbsp;</span></td>";
									}
									output += "</tr>"
									if(vbReplyList[j].modify_date == null){
										vbReplyList[j].reg_date = vbReplyList[j].reg_date.substring(2, vbReplyList[j].reg_date.lastIndexOf(":"));
										output += "<tr><td class='replytb' colspan='4' align='center' style='background-color:#fafafa;'><span style='font-size:0.75em;'>"+vbReplyList[j].reg_date+"</span></td></tr>";
									}else{
										vbReplyList[j].modify_date = vbReplyList[j].modify_date.substring(2, vbReplyList[j].modify_date.lastIndexOf(":"));
										output += "<tr><td class='replytb' colspan='4' align='center' style='background-color:#fafafa;'><span style='font-size:0.75em;'>"+vbReplyList[j].modify_date+"</span></td></tr>";
									}
									output += "</tbody></table>";
								}
								output += "</div>";
							}else{
								output += "<div><span> * 작성된 댓글이 없습니다. </span></div>";
							}
							output += "</div><br />";
							contentArea.innerHTML += output;
						}
					}else{
						output += "<div class='container container-solid'>";
						output += "<header class='major'>";
						output += "<h2>등록된 게시글이 없습니다.</h2>"
						output += "</header>";
						output += "</div>";
						contentArea.innerHTML += output;
					}
				});
		}
		
		function vSearchBoard(list){
			let contentArea = document.querySelector(".main-content-area");
			contentArea.innerHTML = "";
			let output = "";
			const login_id = "${userBean.login_id}";
			const user_idx = "${userBean.user_idx}";
			let board_writerId;
			let replyList;
			for(let i = 0; i < list.length; i++){
				replyList = list[i].replyList;
				output = "";
				output += "<div class='container container-solid'>";
				output += "<div class='content_inner' style='display:flex;'>";
				output += "<div style='width:22em;'>";
				output += "<header class='major'>";
				output += "<h2>"+list[i].board_title+"</h2>";
				output += "</header>";
				output += "</div>";
				output += "<div style='width:23em;'>";
				output += "<span style='float:right;'>작성일 &nbsp;&nbsp;"+list[i].reg_date+"<br />작성자 &nbsp;&nbsp;"+list[i].writer_nick+"</span>";
				output += "</div>";
				output += "</div>";	//content_inner.
				output += "<div class='content-area'><p>"+list[i].board_content+"</p></div>";
				output += "<div class='container_outer'>";
				output += "<table><tbody><tr>";
				output += "<td style='width:12%'>댓글작성</td>";
				output += "<td><textArea id='txtArea_"+list[i].board_idx+"' name='replyTxtArea' style='resize:none; max-height:5em; overflow:hidden;'></textarea></td>";
				output += "<td class='replyBtn' style='width:15%;' onclick='replyInsert("+list[i].board_idx+");'><input type='button' value='등록' /></td>";
				output += "</tr></tboby></table>";
				output += "</div>";	//container_outer.
				if(replyList.length > 0){
					output += "<div class='replyDiv'>";
					for(let j = 0; j < replyList.length; j++){
						output += "<table style='margin:0.25em;'><tbody>";
						output += "<tr style='vertical-align:middle;'>";
						if(replyList[j].reply_res_path == null){
							output += "<td rowspan='2' class='replytb' style='width:5%;'><span><img src='/resources/images/default_profile.png' style='width:25px; height:25px;'/></span></td>";
						}else{
							output += "<td rowspan='2' class='replytb' style='width:5%;'><span><img src='"+replyList[j].reply_res_path+"' style='width:25px; height:25px;' /></span></td>";
						}
						output += "<td rowspan='2' class='replytb' style='width:15%;'>"+replyList[j].reply_nick+"</td>";
						output += "<td rowspan='2' class='replytb' style='width:auto;'><span name='replys' id='replyContent_"+replyList[j].reply_idx+"'>"+replyList[j].reply_content+"</span></td>";
						if(replyList[j].reply_uidx == user_idx){
							output += "<td align='center' class='replytb replyModify' name='replyModis' id='replyModify_"+replyList[j].reply_idx+"' style='width:7%;' onclick='replyModify("+replyList[j].reply_idx+");'><span><a>수정</a></span></td>";
							output += "<td align='center' class='replytb replyModifySave' name='replyModiSaves' id='replyModifySave_"+replyList[j].reply_idx+"' style='width:7%; display:none;' onclick='replyModifySave("+replyList[j].reply_idx+");'><span><a>저장</a></span></td>";
							output += "<td align='center' class='replytb replyDelete' name='replyDels' id='replyDelete_"+replyList[j].reply_idx+"' style='width:7%;' onclick='replyDelete("+replyList[j].reply_idx+");'><span><a>삭제</a></span></td>";
							output += "<td align='center' class='replytb replyCancel' name='replyCans' id='replyCancel_"+replyList[j].reply_idx+"' style='width:7%; display:none;' onclick='replyCancel("+replyList[j].reply_idx+");'><span><a>취소</a></span></td>";
						}else{
							output += "<td align='center' class='replytb' name='replyblank' id='replyblank_"+replyList[j].reply_idx+"' style='width:7%;'><span>&nbsp;</span></td>";
							output += "<td align='center' class='replytb' name='replyblank2' id='replyblanks_"+replyList[j].reply_idx+"' style='width:7%;'><span>&nbsp;</span></td>";
						}
						output += "</tr>"
						if(replyList[j].modify_date == null){
							replyList[j].reg_date = replyList[j].reg_date.substring(2, replyList[j].reg_date.lastIndexOf(":"));
							output += "<tr><td class='replytb' colspan='2' align='center' style='background-color:#fafafa;'><span style='font-size:0.75em;'>"+replyList[j].reg_date+"</span></td></tr>";
						}else{
							replyList[j].modify_date = replyList[j].modify_date.substring(2, replyList[j].modify_date.lastIndexOf(":"));
							output += "<tr><td class='replytb' colspan='2' align='center' style='background-color:#fafafa;'><span style='font-size:0.75em;'>"+replyList[j].modify_date+"</span></td></tr>";
						}
						output += "</tbody></table>";
					}
					output += "</div>";
				}else{
					output += "<div><span> * 작성된 댓글이 없습니다. </span></div>";
				}
				output += "</div><br />";
				contentArea.innerHTML += output;
			}
		}
		
		function replyInsert(bidx){
			<c:if test="${empty userBean}">
				alert("로그인이 필요한 서비스입니다.");
				return;
			</c:if>
		}
		
	</script>
</body>
</html>