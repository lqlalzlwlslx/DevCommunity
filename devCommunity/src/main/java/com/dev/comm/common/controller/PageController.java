package com.dev.comm.common.controller;

import java.io.File;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.dev.comm.util.Constants;

@Controller
@PropertySource("classpath:config.properties")
public class PageController {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	@Autowired
	private Environment env;
	
	@Autowired
	private ServletContext servletContext;
	
	@RequestMapping("/console")
	public ModelAndView mainAdmin(HttpServletRequest request, Model model) throws Exception {
		
		log.debug("admin console.");
		
		String defaultProfile = servletContext.getRealPath("/resources");
		String defaultProfileSrc = env.getProperty("file.user.default.profile");
		
		log.info("defaultProfile : " + defaultProfile);
		log.info("defaultProfileSrc : " + defaultProfileSrc);
		log.info("");
		log.info(defaultProfile + defaultProfileSrc);
		
		String filePath = defaultProfile + defaultProfileSrc;
		
		File file = new File(filePath);
		
		log.info("exist???: " + file.exists());
		
		return new ModelAndView("console/index");
	}
	
	@RequestMapping(value = "/loginFrm")
	public ModelAndView loginFrm(HttpServletRequest request, Model model) throws Exception {
		return new ModelAndView("user/login");
	}
	
	@RequestMapping(value = "/signUpFrm")
	public ModelAndView signUpFrm(HttpServletRequest request, Model model) throws Exception {
		return new ModelAndView("user/signUpFrm");
	}
	
	@RequestMapping(value = "/logout")
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		HttpSession session = request.getSession();
		if(session.getAttribute(Constants.ADMIN_SESSION_KEY) == null) session.invalidate();
		else {
			session.removeAttribute(Constants.USER_SESSION_KEY);
		}
		
		try {
			Thread.sleep(100L);
		}catch(InterruptedException e) {
			e.printStackTrace();
		}
		
		return new ModelAndView("redirect:/");
	}
	
	
	

}
