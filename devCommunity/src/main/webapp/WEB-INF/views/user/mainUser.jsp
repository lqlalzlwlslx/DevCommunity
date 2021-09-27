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
	span.image.avatar{width:150px !important;}
	table>tbody>tr>td{vertical-align:middle;}
	table>tbody>tr>td>input[type="button"]:hover{pointer-events: none;}
	input[type="radio"] + label{padding-right:2em !important;}
	.container{padding:0 !important;}
	.container-solid{border-top:solid 6px #f4f4f4;}
	.signUpCommunity:hover{cursor:pointer;}
	.communityList { color: #333; text-decoration: none; display: inline-block; padding: 15px 0; position: relative; }
	.communityList:after { background: none repeat scroll 0 0 transparent; bottom: 0; content: ""; display: block; height: 2px;
		left: 50%; position: absolute; background: #b9f; transition: width 0.3s ease 0s, left 0.3s ease 0s; width: 0;
	}
	.communityList:hover:after { width: 100%; left: 0; }
</style>
<script type="text/javascript">
	<c:if test="${empty userBean}">
		location.href="<%=request.getContextPath()%>/";
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
						<!-- <div style="width:35%;" align="right"><a href="#" onclick="signUp();">회원가입</a></div>
						<div style="width:2%;"></div>
						<div style="width:60%;"><a href="#">아이디/비밀번호 찾기</a></div> -->
					</div>
					</c:if>
				</header>
				<c:if test="${not empty userBean }">
				<nav id="nav">
					<ul>
						<li><a href="#" id="userMyPage">마이페이지</a></li>
						<li id="ucLi"><a href="#" id="ucListView">커뮤니티</a></li>
						<c:if test="${empty ucList}">
						<li id="ucEmpty"style="display:none;"><a>현재 가입된 커뮤니티가 없습니다.</a></li>
						</c:if>
						<c:if test="${not empty ucList}">
						<c:forEach items="${ucList}" var="ucList" varStatus="status">
						<li id="ucList_${ucList.comm_idx}" onclick="moveToCommunityView(${ucList.comm_idx})" class="communityList" style="display:none; cursor:pointer;"><a>${ucList.comm_name}<c:if test="${ucList.comm_role_cd == 9}"><span style="margin-left:3em; background-color:">관리</span></c:if></a></li>
						</c:forEach>
						</c:if>
						<li id="communityFrm"><a href="#">커뮤니티 개설</a></li>
						<li style="display:none;"><!-- <button id="commBtn" data-toggle="modal" data-target="#myModal"></button> -->
						<button type="button" id="commBtn" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal"></button></li>
						<li><a href="#" onclick="logout();">로그아웃</a></li>
					</ul>
				</nav>
				</c:if>
				<!-- 
				<footer>
					<ul class="icons">
						<li><a href="#" class="icon brands fa-twitter"><span class="label">Twitter</span></a></li>
						<li><a href="#" class="icon brands fa-facebook-f"><span class="label">Facebook</span></a></li>
						<li><a href="#" class="icon brands fa-instagram"><span class="label">Instagram</span></a></li>
						<li><a href="#" class="icon brands fa-github"><span class="label">Github</span></a></li>
						<li><a href="#" class="icon solid fa-envelope"><span class="label">Email</span></a></li>
					</ul>
				</footer>
				 -->
			</section>

		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Main -->
					<div id="main">

						<!-- One -->
							<section id="one">
								<div class="image main" data-position="center">
									<!-- <img src="/resources/images/banner.jpg" alt="" /> -->
									<div style="width:10%;"></div>
									<!-- <c:if test="${not empty ucList}">
									<div style="width:20%; margin:auto;">
									<select id="searchScopeTxt">
											<option value="0">=== 선택 ===</option>
											<c:forEach items="${ucList}" var="ucList" varStatus="status">
												<option value="${ucList.comm_name}">${ucList.comm_name}</option>
											</c:forEach>
										</select>
									</div>
									</c:if> -->
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
								<div class="container">
									<header class="major">
										<h2>공지사항</h2>
										<p>DevCoummunity에 오신 것을 환영합니다.<br />
										이용 수칙에 관해 잘 읽어주시고 활동해주세요.</p>
									</header>
									<p>공지사항 블라블라<br />이용수칙 블라블라<br /></p>
								</div>
							</section>
						<div class="main-content-area">	
							<div class="container container-solid">
								<header class="major">
									<h2>board_title</h2>
									<!-- <p>DevCoummunity에 오신 것을 환영합니다.<br />
									이용 수칙에 관해 잘 읽어주시고 활동해주세요.</p> -->
								</header>
								<p>board_content</p>
							</div>
						</div>
						<!-- Two -->
							<!-- <section id="two">
								<div class="container">
									<h3>Things I Can Do</h3>
									<p>Integer eu ante ornare amet commetus vestibulum blandit integer in curae ac faucibus integer non. Adipiscing cubilia elementum integer lorem ipsum dolor sit amet.</p>
									<ul class="feature-icons">
										<li class="icon solid fa-code">Write all the code</li>
										<li class="icon solid fa-cubes">Stack small boxes</li>
										<li class="icon solid fa-book">Read books and stuff</li>
										<li class="icon solid fa-coffee">Drink much coffee</li>
										<li class="icon solid fa-bolt">Lightning bolt</li>
										<li class="icon solid fa-users">Shadow clone technique</li>
									</ul>
								</div>
							</section> -->

						<!-- Three -->
							<!-- <section id="three">
								<div class="container">
									<h3>A Few Accomplishments</h3>
									<p>Integer eu ante ornare amet commetus vestibulum blandit integer in curae ac faucibus integer non. Adipiscing cubilia elementum integer. Integer eu ante ornare amet commetus.</p>
									<div class="features">
										<article>
											<a href="#" class="image"><img src="/resources/images/pic01.jpg" alt="" /></a>
											<div class="inner">
												<h4>Possibly broke spacetime</h4>
												<p>Integer eu ante ornare amet commetus vestibulum blandit integer in curae ac faucibus integer adipiscing ornare amet.</p>
											</div>
										</article>
										<article>
											<a href="#" class="image"><img src="/resources/images/pic02.jpg" alt="" /></a>
											<div class="inner">
												<h4>Terraformed a small moon</h4>
												<p>Integer eu ante ornare amet commetus vestibulum blandit integer in curae ac faucibus integer adipiscing ornare amet.</p>
											</div>
										</article>
										<article>
											<a href="#" class="image"><img src="/resources/images/pic03.jpg" alt="" /></a>
											<div class="inner">
												<h4>Snapped dark matter in the wild</h4>
												<p>Integer eu ante ornare amet commetus vestibulum blandit integer in curae ac faucibus integer adipiscing ornare amet.</p>
											</div>
										</article>
									</div>
								</div>
							</section> -->

						<!-- Four -->
							<!-- <section id="four">
								<div class="container">
									<h3>Contact Me</h3>
									<p>Integer eu ante ornare amet commetus vestibulum blandit integer in curae ac faucibus integer non. Adipiscing cubilia elementum integer. Integer eu ante ornare amet commetus.</p>
									<form method="post" action="#">
										<div class="row gtr-uniform">
											<div class="col-6 col-12-xsmall"><input type="text" name="name" id="name" placeholder="Name" /></div>
											<div class="col-6 col-12-xsmall"><input type="email" name="email" id="email" placeholder="Email" /></div>
											<div class="col-12"><input type="text" name="subject" id="subject" placeholder="Subject" /></div>
											<div class="col-12"><textarea name="message" id="message" placeholder="Message" rows="6"></textarea></div>
											<div class="col-12">
												<ul class="actions">
													<li><input type="submit" class="primary" value="Send Message" /></li>
													<li><input type="reset" value="Reset Form" /></li>
												</ul>
											</div>
										</div>
									</form>
								</div>
							</section> -->
							

						<!-- Five -->
						<!--
							<section id="five">
								<div class="container">
									<h3>Elements</h3>

									<section>
										<h4>Text</h4>
										<p>This is <b>bold</b> and this is <strong>strong</strong>. This is <i>italic</i> and this is <em>emphasized</em>.
										This is <sup>superscript</sup> text and this is <sub>subscript</sub> text.
										This is <u>underlined</u> and this is code: <code>for (;;) { ... }</code>. Finally, <a href="#">this is a link</a>.</p>
										<hr />
										<header>
											<h4>Heading with a Subtitle</h4>
											<p>Lorem ipsum dolor sit amet nullam id egestas urna aliquam</p>
										</header>
										<p>Nunc lacinia ante nunc ac lobortis. Interdum adipiscing gravida odio porttitor sem non mi integer non faucibus ornare mi ut ante amet placerat aliquet. Volutpat eu sed ante lacinia sapien lorem accumsan varius montes viverra nibh in adipiscing blandit tempus accumsan.</p>
										<header>
											<h5>Heading with a Subtitle</h5>
											<p>Lorem ipsum dolor sit amet nullam id egestas urna aliquam</p>
										</header>
										<p>Nunc lacinia ante nunc ac lobortis. Interdum adipiscing gravida odio porttitor sem non mi integer non faucibus ornare mi ut ante amet placerat aliquet. Volutpat eu sed ante lacinia sapien lorem accumsan varius montes viverra nibh in adipiscing blandit tempus accumsan.</p>
										<hr />
										<h2>Heading Level 2</h2>
										<h3>Heading Level 3</h3>
										<h4>Heading Level 4</h4>
										<h5>Heading Level 5</h5>
										<h6>Heading Level 6</h6>
										<hr />
										<h5>Blockquote</h5>
										<blockquote>Fringilla nisl. Donec accumsan interdum nisi, quis tincidunt felis sagittis eget tempus euismod. Vestibulum ante ipsum primis in faucibus vestibulum. Blandit adipiscing eu felis iaculis volutpat ac adipiscing accumsan faucibus. Vestibulum ante ipsum primis in faucibus lorem ipsum dolor sit amet nullam adipiscing eu felis.</blockquote>
										<h5>Preformatted</h5>
										<pre><code>i = 0;

while (!deck.isInOrder()) {
    print 'Iteration ' + i;
    deck.shuffle();
    i++;
}

print 'It took ' + i + ' iterations to sort the deck.';</code></pre>
									</section>

									<section>
										<h4>Lists</h4>
										<div class="row">
											<div class="col-6 col-12-xsmall">
												<h5>Unordered</h5>
												<ul>
													<li>Dolor pulvinar etiam magna etiam.</li>
													<li>Sagittis adipiscing lorem eleifend.</li>
													<li>Felis enim feugiat dolore viverra.</li>
												</ul>
												<h5>Alternate</h5>
												<ul class="alt">
													<li>Dolor pulvinar etiam magna etiam.</li>
													<li>Sagittis adipiscing lorem eleifend.</li>
													<li>Felis enim feugiat dolore viverra.</li>
												</ul>
											</div>
											<div class="col-6 col-12-xsmall">
												<h5>Ordered</h5>
												<ol>
													<li>Dolor pulvinar etiam magna etiam.</li>
													<li>Etiam vel felis at lorem sed viverra.</li>
													<li>Felis enim feugiat dolore viverra.</li>
													<li>Dolor pulvinar etiam magna etiam.</li>
													<li>Etiam vel felis at lorem sed viverra.</li>
													<li>Felis enim feugiat dolore viverra.</li>
												</ol>
												<h5>Icons</h5>
												<ul class="icons">
													<li><a href="#" class="icon brands fa-twitter"><span class="label">Twitter</span></a></li>
													<li><a href="#" class="icon brands fa-facebook-f"><span class="label">Facebook</span></a></li>
													<li><a href="#" class="icon brands fa-instagram"><span class="label">Instagram</span></a></li>
													<li><a href="#" class="icon brands fa-github"><span class="label">Github</span></a></li>
													<li><a href="#" class="icon brands fa-dribbble"><span class="label">Dribbble</span></a></li>
													<li><a href="#" class="icon brands fa-tumblr"><span class="label">Tumblr</span></a></li>
												</ul>
											</div>
										</div>
										<h5>Actions</h5>
										<ul class="actions">
											<li><a href="#" class="button primary">Default</a></li>
											<li><a href="#" class="button">Default</a></li>
											<li><a href="#" class="button alt">Default</a></li>
										</ul>
										<ul class="actions small">
											<li><a href="#" class="button primary small">Small</a></li>
											<li><a href="#" class="button small">Small</a></li>
											<li><a href="#" class="button alt small">Small</a></li>
										</ul>
										<div class="row">
											<div class="col-3 col-6-medium col-12-xsmall">
												<ul class="actions stacked">
													<li><a href="#" class="button primary">Default</a></li>
													<li><a href="#" class="button">Default</a></li>
													<li><a href="#" class="button alt">Default</a></li>
												</ul>
											</div>
											<div class="col-3 col-6 col-12-xsmall">
												<ul class="actions stacked">
													<li><a href="#" class="button primary small">Small</a></li>
													<li><a href="#" class="button small">Small</a></li>
													<li><a href="#" class="button alt small">Small</a></li>
												</ul>
											</div>
											<div class="col-3 col-6-medium col-12-xsmall">
												<ul class="actions stacked">
													<li><a href="#" class="button primary fit">Default</a></li>
													<li><a href="#" class="button fit">Default</a></li>
													<li><a href="#" class="button alt fit">Default</a></li>
												</ul>
											</div>
											<div class="col-3 col-6-medium col-12-xsmall">
												<ul class="actions stacked">
													<li><a href="#" class="button primary small fit">Small</a></li>
													<li><a href="#" class="button small fit">Small</a></li>
													<li><a href="#" class="button alt small fit">Small</a></li>
												</ul>
											</div>
										</div>
									</section>

									<section>
										<h4>Table</h4>
										<h5>Default</h5>
										<div class="table-wrapper">
											<table>
												<thead>
													<tr>
														<th>Name</th>
														<th>Description</th>
														<th>Price</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>Item One</td>
														<td>Ante turpis integer aliquet porttitor.</td>
														<td>29.99</td>
													</tr>
													<tr>
														<td>Item Two</td>
														<td>Vis ac commodo adipiscing arcu aliquet.</td>
														<td>19.99</td>
													</tr>
													<tr>
														<td>Item Three</td>
														<td> Morbi faucibus arcu accumsan lorem.</td>
														<td>29.99</td>
													</tr>
													<tr>
														<td>Item Four</td>
														<td>Vitae integer tempus condimentum.</td>
														<td>19.99</td>
													</tr>
													<tr>
														<td>Item Five</td>
														<td>Ante turpis integer aliquet porttitor.</td>
														<td>29.99</td>
													</tr>
												</tbody>
												<tfoot>
													<tr>
														<td colspan="2"></td>
														<td>100.00</td>
													</tr>
												</tfoot>
											</table>
										</div>

										<h5>Alternate</h5>
										<div class="table-wrapper">
											<table class="alt">
												<thead>
													<tr>
														<th>Name</th>
														<th>Description</th>
														<th>Price</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>Item One</td>
														<td>Ante turpis integer aliquet porttitor.</td>
														<td>29.99</td>
													</tr>
													<tr>
														<td>Item Two</td>
														<td>Vis ac commodo adipiscing arcu aliquet.</td>
														<td>19.99</td>
													</tr>
													<tr>
														<td>Item Three</td>
														<td> Morbi faucibus arcu accumsan lorem.</td>
														<td>29.99</td>
													</tr>
													<tr>
														<td>Item Four</td>
														<td>Vitae integer tempus condimentum.</td>
														<td>19.99</td>
													</tr>
													<tr>
														<td>Item Five</td>
														<td>Ante turpis integer aliquet porttitor.</td>
														<td>29.99</td>
													</tr>
												</tbody>
												<tfoot>
													<tr>
														<td colspan="2"></td>
														<td>100.00</td>
													</tr>
												</tfoot>
											</table>
										</div>
									</section>

									<section>
										<h4>Buttons</h4>
										<ul class="actions">
											<li><a href="#" class="button primary">Primary</a></li>
											<li><a href="#" class="button">Default</a></li>
											<li><a href="#" class="button alt">Alternate</a></li>
										</ul>
										<ul class="actions">
											<li><a href="#" class="button primary large">Large</a></li>
											<li><a href="#" class="button">Default</a></li>
											<li><a href="#" class="button alt small">Small</a></li>
										</ul>
										<ul class="actions fit">
											<li><a href="#" class="button primary fit">Fit</a></li>
											<li><a href="#" class="button fit">Fit</a></li>
											<li><a href="#" class="button alt fit">Fit</a></li>
										</ul>
										<ul class="actions fit small">
											<li><a href="#" class="button primary fit small">Fit + Small</a></li>
											<li><a href="#" class="button fit small">Fit + Small</a></li>
											<li><a href="#" class="button alt fit small">Fit + Small</a></li>
										</ul>
										<ul class="actions">
											<li><a href="#" class="button primary icon solid fa-download">Icon</a></li>
											<li><a href="#" class="button icon solid fa-download">Icon</a></li>
											<li><a href="#" class="button alt icon solid fa-check">Icon</a></li>
										</ul>
										<ul class="actions">
											<li><span class="button primary disabled">Primary</span></li>
											<li><span class="button disabled">Default</span></li>
											<li><span class="button alt disabled">Alternate</span></li>
										</ul>
									</section>

									<section>
										<h4>Form</h4>
										<form method="post" action="#">
											<div class="row gtr-uniform">
												<div class="col-6 col-12-xsmall">
													<input type="text" name="demo-name" id="demo-name" value="" placeholder="Name" />
												</div>
												<div class="col-6 col-12-xsmall">
													<input type="email" name="demo-email" id="demo-email" value="" placeholder="Email" />
												</div>
												<div class="col-12">
													<select name="demo-category" id="demo-category">
														<option value="">- Category -</option>
														<option value="1">Manufacturing</option>
														<option value="1">Shipping</option>
														<option value="1">Administration</option>
														<option value="1">Human Resources</option>
													</select>
												</div>
												<div class="col-4 col-12-medium">
													<input type="radio" id="demo-priority-low" name="demo-priority" checked>
													<label for="demo-priority-low">Low Priority</label>
												</div>
												<div class="col-4 col-12-medium">
													<input type="radio" id="demo-priority-normal" name="demo-priority">
													<label for="demo-priority-normal">Normal Priority</label>
												</div>
												<div class="col-4 col-12-medium">
													<input type="radio" id="demo-priority-high" name="demo-priority">
													<label for="demo-priority-high">High Priority</label>
												</div>
												<div class="col-6 col-12-medium">
													<input type="checkbox" id="demo-copy" name="demo-copy">
													<label for="demo-copy">Email me a copy of this message</label>
												</div>
												<div class="col-6 col-12-medium">
													<input type="checkbox" id="demo-human" name="demo-human" checked>
													<label for="demo-human">I am a human and not a robot</label>
												</div>
												<div class="col-12">
													<textarea name="demo-message" id="demo-message" placeholder="Enter your message" rows="6"></textarea>
												</div>
												<div class="col-12">
													<ul class="actions">
														<li><input type="submit" value="Send Message" /></li>
														<li><input type="reset" value="Reset" class="alt" /></li>
													</ul>
												</div>
											</div>
										</form>
									</section>

									<section>
										<h4>Image</h4>
										<h5>Fit</h5>
										<span class="image fit"><img src="images/banner.jpg" alt="" /></span>
										<div class="box alt">
											<div class="row gtr-50 gtr-uniform">
												<div class="col-4"><span class="image fit"><img src="images/pic01.jpg" alt="" /></span></div>
												<div class="col-4"><span class="image fit"><img src="images/pic02.jpg" alt="" /></span></div>
												<div class="col-4"><span class="image fit"><img src="images/pic03.jpg" alt="" /></span></div>
												<div class="col-4"><span class="image fit"><img src="images/pic02.jpg" alt="" /></span></div>
												<div class="col-4"><span class="image fit"><img src="images/pic03.jpg" alt="" /></span></div>
												<div class="col-4"><span class="image fit"><img src="images/pic01.jpg" alt="" /></span></div>
												<div class="col-4"><span class="image fit"><img src="images/pic03.jpg" alt="" /></span></div>
												<div class="col-4"><span class="image fit"><img src="images/pic01.jpg" alt="" /></span></div>
												<div class="col-4"><span class="image fit"><img src="images/pic02.jpg" alt="" /></span></div>
											</div>
										</div>
										<h5>Left &amp; Right</h5>
										<p><span class="image left"><img src="images/avatar.jpg" alt="" /></span>Fringilla nisl. Donec accumsan interdum nisi, quis tincidunt felis sagittis eget. tempus euismod. Vestibulum ante ipsum primis in faucibus vestibulum. Blandit adipiscing eu felis iaculis volutpat ac adipiscing accumsan eu faucibus. Integer ac pellentesque praesent tincidunt felis sagittis eget. tempus euismod. Vestibulum ante ipsum primis in faucibus vestibulum. Blandit adipiscing eu felis iaculis volutpat ac adipiscing accumsan eu faucibus. Integer ac pellentesque praesent. Donec accumsan interdum nisi, quis tincidunt felis sagittis eget. tempus euismod. Vestibulum ante ipsum primis in faucibus vestibulum. Blandit adipiscing eu felis iaculis volutpat ac adipiscing accumsan eu faucibus. Integer ac pellentesque praesent tincidunt felis sagittis eget. tempus euismod. Vestibulum ante ipsum primis in faucibus vestibulum. Blandit adipiscing eu felis iaculis volutpat ac adipiscing accumsan eu faucibus. Integer ac pellentesque praesent.</p>
										<p><span class="image right"><img src="images/avatar.jpg" alt="" /></span>Fringilla nisl. Donec accumsan interdum nisi, quis tincidunt felis sagittis eget. tempus euismod. Vestibulum ante ipsum primis in faucibus vestibulum. Blandit adipiscing eu felis iaculis volutpat ac adipiscing accumsan eu faucibus. Integer ac pellentesque praesent tincidunt felis sagittis eget. tempus euismod. Vestibulum ante ipsum primis in faucibus vestibulum. Blandit adipiscing eu felis iaculis volutpat ac adipiscing accumsan eu faucibus. Integer ac pellentesque praesent. Donec accumsan interdum nisi, quis tincidunt felis sagittis eget. tempus euismod. Vestibulum ante ipsum primis in faucibus vestibulum. Blandit adipiscing eu felis iaculis volutpat ac adipiscing accumsan eu faucibus. Integer ac pellentesque praesent tincidunt felis sagittis eget. tempus euismod. Vestibulum ante ipsum primis in faucibus vestibulum. Blandit adipiscing eu felis iaculis volutpat ac adipiscing accumsan eu faucibus. Integer ac pellentesque praesent.</p>
									</section>

								</div>
							</section>
						-->

					</div>

				<!-- Footer -->
				<section id="footer" >
					<div class="container" align="center">
						<ul class="copyright">
							<li>&copy; Untitled. All rights reserved.</li><li>Design: <a href="http://html5up.net">HTML5 UP</a></li>
						</ul>
					</div>
				</section>
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
							<td colspan="3"><textarea style="resize: none;" rows="2" id="communityIntro" placeholder="소개글을 작성해주세요."></textarea></td>
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
			
<!-- Modal Community개설...여기서 처리할까?--><%-- 
<div class="modal fade" id="myModal" role="dialog" >
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">커뮤니티 개설</h4>
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
							<td><input type="text" /></td>
							<td></td>
							<td><a><input type="button" value="중복체크" style="width:70%;"/></a></td>
						</tr>
						<tr>
							<td><input type="button" value="카테고리 선택" /></td>
							<td></td>
							<td colspan="3">
								<input type="radio" id="categoryJava" name="communityCategory" value="Java"/><label for="categoryJava">Java</label>
								<input type="radio" id="categoryC" name="communityCategory" value="C"/><label for="categoryC">C</label>
								<input type="radio" id="categoryPython" name="communityCategory" value="Python"/><label for="categoryPython">Python</label>
								<input type="radio" id="categoryDatabase" name="communityCategory" value="Database"/><label for="categoryDatabase">Database</label>
							</td>
						</tr>
						<tr>
							<td><input type="button" value="커뮤니티 개설사유" /></td>
							<td></td>
							<td colspan="3"><textarea style="resize: none;" rows="5" placeholder="사유를 입력해주세요."></textarea></td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div> --%>
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
	</script>


</body>
</html>