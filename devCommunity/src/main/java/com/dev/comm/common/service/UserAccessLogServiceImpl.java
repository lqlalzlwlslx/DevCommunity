package com.dev.comm.common.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dev.comm.common.dao.UserAccessLogDao;
import com.dev.comm.common.vo.UserAccessLog;

@Service
public class UserAccessLogServiceImpl implements UserAccessLogService {
	
	@Autowired
	private UserAccessLogDao userAccessLogDao;

	@Override
	public void insertUserAccessLog(UserAccessLog ual) throws Exception {
		userAccessLogDao.insertUserAccessLog(ual);
	}

}
