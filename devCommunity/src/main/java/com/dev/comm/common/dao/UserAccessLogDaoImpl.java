package com.dev.comm.common.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Repository;

import com.dev.comm.common.vo.UserAccessLog;

@Repository
public class UserAccessLogDaoImpl implements UserAccessLogDao {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private DataSourceTransactionManager transactionManager;

	@Override
	public void insertUserAccessLog(UserAccessLog ual) throws Exception {
		sqlSession.insert("userAccessLog.insertUserAccessLog", ual);
	}

}
