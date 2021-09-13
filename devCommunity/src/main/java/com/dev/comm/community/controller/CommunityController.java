package com.dev.comm.community.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dev.comm.community.service.CommunityService;
import com.dev.comm.user.vo.User;
import com.dev.comm.util.SessionManager;
import com.google.gson.JsonObject;

@Controller
public class CommunityController {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	@Autowired
	private CommunityService communityService;
	
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

}
