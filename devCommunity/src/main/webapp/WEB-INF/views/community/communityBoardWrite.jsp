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
	input[type="radio"] + label{padding-right:1em !important;}
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
	.boardLeft{width:5em;}
	p{margin: 0;}
</style>
<script type="text/javascript">
	<c:if test="${empty userBean}">
		location.href="<%=request.getContextPath()%>/";
	</c:if>
	
	<c:if test="${not empty result}">
		<c:if test="${result == true}">
			<c:if test="${not empty moveToValue}">
				top.location.href="<%=request.getContextPath()%>/user/moveToCommunityView.do?idx=${moveToValue}";
			</c:if>
		</c:if>
		
		<c:if test="${result == false}">
			<c:if test="${not empty msg}">
				alert("${msg}");
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
					</div>
					</c:if>
				</header>
				<c:if test="${not empty userBean }">
				<nav id="nav">
					<ul>
						<li onclick="moveToMain();"><a href="#">메인페이지 이동</a></li>
						<li onclick="moveToFaQ();" style="cursor:pointer;"><a> 1:1 문의하기 </a></li>
						<li><a href="#" id="userMyPage">마이페이지</a></li>
						<li id="ucLi"><a id="ucListView">커뮤니티</a></li>
						<c:if test="${empty ucList}">
						<li id="ucEmpty"style="display:none;"><a>가입된 커뮤니티가 없습니다.</a></li>
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
			</section>

		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Main -->
					<div id="main">

							<section id="one">
								<div class="image main" data-position="center">
									<div style="width:10%;"></div>
									<div style="width:2%;"></div>
									<div style="width:20%; margin:auto;">
										<select id="searchTxt">
											<option value="0">=== 선택 ===</option>
											<option value="content">내용</option>
											<option value="title">제목</option>
											<option value="writer">작성자</option>
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
								
								<div class="container" style="width:60em;">
								<br /><br />
								<form name="boardFrm" id="boardFrm" action="<%=request.getContextPath()%>/board/insertCommunityBoard.do" method="POST" enctype="multipart/form-data" >
								<input type="hidden" name="cidx" value="${comm_idx}" />
								<div id="loadValues"></div>
								<table>
									<tbody>
										<tr>
											<td class="boardLeft">제목</td>
											<td><input type="text" id="board_title" name="board_title"/></td>
										</tr>
										<tr>
											<td class="boardLeft">내용</td>
											<td><textarea name="board_content" id="summernote" rows="8" cols="90" style="resize:none;"></textarea></td>
										</tr>
										<tr style="vertical-align:middle;">
											<td>공개범위</td>
											<td>
												<span style="float:left;">
												<input type="radio" name="boardScope" id="boardScopeA" value="A" checked/><label for="boardScopeA">전체공개</label>
												<input type="radio" name="boardScope" id="boardScopeC" value="C" /><label for="boardScopeC">커뮤니티공개</label>
												<input type="hidden" name="boardScopeValue" value="" />
												</span>
												<span style="float:right;">
													<input onclick="cancelBoard();" type="button" value="취소"/>&nbsp;&nbsp;&nbsp;&nbsp;
													<input onclick="insertCommunityBoard();" type="button" value="등록" />
												</span>
											</td>
										</tr>
									</tbody>
								</table>
								</form>
								</div>
							</section>

					</div>

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
	document.addEventListener("DOMContentLoaded", function(){
		$("#summernote").summernote({
			height: 350,
			lang: "ko-KR",
			disableResizeEditor: true,
			focus: true,
			codemirror: {
			      mode: 'text/html',
			      htmlMode: true,
			      lineNumbers: true,
			      theme: 'monokai'
			},
			/* toolbar: [
                // [groupName, [list of button]]
                ['Font Style', ['fontname']],
                ['style', ['bold', 'italic', 'underline']],
                ['font', ['strikethrough']],
                ['fontsize', ['fontsize']],
                ['color', ['color']],
                ['para', ['paragraph']],
                ['height', ['height']],
                ['Insert', ['picture']],
                ['Insert', ['link']],
                ['Misc', ['fullscreen']]
            ], */
            
            callbacks: {	//여기 부분이 이미지를 첨부하는 부분
				onImageUpload : function(files) {
					for(var i = 0; i < files.length; i++){
						uploadSummernoteImageFile(files[i],this);
					}
				},
				onPaste: function (e) {
					var clipboardData = e.originalEvent.clipboardData;
					if (clipboardData && clipboardData.items && clipboardData.items.length) {
						var item = clipboardData.items[0];
						if (item.kind === 'file' && item.type.indexOf('image/') !== -1) {
							e.preventDefault();
						}
					}
				}
			}
		});
		
		var containerDiv = document.getElementById("loadValues");
		var ul = document.createElement("ul");
		var li = document.createElement("li");
		
		function uploadSummernoteImageFile(file, editor) { // 이미지 파일 업로드..
			const frmData = new FormData();
			frmData.append("file", file);
			
			fetch("<%=request.getContextPath()%>/user/board/tempImagesUpload",{
				method: "POST",
				body: frmData
			}).then(res => res.json())
			.then((data) => {
				if(data.result == false){
					top.location.href = "<%=request.getContextPath()%>/";
				}
				$(editor).summernote('insertImage', data.url);
				
				li.style.display = "none";
				li.innerHTML += '<input type="hidden" name="realFileName" value="'+data.realFileName+'" />';
				li.innerHTML += '<input type="hidden" name="resPathValue" value="'+data.url+'" />';
				ul.appendChild(li);
				containerDiv.appendChild(ul);
				
				$('#imageBoard > ul').append('<li><img src="'+data.url+'" width="40%;" height="auto"/></li>');

			});
			
			
			/* $.ajax({
				data : data,
				type : "POST",
				url : "/board/uploadSummernoteImageFile",
				contentType : false,
				processData : false,
				success : function(data) {
	            	//항상 업로드된 파일의 url이 있어야 한다.
					$(editor).summernote('insertImage', data.url);
				}
			}); */
		}
	});
</script>

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
		
		function cancelBoard(){
			location.href = history.back();
		}
		
		function insertCommunityBoard(){ // 제목, 내용 등 검증하고 submit 처리 해야함.
			const frm = document.boardFrm;
			const title = frm.board_title.value;
			const content = frm.board_content.value;
			
			const cidx = frm.cidx.value;
			
			var scopes = document.getElementsByName("boardScope");
			for(var i = 0; i < scopes.length; i++){
				if(scopes[i].checked == true){
					frm.boardScopeValue.value = scopes[i].value;
				}
			}
			
			if(!title) { alert("제목을 입력해주세요."); document.querySelector("#board_title").focus(); return; }
			if(!content) { alert("내용을 입력해주세요."); document.querySelector("#summernote").focus(); return; }
			
			frm.submit();
			
		}
		
		
	</script>


</body>
</html>