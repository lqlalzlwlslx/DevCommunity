package com.dev.comm.community.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dev.comm.community.dao.CommunityDao;
import com.dev.comm.community.vo.Community;
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
	
}
