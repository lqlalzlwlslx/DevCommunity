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
	.ablist_titles:hover, .ablist_black:hover, .ablist_delete:hover, .ablist_active:hover, .bblist_titles:hover, .bblist_black:hover, .ablist_replytotal:hover, .bblist_replytotal:hover{cursor:pointer;}
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
		
		document.querySelector("#reqUserListCloseBtn").addEventListener("click", function(){
			location.reload();
		});
		
		document.querySelector("#communityMemberManage").addEventListener("click", function(){
			document.querySelector(".modal-open").style.paddingRight = "0px";
			document.querySelector(".modal-open").style.overflow = "auto";
		});
		
		document.querySelector("#communityBlackManage").addEventListener("click", function(){
			document.querySelector(".modal-open").style.paddingRight = "0px";
			document.querySelector(".modal-open").style.overflow = "auto";
		});
		
		document.querySelector("#communityActiveBoardview").addEventListener("click", function(){
			document.querySelector(".modal-open").style.paddingRight = "0px";
			document.querySelector(".modal-open").style.overflow = "auto";
		});
		
		document.querySelector("#communityBlackBoardview").addEventListener("click", function(){
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
	function dupleCheckCommunity(){ //???????????? ?????? ?????? ??????.
		
		const name = document.querySelector("#communityNameValue").value;
		if(!name) { alert("???????????? ????????? ??????????????????."); document.querySelector("#communityNameValue").focus(); return;}
		
		fetch("/community/nameDupleCheck.do?name="+name)
			.then(res => res.json())
			.then((data) => {
				if(data.result == true) { alert(data.msg); communityPassed = true;}
				else { alert(data.msg); document.querySelector("#communityNameValue").focus(); return; }
			});
	}

	function modalClosed(){ //??? ?????? ??? value ?????????.
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
					alert("?????????????????? ?????? ??????????????????.");
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
					<h1 id="logo"><span id="loginbtn">${userBean.nick_name} ???</span></h1><br />
					<div style="display:flex;" align="center">
					<p></p>
						<!-- <div style="width:35%;" align="right"><a href="#" onclick="signUp();">????????????</a></div>
						<div style="width:2%;"></div>
						<div style="width:60%;"><a href="#">?????????/???????????? ??????</a></div> -->
					</div>
					</c:if>
				</header>
				<c:if test="${not empty userBean }">
				<nav id="nav">
					<ul>
						<li onclick="moveToMain();"><a href="#">??????????????? ??????</a></li>
						<li onclick="moveToFaQ();" style="cursor:pointer;"><a> 1:1 ???????????? </a></li>
						<li><a href="#" id="userMyPage">???????????????</a></li>
						<li style="cursor:pointer;" onclick="allCommunityView();"><a>?????? ???????????? ??????</a></li>
						<li id="ucLi"><a id="ucListView">????????????</a></li>
						<c:if test="${empty ucList}">
						<li id="ucEmpty"style="display:none;"><a>????????? ??????????????? ????????????.</a></li>
						</c:if>
						<c:if test="${not empty ucList}">
						<c:forEach items="${ucList}" var="ucList" varStatus="status">
						<li id="ucList_${ucList.comm_idx}" onclick="moveToCommunityView(${ucList.comm_idx})" class="communityList" style="display:none; cursor:pointer;"><a>${ucList.comm_name}</a></li>
						</c:forEach>
						</c:if>
						<li id="communityFrm"><a href="#">???????????? ??????</a></li>
						<li style="display:none;"><!-- <button id="commBtn" data-toggle="modal" data-target="#myModal"></button> -->
						<button type="button" id="commBtn" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal"></button></li>
						<li><a href="#" onclick="logout();">????????????</a></li>
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
									<div style="padding-bottom:1em;">
										<span>* ????????????</span>
										<c:if test="${empty closureinfo}">
										<span id="closureCommuntiyArea" style="float:right; cursor:pointer; font-size:1.25em;" onclick="closureCommunity('${comminfo.comm_idx}', '${comminfo.comm_name}');"><a>???????????? ????????????</a></span>
										<!-- <span id="closureCommunityCancelArea" style="float:right; display:none; cursor:pointer; font-size:1.25em;" onclick="closureCommunityCancel('${comminfo.comm_idx}');"><a>???????????? ??????</a></span> -->
										</c:if>
										<c:if test="${not empty closureinfo}">
										<span style="float:right;">* ${closureinfo.remaining_period}??? ??? ??????????????? ???????????????.</span><br />
										<span id="closureCommunityCancelArea" style="float:right; cursor:pointer; font-size:1.25em;" onclick="closureCommunityCancel('${comminfo.comm_idx}');">
										<a>???????????? ??????</a>
										</span>
										</c:if>
									</div>
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
												<td>???????????????</td>
												<td>${comminfo.comm_name}</td>
												<td></td>
												<td></td>
												<td></td>
											</tr>
											<tr>
												<td>???????????? ?????????</td>
												<td>${comminfo.manager_name}</td>
												<td></td>
												<td colspan="2" align="right">
													<span><input type="button" id="proxyManagerBtn" style="background-color:#4acaa8;" data-bs-toggle="modal" data-bs-target="#proxyManagerModal" value="????????? ??????" /></span>
												</td>
											</tr>
											<tr>
												<td>???????????? ??????</td>
												<td>${comminfo.comm_type_nm}</td>
												<td></td>
												<td></td>
												<td></td>
											</tr>
											<tr>
												<td>???????????? ?????????</td>
												<td>${fn:substring(comminfo.reg_date, 2, 16)}</td>
												<td></td>
												<td></td>
												<td></td>
											</tr>
											<tr>
												<td>???????????? ?????????</td>
												<td class="modifyIntro" colspan="2"><span id="commintro_txt"><c:if test="${empty comminfo.comm_intro}"> * ???????????? ??????????????????.</c:if><c:if test="${not empty comminfo.comm_intro}">${comminfo.comm_intro}</c:if></span></td>
												<td class="modifyIntro1" align="center" style="display:none;" onclick="modifySave('${comminfo.comm_idx}')"><span><input type="button" style="background-color:#4acaa8;" value="??????" /></span></td>
												<td class="modifyIntro2" align="center" style="display:none;" onclick="modifyCancel('${comminfo.comm_idx}');"><span><input type="button" style="background-color:#4acaa8;" value="??????" /></span></td>
												<td colspan="2" class="modifyIntro4" align="center" onclick="modifyCommunityIntro('${comminfo.comm_idx}');"><span><input type="button" style="background-color:#4acaa8;" value="????????? ??????" /></span></td>
											</tr>
											<tr>
												<td>?????????</td>
												<td id="commUserTotal">${comminfo.total_member} ???</td>
												<td></td>
												<td colspan="2" align="right" id="communityMemberManage"><span><input type="button" style="background-color:#4acaa8;" data-bs-toggle="modal" data-bs-target="#communityMemberManageModal" value="????????????" /></span></td>
											</tr>
											<tr>
												<td>????????????</td>
												<td>${comminfo.total_black} ???</td>
												<td></td>
												<td colspan="2" align="right" id="communityBlackManage"><span><input type="button" style="background-color:#4acaa8;" data-bs-toggle="modal" data-bs-target="#communityBlackManageModal" value="??????????????????" /></span></td>
											</tr>
											<tr>
												<td>????????????</td>
												<td id="commRequestCount">${comminfo.comm_sign_request} ???</td>
												<td></td>
												<td colspan="2" align="right"><span><input id="communityRequestListView" type="button" style="background-color:#4acaa8;" data-bs-toggle="modal" data-bs-target="#requestUserListModal" value="????????????" /></span></td>
											</tr>
											<tr>
												<td>????????? ???</td>
												<td>${comminfo.total_board} ???</td>
												<td></td>
												<td colspan="2" align="right"><span><input id="communityActiveBoardview" type="button" style="background-color:#4acaa8;" data-bs-toggle="modal" data-bs-target="#activeBoardListModal" value="???????????????" /></span></td>
											</tr>
											<tr>
												<td>??????????????? ???</td>
												<td>${comminfo.total_black_board} ???</td>
												<td></td>
												<td colspan="2" align="right"><span><input id="communityBlackBoardview" type="button" style="background-color:#4acaa8;" data-bs-toggle="modal" data-bs-target="#blackBoardListModal" value="???????????????" /></span></td>
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
							<li>&copy;2021 DevCommunity.</li>
						</ul>
					</div>
				</section>
			</div>




<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">???????????? ??????</h5>
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
							<td><input type="button" value="???????????? ??????" /></td>
							<td></td>
							<td><input type="text" id="communityNameValue" placeholder="???????????? ????????? ???????????????." /></td>
							<td></td>
							<td style="cursor:pointer;" onclick="dupleCheckCommunity();"><input type="button" value="????????????" style="width:70%;"/></td>
						</tr>
						<tr>
							<td><input type="button" value="???????????? ??????" /></td>
							<td></td>
							<td colspan="3">
								<input type="radio" id="categoryJava" name="communityCategory" value="J"/><label for="categoryJava">Java</label>
								<input type="radio" id="categoryC" name="communityCategory" value="C"/><label for="categoryC">C</label>
								<input type="radio" id="categoryPython" name="communityCategory" value="P"/><label for="categoryPython">Python</label>
								<input type="radio" id="categoryDatabase" name="communityCategory" value="D"/><label for="categoryDatabase">Database</label>
							</td>
						</tr>
						<tr>
							<td><input type="button" value="???????????? ????????????" /></td>
							<td></td>
							<td colspan="3"><textarea style="resize: none;" rows="2" id="communityRegCont" placeholder="????????? ??????????????????."></textarea></td>
						</tr>
						<tr>
							<td><input type="button" value="???????????? ?????????" /></td>
							<td></td>
							<td colspan="3"><textarea style="resize: none;" rows="2" id="communityIntro" placeholder="???????????? ??????????????????.&#10;???????????? ???????????? ?????? ??? ???????????????."></textarea></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" id="modalCancelBtn" class="btn btn-secondary" data-bs-dismiss="modal" onclick="modalClosed();">??????</button>
				<button type="button" class="btn btn-primary" onclick="createCommunity();">?????? ??????</button>
			</div>
		</div>
	</div>
</div>
<!-- ????????? ?????? ?????? -->
<div class="modal fade" id="proxyManagerModal" tabindex="-1" aria-labelledby="proxyManagerModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="proxyManagerModalLabel">???????????? ????????? ??????</h5>
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
									<td align="center" style="padding:0.1em 0.1em; width:20%;" onclick="mandateCommunityManager('${comminfo.comm_idx}', '${commUserList.user_idx}', '${commUserList.nick_name}');"><span><a><input type="button" value="??????" style="background-color:#4acaa8;"/></a></span></td>
								</tr>
							</tbody>
						</table>
					</c:forEach>
				</c:if>
				<c:if test="${empty comminfo.userList}">
					<div><span> * ?????? ???????????? ????????????.</span></div>
				</c:if>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">??????</button>
				<!-- <button type="button" class="btn btn-primary">Save changes</button> -->
			</div>
		</div>
	</div>
</div>
<!-- ??????????????? ?????? ?????? -->
<div class="modal fade" id="requestUserListModal" tabindex="-1" aria-labelledby="requestUserListModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="requestUserListModalLabel">???????????? ???????????? ?????????</h5>
				<!-- <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button> -->
			</div>
			<div class="modal-body">
				<c:if test="${not empty comminfo.reqUserList}">
				<table style="margin:0.25em;">
				<thead>
					<tr>
						<th style="width:10%;"></th>
						<th align="right" style="width:auto; text-align:center;">?????????</th>
						<th align="center" style="width:20%; text-align:center;">????????????</th>
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
									<td align="center" style="padding:0.1em 0.1em; width:20%;" onclick="confirmSignCommunity('${commReqList.user_idx}');"><span><a><input type="button" value="??????" style="background-color:#4acaa8;"/></a></span></td>
									<td align="center" style="padding:0.1em 0.1em; width:20%;" onclick="rejectSignCommunity('${commReqList.user_idx}');"><span><a><input type="button" value="??????" style="background-color:#4acaa8;"/></a></span></td>
								</tr>
							</tbody>
						</table>
					</c:forEach>
				</c:if>
				<c:if test="${empty comminfo.userList}">
					<div><span> * ???????????? ???????????? ????????????.</span></div>
				</c:if>
			</div>
			<div class="modal-footer">
				<button type="button" id="reqUserListCloseBtn" class="btn btn-secondary" data-bs-dismiss="modal" onclick="ManageModalClose();">??????</button>
				<!-- <button type="button" class="btn btn-primary">Save changes</button> -->
			</div>
		</div>
	</div>
</div>
<!-- ???????????? ?????? ?????? -->
<div class="modal fade" id="communityMemberManageModal" tabindex="-1" aria-labelledby="communityMemberManageLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
	<div class="modal-dialog modal-xl">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="communityMemberManageLabel">?????? ??????</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="memberManageClose();"></button>
			</div>
			<div class="modal-body">
				<c:if test="${not empty cmUserList}">
				<table style="margin:0.25em;">
					<thead>
						<tr>
							<th style="text-align:center; width:7%;">?????????</th>
							<th style="text-align:center; width:15%;">?????????</th>
							<th style="text-align:center; width:10%;">??????</th>
							<th style="text-align:center; width:20%;">?????????</th>
							<th style="text-align:center; width:20%;">?????? ????????? ??????</th>
							<th style="text-align:center; width:15%;">????????? ???</th>
							<th style="text-align:center; width:10%;">&nbsp;</th>
						</tr>
					</thead>
				</table>
					<c:forEach items="${cmUserList}" var="manageUsers" varStatus="manageUserStatus">
						<table style="margin:0.25em;" id="manageUser_${manageUsers.user_idx}" name="manageUserTables">
							<tbody>
								<tr>
									<td align="center" style="padding:0.1em 0.1em; width:7%;">
										<c:if test="${manageUsers.profile_src == null}"><span><img class="commUserListImg" src="/resources/images/default_profile.png" style="width:30px; height:30px;"/></span></c:if>
										<c:if test="${manageUsers.profile_src != null}"><span><img class="commUserListImg" src="${manageUsers.profile_src}" style="width:30px; height:30px;"/></span></c:if>
									</td>
									<td align="center" style="padding:0.1em 0.1em; width:15%;">${manageUsers.nick_name}</td>
									<td align="center" style="padding:0.1em 0.1em; width:10%;">${manageUsers.user_stat_nm}</td>
									<td align="center" style="padding:0.1em 0.1em; width:20%;">${fn:substring(manageUsers.user_comm_req_date, 2, 16)}</td>
									<td align="center" style="padding:0.1em 0.1em; width:20%;">${fn:substring(manageUsers.user_comm_login_date, 2, 16)}</td>
									<td align="center" style="padding:0.1em 0.1em; width:15%;">${manageUsers.user_comm_board_count} ???</td>
									<td align="center" style="padding:0.1em 0.1em; width:10%;" onclick="cmUsersBlockShow('${manageUsers.user_idx}');"><span><a><input type="button" value="????????????" style="background-color:#4acaa8;"/></a></span></td>
								</tr>
								<tr id="cmUserBlockScope_${manageUsers.user_idx}" name="cmUserBlockScopes" style="display:none;">
									<td colspan="4" align="right">?????? ????????? ??????????????????.</td>
									<td colspan="3">
										<input type="radio" id="${manageUsers.user_idx}_blackScope_7" name="bScopes" value="7"><label for="${manageUsers.user_idx}_blackScope_7">7 ???</label>
										<input type="radio" id="${manageUsers.user_idx}_blackScope_15" name="bScopes" value="15"><label for="${manageUsers.user_idx}_blackScope_15">15 ???</label>
										<input type="radio" id="${manageUsers.user_idx}_blackScope_30" name="bScopes" value="30"><label for="${manageUsers.user_idx}_blackScope_30">30 ???</label>
										<input type="radio" id="${manageUsers.user_idx}_blackScope_999" name="bScopes" value="999"><label for="${manageUsers.user_idx}_blackScope_999">?????????</label>
									</td>
								</tr>
								<tr id="cmUserBlockCont_${manageUsers.user_idx}" name="cmUserBlockConts" style="display:none; background-color:white;">
									<td colspan="4" align="right">?????? ????????? ??????????????????.</td>
									<td colspan="3"><textarea id="blockCont_${manageUsers.user_idx}" name="blockContTxts" style="resize:none;"></textarea></td>
								</tr>
								<tr id="cmUserBlockBtn" name="cmUserBlockBtns" style="display:none;">
									<td colspan="4"></td>
									<td colspan="3" align="right">
										<span onclick="communityUserBlock('${manageUsers.user_idx}');"><a><input type="button" value="????????????" style="background-color:#4acaa8;"/></a></span>&nbsp;&nbsp;&nbsp;&nbsp;
										<span onclick="closureBlock('${manageUsers.user_idx}');"><a><input type="button" value="??????" style="background-color:#4acaa8;"/></a></span>
									</td>
								</tr>
							</tbody>
						</table>
					</c:forEach>
				</c:if>
				<c:if test="${empty cmUserList}">
					<div><span> * ?????? ???????????? ????????????.</span></div>
				</c:if>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="memberManageClose();">??????</button>
				<!-- <button type="button" class="btn btn-primary">Save changes</button> -->
			</div>
		</div>
	</div>
</div>
<!-- ???????????? ?????? ?????? ?????? -->
<div class="modal fade" id="communityBlackManageModal" tabindex="-1" aria-labelledby="communityBlackModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
	<div class="modal-dialog modal-xl">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="communityBlackModalLabel">???????????? ??????</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="ManageModalClose();"></button>
			</div>
			<div class="modal-body">
				<c:if test="${not empty comminfo.blackUserList}">
				<table style="margin:0.25em;">
					<thead>
						<tr>
							<th style="text-align:center; width:7%;">?????????</th>
							<th style="text-align:center; width:15%;">?????????</th>
							<th style="text-align:center; width:10%;">??????</th>
							<th style="text-align:center; width:20%;">????????????</th>
							<th style="text-align:center; width:15%;">?????? ?????????</th>
							<th style="text-align:center; width:15%;">?????? ?????????</th>
							<th style="text-align:center; width:10%;">&nbsp;</th>
						</tr>
					</thead>
				</table>
					<c:forEach items="${comminfo.blackUserList}" var="commBlackList" varStatus="commBlackStatus">
						<table style="margin:0.25em;" id="commBlackLists_${commBlackList.user_idx}" name="commBlackTables">
							<tbody>
								<tr>
									<td align="center" style="padding:0.1em 0.1em; width:7%;">
										<c:if test="${commBlackList.profile_src == null}"><span><img class="commUserListImg" src="/resources/images/default_profile.png" style="width:30px; height:30px;"/></span></c:if>
										<c:if test="${commBlackList.profile_src != null}"><span><img class="commUserListImg" src="${commBlackList.profile_src}" style="width:30px; height:30px;"/></span></c:if>
									</td>
									<td align="center" style="padding:0.1em 0.1em; width:15%;">${commBlackList.nick_name}</td>
									<td align="center" style="padding:0.1em 0.1em; width:10%;">${commBlackList.user_comm_stat_nm}</td>
									<td align="center" style="padding:0.1em 0.1em; width:20%;">${commBlackList.black_cont}</td>
									<td align="center" style="padding:0.1em 0.1em; width:15%;">${fn:substring(commBlackList.black_sdate, 2, 16)}</td>
									<td align="center" style="padding:0.1em 0.1em; width:15%;">${fn:substring(commBlackList.black_edate, 2, 16)}</td>
									<td align="center" style="padding:0.1em 0.1em; width:10%;" onclick="communityBlackUserRelease('${commBlackList.user_idx}');">
										<span><a><input type="button" value="????????????" style="background-color:#4acaa8;"/></a></span>
									</td>
								</tr>
							</tbody>
						</table>
					</c:forEach>
				</c:if>
				<c:if test="${empty comminfo.blackUserList}">
					<div><span> * ?????? ?????? ???????????? ????????????.</span></div>
				</c:if>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="ManageModalClose();">??????</button>
				<!-- <button type="button" class="btn btn-primary">Save changes</button> -->
			</div>
		</div>
	</div>
</div>
<!-- ?????? ????????? -->
<div class="modal fade" id="activeBoardListModal" tabindex="-1" aria-labelledby="activeBoardListModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-xl">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="activeBoardListModalLabel">????????? ??????</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="ablistModalClose();"></button>
			</div>
			<div class="modal-body">
				<c:if test="${not empty comminfo.boardList}">
					<table style="margin:0.25em;">
						<thead>
							<tr>
								<th style="text-align:center; width:5%;">No.</th>
								<th style="text-align:center; width:10%;">?????????</th>
								<th style="text-align:center; width:auto;">??????</th>
								<th style="text-align:center; width:10%;">????????????</th>
								<th style="text-align:center; width:10%;">??????</th>
								<th style="text-align:center; width:12%;">?????????</th>
								<th style="text-align:center; width:8%;">?????????</th>
								<th style="text-align:center; width:7.5%;">&nbsp;</th>
								<!-- <th style="text-align:center; width:7.5%;">&nbsp;</th> -->
							</tr>
						</thead>
					</table>
					<c:forEach items="${comminfo.boardList}" var="ablist" varStatus="abStatus">
						<table style="margin:0.25em;" id="abLists_${ablist.board_idx}" name="ablistTables">
							<tbody>
								<tr>
									<td align="center" style="padding:0.1em 0.1em; width:5%;">${ablist.board_idx}</td>
									<td align="center" style="padding:0.1em 0.1em; width:10%;">${ablist.writer_nick}</td>
									<td class="ablist_titles" style="padding:0.1em 0.1em; width:auto;" onclick="ablistBoardShowContent('${ablist.board_idx}');"><span><a>${ablist.board_title}</a></span></td>
									<td align="center" style="padding:0.1em 0.1em; width:10%;"><c:if test="${ablist.board_scope_nm == 'All'}">??????</c:if><c:if test="${ablist.board_scope_nm == 'Communityonly'}">????????????</c:if></td>
									<td align="center" style="padding:0.1em 0.1em; width:10%;" id="ablistStatus_${ablist.board_idx}" name="ablistStatuss">${ablist.board_stat_nm}</td>
									<td align="center" style="padding:0.1em 0.1em; width:12%;">${fn:substring(ablist.reg_date, 2, 16)}</td>
									<c:if test="${ablist.reply_total > 0}"><td class="ablist_replytotal" align="center" style="padding:0.1em 0.1em; width:8%;" onclick="ablistBoardReplyShow('${ablist.board_idx}');"><span><a>${ablist.reply_total} ???</a></span></td></c:if>
									<c:if test="${ablist.reply_total == 0}"><td align="center" style="padding:0.1em 0.1em; width:8%;">${ablist.reply_total} ???</td></c:if>
									<td class="ablist_black" align="center" style="padding:0.1em 0.1em; width:5%;" onclick="ablistBoardBlack('${ablist.board_idx}');"><input type="button" value="??????" style="background-color:#4acaa8;"/></td>
									<!-- <td class="ablist_delete" id="ablistDeletes_${ablist.board_idx}" name="ablistDels" align="center" style="padding:0.1em 0.1em; width:5%;" onclick="ablistBoardDelete('${ablist.board_idx}');"><input type="button" value="??????" style="background-color:#4acaa8;"/></td> -->
								</tr>
								<tr id="ablistContent_${ablist.board_idx}" name="ablistContents" style="display:none;">
									<td colspan="2" align="center" style="vertical-align:middle;"><span>??????</span></td>
									<td>${ablist.board_content}</td>
									<td colspan="5"></td>
								</tr>
								<tr id="ablistReplys_${ablist.board_idx}" name="ablistReplys" style="display:none; background-color:#ffffff;">
									<td colspan="8" style="vertical-align:middle;">
									<c:if test="${not empty ablist.replyList}">
										<c:forEach items="${ablist.replyList}" var="ablistReply" varStatus="abReplyStatus">
											<table style="margin:0.25em;">
												<tbody>
													<tr style="background-color:#ffffff; border-top:solid 0px aliceblue; border-bottom:solid 0px aliceblue;">
														<td align="center" style="width:5%;">
															<c:if test="${ablistReply.reply_res_path == null}"><span><img class="commUserListImg" src="/resources/images/default_profile.png" style="width:30px; height:30px;"/></span></c:if>
															<c:if test="${ablistReply.reply_res_path != null}"><span><img class="commUserListImg" src="${ablistReply.reply_res_path}" style="width:30px; height:30px;"/></span></c:if>
														</td>
														<td align="center" style="width:10%;">${ablistReply.reply_nick}</td>
														<td align="left" style="width:auto;">${ablistReply.reply_content}</td>
														<td colspan="2" align="center" style="width:15%;">${fn:substring(ablistReply.reg_date, 2, 16)}</td>
													</tr>
												</tbody>
											</table>
										</c:forEach>
									</c:if>
									</td>
								</tr>
							</tbody>
						</table>
					</c:forEach>
				</c:if>
				<c:if test="${empty comminfo.boardList}">
					<div><span> * ????????? ???????????? ????????????.</span></div>
				</c:if>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="ablistModalClose();">??????</button>
				<!-- <button type="button" class="btn btn-primary">Save changes</button> -->
			</div>
		</div>
	</div>
</div>

<!-- ?????? ????????? -->
<div class="modal fade" id="blackBoardListModal" tabindex="-1" aria-labelledby="blackBoardListModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-xl">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="blackBoardListModalLabel">?????? ????????? ??????</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="ManageModalClose();"></button>
			</div>
			<div class="modal-body">
				<c:if test="${not empty comminfo.blackBoardList}">
					<table style="margin:0.25em;">
						<thead>
							<tr>
								<th style="text-align:center; width:5%;">No.</th>
								<th style="text-align:center; width:10%;">?????????</th>
								<th style="text-align:center; width:auto;">??????</th>
								<th style="text-align:center; width:10%;">????????????</th>
								<th style="text-align:center; width:10%;">??????</th>
								<th style="text-align:center; width:12%;">?????????</th>
								<th style="text-align:center; width:8%;">?????????</th>
								<th style="text-align:center; width:7.5%;">&nbsp;</th>
							</tr>
						</thead>
					</table>
					<c:forEach items="${comminfo.blackBoardList}" var="bblist" varStatus="bbStatus">
						<table style="margin:0.25em;" id="bbLists_${bblist.board_idx}" name="bblistTables">
							<tbody>
								<tr>
									<td align="center" style="padding:0.1em 0.1em; width:5%;">${bblist.board_idx}</td>
									<td align="center" style="padding:0.1em 0.1em; width:10%;">${bblist.writer_nick}</td>
									<td class="bblist_titles" style="padding:0.1em 0.1em; width:auto;" onclick="bblistBoardShowContent('${bblist.board_idx}');"><span><a>${bblist.board_title}</a></span></td>
									<td align="center" style="padding:0.1em 0.1em; width:10%;"><c:if test="${bblist.board_scope_nm == 'All'}">??????</c:if><c:if test="${bblist.board_scope_nm == 'Communityonly'}">????????????</c:if></td>
									<td align="center" style="padding:0.1em 0.1em; width:10%;" id="bblistStatus_${bblist.board_idx}" name="ablistStatuss">${bblist.board_stat_nm}</td>
									<td align="center" style="padding:0.1em 0.1em; width:12%;">${fn:substring(bblist.reg_date, 2, 16)}</td>
									<c:if test="${bblist.reply_total > 0}"><td class="bblist_replytotal" align="center" style="padding:0.1em 0.1em; width:8%;" onclick="bblistBoardReplyShow('${bblist.board_idx}');"><span><a>${bblist.reply_total} ???</a></span></td></c:if>
									<c:if test="${bblist.reply_total == 0}"><td align="center" style="padding:0.1em 0.1em; width:8%;">${bblist.reply_total} ???</td></c:if>
									<td class="bblist_black" align="center" style="padding:0.1em 0.1em; width:5%;" onclick="bblistBoardActive('${bblist.board_idx}');"><input type="button" value="??????" style="background-color:#4acaa8;"/></td>
								</tr>
								<tr id="bblistContent_${bblist.board_idx}" name="bblistContents" style="display:none;">
									<td colspan="2" align="center" style="vertical-align:middle; border-right:1px groove aliceblue;"><span>??????</span></td>
									<td>${bblist.board_content}</td>
									<td colspan="5"></td>
								</tr>
								<tr id="bblistReplys_${bblist.board_idx}" name="bblistReplys" style="display:none; background-color:#ffffff;">
									<td colspan="8" style="vertical-align:middle;">
									<c:if test="${not empty bblist.replyList}">
										<c:forEach items="${bblist.replyList}" var="bblistReply" varStatus="bbReplyStatus">
											<table style="margin:0.25em;">
												<tbody>
													<tr style="background-color:#ffffff; border-top:solid 0px aliceblue; border-bottom:solid 0px aliceblue;">
														<td align="center" style="width:5%;">
															<c:if test="${bblistReply.reply_res_path == null}"><span><img class="commUserListImg" src="/resources/images/default_profile.png" style="width:30px; height:30px;"/></span></c:if>
															<c:if test="${bblistReply.reply_res_path != null}"><span><img class="commUserListImg" src="${bblistReply.reply_res_path}" style="width:30px; height:30px;"/></span></c:if>
														</td>
														<td align="center" style="width:10%;">${bblistReply.reply_nick}</td>
														<td align="left" style="width:auto;">${bblistReply.reply_content}</td>
														<td colspan="2" align="center" style="width:15%;">${fn:substring(bblistReply.reg_date, 2, 16)}</td>
													</tr>
												</tbody>
											</table>
										</c:forEach>
									</c:if>
									</td>
								</tr>
							</tbody>
						</table>
					</c:forEach>
				</c:if>
				<c:if test="${empty comminfo.blackBoardList}">
					<div><span> * ?????? ???????????? ????????????.</span></div>
				</c:if>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="ManageModalClose();">??????</button>
				<!-- <button type="button" class="btn btn-primary">Save changes</button> -->
			</div>
		</div>
	</div>
</div>			
	<script type="text/javascript">
		function mandateCommunityManager(comm_idx, user_idx, nick){ 
			const manager_idx = "${comminfo.manager_idx}";
			if(confirm(nick +"????????? ???????????? ???????????? ?????????????????????????\n\[??????\] ?????? ??? "+nick+"????????? ????????????\,\n???????????? ?????????????????? ???????????????.")){
				const mandateData = {
						method: "POST",
						headers: {"Content-Type": "application/json"},
						body: JSON.stringify({comm_idx, manager_idx, user_idx, nick})
				};
				fetch("/community/mandateCommunityManager.do", mandateData)
					.then(res => res.json())
					.then((data) => {
						if(data.result){
							alert(data.msg +"\n???????????? ?????????????????? ???????????????.");
							moveToCommunityView(data.comm_idx);
						}else{
							alert('????????? ??????????????????.');
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
						alert("??????????????????.");
						location.reload();
					}
				});
		}
		
		function communityManageUserHide(uidx){
			var tid;
			var tables = document.getElementsByName("manageUserTables");
			for(var i = 0; i < tables.length; i++){
				tid = tables[i].id.substring(tables[i].id.indexOf("_")+1);
				if(uidx == tid){
					tables[i].style.display = "none";
				}
			}
		}
		
		function blackReleaseUserHide(uidx){
			var tid;
			var tables = document.getElementsByName("commBlackTables");
			for(var i = 0; i < tables.length; i++){
				tid = tables[i].id.substring(tables[i].id.indexOf("_")+1);
				if(uidx == tid){
					tables[i].style.display = "none";
				}
			}
		}
		
		function reqUsersHide(uidx, flag){
			var counting = "${comminfo.comm_sign_request}";
			if(counting > 0 && flag == "settle"){
				counting = counting - 1;
				document.querySelector("#commRequestCount").innerHTML = counting + '???';
			}
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
			/* if(confirm("?????? ???????????????????")){
				
			} */
			var win = window.open("<%=request.getContextPath()%>/common/showMessageBox.do", "msgBox", "width=500,height=150,toolbar=0,menubar=no,location=no,scrollbars=no,resizeable=no,status=no");
			confirmStatus = "A";
			const confirmSignData = {
					method: "POST",
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({confirmCidx, idx, confirmStatus})
			};
			fetch("/community/communityConfirmSignAsStatus.do", confirmSignData)
				.then(res => res.json())
				.then((data) => {
					win.close();
					if(data.result) {
						alert("??????????????????.");
						reqUsersHide(data.uidx, "settle");
					}
				});
		}
		
		function rejectSignCommunity(idx){
			/* if(confirm("?????? ???????????????????")){
				
			} */
			var win = window.open("<%=request.getContextPath()%>/common/showMessageBox.do", "msgBox", "width=500,height=150,toolbar=0,menubar=no,location=no,scrollbars=no,resizeable=no,status=no");
			confirmStatus = "D";
			const rejectSignData = {
					method: "POST",
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({confirmCidx, idx, confirmStatus})
			};
			fetch("/community/communityRejectSignAsStatus.do", rejectSignData)
				.then(res => res.json())
				.then((data) => {
					win.close();
					if(data.result){
						alert("??????????????????.");
						reqUsersHide(data.uidx, "reject");
					}
				});
		}
		
		function cmUsersBlockShow(uidx){
			var cmBlockScopes = document.getElementsByName("cmUserBlockScopes");
			var cmBlockConts = document.getElementsByName("cmUserBlockConts");
			var cmBlockBtns = document.getElementsByName("cmUserBlockBtns");
			var cmBlockTxts = document.getElementsByName("blockContTxts");
			var blockArea = document.getElementsByName("bScopes");
			var tempid;
			
			for(var i = 0; i < blockArea.length; i++){
				tempid = blockArea[i].id.substring(0, blockArea[i].id.indexOf("_"));
				if(uidx == tempid){
					blockArea[i].checked = true;
					break;
				}
			}
			
			for(var i = 0; i < cmBlockScopes.length; i++){
				cmBlockScopes[i].style.display = "none";
				cmBlockConts[i].style.display = "none";
				cmBlockBtns[i].style.display = "none";
				cmBlockTxts[i].value = "";
			}
			
			for(var i = 0; i < cmBlockScopes.length; i++){
				tempid = cmBlockScopes[i].id.substring(cmBlockScopes[i].id.indexOf("_")+1);
				if(uidx == tempid){
					cmBlockScopes[i].style.display = "";
					cmBlockScopes[i].style.border = "solid 2px #ffffff";
					cmBlockConts[i].style.display = "";
					cmBlockConts[i].style.border = "solid 2px #ffffff";
					cmBlockBtns[i].style.display = "";
				}
			}
		}
		
		function closureBlock(uidx){
			var cmBlockScopes = document.getElementsByName("cmUserBlockScopes");
			var cmBlockConts = document.getElementsByName("cmUserBlockConts");
			var cmBlockBtns = document.getElementsByName("cmUserBlockBtns");
			var cmBlockTxts = document.getElementsByName("blockContTxts");
			var blockArea = document.getElementsByName("bScopes");
			var tempid;
			for(var i = 0; i < blockArea.length; i++){
				tempid = blockArea[i].id.substring(0, blockArea[i].id.indexOf("_"));
				if(uidx == tempid){
					blockArea[i].checked = true;
					break;
				}
			}
			for(var i = 0; i < cmBlockScopes.length; i++){
				tempid = cmBlockScopes[i].id.substring(cmBlockScopes[i].id.indexOf("_")+1);
				if(uidx == tempid){
					cmBlockScopes[i].style.display = "none";
					cmBlockConts[i].style.display = "none";
					cmBlockTxts[i].value = "";
					cmBlockBtns[i].style.display = "none";
					break;
				}
			}
		}
		
		function memberManageClose(){
			location.reload();
			var cmBlockScopes = document.getElementsByName("cmUserBlockScopes");
			var cmBlockConts = document.getElementsByName("cmUserBlockConts");
			var cmBlockBtns = document.getElementsByName("cmUserBlockBtns");
			var cmBlockTxts = document.getElementsByName("blockContTxts");
			for(var i = 0; i < cmBlockScopes.length; i++){
				if(cmBlockScopes[i].style.display == ""){
					cmBlockScopes[i].style.display = "none";
					cmBlockConts[i].style.display = "none";
					cmBlockTxts[i].value = "";
					cmBlockBtns[i].style.display = "none";
				}
			}
			
		}
		
		function communityUserBlock(uidx){
			var blockConts = document.getElementsByName("blockContTxts");
			var blockArea = document.getElementsByName("bScopes");
			var cidx = "${comminfo.comm_idx}";
			var cmUserBlockScope = null;
			var cmUserBlockCont;
			var tempid;
			
			for(var i = 0; i < blockArea.length; i++){
				tempid = blockArea[i].id.substring(0, blockArea[i].id.indexOf("_"));
				if(uidx == tempid){
					if(blockArea[i].checked == true){
						cmUserBlockScope = blockArea[i].value;
						break;
					}
				}
			}
			/* for(var i = 0; i < blockArea.length; i++){
				if(blockArea[i].checked == true){
					cmUserBlockScope = blockArea[i].value;
					break;
				}
			} */
			for(var i = 0; i < blockConts.length; i++){
				tempid = blockConts[i].id.substring(blockConts[i].id.indexOf("_")+1);
				if(uidx == tempid){
					cmUserBlockCont = blockConts[i].value;
					break;
				}
			}
			if(!cmUserBlockCont) { alert("????????? ??????????????????."); return;}
			
			if(confirm("?????????????????????????")){
				const communityBlockData = {
						method: "POST",
						headers: {"Content-Type": "application/json"},
						body: JSON.stringify({uidx, cmUserBlockScope, cmUserBlockCont, cidx})
				};
				fetch("/community/communityUserBlock.do", communityBlockData)
					.then(res => res.json())
					.then((data) => {
						if(data.result){
							alert("??????????????????.");
							communityManageUserHide(data.uidx);
						}
					});
			}
		}
		
		function communityBlackUserRelease(uidx){
			if(confirm("?????? ???????????? ???????????? ???????????????????")){
				var cidx = "${comminfo.comm_idx}";
				const communityBlackReleaseData = {
						method: "POST",
						headers: {"Content-Type": "application/json"},
						body: JSON.stringify({uidx, cidx})
				};
				fetch("/community/communityBlackUserRelease.do", communityBlackReleaseData)
					.then(res => res.json())
					.then((data) => {
						if(data.result){
							alert(data.msg);
							blackReleaseUserHide(data.uidx);
						}
					});
			}
		}
		
		
		function ablistBoardShowContent(bidx){
			var trs = document.getElementsByName("ablistContents");
			var trid;
			
			for(var i = 0; i < trs.length; i++){
				trid = trs[i].id.substring(trs[i].id.indexOf("_")+1);
				if(bidx == trid){
					if(trs[i].style.display == "") trs[i].style.display = "none";
					else trs[i].style.display = "";
				}else{
					trs[i].style.display = "none";
				}
			}
		}
		
		function bblistBoardShowContent(bidx){
			var trs = document.getElementsByName("bblistContents");
			var trid;
			
			for(var i = 0; i < trs.length; i++){
				trid = trs[i].id.substring(trs[i].id.indexOf("_")+1);
				if(bidx == trid){
					if(trs[i].style.display == "") trs[i].style.display = "none";
					else trs[i].style.display = "";
				}else{
					trs[i].style.display = "none";
				}
			}
		}
		
		function ablistModalClose(){
			var trs = document.getElementsByName("ablistContents");
			for(var i = 0; i < trs.length; i++){
				trs[i].style.display = "none";
			}
			location.reload();
		}
		
		function removeActiveBoardList(bidx){
			var abtbs = document.getElementsByName("ablistTables");
			var tbid;
			for(var i = 0; i < abtbs.length; i++){
				tbid = abtbs[i].id.substring(abtbs[i].id.indexOf("_")+1);
				if(bidx == tbid){
					abtbs[i].style.display = "none";
				}
			}
		}
		
		function removeBlackBoardList(bidx){
			var bbtbs = document.getElementsByName("bblistTables");
			var tbid;
			for(var i = 0; i < bbtbs.length; i++){
				tbid = bbtbs[i].id.substring(bbtbs[i].id.indexOf("_")+1);
				if(bidx == tbid){
					bbtbs[i].style.display = "none";
				}
			}
		}
		
		function statusChangeActiveBoardList(bidx){ // deprecated..
			var statTds = document.getElementsByName("ablistStatuss");
			var abDels = document.getElementsByName("ablistDels");
			var abAct = document.getElementsByName("abActives");
			var tdid;
			for(var i = 0; i < statTds.length; i++){
				tdid = statTds[i].id.substring(statTds[i].id.indexOf("_")+1);
				if(bidx == tdid){
					statTds[i].innerHTML = "??????";
				}
			}
		}
		
		function ablistBoardBlack(bidx){
			if(confirm("?????? ???????????? ?????????????????????????")){
				const abBoardBlackData = {
						method: "POST",
						headers: {"Content-Type": "application/json"},
						body: JSON.stringify({bidx})
				};
				fetch("/board/communityActiveBoardToBlack.do", abBoardBlackData)
					.then(res => res.json())
					.then((data) => {
						alert(data.msg);
						removeActiveBoardList(data.bidx);
					});
			}
		}
		
		function bblistBoardActive(bidx){
			if(confirm("?????? ???????????? ????????????????????????????")){
				const bbBoardActiveData = {
						method: "POST",
						headers: {"Content-Type": "application/json"},
						body: JSON.stringify({bidx})
				};
				fetch("/board/communityBlackBoardToActive.do", bbBoardActiveData)
					.then(res => res.json())
					.then((data) => {
						alert(data.msg);
						removeBlackBoardList(data.bidx);
					});
			}
		}
		
		function ablistBoardDelete(bidx){
			if(confirm("?????? ???????????? ???????????? ???????????????????")){
				const abBoardDelData = {
						method: "POST",
						headers: {"Content-Type": "application/json"},
						body:JSON.stringify({bidx})
				};
				fetch("/board/communityActiveBoardToDelete.do", abBoardDelData)
					.then(res => res.json())
					.then((data) => {
						alert(data.msg);
						statusChangeActiveBoardList(data.bidx);
						//removeActiveBoardList(data.bidx);
					});
			}
		}
		
		function ablistBoardReplyShow(bidx){
			var trs = document.getElementsByName("ablistReplys");
			var trid;
			for(var i = 0; i < trs.length; i++){
				trid = trs[i].id.substring(trs[i].id.indexOf("_")+1);
				if(trid == bidx){
					if(trs[i].style.display == "none") trs[i].style.display = "";
					else trs[i].style.display = "none";
				}else{
					trs[i].style.display = "none";
				}
			}
		}
		
		function bblistBoardReplyShow(bidx){
			var trs = document.getElementsByName("bblistReplys");
			var trid;
			for(var i = 0; i < trs.length; i++){
				trid = trs[i].id.substring(trs[i].id.indexOf("_")+1);
				if(trid == bidx){
					if(trs[i].style.display == "none") trs[i].style.display = "";
					else trs[i].style.display = "none";
				}else{
					trs[i].style.display = "none";
				}
			}
		}
		
		function ManageModalClose(){
			location.reload();
		}
		
		function closureCommunity(cidx, cname){
			const reg_uidx = "${comminfo.manager_idx}";
			if(confirm(cname +" ???????????? ??????????????? ?????????????????????????\n7??? ??? ???????????? ???????????? ??????????????? ??????????????? ???????????????.\n?????? ?????? ????????? ????????? ????????? ??? ????????????.")){
				var win = window.open("<%=request.getContextPath()%>/common/showMessageBox.do", "msgBox", "width=500,height=150,toolbar=0,menubar=no,location=no,scrollbars=no,resizeable=no,status=no");
				win.focus();
				const communityClosureData = {
						method: "POST",
						headers: {"Content-Type": "application/json"},
						body: JSON.stringify({reg_uidx, cidx})
				};
				fetch("/community/communityManagerCommunityClosure.do", communityClosureData)
					.then(res => res.json())
					.then((data) => {
						win.close();
						if(data.result){
							alert(data.msg);
							location.reload();
							//document.querySelector("#closureCommuntiyArea").style.display = "none";
							//document.querySelector("#closureCommunityCancelArea").style.display = "";
						}else{
							alert(data.msg);
						}
					});
			}
			
		}
		
		function closureCommunityCancel(cidx){
			if(confirm("??????????????? ?????????????????????????\n???????????? ??????????????? ??????????????? ???????????????.")){
				var win = window.open("<%=request.getContextPath()%>/common/showMessageBox.do", "msgBox", "width=500,height=150,toolbar=0,menubar=no,location=no,scrollbars=no,resizeable=no,status=no");
				win.focus();
				const closureCancelData = {
						method: "POST",
						headers: {"Content-Type": "application/json"},
						body: JSON.stringify({cidx})
				};
				fetch("/community/communityClosureCancelAsManager.do", closureCancelData)
					.then(res => res.json())
					.then((data) => {
						win.close();
						if(data.result){
							alert(data.msg);
							location.reload();
						}
					});
			}
		}
		
		
		
	</script>


</body>
</html>