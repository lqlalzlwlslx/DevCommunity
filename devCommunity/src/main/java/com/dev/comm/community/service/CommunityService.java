package com.dev.comm.community.service;

import java.util.ArrayList;

import com.dev.comm.community.vo.Community;
import com.dev.comm.user.vo.User;

public interface CommunityService {

	ArrayList<Community> selectUserCommunityList(User user) throws Exception;

	String communityNameDupleCheck(String value) throws Exception;

	int insertCommunity(Community community) throws Exception;

}
