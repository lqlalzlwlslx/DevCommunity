package com.dev.comm.user.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

	
}
