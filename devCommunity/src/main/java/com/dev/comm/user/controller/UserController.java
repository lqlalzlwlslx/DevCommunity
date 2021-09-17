package com.dev.comm.user.controller;

import java.io.File;
import java.util.ArrayList;
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

import com.dev.comm.common.base.Email;
import com.dev.comm.common.base.EmailSender;
import com.dev.comm.common.service.UserAccessLogService;
import com.dev.comm.common.vo.Conf;
import com.dev.comm.common.vo.UserAccessLog;
import com.dev.comm.community.service.CommunityService;
import com.dev.comm.community.vo.Community;
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
		
		if(login_id == null || password == null) {
			obj.addProperty("result", false);
			return obj.toString();
		}
		
		User user = new User();
		user.setLogin_id(login_id);
		
		boolean result = false;
		User tUser = userService.selectUserInfoAsLogin(user);
		
		if(tUser != null) {
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
				
				if(tUser.getTryed() > 5) {
					// 로그인 시도횟수 임계치 실패로직..
				}
				
				obj.addProperty("result", result);
				obj.addProperty("msg", "아이디 또는 비밀번호가 잘못되었습니다.");
				return obj.toString();
			}
			
			result = authentication(request, tUser);
			if(!result) {
				obj.addProperty("result", result);
				return obj.toString();
			}
			obj.addProperty("result", result);
			return obj.toString();
		}else {
			result = false;
			obj.addProperty("result", result);
			obj.addProperty("msg", "아이디 또는 비밀번호를 잘못입력하셨습니다.\n다시 확인해주세요.");
			return obj.toString();
		}
	}
	
	private boolean authentication(HttpServletRequest request, User user) throws Exception {
		if(user != null) {
			HttpSession session = request.getSession();
			log.debug("SESSION: " + session.getId());
			
			user.setAccess_ip(request.getRemoteAddr());
			user.setTryed(0);
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
		profile_src = profile_src.substring(profile_src.indexOf("/resources"));
		
		User user = new User();
		user.setUser_stat_cd("A");
		user.setLogin_id(login_id);
		user.setUser_name(nick_name);
		user.setNick_name(nick_name);
		user.setPassword(passwordEncoder.encode(password));
		user.setUser_role_cd((short)7);
		if(!profile_src.equals("")) user.setProfile_src(profile_src);
		else user.setProfile_src(null);
		
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
		
		ArrayList<Community> userCommunityList = communityService.selectUserCommunityList(user);
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
		
		if(password.equals("")) password = userService.getUserPassword(user.getUser_idx());
		
		user.setUser_name(nick_name);
		user.setNick_name(nick_name);
		user.setPassword(password);
		user.setProfile_src(profile_src);
		
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
		log.debug("requested email: " + email);
		
		HttpSession session = request.getSession();
		log.debug("SESSION: " + session.getId());
		session.removeAttribute(Constants.USER_SESSION_PASSCODE);
		
		session = request.getSession();
		session.setAttribute(Constants.USER_SESSION_PASSCODE, sendPasscode(email));
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
	
	private String sendPasscode(String emailto) throws Exception {
		String passcode = new Integer(1000000 + (new Random()).nextInt(1000000)).toString().substring(1);
		mailFrom = "devcomm00@gmail.com";
		mailTo = emailto;
		mailSubject = "[DevCommunity] 회원가입 인증번호가 전송되었습니다.";
		mailContent += "<h2>인증번호</h2><br />";
		mailContent += "<h3>"+passcode+"</h3>";
		
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
			mp.addAttribute("result", false);
			mp.addAttribute("msg", "사용중인 닉네임입니다.");
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
			log.error("IDX VALUE PARSING ERROR.");
		}
		
		// 회원탈퇴 구현하기.
		
		return mp;
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
