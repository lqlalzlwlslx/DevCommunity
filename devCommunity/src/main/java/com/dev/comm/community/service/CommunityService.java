package com.dev.comm.community.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.dev.comm.board.vo.Board;
import com.dev.comm.community.vo.Community;
import com.dev.comm.community.vo.CommunityUser;
import com.dev.comm.user.vo.User;

public interface CommunityService {

	ArrayList<Community> selectUserCommunityList(User user) throws Exception;

	String communityNameDupleCheck(String value) throws Exception;

	int insertCommunity(Community community) throws Exception;

	int selectCommunityStatus(String value) throws Exception;

	ArrayList<Community> selectAllCommunityList() throws Exception;

	ArrayList<Community> selectConfirmCommunityList() throws Exception;

	void updateCommunityApprovalAsStatus(Community community) throws Exception;

	void insertCoummunityManager(HashMap<String, Integer> map) throws Exception;

	ArrayList<Community> selectCommunityListAsSearchValues(String searchTxt) throws Exception;

	int selectCountCommunityUser(Community comm) throws Exception;

	void insertCommunityUser(CommunityUser cu) throws Exception;

	int selectCountCommunityBoard(Community comm) throws Exception;

	Community selectCommunityDetailView(int comm_idx) throws Exception;

	String selectCommunityUserStatusAsIdx(long comm_idx, int user_idx) throws Exception;

	ArrayList<Community> selectUserCommunityListAsSearchValues(String searchTxt) throws Exception;

	ArrayList<User> selectCommunityAllMembers(Community comm) throws Exception;

	int selectCountCommunityRequestUser(Community comm) throws Exception;

	ArrayList<User> selectCommunityUsersAsCommIdx(int commIdx) throws Exception;

	int updateCommunityManagerAsMandate(int commIdx, int toIdx) throws Exception;

	void updateCommunityUserAsFromIdx(int commIdx, int fromIdx) throws Exception;

	void updateCommunityManagerInfoAsMandate(int commIdx, int toIdx, String toNick) throws Exception;

	void updateCommunityIntro(Community comminfo) throws Exception;

	ArrayList<User> selectCommunitySignRequestUsers(Community comm) throws Exception;

	void deleteCommunityRejectUserStatus(int cidx, int uidx) throws Exception;

	void updateCommunityConfirmUserStatus(int cidx, int uidx, String status) throws Exception;

}
