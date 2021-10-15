/**
 * 
 */


Kakao.init('f11a28cae543113aeeeff3cf384b05ef');
//console.log(Kakao.isInitialized());

function kakaoLogin(){
	
	Kakao.Auth.login({
			success: function(response){
				Kakao.API.request({
					url: "/v2/user/me",
					success: function(response){
						const id = response.kakao_account.email;
						const pw = "";
						const nick = response.kakao_account.profile.nickname;
						const prosrc = response.kakao_account.profile.profile_image_url;
						
						const checkData = {
							method: "POST",
							headers : {"Content-Type": "text/plain"},
							body: JSON.stringify({id, pw, nick, prosrc})
						};
						
						fetch("/userLoginIdCheckAsKakao.do?", checkData) //체크하고 없으면 insert.
							.then(res => res.json())
							.then((data) => {
								console.log(data);
								if(data.result == false) location.href="/";
							});
						const loginFlag = "kakao";
						const loginData = {
							method: "POST",
							headers: {"Content-Type": "application/json"},
							body: JSON.stringify({id, pw, loginFlag})
						};
						fetch("/user/login", loginData)
							.then(res => res.json())
							.then((data) => {
							if(data.result == true) location.href="/user/mainUser.do";
						});
						
					},
					fail: function(error){
						console.log(error);
					},
				})
			},
			fail: function(error){
				console.log(error);
			}
		})
	
}


/*
function kakaoLogin(value){ // 카카오 회원가입, 로그인 로직 분리.
	if(value == "kakaoSign"){ //카카오 회원가입
		if(confirm("카카오회원가입 시 정보의 동의가 필요하며,\n별도의 비밀번호가 저장되지 않습니다.\n사이트 이용 시 카카오로그인으로 이용이 가능합니다.\n진행하시겠습니까?")){
			Kakao.Auth.login({
			success: function(response){
				Kakao.API.request({
					url: "/v2/user/me",
					success: function(response){
						fetch("/user/nickDupleCheck.do?nick="+response.kakao_account.profile.nickname)
							.then(res => res.json())
							.then((data) => {if(data.result != false){}});
						
						const signFlag = "kakao";
						const id = response.kakao_account.email;
						const nick = response.kakao_account.profile.nickname;
						const pw = "";
						const prosrc = response.kakao_account.profile.profile_image_url;
						const kakaoSignData = {
							method: "POST",
							headers: {"Content-Type": "text/plain"},
							body: JSON.stringify({id, nick, pw, prosrc, signFlag})
						};
						fetch("/user/signUpUser", kakaoSignData)
							.then(res => res.json())
							.then((data) => {
								if(data.result == true){
									alert(data.msg);
									top.location.href="/";
								}
							});
					},
					fail: function(error){
						console.log(error);
					},
				})
			},
			fail: function(error){
				console.log(error);
			}
		})
		}
	} else { // 카카오 로그인 처리.
		Kakao.Auth.login({
			success: function(response){
				Kakao.API.request({
					url: "/v2/user/me",
					success: function(response){
						const id = response.kakao_account.email;
						const pw = "";
						const loginFlag = "kakao";
						
						const loginData = {
							method: "POST",
							headers: {"Content-Type": "application/json"},
							body: JSON.stringify({id, pw, loginFlag})
						};
						fetch("/user/login", loginData)
							.then(res => res.json())
							.then((data) => {
								if(data.result == true) location.href="/user/mainUser.do";
							});
					},
					fail: function(error){
						console.log(error);
					},
				})
			},
			fail: function(error){
				console.log(error);
			}
		})
	}
	
}
*/