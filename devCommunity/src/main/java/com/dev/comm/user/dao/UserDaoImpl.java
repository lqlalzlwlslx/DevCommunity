package com.dev.comm.user.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Repository;

import com.dev.comm.user.vo.User;

@Repository
public class UserDaoImpl implements UserDao {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private DataSourceTransactionManager transactionManager;
	
	@Override
	public User selectUserInfoAsLogin(User user) throws Exception {
		return (User) sqlSession.selectOne("user.selectUserInfoAsLogin", user);
	}

	@Override
	public void updateUserInfo(User usr01) throws Exception {
		sqlSession.update("user.updateUserInfo", usr01);
	}

	@Override
	public int insertUser(User user) throws Exception {
		return sqlSession.insert("user.insertUser", user);
	}

	@Override
	public User selectUserInfoAsIdx(int user_idx) throws Exception {
		return sqlSession.selectOne("user.selectUserInfoAsIdx", user_idx);
	}

	@Override
	public void updateUserLogin(User user) throws Exception {
		sqlSession.update("user.updateUserLogin", user);
		
	}

	@Override
	public void updateUserLoginTry(User tUser) throws Exception {
		sqlSession.update("user.updateUserLoginTry", tUser);
	}

	@Override
	public void updateUserProfile(User user) throws Exception {
		sqlSession.update("user.updateUserProfile", user);
	}

	@Override
	public String getUserPassword(int user_idx) throws Exception {
		return sqlSession.selectOne("user.getUserPassword", user_idx);
	}

	@Override
	public String getUserProfileSrc(int user_idx) throws Exception {
		return sqlSession.selectOne("user.getUserProfileSrc", user_idx);
	}

	
}
