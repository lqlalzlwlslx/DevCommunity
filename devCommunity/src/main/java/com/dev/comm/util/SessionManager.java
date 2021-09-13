package com.dev.comm.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.dev.comm.user.vo.User;

public class SessionManager {
	
	public static User getUserSession(HttpServletRequest request) throws Exception {
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute(Constants.USER_SESSION_KEY);
		
		return user;
	}

}
