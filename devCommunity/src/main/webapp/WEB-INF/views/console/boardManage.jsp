<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<style>
	html, body{
		margin: 0;
		height: 100%;
	}
	div flex_item2{height: 100%;}
	.flex_container{
		display: flex;
		flex-direction: column;
	}
	.flex_item1, .flex_item2{
		flex: 1;
		overflow: auto;
		padding: 2% 0 2% 4%;
	}
	a:hover{cursor:pointer; }
	table td{padding: 0.5em 0.5em; }
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
			location.href="<%=request.getContextPath()%>/console/user/userManage.do";
		} else if(value == "boardStatus"){
			// current page. nothing.
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
					<span><b><font size="5">&nbsp; * &nbsp;차단게시글 현황</font></b></span><hr style="margin:1em;">
						<c:if test="${empty bbList}">
							현재 차단게시글이 없습니다.
						</c:if>
						<c:if test="${not empty bbList}">
						<table style="border:1px;">
						<colgroup>
						<col style="width:5%;">
						<col style="width:10%;">
						<col style="width:auto;">
						<col style="width:10%;">
						<col style="width:12%;">
						<col style="width:8%;">
						<col style="width:5%;">
						<col style="width:5%;">
					</colgroup>
							<thead>
								<tr>
									<th style="text-align:center;">No.</th>
									<th style="text-align:center;">작성자</th>
									<th style="text-align:center;">제목</th>
									<th style="text-align:center;">공개범위</th>
									<th style="text-align:center;">상태</th>
									<th style="text-align:center;">작성일</th>
									<th style="text-align:center;">댓글 수</th>
									<th style="text-align:center;"></th>
									<th style="text-align:center;"></th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${bbList}" var="bbList" varStatus="bbStatus">
								<tr>
									<td align="center">${bbList.board_idx}</td>
									<td align="center">${bbList.writer_nick}</td>
									<td onclick="adminShowBoardContent('bb', '${bbList.board_idx}');"><span><a>${bbList.board_title}</a></span></td>
									<td align="center"><c:if test="${bbList.board_scope_nm == 'All'}">전체</c:if><c:if test="${bbList.board_scope_nm == 'Communityonly'}">커뮤니티</c:if></td>
									<td align="center">${bbList.board_stat_nm}</td>
									<td align="center" style="width:12%;">${fn:substring(bbList.reg_date, 2, 16)}</td>
									<c:if test="${bbList.reply_total > 0}"><td align="center" style="width:8%;"><span><a>${bbList.reply_total} 개</a></span></td></c:if><c:if test="${bbList.reply_total == 0}"><td align="center" style="width:8%;">${bbList.reply_total} 개</td></c:if>
									<td align="center" style="width:5%;" onclick="blockBoardToRelease('${bbList.board_idx}');"><span><a href="#">활성</a></span></td>
									<td align="center" style="width:5%;" onclick="blockBoardToDelete('${bbList.board_idx}');"><span><a href="#">삭제</a></span></td>
								</tr>
								<tr id="bbList_${bbList.board_idx}" name="blockLists" style="display:none;">
									<td colspan="2" align="center" style="vertical-align:middle; border-right:1px groove aliceblue;"><span>내용</span></td>
									<td>${bbList.board_content}</td>
									<td colspan="5"></td>
								</tr>
								<tr id="bbReplyList_${bbList.board_idx}" name="blockReplyLists" style="display:none;">
									<td colspan="8">
										<c:if test="${not empty bbList.replyList}">
											<c:forEach items="${bbList.replyList}" var="bbReplyList" varStatus="bbReplyStatus">
												<table style="margin:0.25em;">
													<tr>
														<td align="center" style="width:5%;">
															<c:if test="${bbReplyList.reply_res_path == null}"><span><img class="commUserListImg" src="/resources/images/default_profile.png" style="width:30px; height:30px;"/></span></c:if>
															<c:if test="${bbReplyList.reply_res_path != null}"><span><img class="commUserListImg" src="${bbReplyList.reply_res_path}" style="width:30px; height:30px;"/></span></c:if>
														</td>
														<td align="center" style="width:10%; border-right:1px groove aliceblue;">${bbReplyList.reply_nick}</td>
														<td style="width:auto;">${bbReplyList.reply_content}</td>
														<td align="center" style="width:15%;">${fn:substring(bbReplyList.reg_date, 2, 16)}</td>
													</tr>
												</table>
											</c:forEach>
										</c:if>
										<c:if test="${empty bbList.replyList}">
											<table style="margin:0.25em;">
												<tr>
													<td style="width:5%;"></td>
													<td style="width:10%;"></td>
													<td style="width:auto;"><div><span> * 작성된 댓글이 없습니다.</span></div></td>
													<td style="width:15%;"></td>
												</tr>
											</table>
										</c:if>
									</td>
								</tr>
								</c:forEach>
							</tbody>
						</table>
						</c:if>
				</div>
			</div>
			<div class="flex_item2">
				<div align="left">
				<span><b><font size="5">&nbsp; * &nbsp;게시글 현황</font></b></span><hr style="margin:1em;">
				<c:if test="${not empty abList}">
					<table style="border:1px;">
					<colgroup>
						<col style="width:5%;">
						<col style="width:10%;">
						<col style="width:auto;">
						<col style="width:10%;">
						<col style="width:12%;">
						<col style="width:8%;">
						<col style="width:5%;">
						<col style="width:5%;">
					</colgroup>
						<thead>
							<tr>
								<th style="text-align:center;">No.</th>
								<th style="text-align:center;">작성자</th>
								<th style="text-align:center;">제목</th>
								<th style="text-align:center;">공개범위</th>
								<th style="text-align:center;">상태</th>
								<th style="text-align:center;">작성일</th>
								<th style="text-align:center;">댓글 수</th>
								<th style="text-align:center;"></th>
								<th style="text-align:center;"></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${abList}" var="abList" varStatus="abStatus">
								<tr>
									<td align="center">${abList.board_idx}</td>
									<td align="center">${abList.writer_nick}</td>
									<td onclick="adminShowBoardContent('ab', '${abList.board_idx}');"><span><a>${abList.board_title}</a></span></td>
									<td align="center"><c:if test="${abList.board_scope_nm == 'All'}">전체</c:if><c:if test="${abList.board_scope_nm == 'Communityonly'}">커뮤니티</c:if></td>
									<td align="center">${abList.board_stat_nm}</td>
									<td align="center" style="width:12%;">${fn:substring(abList.reg_date, 2, 16)}</td>
									<c:if test="${abList.reply_total > 0}"><td align="center" style="width:8%;"><span><a>${abList.reply_total} 개</a></span></td></c:if><c:if test="${abList.reply_total == 0}"><td align="center" style="width:8%;">${abList.reply_total} 개</td></c:if>
									<td align="center" style="width:5%;" onclick="activeBoardToBlock('${abList.board_idx}');"><span><a href="#">차단</a></span></td>
									<td align="center" style="width:5%;" onclick="activeBoardToDelete('${abList.board_idx}')"><span><a href="#">삭제</a></span></td>
								</tr>
								<tr id="abList_${abList.board_idx}" name="activeLists" style="display:none;">
									<td colspan="2" align="center" style="vertical-align:middle; border-right:1px groove aliceblue;"><span>내용</span></td>
									<td colspan="3" >${abList.board_content}</td>
									<td colspan="4"></td>
								</tr>
								<tr id="abReplyList_${abList.board_idx}" name="activeReplyLists" style="display:none;">
									<td colspan="9">
										<c:if test="${not empty abList.replyList}">
											<c:forEach items="${abList.replyList}" var="abReplyList" varStatus="abReplyStatus">
												<table style="margin:0.25em;">
													<tr>
														<td align="center" style="width:5%;">
															<c:if test="${abReplyList.reply_res_path == null}"><span><img class="commUserListImg" src="/resources/images/default_profile.png" style="width:30px; height:30px;"/></span></c:if>
															<c:if test="${abReplyList.reply_res_path != null}"><span><img class="commUserListImg" src="${abReplyList.reply_res_path}" style="width:30px; height:30px;"/></span></c:if>
														</td>
														<td align="center" style="width:9.2%; border-right:1px groove aliceblue;">${abReplyList.reply_nick}</td>
														<td style="width:auto;">${abReplyList.reply_content}</td>
														<td align="center" style="width:15%;">${fn:substring(abReplyList.reg_date, 2, 16)}</td>
													</tr>
												</table>
											</c:forEach>
										</c:if>
										<c:if test="${empty abList.replyList}">
											<table style="margin:0.25em;">
												<tr>
													<td style="width:5%;"></td>
													<td style="width:9.2%;"></td>
													<td style="width:auto;"><div><span> * 작성된 댓글이 없습니다.</span></div></td>
													<td style="width:15%;"></td>
												</tr>
											</table>
										</c:if>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:if>
				</div>
			</div>
		</div>
	
	</div>
	
	<script type="text/javascript">
	
	function blockBoardToRelease(idx){ //차단 게시글 -> 활성 
		if(confirm("활성화 처리 하시겠습니까?")){
			const bToRelData = {
					method : "POST",
					headers : {"Content-Type": "application/json"},
					body: JSON.stringify({idx})
			};
			fetch("/console/board/blockBoardToReleaseAsIdx", bToRelData)
				.then(res => res.json())
				.then((data) => {
					if(data.result){
						alert('성공했습니다.');
						location.reload();
					}else{
						if(data.msg == "SESSION_TIMEOUT") location.href="<%=request.getContextPath()%>/console/logout.do";
					}
				});
		}
	}
	
	function blockBoardToDelete(idx){ // 차단 게시글 -> 삭제
		if(confirm("삭제하시겠습니까?")){
			const blockDelData = {
					method: "POST",
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({idx})
			};
			fetch("/console/board/blockBoardToDeleteAsIdx", blockDelData)
				.then(res => res.json())
				.then((data) => {
					if(data.result){
						alert("성공했습니다.");
						location.reload();
					}else{
						if(data.msg == "SESSION_TIMEOUT") location.href="<%=request.getContextPath()%>/console/logout.do";
					}
				});
		}
	}
	
	function activeBoardToBlock(idx){ // 활성 게시글 -> 차단
		if(confirm("차단 처리 하시겠습니까?")){
			const aToBlockData = {
					method: "POST",
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({idx})
			};
			fetch("/console/board/activeBoardToBlockAsIdx", aToBlockData)
				.then(res => res.json())
				.then((data) => {
					if(data.result){
						alert("성공했습니다.");
						location.reload();
					}else{
						if(data.msg == "SESSION_TIMEOUT") location.href="<%=request.getContextPath()%>/console/logout.do";
					}
				});
		}
	}
	
	function activeBoardToDelete(idx){ // 활성 게시글 -> 삭제
		if(confirm("삭제하시겠습니까?")){
			const activeDelData = {
					method: "POST",
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({idx})	
			};
			fetch("/console/board/activeBoardToDeleteAsIdx", activeDelData)
				.then(res => res.json())
				.then((data) => {
					if(data.result){
						alert('성공했습니다.');
						location.reload();
					}else{
						if(data.msg == "SESSION_TIMEOUT") location.href="<%=request.getContextPath()%>/console/logout.do";
					}
				});
		}
	}
	
	function adminShowBoardContent(stat, idx){
		var trs;
		var ctrs;
		var listtmp;
		if(stat == 'bb'){
			trs = document.getElementsByName("blockLists");
			ctrs = document.getElementsByName("blockReplyLists");
			for(var i = 0; i < trs.length; i++){
				listtmp = trs[i].id.substring(trs[i].id.indexOf("_")+1);
				if(idx == listtmp && trs[i].style.display == "none"){
					trs[i].style.display = "";
					ctrs[i].style.display = "";
				}else if(idx == listtmp && trs[i].style.display == ""){
					trs[i].style.display = "none";
					ctrs[i].style.display = "none";
				}else{
					trs[i].style.display = "none";
					ctrs[i].style.display = "none";
				}
			}
		}else if(stat == 'ab'){
			trs = document.getElementsByName("activeLists");
			ctrs = document.getElementsByName("activeReplyLists");
			for(var i = 0; i < trs.length; i++){
				listtmp = trs[i].id.substring(trs[i].id.indexOf("_")+1);
				if(idx == listtmp && trs[i].style.display == "none"){
					trs[i].style.display = "";
					ctrs[i].style.display = "";
				}else if(idx == listtmp && trs[i].style.display == ""){
					trs[i].style.display = "none";
					ctrs[i].style.display = "none";
				}else{
					trs[i].style.display = "none";
					ctrs[i].style.display = "none";
				}
			}
		}
	}
	
	
	</script>
	
</body>
</html>