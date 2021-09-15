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
					console.log(response);
					console.log("");
					console.log(response.kakao_account);
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