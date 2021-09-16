package com.dev.comm.community.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.dev.comm.common.base.Email;
import com.dev.comm.common.base.EmailSender;
import com.dev.comm.community.service.CommunityService;
import com.dev.comm.community.vo.Community;
import com.dev.comm.user.service.UserService;
import com.dev.comm.user.vo.User;
import com.dev.comm.util.SessionManager;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Controller
public class CommunityController {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	@Autowired
	private CommunityService communityService;
	
	@Autowired(required=true)
	private EmailSender mailSender;
	
	@Autowired
	private UserService userService;
	
	private String mailFrom;
	private String mailTo;
	private String mailSubject;
	private String mailContent;
	private String mailContentType = "text/html";
	
	@RequestMapping(value = "/community/nameDupleCheck", method = RequestMethod.GET, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String communityNameDulpleCheck(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		JsonObject obj = new JsonObject();
		
		String name = request.getParameter("name");
		log.debug("duplication check: " + name);
		
		User user = SessionManager.getUserSession(request);
		if(user == null) {
			obj.addProperty("result", false);
			obj.addProperty("msg", "세션이 만료되어 처리에 실패했습니다.");
			return obj.toString();
		}
		
		if(!name.equals("")) {
			String count = communityService.communityNameDupleCheck(name) == null ? "0" : "1";
			int dupleCount = Integer.parseInt(count);
			if(dupleCount > 0) {
				obj.addProperty("result", false);
				obj.addProperty("msg", "동일한 커뮤니티명이 존재합니다.");
				return obj.toString();
			} else {
				obj.addProperty("result",  true);
				obj.addProperty("msg", "사용가능한 커뮤니티명입니다.");
				return obj.toString();
			}
		}
		
		return null;
		
	}
	
	@RequestMapping(value = "/community/insertCommunity", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String insertCommunity(HttpServletRequest request, HttpServletResponse response, Model model, @RequestBody String data) throws Exception {
		log.info("=== insertCommunity ===");
		JsonObject obj = new JsonObject();
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		User user = SessionManager.getUserSession(request);
		if(user == null) {
			obj.addProperty("result", false);
			obj.addProperty("msg", "실패했습니다.");
			return obj.toString();
		}
		
		String comm_name = element.getAsJsonObject().get("comm_name").getAsString();
		String comm_type = element.getAsJsonObject().get("comm_category").getAsString();
		String comm_reg_cont = element.getAsJsonObject().get("comm_reg_cont").getAsString();
		
		Community community = new Community();
		community.setComm_name(comm_name);
		community.setManager_idx(Integer.toString(user.getUser_idx()));
		community.setManager_name(user.getNick_name());
		community.setComm_type_cd(comm_type);
		community.setComm_reg_cont(comm_reg_cont);
		community.setComm_stat_cd("I"); //신청할 때 비활성으로 insert. 관리자 승인 후 활성시키는 걸로..
		
		if(communityService.insertCommunity(community) > 0) {
			
			mailFrom = user.getLogin_id();
			mailTo = userService.selectAdminEmail(); //decadmin@gmail.com,saint@pdic.co.kr
			
			mailContent += "<h2>커뮤니티 신청 건이 있습니다.</h2><br />";
			mailContent += "<h3>확인 후 사이트에 접속하셔서 승인 바랍니다.</h3><br /><br />";
			mailContent += "<h4>신청자(닉네임) : " + community.getManager_name() + "<br />";
			mailContent += "커뮤니티명 : " + community.getComm_name() + "<br />";
			mailContent += "커뮤니티 타입 : " + community.getComm_type_cd() + "<br />";
			mailContent += "신청사유 : " + community.getComm_reg_cont() + "<br /></h4>";
			//content += "신청일자 : " + community.getReg_date();
			
			mailSubject = user.getNick_name() + "님의 [" + community.getComm_name() + "] 개설 신청";
			
			mailSender.sendMail(new Email(mailFrom, mailTo, mailSubject, mailContent, mailContentType));
			
			obj.addProperty("result", true);
			obj.addProperty("msg", "신청에 성공했습니다.\n관리자 승인 후 커뮤니티가 활성화 됩니다.");
			return obj.toString();
		} else {
			obj.addProperty("result", false);
			obj.addProperty("msg", "실패했습니다.");
			return obj.toString();
		}
	}
	
	@RequestMapping(value = "/console/community/communityStatus", method = RequestMethod.GET, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String communityStatus(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.info("=== admin communityStatus ===");
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) response.sendRedirect(request.getContextPath() + "/logout.do");
		
		JsonObject obj = new JsonObject();
		
		int comm_type_j = communityService.selectCommunityStatus("J");
		int comm_type_c = communityService.selectCommunityStatus("C");
		int comm_type_p = communityService.selectCommunityStatus("P");
		int comm_type_d = communityService.selectCommunityStatus("D");
		
		obj.addProperty("result", true);
		obj.addProperty("comm_type_j", comm_type_j);
		obj.addProperty("comm_type_c", comm_type_c);
		obj.addProperty("comm_type_p", comm_type_p);
		obj.addProperty("comm_type_d", comm_type_d);
		return obj.toString();
		
	}
	
	@RequestMapping(value = "/console/community/communityManage", method = RequestMethod.GET)
	public ModelAndView communityManage(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.info("=== admin communityManage ===");
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) response.sendRedirect(request.getContextPath() + "/logout.do");
		
		ArrayList<Community> communityList = new ArrayList<Community>();
		ArrayList<Community> communityConfirmList = new ArrayList<Community>();
		
		communityList = communityService.selectAllCommunityList();
		communityConfirmList = communityService.selectConfirmCommunityList();
		
		if(communityList != null) model.addAttribute("communityList", communityList);
		if(communityConfirmList != null) model.addAttribute("communityConfirmList", communityConfirmList);
		
		return new ModelAndView("console/communityManage");
	}
	
	@RequestMapping(value = "/console/communityApproval", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String communityApproval(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		log.info("=== communityApproval ===");
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) response.sendRedirect(request.getContextPath() + "/logout.do");
//		ModelMap mp = new ModelMap();
		JsonObject obj = new JsonObject();
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		String approval = element.getAsJsonObject().get("status").getAsString();
		int manager_idx = element.getAsJsonObject().get("value1").getAsInt();
		int comm_idx = element.getAsJsonObject().get("value2").getAsInt();
		log.debug("managerIdx: " + manager_idx);
		log.debug("communityIdx: " + comm_idx);
		
		Community community = new Community();
		community.setComm_idx(comm_idx);
		community.setStatus(approval);
		
		communityService.updateCommunityApprovalAsStatus(community); 
		
		mailFrom = admin.getLogin_id();
		mailTo = userService.getLoginIdAsIdx(manager_idx);
		
		if(approval.equals("settle")) {
			mailSubject = "[DevCommunity] 커뮤니티 개설신청 승인 알림";
			mailContent = "<h2>커뮤니티 개설 신청 건이 승인되었습니다.</h2>";
		}else {
			mailSubject = "[DevCommunity] 커뮤니티 개설신청 반려 알림";
			mailContent = "<h2>커뮤니티 개설 신청 건이 반려되었습니다.</h2>";
		}
		
		mailSender.sendMail(new Email(mailFrom, mailTo, mailSubject, mailContent, mailContentType));
		
		try {
			Thread.sleep(800L);
		}catch(InterruptedException e) {
			log.error(e);
		}
		
		obj.addProperty("result", true);
		obj.addProperty("status", approval);
		obj.addProperty("comm_idx", comm_idx);
		obj.addProperty("manager_idx", manager_idx);
		
		return obj.toString();
		
	}
	
	@RequestMapping(value = "/console/insertCommunityManager", method = RequestMethod.GET)
	@ResponseBody
	public ModelMap insertCommunityManager(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelMap mp = new ModelMap();
		
		int comm_idx = Integer.parseInt(request.getParameter("comm_idx"));
		int manager_idx = Integer.parseInt(request.getParameter("manager_idx"));
		
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("comm_idx", comm_idx);
		map.put("manager_idx", manager_idx);
		
		try {
			communityService.insertCoummunityManager(map);
			mp.addAttribute("result", true);
		}catch(Exception e) {
			e.printStackTrace();
			log.error(e);
		}
		
		return mp;
	}
	
}
