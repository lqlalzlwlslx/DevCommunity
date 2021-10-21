<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<style>
	#loginbtn:hover{pointer-events: none !important;}
	div.image.main{
		background-image: url(../../resources/images/banner.jpg);
		top: 0;
		display:flex;
	}
	span.image.avatar>img{
  		width: 150px;
  		height: 150px;
  		object-fit: cover;
	}
	#ucLi:hover{cursor:pointer; }
	span.image.avatar{width:150px !important;}
	table>tbody>tr>td{vertical-align:middle;}
	table>tbody>tr>td>input[type="button"]:hover{pointer-events: none;}
	input[type="radio"] + label{padding-right:2em !important;}
	.container{padding:0 !important;}
	.container-solid{border-top:solid 6px #f4f4f4;}
	.signUpCommunity:hover{cursor:pointer;}
	.communityList { color: #333; text-decoration: none; display: inline-block; padding: 15px 0; position: relative; }
	.communityList:after { background: none repeat scroll 0 0 transparent; bottom: 0; content: ""; display: block; height: 2px;
		left: 50%; position: absolute; background: #b9f; transition: width 0.3s ease 0s, left 0.3s ease 0s; width: 0;
	}
	.communityList:hover:after { width: 100%; left: 0; }
	.communitySearchTd:hover{cursor:pointer;}
	.communitySearchTd{padding: 0.25em 0.25em;}
	.replyBtn:hover, .replyspan:hover{cursor: pointer !important;}
	.replytb{padding:0; }
	.replyModify:hover, .replyDelete:hover, .replyModifySave:hover, .replyCancel:hover{cursor:pointer;}
</style>
<script type="text/javascript">
	<c:if test="${empty userBean}">
		location.href="<%=request.getContextPath()%>/";
	</c:if>
	
	<c:if test="${not empty COMM_BLOCKED}">
		alert("커뮤니티 관리자에 의해 활동정지 상태입니다.\n메인 화면으로 이동합니다.");
		moveToMain();
	</c:if>
	
	<c:if test="${not empty result}">
		<c:if test="${result == false}">
			<c:if test="${status == 'SESSION_TIMEOUT'}">
				moveToMain();
			</c:if>
			<c:if test="${status == 'PARSING_FAIL'}">
				alert("오류가 발생했습니다. 다시 시도해주세요.");
			</c:if>
		</c:if>
		<c:if test="${result == true}">
			<c:if test="${status == 'DELETE'}">
				alert("성공했습니다.");
				//location.reload();
			</c:if>
		</c:if>
	</c:if>
	var communityPassed = false;
	window.onload = function (){
		const userInfoBtn = document.querySelector("#userMyPage");
		userInfoBtn.addEventListener("click", function (){
			location.href="<%=request.getContextPath()%>/user/userMyPage.do";
		});
		
		const ucView = document.querySelector("#ucListView");
		ucView.addEventListener("click", function(){
			ucListview();
		});
		
		document.querySelector("#communityFrm").addEventListener("click", function(){
			document.getElementById("exampleModal").setAttribute("data-bs-backdrop", "static");
			document.getElementById("exampleModal").setAttribute("data-bs-keyboard", "false");
			document.querySelector("#commBtn").click();
			document.querySelector(".modal-open").style.paddingRight = "0px";
			document.querySelector(".modal-open").style.overflow = "auto";
		});
		
		document.querySelector("#inSearchBtn").addEventListener("click", function(){
			inCommunitySearch();
		});
		
	}		
	
	function ucListview(){
		<c:if test="${not empty ucList}">
			<c:forEach items="${ucList}" var="ucList" varStatus="status">
				if(document.querySelector("#ucList_${ucList.comm_idx}").style.display == "none"){
					document.querySelector("#ucList_${ucList.comm_idx}").style.display = "block";
				}else if(document.querySelector("#ucList_${ucList.comm_idx}").style.display == "block"){
					document.querySelector("#ucList_${ucList.comm_idx}").style.display = "none";
				}
			</c:forEach>
		</c:if>
		<c:if test="${empty ucList}">
			if(document.querySelector("#ucEmpty").style.display == "none"){
				document.querySelector("#ucEmpty").style.display = "inline-block";
			}else if(document.querySelector("#ucEmpty").style.display == "inline-block"){
				document.querySelector("#ucEmpty").style.display = "none";
			}
		</c:if>
	}
	function dupleCheckCommunity(){ //커뮤니티 이름 중복 체크.
		
		const name = document.querySelector("#communityNameValue").value;
		if(!name) { alert("커뮤니티 이름을 입력해주세요."); document.querySelector("#communityNameValue").focus(); return;}
		
		fetch("/community/nameDupleCheck.do?name="+name)
			.then(res => res.json())
			.then((data) => {
				if(data.result == true) { alert(data.msg); communityPassed = true;}
				else { alert(data.msg); document.querySelector("#communityNameValue").focus(); return; }
			});
	}

	function modalClosed(){ //창 닫을 때 value 초기화.
			document.querySelector("#communityNameValue").value = "";
			document.querySelector("#communityRegCont").value = "";
			var categorys = document.getElementsByName("communityCategory");
			for(var i = 0; i < categorys.length; i++){
				if(categorys[i].getAttribute('type') === 'radio'){
					categorys[i].checked = false;
				}
			}
	}
	
	function createCommunity(){
		var comm_name = document.querySelector("#communityNameValue").value;
		fetch("/community/nameDupleCheck.do?name="+comm_name)
			.then(res => res.json())
			.then((data) => {
				if(data.result == false) {
					alert("커뮤니티명을 다시 확인해주세요.");
					document.querySelector("#communityNameValue").focus();
					return;
				}
			});
		var comm_category;
		var categorys = document.getElementsByName("communityCategory");
		for(var i = 0; i < categorys.length; i++){
			if(categorys[i].checked == true) {
				comm_category = categorys[i].value;
				break;
			}
		}
		const comm_reg_cont = document.querySelector("#communityRegCont").value;
		const comm_intro = document.querySelector("#communityIntro").value;
		const communityData = {
				method: "POST",
				headers: {"Content-Type": "application/json"},
				body: JSON.stringify({comm_name, comm_category, comm_reg_cont, comm_intro})
		};
		
		fetch("/community/insertCommunity", communityData)
			.then(res => res.json())
			.then((data) => {
				//console.log(data);
				if(data.result == true){
					alert(data.msg);
					document.querySelector("#modalCancelBtn").click();
				}else{
					alert(data.msg);
					return;
				}
			});
		
	}
	
</script>
</head>
<body>
	<!-- Header -->
			<section id="header">
				<header>
					<c:if test="${ not empty userBean }">
						<c:if test="${empty userBean.profile_src}">
						<span class="image avatar"><img src="/resources/images/default_profile.png" alt="" /></span>
						</c:if>
						<c:if test="${not empty userBean.profile_src }">
						<span class="image avatar"><img src="${contextPath}${userBean.profile_src}" alt="" /></span>
						</c:if>
					<h1 id="logo"><span id="loginbtn">${userBean.nick_name} 님</span></h1><br />
					<div style="display:flex;" align="center">
					<p></p>
						<!-- <div style="width:35%;" align="right"><a href="#" onclick="signUp();">회원가입</a></div>
						<div style="width:2%;"></div>
						<div style="width:60%;"><a href="#">아이디/비밀번호 찾기</a></div> -->
					</div>
					</c:if>
				</header>
				<c:if test="${not empty userBean }">
				<nav id="nav">
					<ul>
						<li onclick="moveToMain();"><a href="#">메인페이지 이동</a></li>
						<li><a href="#" id="userMyPage">마이페이지</a></li>
						<li id="ucLi"><a id="ucListView">커뮤니티</a></li>
						<c:if test="${empty ucList}">
						<li id="ucEmpty"style="display:none;"><a>현재 가입된 커뮤니티가 없습니다.</a></li>
						</c:if>
						<c:if test="${not empty ucList}">
						<c:forEach items="${ucList}" var="ucList" varStatus="status">
						<li id="ucList_${ucList.comm_idx}" onclick="moveToCommunityView(${ucList.comm_idx})" class="communityList" style="display:none; cursor:pointer;"><a>${ucList.comm_name}</a></li>
						</c:forEach>
						</c:if>
						<li id="communityFrm"><a href="#">커뮤니티 개설</a></li>
						<li style="display:none;"><!-- <button id="commBtn" data-toggle="modal" data-target="#myModal"></button> -->
						<button type="button" id="commBtn" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal"></button></li>
						<li><a href="#" onclick="logout();">로그아웃</a></li>
					</ul>
				</nav>
				</c:if>
				<!-- 
				<footer>
					<ul class="icons">
						<li><a href="#" class="icon brands fa-twitter"><span class="label">Twitter</span></a></li>
						<li><a href="#" class="icon brands fa-facebook-f"><span class="label">Facebook</span></a></li>
						<li><a href="#" class="icon brands fa-instagram"><span class="label">Instagram</span></a></li>
						<li><a href="#" class="icon brands fa-github"><span class="label">Github</span></a></li>
						<li><a href="#" class="icon solid fa-envelope"><span class="label">Email</span></a></li>
					</ul>
				</footer>
				 -->
			</section>

		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Main -->
					<div id="main">

						<!-- One -->
							<section id="one">
								<div class="image main" data-position="center">
									<!-- <img src="/resources/images/banner.jpg" alt="" /> -->
									<div style="width:10%;"></div>
									<!-- <c:if test="${not empty ucList}">
									<div style="width:20%; margin:auto;">
									<select id="searchScopeTxt">
											<option value="0">=== 선택 ===</option>
											<c:forEach items="${ucList}" var="ucList" varStatus="status">
												<option value="${ucList.comm_name}">${ucList.comm_name}</option>
											</c:forEach>
										</select>
									</div>
									</c:if> -->
									<div style="width:2%;"></div>
									<div style="width:20%; margin:auto;">
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
										<input type="button" id="searchBtn" onclick="searchCondition();" value="검색" />
									</div>
								</div>
								<div class="container">
									<header class="major">
										<c:if test="${not empty commInfo}">
											<div style="display:flex;">
											<div style="width:90%;"><h2 style="margin: 0; font-size:3.5em;">${commInfo.comm_name}</h2></div>
											<div align="right" style="padding-top: 1em;"><c:if test="${commInfo.manager_idx == userBean.user_idx}"><span style="float:right;" onclick="communityManagerSettings('${commInfo.comm_idx}');"><input type="button" value="커뮤니티 관리" style="background-color:#4acaa8;"/></span></c:if></div>
											</div>
											<table>
												<tbody>
													<tr>
														<td class="communitySearchTd">
															<select id="inCommunity_searchTxt">
																<option value="0">=== 선택 ===</option>
																<option value="inCommunity_content">내용</option>
																<option value="inCommunity_title">제목</option>
																<option value="inCommunity_writer">작성자</option>
															</select>
														</td>
														<td class="communitySearchTd">
															<input type="text" id="inCommunity_SearchInputTxt" onKeyPress="if(event.keyCode==13) inCommunitySearch();"/>
														</td>
														<td class="communitySearchTd" id="inSearchBtn">
															<input type="button" value="검색" />
														</td>
														<td class="communitySearchTd">
															<span style="float: right;" onclick="moveToMain();"><a href="#">메인페이지로 이동</a></span><br />
															<span style="float: right;" onclick="communityBoardWrite();"><a href="#">글쓰기</a></span>
															<span style="display:none;"><button type="button" id="boardModalBtn" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#boardModal"></button></span>
														</td>
													</tr>
												</tbody>
											</table>
											
											
										</c:if>
										<c:if test="${empty commInfo}"><h2>잉여잉여잉여잉여</h2></c:if>
									</header>	
								</div>
							</section>
							
							<c:if test="${not empty cbList}">
								<c:forEach items="${cbList}" var="cbList" varStatus="status">
									<div class="main-content-area">	
										<div class="container container-solid">
											<div class='content_inner' style='display:flex;'>	
												<div style="width:23em;">
													<header class="major">
														<h2>${cbList.board_title}</h2>
													</header>
												</div>
												<div style="width:22em;">
													<span style="float:right;">작성일 &nbsp;&nbsp;${cbList.reg_date}<br />작성자 &nbsp;&nbsp;${cbList.writer_nick}
														<c:if test="${cbList.board_uidx == userBean.user_idx}">
														<span onclick="modifyBoard(${cbList.board_idx})"><a href="#">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;수정</a></span>
														<span onclick="deleteBoard(${cbList.board_idx})"><a href="#">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;삭제</a></span>
														</c:if>
													</span>
												</div>
											</div>
											<div class='content-area'><p>${cbList.board_content}</p></div>
											<div class='container_outer'>
												<table><tbody><tr>
												<td style='width:12%;'>댓글작성</td>
												<td><textarea id="textArea_${cbList.board_idx}" name='replyTxtArea' style='resize:none; max-height:5em; overflow:hidden;'></textarea></td>
												<td class='replyBtn' style='width:15%;'><input type='button' value='등록' onclick='replyInsert("${cbList.board_idx}");'/></td>
												</tr></tbody></table>
											</div>
											<c:if test="${not empty cbList.replyList}">
												<c:forEach items="${cbList.replyList}" var="cbReplyList" varStatus="replyStatus">
													<div class='replyDiv'>
														<table style="margin:0.25em;">
															<tbody>
																<tr style='vertical-align:middle;'>
																	<c:if test="${empty cbReplyList.reply_res_path}">
																		<td rowspan="2" class='replytb' style='width:5%;'><span><img src="/resources/images/default_profile.png" style="width:25px; height:25px;" /></span></td>
																	</c:if>
																	<c:if test="${not empty cbReplyList.reply_res_path}">
																		<td rowspan="2" class='replytb' style='width:5%;'><span><img src="${cbReplyList.reply_res_path}" style="width:25px; height:25px;" /></span></td>
																	</c:if>
																	<td rowspan="2" class='replytb' style="width:15%;">${cbReplyList.reply_nick}</td>
																	<td rowspan="2" class='replytb' style="width:auto;"><span name='replys' id='replyContent_${cbReplyList.reply_idx}'>${cbReplyList.reply_content}</span></td>
																	<c:if test="${cbReplyList.reply_uidx == userBean.user_idx}">
																		<td align="center" class="replytb replyModify" name="replyModis" id="replyModify_${cbReplyList.reply_idx}" style="width:7%;" onclick="replyModify('${cbReplyList.reply_idx}');"><span><a>수정</a></span></td>
																		<td align="center" class="replytb replyModifySave" name="replyModiSaves" id="replyModifySave_${cbReplyList.reply_idx}" style="width:7%; display:none;" onclick="replyModifySave('${cbReplyList.reply_idx}');"><span><a>저장</a></span></td>
																		<td align="center" class="replytb replyDelete" name="replyDels" id="replyDelete_${cbReplyList.reply_idx}" style="width:7%;" onclick="replyDelete('${cbReplyList.reply_idx}');"><span><a>삭제</a></span></td>
																		<td align="center" class="replytb replyCancel" name="replyCans" id="replyCancel_${cbReplyList.reply_idx}" style="width:7%; display:none;" onclick="replyCancel('${cbReplyList.reply_idx}');"><span><a>취소</a></span></td>
																	</c:if>
																	<c:if test="${cbReplyList.reply_uidx != userBean.user_idx}">
																		<td colspan="2" align="center" class="replytb" style="width:7%;">&nbsp;</td>
																		<td colspan="2" align="center" class="replytb" style="width:7%;">&nbsp;</td>
																	</c:if>
																</tr>
																<tr>
																	<td colspan="4" align="center" class="replytb" style="background-color:#fafafa;">
																		<c:if test="${cbReplyList.modify_date == null}"><span style="font-size:0.75em;">${fn:substring(cbReplyList.reg_date, 2, 16)}</span></c:if>
																		<c:if test="${cbReplyList.modify_date != null}"><span style="font-size:0.75em;">${fn:substring(cbReplyList.modify_date, 2, 16)}</span></c:if>
																	</td>
																</tr>
															</tbody>
														</table>
													</div>
												</c:forEach>
											</c:if>
											<c:if test="${empty cbList.replyList}">
												<div><span> * 작성된 댓글이 없습니다. </span></div>
											</c:if>
										</div><br />
									</div>
								</c:forEach>
							</c:if>
							<c:if test="${empty cbList}">
							<div class="main-content-area2">	
								<div class="container container-solid">
									<header class="major">
										<h2>등록된 게시글이 없습니다.</h2>
									</header>
								</div>
							</div>
							</c:if>
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


<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">커뮤니티 개설</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="modalClosed();"></button>
			</div>
			<div class="modal-body">
				<table style="border:1px;">
					<colgroup>
						<col width="15%">
						<col width="5%">
						<col width="50%">
						<col width="5%">
						<col width="30%">
					</colgroup>
					<thead>
						<tr>
							<th></th>
							<th></th>
							<th></th>
							<th></th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="button" value="커뮤니티 이름" /></td>
							<td></td>
							<td><input type="text" id="communityNameValue" placeholder="커뮤니티 이름을 입력하세요." /></td>
							<td></td>
							<td style="cursor:pointer;" onclick="dupleCheckCommunity();"><input type="button" value="중복체크" style="width:70%;"/></td>
						</tr>
						<tr>
							<td><input type="button" value="카테고리 선택" /></td>
							<td></td>
							<td colspan="3">
								<input type="radio" id="categoryJava" name="communityCategory" value="J"/><label for="categoryJava">Java</label>
								<input type="radio" id="categoryC" name="communityCategory" value="C"/><label for="categoryC">C</label>
								<input type="radio" id="categoryPython" name="communityCategory" value="P"/><label for="categoryPython">Python</label>
								<input type="radio" id="categoryDatabase" name="communityCategory" value="D"/><label for="categoryDatabase">Database</label>
							</td>
						</tr>
						<tr>
							<td><input type="button" value="커뮤니티 개설사유" /></td>
							<td></td>
							<td colspan="3"><textarea style="resize: none;" rows="2" id="communityRegCont" placeholder="사유를 입력해주세요."></textarea></td>
						</tr>
						<tr>
							<td><input type="button" value="커뮤니티 소개글" /></td>
							<td></td>
							<td colspan="3"><textarea style="resize: none;" rows="2" id="communityIntro" placeholder="소개글을 작성해주세요.&#10;소개글은 커뮤니티 조회 시 노출됩니다."></textarea></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" id="modalCancelBtn" class="btn btn-secondary" data-bs-dismiss="modal" onclick="modalClosed();">취소</button>
				<button type="button" class="btn btn-primary" onclick="createCommunity();">개설 신청</button>
			</div>
		</div>
	</div>
</div>

	<script type="text/javascript">
		function uSearch(list){
			var contentArea = document.querySelector(".main-content-area");
			contentArea.innerHTML = "";
			var output;
			var reqDate;
			var ucIdxs = "";
			<c:if test="${not empty ucList}">
			<c:forEach items="${ucList}" var="ucLists" varStatus="status">
				if(ucIdxs.trim() == "") {}
				else {ucIdxs += ",";}
				ucIdxs += "${ucLists.comm_idx}";
			</c:forEach>
			</c:if>
			for(var i = 0; i < list.length; i++){
				reqDate = list[i].reg_date.split(" ")[0];
				output = "";
				output += "<div class='container container-solid'>";
				output += "<header class='major'>";
				output += "<span style='color:#4acaa8; font-size:3em; line-height:1.5em;'>"+list[i].comm_name+"</span>";
				if(ucIdxs.indexOf(list[i].comm_idx) > -1){
					output += "";
				}else if(list[i].comm_user_stat_cd == "R"){
					output += "<span style='float:right; margin-top:2.5em;'>승인 대기 중</span>";
				}else{
					output += "<span class='signUpCommunity' onclick='signUpCommunity("+list[i].comm_idx+");' style='float:right; margin-top:2.5em;'>커뮤니티 가입신청</span>";
				}
				output += "</header><br />";
				output += "<table><tbody>"
				output += "<tr><td>커뮤니티 관리자</td><td>"+list[i].manager_name+"</td>";
				output += "<td>개설일</td><td>"+reqDate+"</td>";
				output += "<td>회원수</td><td>"+list[i].total_member+" 명</td></tr>";
				output += "<tr><td>소개글</td><td colspan='3'>"+list[i].comm_intro+"</td><td>게시글 수</td><td>"+list[i].total_board+" 개</td></tr>";
				output += "</tbody></table>";
				output += "</div>";
				contentArea.innerHTML += output;
			}
			
		}
		
		function moveToCommunityView(value){
			top.location.href="<%=request.getContextPath()%>/user/moveToCommunityView.do?idx="+value;
		}
		
		function communityBoardWrite(){
			location.href="<%=request.getContextPath()%>/user/communityBoard.do?cidx="+${commInfo.comm_idx};
		}
		
		let boardFlag;
		function modifyBoard(idx){
			boardFlag = "modify";
			enterFlag = "cm";
			location.href="<%=request.getContextPath()%>/board/userBoardModify.do?flag="+boardFlag+"&enterFlag="+enterFlag+"&idx="+idx;
		}
		
		function deleteBoard(idx){
			if(confirm("게시글을 삭제하시겠습니까?")){
				boardFlag = "delete";
				const boardDelData = {
						method: "POST",
						headers: {"Content-Type": "application/json"},
						body: JSON.stringify({idx, boardFlag})
				};
				fetch("/board/userBoardDelete.do",boardDelData)
					.then(res => res.json())
					.then((data) => {
						if(data.result){
							alert("성공했습니다.");
							location.reload();
						}else{
							alert("실패했습니다.");
						}
					});
			}
		}
		
		function replyInsert(bidx){
			var txtAreas = document.getElementsByName("replyTxtArea");
			var replyContent;
			var tmp;
			for(var i = 0; i < txtAreas.length; i++){
				tmp = txtAreas[i].id.substring(txtAreas[i].id.indexOf("_")+1);
				if(bidx == tmp){
					replyContent = txtAreas[i].value;
					break;
				}
			}
			const replyInsertData = {
					method: "POST",
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({bidx, replyContent})
			};
			
			fetch("/board/reply/insertCommunityBoardReply.do", replyInsertData)
				.then(res => res.json())
				.then((data) => {
					if(data.result){
						location.reload();
					}else{
						alert(data.msg);
					}
				});
		}
		
		var retmp;
		var value;
		var replys;
		var modiBtns;
		var modiSaveBtns;
		var delBtns;
		var canBtns;
		var modiTxtAreas;
		function replyModify(idx){
			replys = document.getElementsByName("replys");
			modiBtns = document.getElementsByName("replyModis");
			modiSaveBtns = document.getElementsByName("replyModiSaves");
			delBtns = document.getElementsByName("replyDels");
			canBtns = document.getElementsByName("replyCans");
			for(var i = 0; i < replys.length; i++){
				retmp = replys[i].id.substring(replys[i].id.indexOf("_")+1);
				if(idx == retmp){
					value = replys[i].innerHTML;
					replys[i].innerHTML = "<textarea id='replyModifyTxtArea_"+idx+"' name='replyModifyTxtAreas' style='resize:none; max-height:5em; max-width:90%; overflow:hidden;'>"+value+"</textarea>";
					modiBtns[i].style.display = "none";
					modiSaveBtns[i].style.display = "";
					delBtns[i].style.display = "none";
					canBtns[i].style.display = "";
					break;
				}
			}
		}
		
		function replyModifySave(idx){
			let replyModifyContent;
			modiTxtAreas = document.getElementsByName("replyModifyTxtAreas");
			for(var i = 0; i < modiTxtAreas.length; i++){
				retmp = modiTxtAreas[i].id.substring(modiTxtAreas[i].id.indexOf("_")+1);
				if(idx == retmp){
					replyModifyContent = modiTxtAreas[i].value;
				}
			}
			const replyModifyData = {
					method: "POST",
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({idx, replyModifyContent})
			};
			
			fetch("/board/reply/updateCommunityBoardReplyContent.do", replyModifyData)
				.then(res => res.json())
				.then((data) => {
					if(data.result){
						location.reload();
					}else{
						alert("실패했습니다.");
					}
				});
		}
		
		function replyCancel(idx){
			replys = document.getElementsByName("replys");
			modiBtns = document.getElementsByName("replyModis");
			modiSaveBtns = document.getElementsByName("replyModiSaves");
			delBtns = document.getElementsByName("replyDels");
			canBtns = document.getElementsByName("replyCans");
			for(var i = 0; i < replys.length; i++){
				retmp = replys[i].id.substring(replys[i].id.indexOf("_")+1);
				if(idx == retmp){
					value = replys[i].innerHTML;
					if(value.indexOf("<textarea") > -1){
						value = value.substring(value.indexOf(">")+1, value.indexOf("</textarea>"));
					}
					replys[i].innerHTML = value;
					modiBtns[i].style.display = "";
					modiSaveBtns[i].style.display = "none";
					delBtns[i].style.display = "";
					canBtns[i].style.display = "none";
					break;
				}
			}
		}
		
		function replyDelete(idx){
			if(confirm("삭제하시겠습니까?")){
				const replyDelData = {
						method: "POST",
						headers: {"Content-Type": "application/json"},
						body: JSON.stringify({idx})
				};
				
				fetch("/board/reply/deleteCommunityBoardReply.do",replyDelData)
					.then(res => res.json())
					.then((data) => {
						if(data.result == true){
							location.reload();
						}else{
							alert("실패했습니다.");
						}
					});
			}
		}
		
		function inCommunitySearch(){
			const insBox = document.querySelector("#inCommunity_searchTxt");
			const inCondition = insBox.options[insBox.selectedIndex].value;
			const inSearchValue = document.querySelector("#inCommunity_SearchInputTxt").value;
			
			if(inCondition == "0"){ alert("검색할 항목을 선택해주세요."); return; }
			if(!inSearchValue) { alert("검색할 단어를 입력해주세요."); return; }
			
			/* fetch("/community/communityBoardSearchAsValues.do?condition="+inCondition+"&searchValue="+inSearchValue+"&cidx="+${commInfo.comm_idx})
				.then(res => res.json())
				.then(data => drawCommunityBoardSearchResult(data)); */
			location.href="<%=request.getContextPath()%>/community/communityBoardSearchAsValues.do?condition="+inCondition+"&searchValue="+inSearchValue+"&cidx="+${commInfo.comm_idx};
		}
		
		function communityManagerSettings(idx){
			location.href="<%=request.getContextPath()%>/community/communityManagerSettingsView.do?idx="+idx;
		}
	</script>


</body>
</html>