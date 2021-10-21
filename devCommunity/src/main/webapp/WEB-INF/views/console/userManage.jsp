<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<style>
	html, body{
		margin: 0;
		height: 100%;
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
	.uList_img{
		width: 30px;
  		height: 30px;
  		object-fit: cover;
	}
	.uList_img:hover{
		-webkit-transform:scale(5);
		-moz-transform:scale(5);
		-ms-transform:scale(5);
		-o-transform:scale(5);
		transform:scale(5);
	}
	#userDetail:hover, #userRelease:hover{cursor:pointer;}
	.umTd{vertical-align:middle; padding: 0.25em 0.25em;}
</style>
<script type="text/javascript">
	<c:if test="${empty adminBean}">
		location.href="<%=request.getContextPath()%>/console/logout.do";
	</c:if>
	
	window.onload = function(){
		
	}
	
	
	
	function pageHandler(value){
		if(value == "communityStatus"){ //communityStatus.
			location.href="<%=request.getContextPath()%>/console/mainAdmin.do";
		} else if(value == "userStatus"){ //userStatus.
			//current page. nothing.
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
				<li><a href="#" id="userStatus" onclick="pageHandler(this.id);">회원정보 관리</a></li>
				<li><a href="#" id="boardStatus" onclick="pageHandler(this.id);">게시글 관리</a></li>
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
				<span><b><font size="5">&nbsp; * &nbsp;블랙리스트 현황</font></b></span><hr style="margin:1em;">
				<c:if test="${empty blackList}">
					현재 블랙리스트로 등록된 회원이 없습니다.
				</c:if>
				<c:if test="${not empty blackList}">
					<table>
						<thead>
							<tr>
								<th>프로필이미지</th>
								<th>아이디</th>
								<th>닉네임</th>
								<th>가입일</th>
								<th>상태</th>
								<th>최근 로그인 일시</th>
								<th>차단 시작일</th>
								<th>차단 종료일</th>
								<th></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${blackList}" var="bList" varStatus="status">
								<tr>
									<td class="umTd"><img class="uList_img" src="${bList.profile_src}" alt="" /></td>
									<td class="umTd">${bList.login_id}</td>
									<td class="umTd">${bList.nick_name}</td>
									<td class="umTd">${fn:substring(bList.reg_date, 2, 16)}</td>
									<td class="umTd">${bList.user_stat_nm}</td>
									<td class="umTd">${fn:substring(bList.login_date, 2, 16)}</td>
									<td class="umTd">${fn:substring(bList.black_sdate, 2, 16)}</td>
									<td class="umTd">${fn:substring(bList.black_edate, 2, 16)}</td>
									<td class="umTd" id="userRelease"><span onclick="userBlackListRelease(${bList.user_idx})">차단 즉시해제</span></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:if>
				</div>
			</div>
			<div class="flex_item2">
				<div align="left">
				<span><b><font size="5">&nbsp; * &nbsp;회원 현황</font></b></span><hr style="margin:1em;">
				<c:if test="${not empty userList}">
					<table style="border:1px;">
						<colgroup>
						</colgroup>
						<thead>
							<tr>
								<th>프로필이미지</th>
								<th>아이디</th>
								<th>닉네임</th>
								<th>가입일</th>
								<th>상태</th>
								<th>최근 로그인 일시</th>
								<th></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${userList}" var="uList" varStatus="status">
								<tr>
									<td class="umTd"><img class="uList_img" src="${uList.profile_src}" alt="" /></td>
									<td class="umTd">${uList.login_id}</td>
									<td class="umTd">${uList.nick_name}</td>
									<td class="umTd">${fn:substring(uList.reg_date, 2, 16)}</td>
									<td class="umTd">${uList.user_stat_nm}</td>
									<td class="umTd">${uList.login_date}</td>
									<td class="umTd" id="userDetail"><span onclick="userDetailView('${uList.user_idx}');" data-bs-toggle="modal" data-bs-target="#userView">정보보기</span></td>
								</tr>
							</c:forEach>
						</tbody>
				</table>
				</c:if>
				</div>
			</div>
		</div>
	
	</div>
	
	<div class="modal fade" id="userView" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="userNameField"></h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="closureModal();"></button>
				</div>
				<div class="modal-body">
					<table>
						<tbody>
							<tr>
								<td>아이디</td>
								<td id="userIdField"></td>
							</tr>
							<tr>
								<td>닉네임</td>
								<td id="userNickField"></td>
							</tr>
							<tr>
								<td style="vertical-align:middle;">가입된 커뮤니티
								<td id="userCommunityInfo"></td>
							</tr>
							<tr>
								<td style="vertical-align:middle;">프로필이미지</td>
								<td id="userProfileField"></td>
							</tr>
							<tr>
								<td>상태</td>
								<td id="userStatusField">
									<input type="radio" id="Active" value="A" name="userStat" onclick="showBlackListScope(this.value);"/><label for="Active">활성</label>
									<input type="radio" id="Black" value="B" name="userStat" onclick="showBlackListScope(this.value);"/><label for="Black">차단</label>
									<input type="radio" id="Inactive" value="I" name="userStat" disabled /><label for="Inactive">비활성</label>
								</td>
							</tr>
							<tr>
								<td colspan="2" style="display:none; vertical-align:middle;" id="showBScope" align="right">
									<c:if test="${not empty bScope}">
									<c:forEach items="${bScope}" var="bScope" varStatus="status">
										<input type="radio" id="blackScope_${bScope.conf_type_cd}" name="bScopes" value="${bScope.conf_type_cd}">
										<label for="blackScope_${bScope.conf_type_cd}">${bScope.conf_name}</label>
									</c:forEach>
									</c:if>
								</td>
							</tr>
							<tr style="display:none;" id="showBcont">
								<td style="vertical-align:middle;">사유입력</td>
								<td>
									<textarea style="resize:none;" id="bl_cont"></textarea>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="closureModal();">닫기</button>
					<button type="button" class="btn btn-primary" id="userInfoSvaeBtn">저장</button>
				</div>
			</div>
		</div>
	</div>
	
	<script type="text/javascript">
		function userDetailView(idx){
			document.querySelector(".modal-open").style.paddingRight = "0px";
			document.querySelector(".modal-open").style.overflow = "auto";
			fetch("/console/user/userDetailView.do?idx="+idx)
				.then(res => res.json())
				.then(data => showWinUser(data));
		}
		
		function showWinUser(res){
			var ui = res.userInfo;
			var ucList = res.ucList;
			
			var prosrc = "<img src='"+ui.profile_src+"' style='width:150px; height:150px;' alt='' />";
			
			document.getElementById("userNameField").innerHTML = ui.nick_name +" 님의 회원정보";
			document.getElementById("userIdField").innerHTML = ui.login_id;
			document.getElementById("userNickField").innerHTML = ui.nick_name;
			document.getElementById("userProfileField").innerHTML = prosrc;
			
			document.getElementById("userInfoSvaeBtn").setAttribute("onclick","saveUserInfo("+ui.user_idx+");");
			
			var userStats = document.getElementsByName("userStat");
			for(var i = 0; i < userStats.length; i++){
				if(userStats[i].getAttribute('value') == ui.user_stat_cd){
					userStats[i].checked = true;
				}
				if(ui.user_stat_cd == "I"){
					document.getElementById("Active").disabled = true;
					document.getElementById("Black").disabled = true;
				}else{
					document.getElementById("Active").disabled = false;
					document.getElementById("Black").disabled = false;
				}
			}
			
			if(ucList.length > 0){
				for(var i = 0; i < ucList.length; i++){
					document.getElementById("userCommunityInfo").innerHTML += ucList[i].comm_name;
					if(i < ucList.length - 1) document.getElementById("userCommunityInfo").innerHTML += "<br />";
					
				}
			}else{
				document.getElementById("userCommunityInfo").innerHTML = "가입된 커뮤니티 없음";
			}
			
		}
		var scopesName ;
		function showBlackListScope(value){
			//....
			if(value == "A"){
				document.querySelector("#showBScope").style.display = "none";
				document.querySelector("#showBcont").style.display = "none";
				scopesName = document.getElementsByName("bScopes");
				for(var i = 0; i < scopesName.length; i++){
					if(scopesName[i].getAttribute('type') === 'radio'){
						scopesName[i].checked = false;
					}
				}
			}
			if(value == "B"){
				document.querySelector("#showBScope").style.display = "";
				document.querySelector("#showBcont").style.display = "";
			}
		}
		
		function closureModal(){
			document.querySelector("#showBScope").style.display = "none";
			document.querySelector("#showBcont").style.display = "none";
			document.querySelector("#bl_cont").value = "";
			document.querySelector("#userCommunityInfo").innerHTML = "";
			scopesName = document.getElementsByName("bScopes");
			for(var i = 0; i < scopesName.length; i++){
				if(scopesName[i].getAttribute('type') === 'radio'){
					scopesName[i].checked = false;
				}
			}
		}
		
		function saveUserInfo(uid){
			var blacklistScope = null;
			var blacklstCont;
			
			if(document.querySelector("#Black").checked == true){
				scopesName = document.getElementsByName("bScopes");
				for(var i = 0; i < scopesName.length; i++){
					if(scopesName[i].checked == true){
						blacklistScope = scopesName[i].value;
						blacklistCont = document.querySelector("#bl_cont").value;
					}
				}
				if(blacklistScope == null) { alert("차단 기간을 설정해주세요."); return; }
				if(!blacklistCont) { alert("차단 사유를 작성해주세요."); document.querySelector("#bl_cont").focus(); return; }
				
				if(confirm("해당 사용자를 " + blacklistScope + "일 기간만큼 차단히겠습니까?\n차단 설정 후 사용자에게 이메일로 사유가 발송됩니다.")){
					const blackData = {
							method: "POST",
							headers: {"Content-Type": "application/json"},
							body: JSON.stringify({uid, blacklistScope, blacklistCont})
					};
					fetch("/console/user/insertBlackListUser", blackData)
						.then(res => res.json())
						.then((data) => {
							if(data.result == true){
								alert(data.msg);
								location.reload();
							}else{
								alert(data.msg);
							}
						});
				}
				
			}else{
				//차단이 아닌 경우는 그냥 닫아도 되지 않을까..?
			}
			
		}
		
		function userBlackListRelease(uid){
			if(confirm("차단을 즉시 해제하시겠습니까?")){
				fetch("/console/user/userBlackListRelease.do?idx="+uid)
					.then(res => res.json())
					.then((data) => {
						if(data.result == true){
							alert(data.msg);
							location.relead();
						}else{
							alert(data.msg);
						}
					});
			}
		}
	
	
	</script>
	
</body>
</html>