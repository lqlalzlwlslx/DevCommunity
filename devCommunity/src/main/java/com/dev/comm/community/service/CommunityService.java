package com.dev.comm.community.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.dev.comm.board.vo.Board;
import com.dev.comm.community.vo.Community;
import com.dev.comm.community.vo.CommunityBlackList;
import com.dev.comm.community.vo.CommunityClosure;
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

	void deleteCommunitySignUserCancel(int user_idx, int comm_idx) throws Exception;

	void updateUserCommunityLoginDate(int user_idx, long comm_idx) throws Exception;

	int selectCountCommunityBlack(Community comm) throws Exception;

	ArrayList<User> selectCommunityBlackListUser(Community comm) throws Exception;

	CommunityBlackList insertCommunityBlackListUser(CommunityBlackList cbl) throws Exception;

	CommunityBlackList selectCommunityBlackListUserInfo(int uidx, int cidx) throws Exception;

	void deleteCommunityUserBlackList(CommunityBlackList comBlinfo) throws Exception;

	void updateCommunityUserBlackListLogRelease(CommunityBlackList comBlinfo) throws Exception;

	void updateCommunityUserBlackListReleaseStatus(int uidx, int cidx) throws Exception;

	int selectCountCommunityBlackBoard(Community comm) throws Exception;

	ArrayList<Board> selectCommunityBlackBoardList(Community comm) throws Exception;

	ArrayList<Board> selectCommunityActiveBoardList(Community comm) throws Exception;

	void insertCommunityClosureRequestAsFlag(CommunityClosure cc) throws Exception;

	CommunityClosure selectCommunityClosureRequestDataAsCidx(long comm_idx) throws Exception;

	CommunityClosure deleteCommunityClosureAsManager(int cidx) throws Exception;

	int userCommunityExit(int cidx, int uidx) throws Exception;

	ArrayList<Community> selectUserSignCommunityList(int user_idx) throws Exception;

	ArrayList<Community> selectUserAllCommunityList() throws Exception;

}
