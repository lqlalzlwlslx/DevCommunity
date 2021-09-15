package com.dev.comm.user.dao;

import com.dev.comm.user.vo.User;

public interface UserDao {

	User selectUserInfoAsLogin(User user) throws Exception;

	void updateUserInfo(User usr01) throws Exception;

	int insertUser(User user) throws Exception;

	User selectUserInfoAsIdx(int user_idx) throws Exception;

	void updateUserLogin(User user) throws Exception;

	void updateUserLoginTry(User tUser) throws Exception;

	void updateUserProfile(User user) throws Exception;

	String getUserPassword(int user_idx) throws Exception;

	String getUserProfileSrc(int user_idx) throws Exception;

	String selectAdminEmail() throws Exception;

	String userNickDupleCheck(String nickName) throws Exception;

}
