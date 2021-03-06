package com.dev.comm.user.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Repository;

import com.dev.comm.common.vo.BlackList;
import com.dev.comm.common.vo.Conf;
import com.dev.comm.community.vo.CommunityBlackList;
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

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<User> selectBlackListUser() throws Exception {
		return (ArrayList)sqlSession.selectList("user.selectBlackListUser");
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<User> selectAllUserList() throws Exception {
		return (ArrayList)sqlSession.selectList("user.selectAllUserList");
	}

	@SuppressWarnings("unchecked")
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

	@Override
	public BlackList deleteUserBlackList(int user_idx) throws Exception {
		BlackList bl = new BlackList();
		bl = sqlSession.selectOne("user.selectOneUserBlackListInfo", user_idx);
		sqlSession.delete("user.deleteUserBlackList", bl);
		return bl;
	}

	@Override
	public void updateUserBlackListLogRelease(BlackList blackList) throws Exception {
		sqlSession.update("user.updateUserBlackListLogRelease", blackList);
	}

	@Override
	public void updateUserBlackListReleaseStatus(int user_idx) throws Exception {
		sqlSession.update("user.updateUserBlackListReleaseStatus", user_idx);
	}

	@Override
	public String findLoginIdAsSecondMail(String value) throws Exception {
		return sqlSession.selectOne("user.findLoginIdAsSecondMail", value);
	}

	@Override
	public int changePasswdAsFindNewPasswd(User usr) throws Exception {
		return sqlSession.update("user.changePasswdAsFineNewPasswd", usr);
	}

	@Override
	public void updateUserStatusAsOverTryedLogin(User tUser) throws Exception {
		sqlSession.update("user.updateUserStatusAsOverTryedLogin", tUser);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<User> selectCommunityMemberManage(int cidx) throws Exception {
		return (ArrayList) sqlSession.selectList("user.selectCommunityMemberManage", cidx);
	}

	@Override
	public BlackList selectBlackListUserInfo(User tUser) throws Exception {
		return sqlSession.selectOne("user.selectBlackListUserInfo", tUser);
	}

	@Override
	public void updateCommunityUserBlackListStatus(long comm_idx, int user_idx) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("comm_idx", comm_idx);
		map.put("user_idx", user_idx);
		sqlSession.update("user.updateCommunityUserBlackListStatus", map);
	}

	@Override
	public void insertCommunityBlackListUserLog(CommunityBlackList cbl) throws Exception {
		sqlSession.insert("user.insertCommunityBlackListUserLog", cbl);
	}

	@Override
	public String getUserCommunityStatus(int user_idx, long comm_idx) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("user_idx", user_idx);
		map.put("comm_idx", comm_idx);
		return sqlSession.selectOne("user.getUserCommunityStatus", map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<User> selectCommunityUsersLoginIdAsClosure(int comm_idx) throws Exception {
		return (ArrayList) sqlSession.selectList("user.selectCommunityUsersLoginIdAsClosure", comm_idx);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<BlackList> selectBlackListUsersDaily() throws Exception {
		return (ArrayList) sqlSession.selectList("user.selectBlackListUsersDaily");
	}

	@Override
	public BlackList selectBlackListUserReleaseStatusCheck(BlackList blackList) throws Exception {
		return sqlSession.selectOne("user.selectBlackListUserReleaseStatusCheck", blackList);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<CommunityBlackList> selectCommunityBlackListUsersDaily() throws Exception {
		return (ArrayList) sqlSession.selectList("user.selectCommunityBlackListUsersDaily");
	}

	@Override
	public CommunityBlackList selectCommunityBlackListUserReleaseStatusCheck(CommunityBlackList communityBlackList)
			throws Exception {
		return sqlSession.selectOne("user.selectCommunityBlackListUserReleaseStatusCheck", communityBlackList);
	}


	
}
