package com.dev.comm.common.base;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.dev.comm.user.vo.User;
import com.dev.comm.util.Constants;

public class SessionInterceptor extends HandlerInterceptorAdapter{
	
	protected final Log log = LogFactory.getLog(getClass());
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		//to-do
		StringBuffer URL = request.getRequestURL();
		
		if(0 < URL.indexOf("/user")) return true;
		
		HttpSession session = request.getSession();
		Object userBean = session.getAttribute(Constants.USER_SESSION_KEY);
		Object adminBean = session.getAttribute(Constants.ADMIN_SESSION_KEY);
		if(userBean == null && adminBean == null) {
			log.debug("NO SESSION !!");
		}else {
			if((userBean != null) && ((User)userBean).getAccess_ip().equals(request.getRemoteAddr())
					|| (adminBean != null) && ((User)adminBean).getAccess_ip().equals(request.getRemoteAddr())) {
				return false;
			}
		}
		
		return true;
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		//to-do
	}
	
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		//to-do
	}

}
