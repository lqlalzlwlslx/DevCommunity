package com.dev.comm.common.dao;

import org.springframework.stereotype.Repository;

import com.dev.comm.common.vo.UserAccessLog;

@Repository
public interface UserAccessLogDao {
	
	void insertUserAccessLog(UserAccessLog ual) throws Exception;

}
