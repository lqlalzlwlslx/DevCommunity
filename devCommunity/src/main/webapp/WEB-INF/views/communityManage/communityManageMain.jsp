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
	.replyBtn:hover, .replyspan:hover{cursor: pointer !important;}
	.replytb{padding:0; }
	.replyModify:hover, .replyDelete:hover, .replyModifySave:hover, .replyCancel:hover{cursor:pointer;}
	.commUserListImg:hover{
		-webkit-transform:scale(5);
		-moz-transform:scale(5);
		-ms-transform:scale(5);
		-o-transform:scale(5);
		transform:scale(5);
	}
</style>
<script type="text/javascript">
	<c:if test="${empty userBean}">
		location.href="<%=request.getContextPath()%>/";
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
		
		document.querySelector("#proxyManagerBtn").addEventListener("click", function(){
			document.querySelector(".modal-open").style.paddingRight = "0px";
			document.querySelector(".modal-open").style.overflow = "auto";
		});
		
		document.querySelector("#communityRequestListView").addEventListener("click", function(){
			document.querySelector(".modal-open").style.paddingRight = "0px";
			document.querySelector(".modal-open").style.overflow = "auto";
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
						<li id="ucLi"><a href="#" id="ucListView">커뮤니티</a></li>
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
									
								</div>
								<div class="container">
									<header class="major">
										<h2 style="font-size:3.5em;">${comminfo.comm_name}</h2>
									</header>
									<div><span>* 기본정보</span></div>
									<br />
									<table>
										<colgroup>
											<col width="20%">
											<col width="auto">
											<col width="5%">
											<col width="3%">
											<col width="3%">
										</colgroup>
										<tbody>
											<tr>
												<td>커뮤니티명</td>
												<td>${comminfo.comm_name}</td>
												<td></td>
												<td></td>
												<td></td>
											</tr>
											<tr>
												<td>커뮤니티 관리자</td>
												<td>${comminfo.manager_name}</td>
												<td></td>
												<td colspan="2" align="right">
													<span><input type="button" id="proxyManagerBtn" style="background-color:#4acaa8;" data-bs-toggle="modal" data-bs-target="#proxyManagerModal" value="관리자 위임" /></span>
												</td>
											</tr>
											<tr>
												<td>커뮤니티 타입</td>
												<td>${comminfo.comm_type_nm}</td>
												<td></td>
												<td></td>
												<td></td>
											</tr>
											<tr>
												<td>커뮤니티 개설일</td>
												<td>${fn:substring(comminfo.reg_date, 2, 16)}</td>
												<td></td>
												<td></td>
												<td></td>
											</tr>
											<tr>
												<td>커뮤니티 소개글</td>
												<td class="modifyIntro" colspan="2"><span id="commintro_txt"><c:if test="${empty comminfo.comm_intro}"><span> * 소개글을 수정해주세요.</span></c:if><c:if test="${not empty comminfo.comm_intro}">${comminfo.comm_intro}</c:if></span></td>
												<td class="modifyIntro1" align="center" style="display:none;" onclick="modifySave('${comminfo.comm_idx}')"><span><input type="button" style="background-color:#4acaa8;" value="변경" /></span></td>
												<td class="modifyIntro2" align="center" style="display:none;" onclick="modifyCancel('${comminfo.comm_idx}');"><span><input type="button" style="background-color:#4acaa8;" value="취소" /></span></td>
												<td colspan="2" class="modifyIntro4" align="center" onclick="modifyCommunityIntro('${comminfo.comm_idx}');"><span><input type="button" style="background-color:#4acaa8;" value="소개글 수정" /></span></td>
											</tr>
											<tr>
												<td>회원수</td>
												<td>${comminfo.total_member} 명</td>
												<td></td>
												<td colspan="2" align="right"><span><input type="button" style="background-color:#4acaa8;" value="회원관리" /></span></td>
											</tr>
											<tr>
												<td>가입신청</td>
												<td>${comminfo.comm_sign_request} 명</td>
												<td></td>
												<td colspan="2" align="right"><span><input id="communityRequestListView" type="button" style="background-color:#4acaa8;" data-bs-toggle="modal" data-bs-target="#requestUserListModal"value="목록보기" /></span></td>
											</tr>
											<tr>
												<td>게시글 수</td>
												<td>${comminfo.total_board} 개</td>
												<td></td>
												<td></td>
												<td align="right"></td>
											</tr>
										</tbody>
									</table>
								</div>
							</section>
						<!-- <div class="main-content-area">	
							<div class="container container-solid">
								<header class="major">
									<h2>board_title</h2>
								</header>
								<p>board_content</p>
							</div>
						</div> -->
						

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
<!-- 관리자 위임 모달 -->
<div class="modal fade" id="proxyManagerModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="proxyManagerModalLabel">커뮤니티 관리자 위임</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<c:if test="${not empty comminfo.userList}">
					<c:forEach items="${comminfo.userList}" var="commUserList" varStatus="commUserStatus">
						<table style="margin:0.25em;">
							<tbody>
								<tr>
									<td align="center" style="padding:0.1em 0.1em; width:15%;">
										<c:if test="${commUserList.profile_src == null}"><span><img class="commUserListImg" src="/resources/images/default_profile.png" style="width:30px; height:30px;" /></span></c:if>
										<c:if test="${commUserList.profile_src != null}"><span><img class="commUserListImg" src="${commUserList.profile_src}" style="width:30px; height:30px;"/></span></c:if>
									</td>
									<td align="center" style="padding:0.1em 0.1em; width:auto;">${commUserList.nick_name}</td>
									<td align="center" style="padding:0.1em 0.1em; width:20%;" onclick="mandateCommunityManager('${comminfo.comm_idx}', '${commUserList.user_idx}', '${commUserList.nick_name}');"><span><a><input type="button" value="위임" style="background-color:#4acaa8;"/></a></span></td>
								</tr>
							</tbody>
						</table>
					</c:forEach>
				</c:if>
				<c:if test="${empty comminfo.userList}">
					<div><span> * 위임 대상자가 없습니다.</span></div>
				</c:if>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				<!-- <button type="button" class="btn btn-primary">Save changes</button> -->
			</div>
		</div>
	</div>
</div>
<!-- 가입신청자 확인 모달 -->
<div class="modal fade" id="requestUserListModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="requestUserListModalLabel">커뮤니티 가입신청 리스트</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<c:if test="${not empty comminfo.reqUserList}">
				<table style="margin:0.25em;">
				<thead>
					<tr>
						<th style="width:10%;"></th>
						<th align="right" style="width:auto; text-align:center;">닉네임</th>
						<th align="center" style="width:20%; text-align:center;">신청일자</th>
						<th style="width:20%;"></th>
						<th style="width:20%;"></th>
					</tr>
				</thead>
				</table>
					<c:forEach items="${comminfo.reqUserList}" var="commReqList" varStatus="commReqStatus">
						<table style="margin:0.25em;" id="reqUsers_${commReqList.user_idx}" name="reqTables">
							<tbody>
								<tr>
									<td align="center" style="padding:0.1em 0.1em; width:10%;">
										<c:if test="${commReqList.profile_src == null}"><span><img class="commUserListImg" src="/resources/images/default_profile.png" style="width:30px; height:30px;" /></span></c:if>
										<c:if test="${commReqList.profile_src != null}"><span><img class="commUserListImg" src="${commReqList.profile_src}" style="width:30px; height:30px;"/></span></c:if>
									</td>
									<td align="center" style="padding:0.1em 0.1em; width:auto;">${commReqList.nick_name}</td>
									<td align="center" style="padding:0.1em 0.1em; width:20%;">${fn:substring(commReqList.user_comm_req_date, 2, 16)}</td>
									<td align="center" style="padding:0.1em 0.1em; width:20%;" onclick="confirmSignCommunity('${commReqList.user_idx}');"><span><a><input type="button" value="승인" style="background-color:#4acaa8;"/></a></span></td>
									<td align="center" style="padding:0.1em 0.1em; width:20%;" onclick="rejectSignCommunity('${commReqList.user_idx}');"><span><a><input type="button" value="반려" style="background-color:#4acaa8;"/></a></span></td>
								</tr>
							</tbody>
						</table>
					</c:forEach>
				</c:if>
				<c:if test="${empty comminfo.userList}">
					<div><span> * 가입신청 리스트가 없습니다.</span></div>
				</c:if>
			</div>
			<div class="modal-footer">
				<button type="button" id="reqUserListCloseBtn" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
				<!-- <button type="button" class="btn btn-primary">Save changes</button> -->
			</div>
		</div>
	</div>
</div>
			
	<script type="text/javascript">
		function mandateCommunityManager(comm_idx, user_idx, nick){ 
			const manager_idx = "${comminfo.manager_idx}";
			if(confirm(nick +"님에게 커뮤니티 관리자를 위임하시겠습니까?\n\[확인\] 클릭 시 "+nick+"님에게 위임되며\,\n커뮤니티 메인페이지로 이동됩니다.")){
				const mandateData = {
						method: "POST",
						headers: {"Content-Type": "application/json"},
						body: JSON.stringify({comm_idx, manager_idx, user_idx, nick})
				};
				fetch("/community/mandateCommunityManager.do", mandateData)
					.then(res => res.json())
					.then((data) => {
						if(data.result){
							alert(data.msg +"\n커뮤니티 메인페이지로 이동됩니다.");
							moveToCommunityView(data.comm_idx);
						}else{
							alert('오류가 발생했습니다.');
							return;
						}
					});
			}
		}
		
		function moveToCommunityView(value){
			top.location.href="<%=request.getContextPath()%>/user/moveToCommunityView.do?idx="+value;
		}
		
		var introSpan;
		var introTxt;
		function modifyCommunityIntro(comm_idx){
			introSpan = document.getElementById("commintro_txt");
			introTxt = introSpan.innerHTML;
			introSpan.innerHTML = "<textarea id='introModifyTxt' style='resize:none; max-height:5em; max-width:90%; overflow:hidden;'>"+introTxt+"</textarea>";
			
			if(document.querySelector(".modifyIntro1").style.display == "none"){
				document.querySelector(".modifyIntro").setAttribute("colspan", "2");
				document.querySelector(".modifyIntro1").style.display = "";
				document.querySelector(".modifyIntro2").style.display = "";
				document.querySelector(".modifyIntro4").style.display = "none";
			}
		}
		
		function modifyCancel(comm_idx){
			introSpan.innerHTML = introTxt;
			if(document.querySelector(".modifyIntro1").style.display == ""){
				document.querySelector(".modifyIntro1").style.display = "none";
				document.querySelector(".modifyIntro2").style.display = "none";
				document.querySelector(".modifyIntro4").style.display = "";
			}
		}
		
		function modifySave(comm_idx){
			var modiTxt = document.getElementById("introModifyTxt").value;
			const introModifyData = {
					method: "POST",
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({comm_idx, modiTxt})
			};
			
			fetch("/community/updateCommunityIntro.do", introModifyData)
				.then(res => res.json())
				.then((data) => {
					if(data.result){
						alert("성공했습니다.");
						location.reload();
					}
				});
		}
		
		function reqUsersHide(uidx){
			var tid;
			var tables = document.getElementsByName("reqTables");
			for(var i = 0; i < tables.length; i++){
				tid = tables[i].id.substring(tables[i].id.indexOf("_")+1);
				if(uidx == tid){
					tables[i].style.display = "none";
				}
			}
		}
		
		var confirmCidx = "${comminfo.comm_idx}";
		var confirmStatus;
		function confirmSignCommunity(idx){
			/* if(confirm("승인 하시겠습니까?")){
				
			} */
			confirmStatus = "A";
			const confirmSignData = {
					method: "POST",
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({confirmCidx, idx, confirmStatus})
			};
			fetch("/community/communityConfirmSignAsStatus.do", confirmSignData)
				.then(res => res.json())
				.then((data) => {
					if(data.result) {
						alert("성공했습니다.");
						reqUsersHide(data.uidx);
					}
				});
		}
		
		function rejectSignCommunity(idx){
			/* if(confirm("반려 하시겠습니까?")){
				
			} */
			confirmStatus = "D";
			const rejectSignData = {
					method: "POST",
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({confirmCidx, idx, confirmStatus})
			};
			fetch("/community/communityRejectSignAsStatus.do", rejectSignData)
				.then(res => res.json())
				.then((data) => {
					if(data.result){
						alert("성공했습니다.");
						reqUsersHide(data.uidx);
					}
				});
		}
		
	</script>


</body>
</html>