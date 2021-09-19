package com.dev.comm.user.service;

import java.util.ArrayList;

import com.dev.comm.common.vo.BlackList;
import com.dev.comm.common.vo.Conf;
import com.dev.comm.user.vo.User;

public interface UserService {

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

	String getLoginIdAsIdx(int manager_idx) throws Exception;

	ArrayList<User> selectBlackListUser() throws Exception;

	ArrayList<User> selectAllUserList() throws Exception;

	ArrayList<Conf> selectConfAsBlackListScope() throws Exception;

	int updateUserEscapeAsIdx(int user_idx) throws Exception;

	BlackList insertBlackListuser(BlackList bl) throws Exception;

	void updateUserBlackListStatus(int user_idx) throws Exception;

	void insertBlackListUserLog(BlackList bl) throws Exception;

	BlackList deleteUserBlackList(int user_idx) throws Exception;

	void updateUserBlackListLogRelease(BlackList blackList) throws Exception;

	void updateUserBlackListReleaseStatus(int user_idx) throws Exception;

}
