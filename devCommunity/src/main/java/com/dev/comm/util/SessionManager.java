package com.dev.comm.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.dev.comm.user.vo.User;

public class SessionManager {
	
	public static User getUserSession(HttpServletRequest request) {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(Constants.USER_SESSION_KEY);
		
		return user;
	}
	
	public static User getAdminSession(HttpServletRequest request) {
		HttpSession session = request.getSession();
		User admin = (User) session.getAttribute(Constants.ADMIN_SESSION_KEY);
		
		return admin;
	}
	
	public static void expireSession(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		if(session != null) session.invalidate();
		session = null;
	}
	
	public static boolean isAlive(HttpServletRequest request) {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(Constants.USER_SESSION_KEY);
		
		if(user == null) return false;
		else return true;
	}

}
