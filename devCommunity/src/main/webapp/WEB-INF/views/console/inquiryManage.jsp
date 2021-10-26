<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>

<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<style>
	html, body{
		margin: 0;
		height: 100%;
		overflow: hidden;
	}
	div{height: 100%;}
	.flex_container{
		display: flex;
		flex-direction: column;
	}
	.flex_item1, .flex_item2{
		flex: 1;
		overflow: auto;
		align: center;
		padding:2% 0% 2% 4%;
	}
	table td{padding:0.35em 0.35em;}
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
		} else if(value == "inquiryStatus"){
			//current page. nothing.
		} else if(value == "userStatus"){ //userStatus.
			location.href="<%=request.getContextPath()%>/console/user/userManage.do";
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
				<li><a href="#" id="inquiryStatus" onclick="pageHandler(this.id);">1:1 문의 관리</a></li>
				<li><a href="#" id="userStatus" onclick="pageHandler(this.id);">회원정보 관리</a></li>
				<li><a href="#" id="boardStatus" onclick="pageHandler(this.id);">게시글 관리</a></li>
				<li><a href="#" id="communityManage" onclick="pageHandler(this.id);">커뮤니티 관리</a></li>
				<li><a href="#" onclick="logout();">로그아웃</a></li>
			</ul>
		</nav>
		</c:if>
	</section>
	
	<div id="wrapper">
		<!-- <h2>&nbsp;&nbsp;Developer Community</h2> -->
		<div id="main" class="flex_container" align="center">
			<div class="flex_item1">
				<div align="left">
					<span><b><font size="5">&nbsp; * &nbsp;1:1 문의 현황</font></b></span><hr style="margin:1em;">
					<c:if test="${empty inquiryList}">
						<span> * 문의글이 없습니다.</span>
					</c:if>
					<c:if test="${not empty inquiryList}">
						<table style="margin:0.25em;">
							<thead>
								<tr>
									<th style="text-align:center; width:6%;">No.</th>
									<th style="text-align:center; width:10%;">닉네임</th>
									<th style="text-align:center; width:auto;">제목</th>
									<th style="text-align:center; width:15%;">문의접수일</th>
									<th style="text-align:center; width:10%;">상태</th>
									<th style="text-align:center; width:15%;">답변등록일</th>
									<th style="text-align:center; width:10%;"></th>
								</tr>
							</thead>
						</table>
						<c:set var="inquiryIndex" value="0" />
						<c:forEach items="${inquiryList}" var="inquiryList" varStatus="inquiryStatus">
						<c:set var="inquiryIndex" value="${inquiryIndex + 1}" />
							<table style="margin:0.25em;" name="inquiryLists" id="inquiryLists_${inquiryList.inquiry_idx}">
								<tbody>
									<tr>
										<td align="center" style="width:6%;">${inquiryIndex}</td>
										<td align="center" style="width:10%;">${inquiryList.reg_nick}</td>
										<td align="left" style="width:auto%;"><span style="cursor:pointer;" onclick="showInquiryContent('${inquiryList.inquiry_idx}')"><a>${inquiryList.inquiry_title}</a></span></td>
										<td align="center" style="width:15%;">${fn:substring(inquiryList.reg_date, 2, 16)}</td>
										<td align="center" style="width:10%;">${inquiryList.inquiry_stat_nm}</td>
										<td align="center" style="width:15%;"><c:if test="${inquiryList.inquiry_stat == 'S' || inquiryList.inquiry_stat == 'M'}">${fn:substring(inquiryList.answer_date, 2, 16)}</c:if></td>
										<td align="center" style="width:10%;">
											<c:if test="${inquiryList.inquiry_stat == 'R'}"><span style="cursor:pointer;" onclick="showInquiryAnswer('${inquiryList.inquiry_idx}')"><a>답변등록</a></span></c:if>
											<c:if test="${inquiryList.inquiry_stat == 'S' || inquiryList.inquiry_stat == 'M'}"><span style="cursor:pointer;" onclick="showModifyInquiryAnswer('${inquiryList.inquiry_idx}');"><a>답변수정</a></span></c:if>
										</td>
									</tr>
									<tr style="display:none;" id="inquiryContents_${inquiryList.inquiry_idx}" name="inquiryContents">
										<td colspan="2" align="center" style="border-right:1px groove aliceblue; vertical-align:middle;">내용</td>
										<td colspan="5">${inquiryList.inquiry_content}</td>
									</tr>
									<tr style="display:none;" id="inquiryAnswerValues_${inquiryList.inquiry_idx}" name="inquiryAnswerValues">
										<td colspan="2" align="center" style="border-right:1px groove aliceblue; vertical-align:middle;">답변내용</td>
										<td colspan="6"><c:if test="${empty inquiryList.inquiry_answer}">* 답변이 등록되지 않았습니다.</c:if><c:if test="${not empty inquiryList.inquiry_answer}">${inquiryList.inquiry_answer}</c:if></td>
									</tr>
									<tr style="display:none;" id="inquiryAnswers_${inquiryList.inquiry_idx}" name="inquiryAnswers">
										<td colspan="2" align="center" style="border-right:1px grovve aliceblue; vertical-align:middle;">답변등록</td>
										<td colspan="4">
											<textarea style="resize:none;" id="inquiryAnswerArea_${inquiryList.inquiry_idx}" name="inquiryAnswerTxts"></textarea>
										</td>
										<td align="center" style="vertical-align:middle;" onclick="updateInquiryAnswer('${inquiryList.inquiry_idx}');"><span style="cursor:pointer;"><input type="button" value="답변등록" /></span></td>
									</tr>
									<tr style="display:none;" id="modifyInquiryAnswers_${inquiryList.inquiry_idx}" name="modifyInquiryAnswerArea">
										<td colspan="2" align="center" style="border-right:1px groove aliceblue; vertical-align:middle;">답변수정</td>
										<td colspan="4">
											<textarea style="resize:none;" id="modifyInquiryAnswerTxt_${inquiryList.inquiry_idx}" name="modifyInquiryAnswers">${fn:replace(inquiryList.inquiry_answer, '<br />', '&#10;')}</textarea>
										</td>
										<td align="center" style="vertical-align:middle;" onclick="modifyInquiryAnswer('${inquiryList.inquiry_idx}');"><span style="cursor:pointer;"><input type="button" value="답변수정" /></span></td>
									</tr>
								</tbody>
							</table>
						</c:forEach>
					</c:if>
				</div>
			</div>
			<!-- <div class="flex_item2"></div> -->
		</div>
	
	</div>
	<script type="text/javascript">
		function showInquiryContent(idx){
			var trs = document.getElementsByName("inquiryContents");
			var ans = document.getElementsByName("inquiryAnswerValues");
			var ina = document.getElementsByName("inquiryAnswers");
			var modis = document.getElementsByName("modifyInquiryAnswerArea");
			var trid;
			for(var i = 0; i < trs.length; i++){
				trid = trs[i].id.substring(trs[i].id.indexOf("_")+1);
				if(idx == trid){
					if(trs[i].style.display == "none") {
						trs[i].style.display = "";
						ans[i].style.display = "";
						ina[i].style.display = "none";
						modis[i].style.display = "none";
					}else {
						trs[i].style.display = "none";
						ans[i].style.display = "none";
						modis[i].style.display = "none";
						ina[i].style.display = "none";
					}
				}else{
					trs[i].style.display = "none";
					ans[i].style.display = "none";
					modis[i].style.display = "none";
					ina[i].style.display = "none";
				}
			}
		}
		
		function showInquiryAnswer(idx){
			var trs = document.getElementsByName("inquiryAnswers");
			var txts = document.getElementsByName("inquiryAnswerTxts");
			var trid;
			for(var i = 0; i < txts.length; i++) txts[i].value = "";
			for(var i = 0; i < trs.length; i++){
				trid = trs[i].id.substring(trs[i].id.indexOf("_")+1);
				if(idx == trid){
					if(trs[i].style.display == "none") trs[i].style.display = "";
					else trs[i].style.display = "none";
				}else{
					trs[i].style.display = "none";
				}
			}
		}
		
		function updateInquiryAnswer(idx){
			var txts = document.getElementsByName("inquiryAnswerTxts");
			var txtid;
			var inquiryAnswer;
			for(var i = 0; i < txts.length; i++){
				txtid = txts[i].id.substring(txts[i].id.indexOf("_")+1);
				if(idx == txtid){
					//inquiryAnswer = txts[i].value;
					inquiryAnswer = txts[i].value.replace(/(?:\r\n|\r|\n)/g, '<br />');
				}
			}
			return;
			if(!inquiryAnswer) { alert("답변을 작성 후 등록해주세요."); return; }
			const answerData = {
					method: "POST",
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({idx, inquiryAnswer})
			};
			fetch("/console/board/updateInquiryAnswerAsIdx.do", answerData)
				.then(res => res.json())
				.then((data) => {
					if(data.result){
						alert(data.msg);
						location.reload();
					}else{
						alert(data.msg);
					}
				});
		}
		
		function showModifyInquiryAnswer(idx){
			var trs = document.getElementsByName("modifyInquiryAnswerArea");
			var ans = document.getElementsByName("inquiryAnswerValues");
			
			var trid;
			for(var i = 0; i < ans.length; i++) ans[i].style.display = "none";
			for(var i = 0; i < trs.length; i++){
				trid = trs[i].id.substring(trs[i].id.indexOf("_")+1);
				if(idx == trid){
					if(trs[i].style.display == "none") {
						trs[i].style.display = "";
						ans[i].style.display = "none";
					}else{
						trs[i].style.display = "none";
						ans[i].style.display = "none";
					}
				}else{
					trs[i].style.display = "none";
					ans[i].style.display = "none";
				}
			}
		}
		
		function modifyInquiryAnswer(idx){
			var modiTxts = document.getElementsByName("modifyInquiryAnswers");
			var trid;
			var modifyAnswerTxt;
			for(var i = 0; i < modiTxts.length; i++){
				trid = modiTxts[i].id.substring(modiTxts[i].id.indexOf("_")+1);
				if(idx == trid){
					modifyAnswerTxt = modiTxts[i].value.replace(/(?:\r\n|\r|\n)/g, '<br />');
					break;
				}
			}
			const modifyAnswerData = {
					method :"POST",
					headers: {"Content-Type": "application/json"},
					body:JSON.stringify({idx, modifyAnswerTxt})
			};
			fetch("/console/board/modifyInquiryAnswerAsIdx.do", modifyAnswerData)
				.then(res => res.json())
				.then((data) => {
					if(data.result){
						alert(data.msg);
						location.reload();
					}else{
						alert(data.msg);
					}
				});
		}
	</script>
</body>
</html>