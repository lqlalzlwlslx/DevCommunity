package com.dev.comm.user.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.dev.comm.board.service.BoardService;
import com.dev.comm.board.vo.Board;
import com.dev.comm.board.vo.Inquiry;
import com.dev.comm.common.base.Email;
import com.dev.comm.common.base.EmailSender;
import com.dev.comm.common.service.UserAccessLogService;
import com.dev.comm.common.vo.BlackList;
import com.dev.comm.common.vo.Conf;
import com.dev.comm.common.vo.UserAccessLog;
import com.dev.comm.community.service.CommunityService;
import com.dev.comm.community.vo.Community;
import com.dev.comm.community.vo.CommunityUser;
import com.dev.comm.user.service.UserService;
import com.dev.comm.user.vo.User;
import com.dev.comm.util.Constants;
import com.dev.comm.util.SessionManager;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Controller
public class UserController {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private CommunityService communityService;
	
	@Autowired
	private UserAccessLogService userAccessLogService;
	
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	private BoardService boardService;
	
	@Autowired
	private Environment env;
	
	private String mailFrom;
	private String mailTo;
	private String mailSubject;
	private String mailContent;
	private String mailContentType = "text/html";
	
	@Autowired(required=true)
	private EmailSender mailSender;
	
	@RequestMapping(value = "/user/login", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String userLogin(HttpServletRequest request, HttpServletResponse response, Model model, @RequestBody String data) throws Exception {
		log.info("=== userLogin ===");
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		JsonObject obj = new JsonObject();
		
		String login_id = element.getAsJsonObject().get("id").getAsString();
		String password = element.getAsJsonObject().get("pw").getAsString();
		String loginFlag = element.getAsJsonObject().get("loginFlag").getAsString();
		
		User tmpUser = new User();
		tmpUser.setLogin_id(login_id);
		tmpUser = userService.selectUserInfoAsLogin(tmpUser);
		
		if((login_id == null || password == null) && loginFlag.equals("normal")) {
			obj.addProperty("result", false);
			return obj.toString();
		}else {
			//log.debug(tmpUser == null ? "true" : "false");
			if(tmpUser != null && loginFlag.equals("kakao")) {
				boolean kakaoResult = authentication(request, tmpUser, loginFlag);
				if(kakaoResult) {
					obj.addProperty("result", true);
					return obj.toString();
				}
			}
		}
		tmpUser = null;
		User user = new User();
		user.setLogin_id(login_id);
		
//		String msg = "";
		boolean result = false;
		User tUser = userService.selectUserInfoAsLogin(user);
		
		if(tUser != null && !tUser.getUser_stat_cd().equals("T")) {
			result = true;
			if(tUser.getUser_role_cd() == 99 && tUser.getPassword().equals("mismatchadmin")) {
				User usr01 = new User();
				usr01.setPassword(passwordEncoder.encode(password));
				usr01.setUser_idx(tUser.getUser_idx());
				userService.updateUserInfo(usr01);
				result = true;
			}
			if(!passwordEncoder.matches(password, tUser.getPassword())) {
				result = false;
				
				UserAccessLog ual = new UserAccessLog();
				ual.setAccess_ip(request.getRemoteAddr());
				ual.setAccess_status("F");
				ual.setLogin_id(tUser.getPassword());
				userAccessLogService.insertUserAccessLog(ual);
				
				tUser.setTryed(tUser.getTryed() + 1);
				userService.updateUserLoginTry(tUser);
				
				if(tUser.getTryed() >= 4) {
					// 로그인 시도횟수 임계치 실패로직..
					tUser.setUser_stat_cd("T");
					userService.updateUserStatusAsOverTryedLogin(tUser);
					obj.addProperty("result", result);
					obj.addProperty("msg", "로그인 시도 5회 실패로 계정이 잠금되었습니다.\n관리자에게 문의하세요.");
					return obj.toString();
				}
				
				obj.addProperty("result", result);
				obj.addProperty("msg", "아이디 또는 비밀번호가 잘못되었습니다.\n로그인 시도 5회 실패시 계정이 잠금됩니다.\n"+(5 - tUser.getTryed())+"회 남았습니다.");
				return obj.toString();
			}
			
			if(tUser.getUser_stat_cd().equals("B")) { //////////////~일까지.. 기간 체크해주자..
				result = false;
				BlackList blinfo = userService.selectBlackListUserInfo(tUser);
				obj.addProperty("result", result);
				obj.addProperty("msg", "로그인 시도하신 계정은 "+ blinfo.getBl_scope() +"일 활동정지 된 계정입니다.\n" + blinfo.getEnd_date() + "일 이후 로그인이 가능합니다.");
				return obj.toString();
			}
			
			result = authentication(request, tUser, loginFlag);
			if(!result) {
				obj.addProperty("result", result);
				return obj.toString();
			}
			obj.addProperty("result", result);
			return obj.toString();
		}else if(tUser != null && tUser.getUser_stat_cd().equals("T")){
			result = false;
			obj.addProperty("result", result);
			obj.addProperty("msg", "계정이 잠금 상태입니다.\n관리자에게 문의하세요.");
			return obj.toString();
		}else{
			result = false;
			obj.addProperty("result", result);
			obj.addProperty("msg", "아이디 또는 비밀번호를 잘못입력하셨습니다.\n다시 확인해주세요.");
			return obj.toString();
		}
	}
	
	@RequestMapping(value = "/userLoginIdCheckAsKakao", method = RequestMethod.POST)
	@ResponseBody
	public String userLoginIdCheck(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		JsonObject obj = new JsonObject();
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		String login_id = element.getAsJsonObject().get("id").getAsString();
		String pw = null;
		String nick = null;
		String prosrc = null;
		
		User usr = new User();
		usr.setLogin_id(login_id);
		User usr01 = userService.selectUserInfoAsLogin(usr);
		
		if(usr01 != null) {
			obj.addProperty("result", true);
			return obj.toString();
		} else {
			usr01 = new User();
			pw = element.getAsJsonObject().get("pw").getAsString();
			nick = element.getAsJsonObject().get("nick").getAsString();
			prosrc = element.getAsJsonObject().get("prosrc").getAsString();
			if(pw.equals("")) {
				pw = Constants.USER_KAKAO_LOGIN_PWD;
			}
			usr01.setUser_stat_cd("A");
			usr01.setLogin_id(login_id);
			usr01.setUser_name(nick);
			usr01.setNick_name(nick);
			usr01.setPassword(passwordEncoder.encode(pw));
			usr01.setUser_role_cd((short)7);
			if(!prosrc.equals("")) usr01.setProfile_src(prosrc);
			else usr01.setProfile_src(null);
			
			int check = userService.insertUser(usr01);
			if(check > 0) {
				obj.addProperty("result", true);
				obj.addProperty("id", usr01.getLogin_id());
			}else {
				obj.addProperty("result", false);
			}
		}
		
		return obj.toString();
	}
	
	private boolean authentication(HttpServletRequest request, User user, String loginFlag) throws Exception {
		if(user != null) {
			HttpSession session = request.getSession();
			log.debug("SESSION: " + session.getId());
			
			user.setAccess_ip(request.getRemoteAddr());
			user.setTryed(0);
			user.setLogin_flag(loginFlag);
			userService.updateUserLogin(user);
			
			UserAccessLog ual = new UserAccessLog();
			ual.setAccess_ip(request.getRemoteAddr());
			ual.setAccess_status("S");
			ual.setLogin_id(user.getLogin_id());
			userAccessLogService.insertUserAccessLog(ual);
			
			if(user.isAdmin()) session.setAttribute(Constants.ADMIN_SESSION_KEY, user);
			else session.setAttribute(Constants.USER_SESSION_KEY, user);
			
			return true;
		}
		log.debug(">> USER LOGIN FAILED");
		return false;
	}
	
	@ResponseBody
	@RequestMapping(value = "/user/signUpUser", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	public String signUp(HttpServletRequest request, HttpServletResponse response, @RequestBody String data, Model model) throws Exception {
		log.info("=== insertUser ===");
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		JsonObject ojb = new JsonObject();
		
		String login_id = element.getAsJsonObject().get("id").getAsString();
		String nick_name = element.getAsJsonObject().get("nick").getAsString();
		String password = element.getAsJsonObject().get("pw").getAsString();
		String profile_src = element.getAsJsonObject().get("prosrc").getAsString();
		String signFlag = element.getAsJsonObject().get("signFlag").getAsString();
		String secondMail = element.getAsJsonObject().get("secondMail").getAsString();
		
		
		if(signFlag.equals("kakao")) {
			if(password.equals("")) password = Constants.USER_KAKAO_LOGIN_PWD;
		}else {
			if(signFlag.equals("normal")) profile_src = profile_src.substring(profile_src.indexOf("/resources"));
		}
		
		User user = new User();
		user.setUser_stat_cd("A");
		user.setLogin_id(login_id);
		user.setUser_name(nick_name);
		user.setNick_name(nick_name);
		user.setPassword(passwordEncoder.encode(password));
		user.setUser_role_cd((short)7);
		if(!profile_src.equals("")) user.setProfile_src(profile_src);
		else user.setProfile_src(null);
		
		if(secondMail.equals("")) user.setSecond_mail(null);
		else user.setSecond_mail(secondMail);
		
		int result = userService.insertUser(user);
		if(result < 1) {
			ojb.addProperty("result", false);
			ojb.addProperty("msg", "실패했습니다.");
			return ojb.toString();
		}
		ojb.addProperty("result", true);
		ojb.addProperty("msg", "성공했습니다.");
		
		return ojb.toString();
	}
	
	@RequestMapping(value = "/user/mainUser")
	public ModelAndView mainUser(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		
		HttpSession session = request.getSession();
		User user = (User)session.getAttribute(Constants.USER_SESSION_KEY);
		if(user == null) response.sendRedirect(request.getContextPath() + "/logout.do");
		
		ArrayList<Community> userCommunityList = communityService.selectUserCommunityList(user);
		//ArrayList<Board> mainBoardList = communityService.selectMainBoardList();
		if(userCommunityList != null) model.addAttribute("ucList", userCommunityList);
		
		return new ModelAndView("user/mainUser");
	}
	
	@RequestMapping(value = "/user/userMyPage")
	public ModelAndView userMyPage(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		User user = SessionManager.getUserSession(request);
		if(user == null) return new ModelAndView("redirect:/");
		
		return new ModelAndView("user/userMyPage");
	}
	
	@RequestMapping(value = "/user/userProfileUpload", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String userProfileUpload(HttpServletRequest request, HttpServletResponse response, Model model, @RequestParam("uploadFile") MultipartFile uploadFile) throws Exception {
		log.info("=== user Profile upload start ===");
		request.setCharacterEncoding("UTF-8");
		User user = SessionManager.getUserSession(request);
		
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		MultipartFile files = multipartRequest.getFile("uploadFile");
		
		JsonObject obj = new JsonObject();
		File file = null;
		String profilePath = env.getProperty("file.user.profile.upload.path");
		String resPath = env.getProperty("file.user.profile.res.path");
		String fileName = files.getOriginalFilename();
		String renameFile = null;
		String extension = fileName.substring(fileName.lastIndexOf(".")+1);
		
		log.info("origin_file_name : " + fileName);
		
		if(user != null) {
			profilePath += Integer.toString(user.getUser_idx()) + "/";
			file = new File(profilePath);
			log.debug("profilePath: " + profilePath);
			log.debug(file.getAbsolutePath());
			if(!file.exists()) {
				file.mkdirs();
			}
			
			int len = file.listFiles().length;
			if(len > 0) {
				renameFile = (len + 1) + "_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString() + "." + extension;
			} else {
				renameFile = 0 + "_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString() + "." + extension;
			}
			
			File userFile = new File(profilePath, renameFile);
			files.transferTo(userFile);
			
//			user.setProfile_src(resPath + user.getUser_idx() + "/" + renameFile); //resources/userProfile/2/1_오사카_.jpg...
//			userService.updateUserProfile(user); //프로필 업로드 후 취소 누르는 상황 고려.. 바로 업데이트는 아닌듯.
			obj.addProperty("result",  true);
			obj.addProperty("src", resPath + user.getUser_idx() + "/" + renameFile);
			log.info("user profile upload end");
			return obj.toString();
			
		} else {
			profilePath += "temp/";
			file = new File(profilePath);
			log.debug("profilePath: " + profilePath);
			log.debug(file.getAbsolutePath());
			if(!file.exists()) {
				file.mkdirs();
			}
			
			renameFile = "____" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString() + "." + extension; // 언더바 4개. 실제 회원가입 신청때는 파일 리네임이 필요할 듯 해서 구분자 ..
			
			File tempFile = new File(profilePath, renameFile);
			files.transferTo(tempFile);
			
			obj.addProperty("result",  true);
			obj.addProperty("src", resPath + "temp/" + renameFile);
			log.info("temp profile upload end");
			return obj.toString();
		}
	}
	
	@RequestMapping(value = "/user/updateUserProfile", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String updateUserProfile(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		log.info("=== updateUserProfile ===");
		JsonObject obj = new JsonObject();
		
		User user = SessionManager.getUserSession(request);
		if(user == null) {
			obj.addProperty("result",  false);
			obj.addProperty("msg", "실패했습니다.");
			return obj.toString();
		}
		
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		String nick_name = element.getAsJsonObject().get("nick").getAsString();
		String password = element.getAsJsonObject().get("pw1").getAsString();// == null ? "" : element.getAsJsonObject().get("pw1").getAsString();
		String profile_src = element.getAsJsonObject().get("prosrc").getAsString();
		profile_src = profile_src.substring(profile_src.indexOf("/resources"));
		String secondMail = element.getAsJsonObject().get("secondMail").getAsString();
		
		if(password.equals("")) password = userService.getUserPassword(user.getUser_idx());
		
		user.setUser_name(nick_name);
		user.setNick_name(nick_name);
		user.setPassword(password);
		user.setProfile_src(profile_src);
		if(secondMail.equals("")) user.setSecond_mail(null);
		else user.setSecond_mail(secondMail);
		
		try {
			userService.updateUserProfile(user);
			obj.addProperty("result", true);
			obj.addProperty("msg", "성공했습니다.");
			return obj.toString();
		}catch(Exception e) {
			e.printStackTrace();
			obj.addProperty("result", false);
			obj.addProperty("msg", "실패했습니다.");
			return obj.toString();
		}
	}
	
	@RequestMapping(value = "/user/sendAuthCode", method = RequestMethod.POST)
	@ResponseBody
	public ModelMap sendAuthCode(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		ModelMap mp = new ModelMap();
		boolean result = false;
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		String email = element.getAsJsonObject().get("mailto").getAsString();
		String flag = "";
		log.debug("requested email: " + email);
		
		HttpSession session = request.getSession();
		log.debug("SESSION: " + session.getId());
		session.removeAttribute(Constants.USER_SESSION_PASSCODE);
		
		session = request.getSession();
		session.setAttribute(Constants.USER_SESSION_PASSCODE, sendPasscode(email, flag));
		log.debug("attributeNew: " + session.getAttribute(Constants.USER_SESSION_PASSCODE));
		
		try {
			Thread.sleep(800L);
		}catch(InterruptedException ie) {
			ie.printStackTrace();
			result = false;
		}
		result = true;
		
		mp.addAttribute("result", result);
		mp.addAttribute("passcode", session.getAttribute(Constants.USER_SESSION_PASSCODE));
		return mp;
	}
	
	private String sendPasscode(String emailto, String flag) throws Exception {
		String passcode = new Integer(1000000 + (new Random()).nextInt(1000000)).toString().substring(1);
		mailFrom = "devcomm00@gmail.com";
		mailTo = emailto;
		if(flag.equals("find")) {
			mailSubject = "[DevCommunity] 비밀번호 찾기 인증번호가 전송되었습니다.";
			mailContent = "";
			mailContent += "<h2>인증번호</h2><br />";
			mailContent += "<h2>"+passcode+"</h2>";
		}else {
			mailSubject = "[DevCommunity] 회원가입 인증번호가 전송되었습니다.";
			mailContent = "";
			mailContent += "<h2>인증번호</h2><br />";
			mailContent += "<h2>"+passcode+"</h2>";
		}
		mailSender.sendMail(new Email(mailFrom, mailTo, mailSubject, mailContent, mailContentType));
		
		passcode += "|" + emailto + "|" + System.currentTimeMillis();
		log.debug("passcode: " + passcode);
		
		return passcode;
	}
	
	@RequestMapping(value = "/user/nickDupleCheck", method = RequestMethod.GET)
	@ResponseBody
	public ModelMap nickDupleCheck(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelMap mp = new ModelMap();
		
		String nickName = request.getParameter("nick");
		if(nickName.equals("")) {
			mp.addAttribute("result", false);
			mp.addAttribute("msg", "닉네임을 입력해주세요.");
		}
		
		String count = userService.userNickDupleCheck(nickName) == null ? "0" : "1";
		int dupleCount = Integer.parseInt(count);
		
		if(dupleCount > 0) {
			mp.addAttribute("result", true);
			mp.addAttribute("msg", "사용중인 닉네임입니다.\n동일한 닉네임으로 사용은 가능합니다.");
		} else {
			mp.addAttribute("result", true);
			mp.addAttribute("msg", "사용가능한 닉네임입니다.");
		}
		
		return mp;
	}
	
	@RequestMapping(value = "/console/user/userManage", method = RequestMethod.GET)
	public ModelAndView adminUserManage(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.info("=== adminUserManage ===");
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) response.sendRedirect(request.getContextPath() + "/console/logout.do");
		
		// userList. blackList. 또 있나?
		ArrayList<User> userList = new ArrayList<User>();
		ArrayList<User> blackList = new ArrayList<User>();
		ArrayList<Conf> bScope = new ArrayList<Conf>();
		
		blackList = userService.selectBlackListUser();
		userList = userService.selectAllUserList();
		bScope = userService.selectConfAsBlackListScope();
		
		if(blackList != null) model.addAttribute("blackList", blackList);
		if(userList != null) model.addAttribute("userList", userList);
		if(bScope != null) model.addAttribute("bScope", bScope);
		
		
		return new ModelAndView("console/userManage");
	}
	
	@RequestMapping(value = "/console/user/userDetailView", method = RequestMethod.GET)
	@ResponseBody
	public ModelMap adminUserDetailView(HttpServletRequest request, HttpServletResponse response) throws Exception {
		log.info("=== adminUserDetailView ===");
		ModelMap mp = new ModelMap();
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) response.sendRedirect(request.getContextPath() + "/console/logout.do");
		
		int user_idx = -1; 
		try {
			user_idx = Integer.parseInt(request.getParameter("idx"));
		}catch(Exception e) {
			e.printStackTrace();
			log.error("IDX VALUE PARSING ERROR !!");
			mp.addAttribute("result", false);
			return mp;
		}
		
		User userInfo = userService.selectUserInfoAsIdx(user_idx);
		ArrayList<Conf> blackListScope = userService.selectConfAsBlackListScope();
		ArrayList<Community> userCommunityList = communityService.selectUserCommunityList(userInfo);
		
		if(userCommunityList != null) mp.addAttribute("ucList", userCommunityList);
		if(userInfo != null) mp.addAttribute("userInfo", userInfo);
		if(blackListScope != null) mp.addAttribute("bScope", blackListScope);
		
		return mp;
	}
	
	@RequestMapping(value = "/user/userEscape", method = RequestMethod.GET)
	@ResponseBody
	public ModelMap userEscape(HttpServletRequest request) throws Exception {
		ModelMap mp = new ModelMap();
		User user = SessionManager.getUserSession(request);
		if(user == null) {
			mp.addAttribute("result", false);
			mp.addAttribute("msg", "세션이 만료되어 처리에 실패했습니다.");
		}
		int user_idx = -1;
		try {
			user_idx = Integer.parseInt(request.getParameter("idx"));
		}catch(Exception e) {
			e.printStackTrace();
			log.error("IDX VALUE PARSING ERROR.");
		}
		
		// 회원탈퇴 구현하기.
		try {
			int success = userService.updateUserEscapeAsIdx(user_idx);
			if(success > 0) {
				mp.addAttribute("result", true);
				mp.addAttribute("msg", "성공했습니다.");
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error(e);
			mp.addAttribute("result", false);
			mp.addAttribute("msg", "처리에 실패했습니다.");
		}
		
		
		return mp;
	}
	
	@RequestMapping(value = "/console/user/insertBlackListUser", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String insertBlackListUser(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		log.info("===admin insertBlackList===");
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) response.sendRedirect(request.getContextPath() + "/console/logout.do");
		
		JsonObject obj = new JsonObject();
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		try {
			int user_idx = element.getAsJsonObject().get("uid").getAsInt();
			int blScope = element.getAsJsonObject().get("blacklistScope").getAsInt();
			String blCont = element.getAsJsonObject().get("blacklistCont").getAsString();
			
			Calendar cal = Calendar.getInstance();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String endDate = "";
			if(blScope == 7) {
				cal.add(Calendar.DATE, blScope);
				endDate = sdf.format(cal.getTime());
			}else if(blScope == 15) {
				cal.add(Calendar.DATE, blScope);
				endDate = sdf.format(cal.getTime());
			}else if(blScope == 30) {
				cal.add(Calendar.DATE, blScope);
				endDate = sdf.format(cal.getTime());
			}else {
				endDate = "9999-12-31 23:59:59";
			}
			
			BlackList bl = new BlackList();
			bl.setUser_idx(user_idx);
			bl.setEnd_date(endDate);
			bl.setBl_cont(blCont);
			bl.setBl_scope(blScope);
			bl.setBl_flag("S");
			
			bl = userService.insertBlackListuser(bl);
			
			if(bl != null) {
				
				userService.updateUserBlackListStatus(user_idx);
				userService.insertBlackListUserLog(bl);
				
				mailFrom = "devcomm00@gmail.com";
				mailTo = userService.getLoginIdAsIdx(user_idx);
				mailSubject = "[DevCommunity] 활동정지 알림";
				mailContent = "안녕하세요.<br />";
				mailContent += "DevCommunity 관리자입니다.";
				mailContent += "<br />";
				mailContent += "활동 규칙에 의해 현재 시간부터";
				mailContent += endDate +" 기간까지 활동정지 되었습니다.";
				mailContent += "<br />";
				mailContent += "감사합니다.";
				
				mailSender.sendMail(new Email(mailFrom, mailTo, mailSubject, mailContent, mailContentType));
				obj.addProperty("result", true);
				obj.addProperty("msg", "성공했습니다.");
				return obj.toString();
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			log.error(e);
		}
		obj.addProperty("result", false);
		obj.addProperty("msg", "실패했습니다.");
		
		return obj.toString();
	}
	
	@RequestMapping(value = "/console/user/userBlackListRelease", method = RequestMethod.GET)
	@ResponseBody
	public ModelMap adminUserBlackListRelease(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelMap mp = new ModelMap();
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) response.sendRedirect(request.getContextPath() + "/console/logout.do");
		
		int user_idx = -1;
		try {
			user_idx = Integer.parseInt(request.getParameter("idx"));
			
			BlackList blackList = userService.deleteUserBlackList(user_idx);
			if(blackList != null) {
				userService.updateUserBlackListLogRelease(blackList);
				userService.updateUserBlackListReleaseStatus(user_idx);
				
				mailFrom = "devcomm00@gmail.com";
				mailTo = userService.getLoginIdAsIdx(user_idx);
				mailSubject = "[DevCommunity] 활동정지 해제 알림";
				mailContent = "안녕하세요.<br />";
				mailContent += "DevCommunity 관리자입니다.";
				mailContent += "<br />";
				mailContent += "현재 시간부터";
				mailContent += "활동정지 해제가 되었음을 알려드립니다.";
				mailContent += "<br />";
				mailContent += "감사합니다.";
				
				mailSender.sendMail(new Email(mailFrom, mailTo, mailSubject, mailContent, mailContentType));
			}
			mp.addAttribute("result", true);
			mp.addAttribute("msg", "성공했습니다.");
			return mp;
			
		}catch(Exception e) {
			e.printStackTrace();
			log.error(e);
		}
		mp.addAttribute("result", false);
		mp.addAttribute("msg", "실패했습니다.");
		return mp;
	}
	
	@RequestMapping(value = "/user/communitySignUp", method = RequestMethod.POST, produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String userCommunitySignUp(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		log.info("=== user CommunitySignUp ===");
		User user = SessionManager.getUserSession(request);
		JsonObject obj = new JsonObject();
		if(user == null) {
			obj.addProperty("result",  false);
			obj.addProperty("msg", "세션이 만료되어 처리에 실패했습니다.");
			return obj.toString();
		}
		
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		int user_idx = element.getAsJsonObject().get("uid").getAsInt();
		int comm_idx = element.getAsJsonObject().get("comm_idx").getAsInt();
		
		CommunityUser cu = new CommunityUser();
		cu.setComm_idx(comm_idx);
		cu.setUser_idx(user_idx);
		cu.setComm_user_stat_cd("R"); //Request..신청상태
		
		try {
			communityService.insertCommunityUser(cu);
			obj.addProperty("result", true);
			obj.addProperty("cidx", comm_idx);
			obj.addProperty("msg", "성공했습니다.");
		}catch(Exception e) {
			e.printStackTrace();
			log.error(e);
		}
		return obj.toString();
	}
	
	@RequestMapping(value = "/user/communitySignCancel", method = RequestMethod.POST, produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String userCommunitySignCancel(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		log.info("=== user CommunitySign Cancel ===");
		JsonObject obj = new JsonObject();
		User user = SessionManager.getUserSession(request);
		if(user == null) response.sendRedirect(request.getContextPath() + "/logout.do");
		
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		try {
			int user_idx = element.getAsJsonObject().get("uid").getAsInt();
			int comm_idx = element.getAsJsonObject().get("comm_idx").getAsInt();
			
			communityService.deleteCommunitySignUserCancel(user_idx, comm_idx);
			
			obj.addProperty("result", true);
			obj.addProperty("cidx", comm_idx);
			return obj.toString();
		}catch(Exception e) {
			e.printStackTrace();
			log.error("USER COMMUNITY SIGN CANCEL VALUE PARSING ERROR.");
		}
		
		return null;
	}
	
	@RequestMapping(value = "/user/moveToCommunityView", method = RequestMethod.GET)
	public ModelAndView userMoveToCommunityView(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		User user = (User)SessionManager.getUserSession(request);
		if(user == null) response.sendRedirect(request.getContextPath() + "/logout.do");
		
		try {
			long comm_idx = Long.parseLong(request.getParameter("idx"));
			if(comm_idx > 0) {
				String commStatus = userService.getUserCommunityStatus(user.getUser_idx(), comm_idx);
				if(commStatus.equals("CB")) model.addAttribute("COMM_BLOCKED", commStatus);
				
				ArrayList<Board> cBoardList = boardService.selectAllCommunityBoardList(comm_idx);	//커뮤니티 전체 글 조회
				ArrayList<Community> userCommunityList = communityService.selectUserCommunityList(user);
				Community commInfo = communityService.selectCommunityDetailView((int)comm_idx);
				
				ArrayList<Board> communityBoardList = new ArrayList<Board>();
				
				if(cBoardList != null) {
					for(int i = 0; i < cBoardList.size(); i++) {
						Board b = new Board();
						b = cBoardList.get(i);
						b.setReplyList(boardService.selectBoardReplyListAsBidx(b.getBoard_idx()));
						communityBoardList.add(b);
					}
				}
				if(communityBoardList.size() > 0) model.addAttribute("cbList", communityBoardList);
				if(userCommunityList != null) model.addAttribute("ucList", userCommunityList);
				if(commInfo != null) model.addAttribute("commInfo", commInfo);
				
				communityService.updateUserCommunityLoginDate(user.getUser_idx(), comm_idx);
				
				return new ModelAndView("community/communityMain");
				
			}else {
				log.error("IDX PARSING VALUE CANNOT BE LESS THAN 0");
				return new ModelAndView("error");
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			log.error("IDX VALUE PARSING ERROR.");
			return new ModelAndView("error");
		}
	}
	
	@RequestMapping(value = "/user/communityBoard", method = RequestMethod.GET)
	public ModelAndView userCommunityBoard(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		User user = SessionManager.getUserSession(request);
		if(user == null) return new ModelAndView("redirect:/");
		
		int cidx = 0;
		try {
			cidx = Integer.parseInt(request.getParameter("cidx"));
		}catch(Exception e) {
			e.printStackTrace();
			log.error("CIDX PARSING ERROR.");
		}
		
		ArrayList<Community> userCommunityList = communityService.selectUserCommunityList(user);
		if(userCommunityList != null) model.addAttribute("ucList", userCommunityList);
		if(cidx > 0) model.addAttribute("comm_idx", cidx);
		else {
			return new ModelAndView("error");
		}
		model.addAttribute("userInfo", user);
		
		return new ModelAndView("/community/communityBoardWrite");
	}
	
	@RequestMapping(value = "/findLoginIdAsSecondMail", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String findLoginIdAsSecondMail(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		log.info("=== findLoginIdAsSecondMail ===");
		JsonObject obj = new JsonObject();
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		String secondMail = element.getAsJsonObject().get("secondMail").getAsString();
		
		String findLoginId = "";
		
		try{
			findLoginId = userService.findLoginIdAsSecondMail(secondMail);
			String[] loginIds = findLoginId.split(",");
			log.debug(loginIds.length);
			if(loginIds.length > 1) {
				obj.addProperty("result", false);
				obj.addProperty("msg", "동일한 2차메일주소의 계정이 2개이상입니다. 관리자에게 문의하세요.");
				return obj.toString();
			}else {
				mailFrom = "devcomm00@gmail.com";
				mailTo = secondMail;
				mailSubject = "[DevCommunity] 요청하신 아이디 찾기 정보입니다.";
				mailContent = "안녕하세요. <br />DevCommunity 관리자입니다.";
				mailContent += "<br /><br />회원님의 로그인 아이디정보는 <br />";
				mailContent += loginIds[0] + " 입니다.";
				mailContent += "<br/ ><br />감사합니다.";
				
				mailSender.sendMail(new Email(mailFrom, mailTo, mailSubject, mailContent, mailContentType));
				
				obj.addProperty("result", true);
				obj.addProperty("msg", "성공했습니다. 메일을 확인해주세요.");
				return obj.toString();
			}
		}catch(Exception e) {
			e.printStackTrace();
			obj.addProperty("result", false);
			obj.addProperty("msg", "입력하신 2차메일주소로 가입된 계정이 없습니다.");
			return obj.toString();
		}
	}
	
	@RequestMapping(value = "/findPasswdAsLoginIdAuth", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String findPasswdAsLoginIdAuth(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		JsonObject obj = new JsonObject();
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		String mailto = element.getAsJsonObject().get("mailto").getAsString();
		String flag = "find";
		if(mailto.trim().equals("")) {
			obj.addProperty("result", false);
			obj.addProperty("msg", "이메일을 입력해주세요.");
			return obj.toString();
		}
		boolean result = false;
		
		User tuser = new User();
		tuser.setLogin_id(mailto);
		
		User usr = userService.selectUserInfoAsLogin(tuser);
		if(usr != null && !usr.getUser_stat_cd().equals("T")) {
			HttpSession session = request.getSession();
			log.debug("SESSION: " + session.getId());
			session.removeAttribute(Constants.USER_SESSION_PASSCODE);
			
			session = request.getSession();
			session.setAttribute(Constants.USER_SESSION_PASSCODE, sendPasscode(mailto, flag));
			log.debug("attributeNew: " + session.getAttribute(Constants.USER_SESSION_PASSCODE));
			
			try {
				Thread.sleep(800L);
			}catch(InterruptedException ie) {
				ie.printStackTrace();
				result = false;
			}
			result = true;
			
			obj.addProperty("result", result);
			obj.addProperty("passcode", (String)session.getAttribute(Constants.USER_SESSION_PASSCODE));
			return obj.toString();
		}else {
			if(usr.getUser_stat_cd().equals("T")) {
				obj.addProperty("result", false);
				obj.addProperty("msg", "로그인 시도 5회 이상 실패로 잠금된 계정입니다.\n관리자에게 문의하세요.");
				return obj.toString();
			}
			obj.addProperty("result", false);
			obj.addProperty("msg", "정보가 없습니다. 다시 확인해주세요.");
			return obj.toString();
		}
	}
	
	@RequestMapping(value = "/chagenPasswdAsFindNewPasswd", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String changePasswdAsFineNewPasswd(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		JsonObject obj = new JsonObject();
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		String login_id = element.getAsJsonObject().get("login_id").getAsString();
		String new_passwd = element.getAsJsonObject().get("new_passwd").getAsString();
		User usr01 = new User();
		usr01.setLogin_id(login_id);
		
		try {
			User usr = userService.selectUserInfoAsLogin(usr01);
			usr.setPassword(passwordEncoder.encode(new_passwd));
			if(userService.changePasswdAsFindNewPasswd(usr) > 0) {
				log.debug("CHANGE PASSWORD SUCCESS.");
				obj.addProperty("result", true);
				obj.addProperty("msg", "성공했습니다. 메인페이지로 이동됩니다.");
				return obj.toString();
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error("CHANGE PASSWORD ERROR.");
			obj.addProperty("result", false);
			obj.addProperty("msg", "실패했습니다.");
			return obj.toString();
		}
		
		return obj.toString();
	}
	
	@RequestMapping(value = "/user/inquiryToAdmin", method = RequestMethod.GET)
	public ModelAndView userInquiryToAdmin(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		User user = SessionManager.getUserSession(request);
		if(user == null) return new ModelAndView("redirect:/");
		
		ArrayList<Community> userCommunityList = communityService.selectUserCommunityList(user);
		if(userCommunityList != null) model.addAttribute("ucList", userCommunityList);
		
		
		
		return new ModelAndView("config/inquiry");
	}
	
	@RequestMapping(value = "/user/inquiryView", method = RequestMethod.GET)
	public ModelAndView userInquiryView(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		User user = SessionManager.getUserSession(request);
		if(user == null) return new ModelAndView("redirect:/");
		
		ArrayList<Community> userCommunityList = communityService.selectUserCommunityList(user);
		if(userCommunityList != null) model.addAttribute("ucList", userCommunityList);
		
		ArrayList<Inquiry> inquiryList = boardService.selectUserInquiryList(user);
		model.addAttribute("inquiryList", inquiryList);
		
		return new ModelAndView("config/inquiryList");
	}
	
	/*
	@RequestMapping(value = "/user/mainUser", method = RequestMethod.GET)
	public ModelAndView mainUser(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.info("=== mainUser ===");
		
		int user_idx = StringUtils.toInt(request.getParameter("idx") == null ? "0" : request.getParameter("idx"));
//		log.info("user_idx : " + user_idx);
		if(!(user_idx > 0)) {
			return new ModelAndView("error");
		}
		
		User user = userService.selectUserInfoAsIdx(user_idx);
		boolean result = authentication(request, user);
		
		if(!result) {
			return new ModelAndView("error");
		}
		
		ArrayList<Community> userCommunityList = communityService.selectUserCommunityList(user);
		model.addAttribute("ucList", userCommunityList);
		
		return new ModelAndView("user/mainUser");
	}
	*/
	

}
