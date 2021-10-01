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
	/*div{height: 50%;}*/
	#wrapper{height: 100%; padding: 0 9em 0 9em; width: 100%; }
	.flex_container{
		display: flex;
		flex-direction: row;
		justify-content: center;
		align-items: center;
		height: 100%;
	}
	.flex_item1, .flex_item2{
		flex: 1;
		overflow: auto;
		align: center;
		padding: 0 1.5em 10.5em 1.5em;
	}
	.findSecondMail, .findPasswd{vertical-align:middle;}
	#mainBtn{ font-size: 1.5em; padding: 0.5em 0 0 1.5em; }
</style>
<script type="text/javascript">

	let authCodeStatus = false;
	let passedCode;
	
	function findCancel(){
		if(confirm("취소하고 메인페이지로 돌아갑니다.")){
			location.href="<%=request.getContextPath()%>/";
		}
	}
	
	function findLoginId(){
		const secondMail = document.querySelector("#second_mail").value;
		if(!secondMail){
			alert("2차이메일을 입력해주세요.");
			document.querySelector("#second_mail").focus();
			return;
		}
		
		const secondMailData = {
				method: "POST",
				headers: {"Content-Type": "application/json"},
				body: JSON.stringify({secondMail})
		};
		
		fetch("/findLoginIdAsSecondMail", secondMailData)
			.then(res => res.json())
			.then((data) => {
				if(data.result == true){
					alert("입력하신 주소로 메일이 발송되었습니다.\n메일을 확인해주세요.");
				}else{
					//alert("2차이메일로 등록되어있는 계정이 없습니다.");
					alert(data.msg);
				}
			});
	}
	
	function authSend(){
		const mailto = document.querySelector("#login_id").value;
		if(!mailto){ alert("이메일을 입력해주세요."); document.querySelector("#login_id").focus(); return; }
		
		const sendData = {
				method: "POST",
				headers: {"Content-Type": "text/plain;charset-UTF8"},
				body: JSON.stringify({mailto})
		};
		
		fetch("/findPasswdAsLoginIdAuth.do", sendData)
			.then(res => res.json())
			.then(data => remaining(data));
	}
	
	let authSetId;
	function remaining(res){
		if(res.result == true){
			alert("인증번호를 발송했습니다. 메일을 확인해주세요.");
			passedCode = res.passcode.substring(0, res.passcode.indexOf("|"));
			
			let elem = document.getElementById("authCodeCheck");
			let remains = 180;
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
		}else{
			alert(res.msg);
		}
	}
	
	function authSendCheck(){
		let inputAuthCode = document.getElementById("authCodeTxt").value;
		if(!inputAuthCode) { alert("인증번호를 입력해주세요."); document.querySelector("#authCodeTxt").focus(); return; }
		
		if(inputAuthCode == passedCode){
			clearInterval(authsetId);
			document.getElementById("authCodeCheck").innerHTML = "인증완료";
			
			authCodeStatus = true;
		} else {
			alert("인증번호가 틀립니다. 다시 확인해주세요.");
			document.querySelector("#authCodeTxt").focus();
			return;
		}
	}
	
	function saveChangePasswd(){
		if(authCodeStatus == false){
			alert("인증번호가 확인되지 않았습니다."); return;
		}
		const login_id = document.querySelector("#login_id").value;
		const new_passwd = document.querySelector("#new_passwd").value;
		const new_passwd2 = document.querySelector("#new_passwd2").value;
		
		if(!login_id) {alert("이메일이 입력되지 않았습니다."); document.querySelector("#login_id").focus(); return; }
		if(new_passwd != new_passwd2){ alert("입력하신 비밀번호가 일치하지 않습니다."); return; }
		if(!/^[a-zA-Z0-9]{8,15}$/.test(new_passwd)){
			alert("비밀번호는 영대문자, 영소문자, 숫자를 조합하여 8~15자리를 사용해야 합니다.");
			return;
		}
		
		const findData = {
				method: "POST",
				headers: {"Content-Type": "application/json"},
				body: JSON.stringify({login_id, new_passwd})
		};
		
		fetch("/chagenPasswdAsFindNewPasswd.do", findData)
			.then(res => res.json())
			.then((data) => {
				if(data.result == true){
					alert(data.msg);
					moveToMain();
				}else{
					alert(data.msg);
				}
			});
		
		
	}
</script>
</head>
<body>
<div id="mainBtn" onclick="moveToMain();"><span><a href="#">메인으로 가기</a></span></div>


	<div id="wrapper">
		<div id="main" class="flex_container" align="center">
			
			<div class="flex_item1" style="padding-bottom: 24.42em !important;">
				<h2>아이디 찾기</h2>
				<table>
					<tbody>
						<tr>
							<td class="findSecondMail" align="center"><span>2차이메일</span></td>
							<td class="findSecondMail" align="center" colspan="2"><input type="email" id="second_mail" name="second_mail" placeholder="가입시 작성한 2차이메일 주소를 입력하세요."/></td>
						</tr>
						<tr>
							<td class="findSecondMail" align="center"></td>
							<td class="findSecondMail" align="center" onclick="findLoginId();"><input type="button" name="find_button" value="메일 전송" style="width:100%;"/></td>
							<td class="findSecondMail" align="center" onclick="findCancel();"><input type="button" name="find_cancel" value="취소" style="width:100%;" /></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="flex_item2">
				<h2>비밀번호 찾기</h2>
				<table>
					<tbody>
						<tr>
							<td class="findPasswd" align="center"><span>아이디</span></td>
							<td class="findPasswd" align="center" colspan="2"><input type="email" name="login_id" id="login_id" placeholder="로그인 아이디를 입력하세요." /></td>
							<td class="findPasswd" align="center"><input type="button" value="인증번호 발송" onclick="authSend();"/></td>
						</tr>
						<tr>
							<td class="findPasswd" align="center"><span>인증번호</span></td>
							<td class="findPasswd"><input type="text" name="authCode" id="authCodeTxt" style="width:60%;"/></td>
							<td class="findPasswd" style="width:5em;"><span id="authCodeCheck"></span></td>
							<td class="findPasswd" align="center"><input type="button" value="인증번호 확인" onclick="authSendCheck();"/></td>
						</tr>
						<tr>
							<td class="findPasswd" align="center"><span>비밀번호</span></td>
							<td class="findPasswd" align="center" colspan="3"><input type="password" name="new_passwd" id="new_passwd" /></td>
						</tr>
						<tr>
							<td class="findPasswd" align="center"><span>비밀번호<br />확인</span></td>
							<td class="findPasswd" align="center" colspan="3"><input type="password" name="new_passwd2" id="new_passwd2" /></td>
						</tr>
						<tr>
							<td class="findPasswd" align="center"></td>
							<td class="findPasswd" align="center" colspan="2" onclick="saveChangePasswd();"><input type="button" id="saveBtn" value="저장하기" style="width:100%;"/></td>
							<td class="findPasswd" align="center" onclick="findCancel();"><input type="button" id="cancelBtn" value="취소" style="width:100%;"/></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>


</body>
</html>