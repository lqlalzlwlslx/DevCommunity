<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>

<%@ include file="/WEB-INF/views/include/header.jsp" %>
<style>
	input[type="text"], input[type="password"], input[type="button"]{
		width:80% !important;
		margin-bottom:2%;
	}
	fieldset{
		border:0px groove !important;
		width:30%; margin-top:10%;
	}
</style>
<script type="text/javascript">
	window.onload = function(){
		const loginButton = document.querySelector("#loginButton");
		
		loginButton.addEventListener("click", function(){
			loginCheck();
		});
	}
	
	function loginCheck(){
		const id = document.querySelector("#id_field").value;
		const pw = document.querySelector("#pw_field").value;
		
		if(!id) {
			alert("아이디를 입력해주세요.");
			document.querySelector("#id_field").focus();
			return;
		}
		const loginData = {
				method: "POST",
				headers: {"Content-Type": "application/json"},
				body: JSON.stringify({id, pw})
		};
		
		fetch("/user/login", loginData)
			.then(res => res.json())
			.then(data => statusCheck(data));
	}
	function statusCheck(res){
		if(res.result == true) location.href="<%=request.getContextPath()%>/user/mainUser.do";
		else {
			alert(res.msg);
			return;
		}
	}
	
</script>
</head>
<body>

	<div align="center">
		<form>
			<fieldset>
				<legend align="center" style="font-size:36px;">&nbsp;&nbsp;로그인&nbsp;&nbsp;</legend>
				<br /><br />
				<input type="text" id="id_field" placeholder="아이디를 입력하세요." />
				<input type="password" id="pw_field" placeholder="비밀번호를 입력하세요." onKeyPress="if(event.keyCode==13) loginCheck();" /><br />
				
				<input type="button" id="loginButton" value="로그인" /><br />
				<div>
					<span style="float:left; margin-left:10%;">비밀번호가 기억이 나지 않으신가요?</span><span style="float:right; margin-right:10%;"><a href="#">비밀번호 찾기</a></span><br />
					<span style="float:left; margin-left:10%;">회원이 아니신가요?</span><span style="float:right; margin-right:10%;"><a href="#" onclick="signUp();">회원가입</a></span><br /><br />
				</div>
				
				<br />
			</fieldset>
		</form>
	</div>
	
</body>
</html>