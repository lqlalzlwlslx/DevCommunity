package com.dev.comm.user.dao;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Repository;

import com.dev.comm.common.vo.BlackList;
import com.dev.comm.common.vo.Conf;
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

	@Override
	public String selectAdminEmail() throws Exception {
		return sqlSession.selectOne("user.selectAdminEmail");
	}

	@Override
	public String userNickDupleCheck(String nickName) throws Exception {
		return sqlSession.selectOne("user.userNickDupleCheck", nickName);
	}

	@Override
	public String getLoginIdAsIdx(int manager_idx) throws Exception {
		return sqlSession.selectOne("user.getLoginIdAsIdx", manager_idx);
	}

	@Override
	public ArrayList<User> selectBlackListUser() throws Exception {
		return (ArrayList)sqlSession.selectList("user.selectBlackListUser");
	}

	@Override
	public ArrayList<User> selectAllUserList() throws Exception {
		return (ArrayList)sqlSession.selectList("user.selectAllUserList");
	}

	@Override
	public ArrayList<Conf> selectConfAsBlackListScope() throws Exception {
		return (ArrayList)sqlSession.selectList("user.selectConfAsBlackListScope");
	}

	@Override
	public int updateUserEscapeAsIdx(int user_idx) throws Exception {
		return sqlSession.update("user.updateUserEscapeAsIdx", user_idx);
	}

	@Override
	public BlackList insertBlackListuser(BlackList bl) throws Exception {
		sqlSession.insert("user.insertBlackListUser", bl);
		BlackList blackList = new BlackList();
		blackList = sqlSession.selectOne("user.selectOneBlackListForLog", bl);
		return blackList;
	}

	@Override
	public void updateUserBlackListStatus(int user_idx) throws Exception {
		sqlSession.update("user.updateUserBlackListStatus", user_idx);
	}

	@Override
	public void insertBlackListUserLog(BlackList bl) throws Exception {
		sqlSession.insert("user.insertBlackListUserLog", bl);
	}

	
}
