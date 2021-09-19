package com.dev.comm.community.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.dev.comm.community.vo.Community;
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

}
