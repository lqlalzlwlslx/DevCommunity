package com.dev.comm.community.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
		community.setManager_idx(user.getUser_idx()+"");
		community.setManager_name(user.getNick_name());
		community.setComm_type_cd(comm_type);
		community.setComm_reg_cont(comm_reg_cont);
		community.setComm_stat_cd("I"); //신청할 때 비활성으로 insert. 관리자 승인 후 활성시키는 걸로..
		
		if(communityService.insertCommunity(community) > 0) {
			String adminEmail = userService.selectAdminEmail(); //decadmin@gmail.com,saint@pdic.co.kr
			String content = "";
			content += "<h2>커뮤니티 신청 건이 있습니다.</h2><br />";
			content += "<h3>확인 후 사이트에 접속하셔서 승인 바랍니다.</h3><br /><br />";
			content += "<h4>신청자(닉네임) : " + community.getManager_name() + "<br />";
			content += "커뮤니티명 : " + community.getComm_name() + "<br />";
			content += "커뮤니티 타입 : " + community.getComm_type_cd() + "<br />";
			content += "신청사유 : " + community.getComm_reg_cont() + "<br /></h4>";
			//content += "신청일자 : " + community.getReg_date();
			
			Email email = new Email();
			email.setFrom(user.getLogin_id());
			email.setMailto(adminEmail);
			email.setSubject(user.getNick_name() + "님의 [" + community.getComm_name() + "] 개설 신청");
			email.setContent(content);
			
			mailSender.sendMail(email);
			
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
}
