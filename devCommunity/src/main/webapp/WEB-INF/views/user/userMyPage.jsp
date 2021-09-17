<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<style>
	input[type="text"], input[type="password"], input[type="button"]{
		width:80% !important;
		margin-bottom:2%;
		margin-right:20%;
	}
	.leftBtn:hover{pointer-events: none !important;}
	fieldset{
		border:0px groove !important;
		width:50%; margin-top:4%;
	}
	div#login_field_wrap{display:flex;}
	div#left_field{width: 33%; padding-left:10%;}
	div#right_field{width: 63%;}
	span#noticeStage{font-size: 12px;}
	span.image.avatar>img{
  		width: 250px;
  		height: 250px;
  		object-fit: cover;
	}
	.saveBtn{margin-right:0 !important;}
</style>
<script type="text/javascript">
	window.onload = function (){
		const cancel = document.querySelector("#cancelBtn");
		cancel.addEventListener("click", function(){
			if(confirm("변경사항을 저장하지 않고 메인화면으로 이동합니다.")){
				location.href="<%=request.getContextPath()%>/user/mainUser.do";
			}
		});
		
		const save = document.querySelector("#saveBtn");
		save.addEventListener("click", function(){
			saveProfile();
		});
		
		document.querySelector("#fileUpload").addEventListener("change", function(){
			const frmData = new FormData();
			const inputFile = document.querySelector("#fileUpload");
			const files = inputFile.files;
			
			frmData.append("uploadFile", files[0]);
			fetch("<%=request.getContextPath()%>/user/userProfileUpload",{
				method: 'POST',
				body: frmData
			}).then(res => res.json())
			.then(data => updateProfile(data));
			
		});
		
		document.querySelector("#escapeBtn").addEventListener("click", function(){
			if(confirm("회원탈퇴 하시겠습니까?\n탈퇴 시 동일계정으로 가입이 불가합니다.")){
				fetch("/user/userEscape.do?idx="+${userBean.user_idx})
					.then(res => res.json())
					.then((data) => {
						
					});
			}
		});

	}
	
	function updateProfile(res){
		if(res.result == true){
			<c:if test="${empty userBean.profile_src}">
				document.getElementById("uploadsrc1").src = ${contextPath}res.src;
			</c:if>
			<c:if test="${not empty userBean.profile_src}">
				document.getElementById("uploadsrc2").src = ${contextPath}res.src;
			</c:if>
		}
	}
	
	function saveProfile(){
		const nick = document.querySelector("#nick_field").value;
		const pw1 = document.querySelector("#pw_field").value;
		const pw2 = document.querySelector("#pw_field2").value;
		var prosrc ;
		<c:if test="${empty userBean.profile_src}">
			prosrc = document.getElementById("uploadsrc1").src;
		</c:if>
		<c:if test="${not empty userBean.profile_src}">
			prosrc = document.getElementById("uploadsrc2").src;
		</c:if>
		
		if(nick == ""){
			alert("닉네임을 입력해주세요.");
			document.querySelector("#nick_field").focus();
			return;
		}
		
		if(pw1 == "" && pw2 == ""){
			// continue
		}else if(pw1 != "" && pw2 == ""){
			alert("비밀번호확인을 입력해주세요.");
			document.querySelector("#pw_field2").focus();
			return;
		}else if(pw1 == "" && pw2 != ""){
			alert("비밀번호를 입력해주세요.");
			document.querySelector("#pw_field").focus();
			return;
		}else{
			if(pw1 != pw2) {alert("입력하신 비밀번호가 일치하지 않습니다."); return;}
			if(!/^[a-zA-Z0-9]{8,15}$/.test(pw1)){
				alert("비밀번호는 영대문자, 영소문자, 숫자를 조합하여 8~15자리를 사용해야 합니다.");
				return;
			}
		}
		
		const profileData = {
				method: 'POST',
				headers: {"Content-Type": "application/json"},
				body: JSON.stringify({nick, pw1, prosrc})
			};
		
		fetch("/user/updateUserProfile", profileData)
		.then((res) => res.json())
		.then(data => moveTo(data));
	}
	
	function moveTo(res){
		if(res.result == true){
			alert(res.msg);
			location.href="<%=request.getContextPath()%>/user/mainUser.do";
		}
		if(res.result == false){
			alert(res.msg);
			return;
		}
	}
