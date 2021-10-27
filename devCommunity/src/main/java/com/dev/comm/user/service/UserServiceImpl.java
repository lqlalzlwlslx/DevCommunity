package com.dev.comm.user.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dev.comm.common.vo.BlackList;
import com.dev.comm.common.vo.Conf;
import com.dev.comm.community.vo.CommunityBlackList;
import com.dev.comm.user.dao.UserDao;
import com.dev.comm.user.vo.User;

@Service
public class UserServiceImpl implements UserService {
	
	@Autowired
	private UserDao userDao;
	
	@Override
	public User selectUserInfoAsLogin(User user) throws Exception {
		return userDao.selectUserInfoAsLogin(user);
	}

	@Override
	public void updateUserInfo(User usr01) throws Exception {
		userDao.updateUserInfo(usr01);
	}

	@Override
	public int insertUser(User user) throws Exception {
		return userDao.insertUser(user);
	}

	@Override
	public User selectUserInfoAsIdx(int user_idx) throws Exception {
		return userDao.selectUserInfoAsIdx(user_idx);
	}

	@Override
	public void updateUserLogin(User user) throws Exception {
		userDao.updateUserLogin(user);
	}

	@Override
	public void updateUserLoginTry(User tUser) throws Exception {
		userDao.updateUserLoginTry(tUser);
	}

	@Override
	public void updateUserProfile(User user) throws Exception {
		userDao.updateUserProfile(user);
	}

	@Override
	public String getUserPassword(int user_idx) throws Exception {
		return userDao.getUserPassword(user_idx);
	}

	@Override
	public String getUserProfileSrc(int user_idx) throws Exception {
		return userDao.getUserProfileSrc(user_idx);
	}

	@Override
	public String selectAdminEmail() throws Exception {
		return userDao.selectAdminEmail();
	}

	@Override
	public String userNickDupleCheck(String nickName) throws Exception {
		return userDao.userNickDupleCheck(nickName);
	}

	@Override
	public String getLoginIdAsIdx(int manager_idx) throws Exception {
		return userDao.getLoginIdAsIdx(manager_idx);
	}

	@Override
	public ArrayList<User> selectBlackListUser() throws Exception {
		return userDao.selectBlackListUser();
	}

	@Override
	public ArrayList<User> selectAllUserList() throws Exception {
		return userDao.selectAllUserList();
	}

	@Override
	public ArrayList<Conf> selectConfAsBlackListScope() throws Exception {
		return userDao.selectConfAsBlackListScope();
	}

	@Override
	public int updateUserEscapeAsIdx(int user_idx) throws Exception {
		return userDao.updateUserEscapeAsIdx(user_idx);
	}

	@Override
	public BlackList insertBlackListuser(BlackList bl) throws Exception {
		return userDao.insertBlackListuser(bl);
	}

	@Override
	public void updateUserBlackListStatus(int user_idx) throws Exception {
		userDao.updateUserBlackListStatus(user_idx);
	}

	@Override
	public void insertBlackListUserLog(BlackList bl) throws Exception {
		userDao.insertBlackListUserLog(bl);
	}

	@Override
	public BlackList deleteUserBlackList(int user_idx) throws Exception {
		return userDao.deleteUserBlackList(user_idx);
	}

	@Override
	public void updateUserBlackListLogRelease(BlackList blackList) throws Exception {
		userDao.updateUserBlackListLogRelease(blackList);
	}

	@Override
	public void updateUserBlackListReleaseStatus(int user_idx) throws Exception {
		userDao.updateUserBlackListReleaseStatus(user_idx);
	}

	@Override
	public String findLoginIdAsSecondMail(String value) throws Exception {
		return userDao.findLoginIdAsSecondMail(value);
	}

	@Override
	public int changePasswdAsFindNewPasswd(User usr) throws Exception {
		return userDao.changePasswdAsFindNewPasswd(usr);
	}

	@Override
	public void updateUserStatusAsOverTryedLogin(User tUser) throws Exception {
		userDao.updateUserStatusAsOverTryedLogin(tUser);
	}

	@Override
	public ArrayList<User> selectCommunityMemberManage(int cidx) throws Exception {
		return userDao.selectCommunityMemberManage(cidx);
	}

	@Override
	public BlackList selectBlackListUserInfo(User tUser) throws Exception {
		return userDao.selectBlackListUserInfo(tUser);
	}

	@Override
	public void updateCommunityUserBlackListStatus(long comm_idx, int user_idx) throws Exception {
		userDao.updateCommunityUserBlackListStatus(comm_idx, user_idx);
	}

	@Override
	public void inserCommunityBlackListUserLog(CommunityBlackList cbl) throws Exception {
		userDao.insertCommunityBlackListUserLog(cbl);
	}

	@Override
	public String getUserCommunityStatus(int user_idx, long comm_idx) throws Exception {
		return userDao.getUserCommunityStatus(user_idx, comm_idx);
	}

	@Override
	public ArrayList<User> selectCommunityUsersLoginIdAsClosure(int comm_idx) throws Exception {
		return userDao.selectCommunityUsersLoginIdAsClosure(comm_idx);
	}

	@Override
	public ArrayList<BlackList> selectBlackListUsersDaily() throws Exception {
		return userDao.selectBlackListUsersDaily();
	}

	@Override
	public BlackList selectBlackListUserReleaseStatusCheck(BlackList blackList) throws Exception {
		return userDao.selectBlackListUserReleaseStatusCheck(blackList);
	}

	@Override
	public ArrayList<CommunityBlackList> selectCommunityBlackListUsersDaily() throws Exception {
		return userDao.selectCommunityBlackListUsersDaily();
	}

	@Override
	public CommunityBlackList selectCommunityBlackListUserReleaseStatusCheck(CommunityBlackList communityBlackList)
			throws Exception {
		return userDao.selectCommunityBlackListUserReleaseStatusCheck(communityBlackList);
	}

	
}
