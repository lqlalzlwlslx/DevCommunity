<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>

<%@ include file="/WEB-INF/views/include/header.jsp" %>
<style>
	input[type="text"], input[type="password"], input[type="button"]{
		width:90% !important;
	}
	.leftBtn:hover{pointer-events: none !important;}
	fieldset{
		border:0px groove !important;
		width:55%; margin-top:4%;
	}
	span.image.avatar>img{
  		width: 150px;
  		height: 150px;
  		object-fit: cover;
	}
	#cancelButton, #signUpButton{
		width:35% !important;
	}
	.signTd{vertical-align:middle; padding: 0.25em 0.25em;}
</style>

<script type="text/javascript">
	window.onload = function(){
		
		var passedCode;
		
		const submit = document.querySelector("#signUpButton");
		submit.addEventListener("click", function(){
			//console.log('submit click');
			const id = document.querySelector("#id_field").value;
			const nick = document.querySelector("#nick_field").value;
			const pw = document.querySelector("#pw_field").value;
			const pw2 = document.querySelector("#pw_field2").value;
			var prosrc = document.getElementById("prosrc").src;
			let secondMail = document.querySelector("#secondEmailField").value;
			
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
			
			if(document.querySelector("#authCode").innerHTML != "인증완료"){
				alert('인증번호가 일치하지 않습니다. 다시 확인해주세요.');
				return;
			}
			
			if(!secondMail) {secondMail = "";}
			const signFlag = "normal";
			const signData = {
					method: 'POST',
					headers: {"Content-Type": "application/json"},
					body: JSON.stringify({id, nick, pw, prosrc, signFlag, secondMail})
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
		
		document.querySelector("#cancelButton").addEventListener("click", function(){
			if(confirm("메인페이지로 돌아가시겠습니까?")){
				location.href="<%=request.getContextPath()%>/";
			}
		});
		
	}
	function showProfile(res){
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
	
	function authSend(){
		const mailto = document.querySelector("#id_field").value;
		if(!mailto){ alert("이메일을 입력해주세요."); document.querySelector("#id_field").focus(); return; }
		
		const sendData = {
				method: "POST",
				headers: {"Content-Type": "application/json"},
				body: JSON.stringify({mailto})
		};
		
		fetch("/user/sendAuthCode.do", sendData)
			.then(res => res.json())
			.then(data => remaining(data));
	}
	var authsetId;
	function remaining(res){
		if(res.result == true){
			alert("인증번호를 전송했습니다. 메일을 확인해주세요.");
			passedCode = res.passcode.substring(0, res.passcode.indexOf("|"));
			
			var elem = document.getElementById("authCode");
			var remains = 180;
			authsetId = setInterval(frame, 1000);
			function frame(){
				if(remains <= 0){
					clearInterval(authsetId);
					elem.innerHTML = '인증시간만료. 다시 시도해주세요.';
					return;
				} else {
					remains --;
					elem.innerHTML = remains + '초';
				}
			}
		}
	}
	
	function authSendCheck(){
		var inputAuthCode = document.getElementById("authCodeTxt").value;
		if(!inputAuthCode) { alert("인증번호를 입력해주세요."); document.querySelector("#authCodeTxt").focus(); return; }
		
		if(inputAuthCode == passedCode){
			clearInterval(authsetId);
			document.getElementById("authCode").innerHTML = "인증완료";
			document.getElementById("id_field").readOnly = true;
		} else {
			alert("인증번호가 틀립니다. 다시 확인해주세요.");
			document.querySelector("#authCodeTxt").focus();
			return;
		}
	}
	
	function dupleCheckNick(value){
		fetch("/user/nickDupleCheck.do?nick="+value)
			.then(res => res.json())
			.then(data => moveTo(data));
	}
	function moveTo(res){
		if(res.result == true){
			alert(res.msg);
		}else{
			alert(res.msg);
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
				<table>
				<%-- <colgroup>
					<col width="20%">
					<col width="40%">
					<col width="20%">
					<col width="20%">
				</colgroup> --%>
					<tbody>
						<tr>
							<td class="signTd"><input class="leftBtn" type="button" value="아이디"/></td>
							<td colspan="2" class="signTd"><input type="text" id="id_field" placeholder="이메일 주소가 아이디로 사용됩니다." /></td>
							<td class="signTd"><input type="button" value="인증번호 발송" onclick="authSend();"/></td>
						</tr>
						<tr>
							<td class="signTd"></td>
							<td class="signTd"><input type="text" id="authCodeTxt" placeholder="인증번호를 입력해주세요." /></td>
							<td class="signTd"><span id="authCode"></span></td>
							<td class="signTd"><input type="button" value="인증번호 확인" onclick="authSendCheck();"/></td>
						</tr>
						<tr>
							<td class="signTd"><input class="leftBtn" type="button" value="닉네임"/></td>
							<td colspan="2" class="signTd"><input type="text" id="nick_field" placeholder="닉네임을 입력해주세요." /></td>
							<td class="signTd"><input type="button" value="중복체크" onclick="dupleCheckNick(document.querySelector('#nick_field').value);"/></td>
						</tr>
						<tr>
							<td class="signTd"><input class="leftBtn" type="button" value="비밀번호"/></td>
							<td colspan="2" class="signTd"><input type="password" id="pw_field" placeholder="대문자, 소문자, 숫자를 조합하여 8~15자리로 입력하세요." /></td>
							<td class="signTd"></td>
						</tr>
						<tr>
							<td class="signTd"><input class="leftBtn" type="button" value="비밀번호확인"/></td>
							<td colspan="2" class="signTd"><input type="password" id="pw_field2" placeholder="대문자, 소문자, 숫자를 조합하여 8~15자리로 입력하세요." /></td>
							<td class="signTd"></td>
						</tr>
						<tr>
							<td class="signTd"><input class="leftBtn" type="button" value="프로필이미지"/></td>
							<td colspan="2" class="signTd" align="right">
								<span class="image avatar" style="margin-right: 10%;">
									<img id="prosrc" src="<%=request.getContextPath()%>/resources/images/default_profile.png" alt="" />
								</span></td>
							<td class="signTd">
								<input type="file" id="fileUpload" style="display: none;" accept="image/*" />
								<input type="button" value="사진추가" onclick="document.querySelector('#fileUpload').click()" />
							</td>
						</tr>
						<tr>
							<td class="signTd"><input type="button" class="leftBtn" value="2차이메일" /></td>
							<td class="signTd" colspan="3"><input type="email" id="secondEmailField" placeholder="필수입력 값은 아닙니다. 하지만 아이디를 잊어버린 경우 정보를 찾을 때 사용됩니다." /></td>
						</tr>
						<tr>
							<td class="signTd"></td>
							<td colspan="2" class="signTd">
								<input type="button" id="cancelButton" value="취소" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="button" id="signUpButton" value="회원가입신청" /><br /></td>
							<td class="signTd"></td>
						</tr>
						<!-- <tr>
							<td class="signTd"></td>
							<td class="signTd"></td>
							<td class="signTd" onclick="kakaoLogin('kakaoSign');"><input type="button" value="카카오회원가입" /></td>
							<td class="signTd"><input type="button" value="카카오회원가입" /></td>
						</tr> -->
					</tbody>
				</table>
				<!-- <br /><br />
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
						<input class="rightBtn" type="password" id="pw_field" placeholder="대문자,소문자,숫자를 조합하여 8~15자리로 입력하세요." />
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
				
				<div>
					<span style="float:left; margin-left:10%;">비밀번호가 기억이 나지 않으신가요?</span><span style="float:right; margin-right:10%;"><a href="#">비밀번호 찾기</a></span><br />
					<span style="float:left; margin-left:10%;">회원이 아니신가요?</span><span style="float:right; margin-right:10%;"><a href="#" onclick="signUp();">회원가입</a></span><br /><br />
				</div>
				
				<br /> -->
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