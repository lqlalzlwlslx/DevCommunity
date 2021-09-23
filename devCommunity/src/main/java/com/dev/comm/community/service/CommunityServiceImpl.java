package com.dev.comm.community.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dev.comm.community.dao.CommunityDao;
import com.dev.comm.community.vo.Community;
import com.dev.comm.community.vo.CommunityUser;
import com.dev.comm.user.vo.User;

@Service
public class CommunityServiceImpl implements CommunityService {
	
	@Autowired
	private CommunityDao communityDao;

	@Override
	public ArrayList<Community> selectUserCommunityList(User user) throws Exception {
		return communityDao.selectUserCommunityList(user);
	}

	@Override
	public String communityNameDupleCheck(String value) throws Exception {
		return communityDao.communityNameDupleCheck(value);
	}

	@Override
	public int insertCommunity(Community community) throws Exception {
		return communityDao.insertCommunity(community);
	}

	@Override
	public int selectCommunityStatus(String value) throws Exception {
		return communityDao.selectCommunityStatus(value);
	}

	@Override
	public ArrayList<Community> selectAllCommunityList() throws Exception {
		return communityDao.selectAllCommunityList();
	}

	@Override
	public ArrayList<Community> selectConfirmCommunityList() throws Exception {
		return communityDao.selectConfirmCommunityList();
	}

	@Override
	public void updateCommunityApprovalAsStatus(Community community) throws Exception {
		communityDao.updateCommunityApprovalAsStatus(community);
	}

	@Override
	public void insertCoummunityManager(HashMap<String, Integer> map) throws Exception {
		communityDao.insertCommunityManager(map);
	}

	@Override
	public ArrayList<Community> selectCommunityListAsSearchValues(String value) throws Exception {
		return communityDao.selectCommunityListAsSearchValues(value);
	}

	@Override
	public int selectCountCommunityUser(Community comm) throws Exception {
		return communityDao.selectCountCommunityUser(comm);
	}

	@Override
	public void insertCommunityUser(CommunityUser cu) throws Exception {
		communityDao.insertCommunityUser(cu);
	}

	@Override
	public int selectCountCommunityBoard(Community comm) throws Exception {
		return communityDao.selectCountCommunityBoard(comm);
	}
	
}
