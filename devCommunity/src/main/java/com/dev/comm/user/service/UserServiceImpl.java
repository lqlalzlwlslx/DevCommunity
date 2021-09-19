package com.dev.comm.user.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dev.comm.common.vo.BlackList;
import com.dev.comm.common.vo.Conf;
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

	
}