</script>
</head>
<body>
	<div align="center">
		<form id="signUpFrm" accept-charset="UTF-8">
			<fieldset>
				<legend align="center" style="font-size:36px;">&nbsp;&nbsp;회원정보수정&nbsp;&nbsp;</legend>
				<br /><br />
				<div id="login_field_wrap">
					<div id="left_field">
						<input class="leftBtn" type="button" value="아이디" style="margin-bottom: 5.5%;" />
						<input class="leftBtn" type="button" value="닉네임" style="margin-bottom: 5.5%;" />
						<input class="leftBtn" type="button" value="비밀번호" style="margin-bottom: 5.5%;" />
						<input class="leftBtn" type="button" value="비밀번호확인" style="margin-bottom: 55.5%;"/>
						<input class="leftBtn" type="button" value="프로필이미지" style="margin-bottom: 15.5%;" />
					</div>
					<div id="center_field" style="width:3%;"></div>
					<div id="right_field">
						<input type="text" id="id_field" value="${userBean.login_id}" readonly/>
						<input type="text" id="nick_field" value="${userBean.nick_name}" />
						<!-- <div align="left" class="inputTxt"><span style="margin-left:10%;">&nbsp;✔︎&nbsp;email 주소가 아이디로 사용됩니다.</span></div> -->
						<input type="password" id="pw_field" placeholder="비밀번호 입력이 없을 시 기존 비밀번호가 유지됩니다." /><!-- oninput="keyup(this.value);" -->
						<!-- <div style="margin-bottom:2%; margin-left:12%;" align="left"><span id="noticeStage">&nbsp;</span></div> -->
						<input type="password" id="pw_field2" placeholder="비밀번호 입력이 없을 시 기존 비밀번호가 유지됩니다." />
						<div style="display: flex;">
							<span class="image avatar" style="float: left; padding-top:2%;">
								<c:if test="${empty userBean.profile_src}">
									<img id="uploadsrc1" class="profileArea" src="<%=request.getContextPath()%>/resources/images/default_profile.png" alt="" />
								</c:if>
								<c:if test="${not empty userBean.profile_src}">
									<img id="uploadsrc2" class="profileArea" src="${contextPath}${userBean.profile_src}" alt="" />
								</c:if>
							</span>
							<input type="file" name="fileUpload" id="fileUpload" style="display: none;" accept="image/*"/>
							<input type="button" id="fileTxt" style="width: 30% !important; margin-top: 40%;" value="사진변경" onclick="document.querySelector('#fileUpload').click()"/>
						</div>
					</div>
				</div>
				<br />
				<div id="saveField" style="margin-top:1%;">
					<input id="saveBtn" class="saveBtn" type="button" style="width:20% !important;" value="저장"/>&nbsp;&nbsp;&nbsp;&nbsp;
					<input id="cancelBtn" class="saveBtn" type="button" style="width:20% !important;" value="취소"/>&nbsp;&nbsp;&nbsp;&nbsp;
					<input id="escapeBtn" class="saveBtn" type="button" style="width:20% !important;" value="회원탈퇴"/>
				</div>
				
				<!-- <div>
					<span style="float:left; margin-left:10%;">비밀번호가 기억이 나지 않으신가요?</span><span style="float:right; margin-right:10%;"><a href="#">비밀번호 찾기</a></span><br />
					<span style="float:left; margin-left:10%;">회원이 아니신가요?</span><span style="float:right; margin-right:10%;"><a href="#" onclick="signUp();">회원가입</a></span><br /><br />
				</div> -->
				
				<br />
			</fieldset>
		</form>
	</div>
</body>
</html>