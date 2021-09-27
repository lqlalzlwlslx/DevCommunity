package com.dev.comm.community.dao;

import java.util.ArrayList;
import java.util.HashMap;

import com.dev.comm.community.vo.Community;
import com.dev.comm.community.vo.CommunityUser;
import com.dev.comm.user.vo.User;

public interface CommunityDao {

	ArrayList<Community> selectUserCommunityList(User user) throws Exception;

	String communityNameDupleCheck(String value) throws Exception;

	int insertCommunity(Community community) throws Exception;

	int selectCommunityStatus(String value) throws Exception;

	ArrayList<Community> selectAllCommunityList() throws Exception;

	ArrayList<Community> selectConfirmCommunityList() throws Exception;

	void updateCommunityApprovalAsStatus(Community community) throws Exception;

	void insertCommunityManager(HashMap<String, Integer> map) throws Exception;

	ArrayList<Community> selectCommunityListAsSearchValues(String value) throws Exception;

	int selectCountCommunityUser(Community comm) throws Exception;

	void insertCommunityUser(CommunityUser cu) throws Exception;

	int selectCountCommunityBoard(Community comm) throws Exception;

	Community selectCommunityDetailView(int comm_idx) throws Exception;

	String selectCommunityUserStatusAsIdx(long comm_idx, int user_idx) throws Exception;

}
