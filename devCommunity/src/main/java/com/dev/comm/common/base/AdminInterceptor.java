package com.dev.comm.common.base;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.dev.comm.user.vo.User;
import com.dev.comm.util.Constants;

public class AdminInterceptor extends HandlerInterceptorAdapter{
	
	protected final Log log = LogFactory.getLog(getClass());
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		//to-do
		
		User adminBean = (User) request.getSession().getAttribute(Constants.ADMIN_SESSION_KEY);
		if(adminBean == null) {
			log.debug("NO SESSION !!");
			return false;
		}
		if(!adminBean.isAdmin()) {
			log.debug("IS NOT ADMIN SESSION !! NOT ALLOWED !!");
			return false;
		}
		
		StringBuffer URL = request.getRequestURL();
		if(0 < URL.indexOf("logout")) {
			return true;
		}
		
		//remoteIP ...생각해보기.
		
		return true;
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception{
		//to-do
	}
	
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		//to-do
	}

}
