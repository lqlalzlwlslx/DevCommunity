<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<style>
	input[type="text"], input[type="password"], input[type="button"]{
		width:80% !important;
		margin-bottom:2%;
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
	.rightBtn{margin-right:10% !important;}
</style>
<script type="text/javascript">
	window.onload = function(){
		const submit = document.querySelector("#signUpButton");
		submit.addEventListener("click", function(){
			//console.log('submit click');
			const id = document.querySelector("#id_field").value;
			const nick = document.querySelector("#nick_field").value;
			const pw = document.querySelector("#pw_field").value;
			const pw2 = document.querySelector("#pw_field2").value;
			var prosrc = document.getElementById("prosrc").src;
			
			//if(!(id.indexOf("@") > -1)) {alert("올바른 이메일 주소를 입력해주세요."); return;}
			
			if(!id){alert("아이디를 입력해주세요."); document.querySelector("#id_field").focus(); return;}
			if(!nick){alert("닉네임을 입력해주세요."); document.querySelector("#nick_field").focus(); return;}
			if(!pw){alert("비밀번호를 입력해주세요."); document.querySelector("#pw_field").focus(); return;}
			if(!pw2){alert("비밀번호확인을 입력해주세요."); document.querySelector("#pw_field2").focus(); return;}
			
			if(pw != pw2){alert("입력하신 비밀번호가 일치하지 않습니다."); return;}
			if(!/^[a-zA-Z0-9]{8,15}$/.test(pw)){
				alert("비밀번호는 영대문자, 영소문자, 숫자를 조합하여 8~15자리를 사용해야 합니다.");
				return;
			}
			
			const signData = {
					method: 'POST',
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({id, nick, pw, prosrc})
			};
			
			fetch("/user/signUpUser", signData)
				.then((res) => res.json())
				.then(data => signStatus(data));
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
			.then(data => showProfile(data));
		});
		
	}
	function showProfile(res){
		console.log(res);
		if(res.result == true){
			document.getElementById("prosrc").src = ${contextPath}res.src;
		}
	}
	function signStatus(res){
		if(res.result == true){
			alert(res.msg);
			top.location.href="<%=request.getContextPath()%>/";
		} else {
			alert(res.msg);
			return;
		}
	}
</script>
</head>
<body>
	<div align="center">
		<form id="signUpFrm">
			<fieldset>
				<legend align="center" style="font-size:36px;">&nbsp;&nbsp;회원가입&nbsp;&nbsp;</legend>
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
						<input class="rightBtn" type="text" id="id_field" placeholder="이메일 주소가 아이디로 사용됩니다." />
						<input class="rightBtn" type="text" id="nick_field" placeholder="닉네임을 입력해주세요." />
						<!-- <div align="left" class="inputTxt"><span style="margin-left:10%;">&nbsp;✔︎&nbsp;email 주소가 아이디로 사용됩니다.</span></div> -->
						<input class="rightBtn" type="password" id="pw_field" placeholder="대문자,소문자,숫자를 조합하여 8~15자리로 입력하세요." /><!-- oninput="keyup(this.value);" -->
						<!-- <div style="margin-bottom:2%; margin-left:12%;" align="left"><span id="noticeStage">&nbsp;</span></div> -->
						<input class="rightBtn" type="password" id="pw_field2" placeholder="대문자,소문자,숫자를 조합하여 8~15자리로 입력하세요." />
						<div style="display: flex;">
							<span class="image avatar" style="float: left; padding-top:2%;">
								<img id="prosrc" src="<%=request.getContextPath()%>/resources/images/default_profile.png" alt="" />
							</span>
							<input type="file" id="fileUpload" style="display: none;" accept="image/*"/>
							<input type="button" style="width: 38% !important; margin-top: 40%;" value="사진추가" onclick="document.querySelector('#fileUpload').click()"/>
						</div>
					</div>
				</div>
				<br />
				<input type="button" id="signUpButton" value="회원가입신청" style="width: 78% !important; margin-left: 2%;" /><br />
				
				<!-- <div>
					<span style="float:left; margin-left:10%;">비밀번호가 기억이 나지 않으신가요?</span><span style="float:right; margin-right:10%;"><a href="#">비밀번호 찾기</a></span><br />
					<span style="float:left; margin-left:10%;">회원이 아니신가요?</span><span style="float:right; margin-right:10%;"><a href="#" onclick="signUp();">회원가입</a></span><br /><br />
				</div> -->
				
				<br />
			</fieldset>
		</form>
	</div>
	
	<!-- <section id="footer" >
		<div class="container" align="center">
			<ul class="copyright">
				<li>&copy; Untitled. All rights reserved.</li><li>Design: <a href="http://html5up.net">HTML5 UP</a></li>
			</ul>
		</div>
	</section> -->
</body>
</html>