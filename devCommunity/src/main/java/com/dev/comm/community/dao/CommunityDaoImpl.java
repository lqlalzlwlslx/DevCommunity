package com.dev.comm.community.dao;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Repository;

import com.dev.comm.community.vo.Community;
import com.dev.comm.user.vo.User;

@Repository
public class CommunityDaoImpl implements CommunityDao {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private DataSourceTransactionManager transactionManager;

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Community> selectUserCommunityList(User user) throws Exception {
		ArrayList<Community> userCommunityList = (ArrayList) sqlSession.selectList("community.selectUserCommunityList", user);
		return userCommunityList;
	}

	@Override
	public String communityNameDupleCheck(String value) throws Exception {
		return sqlSession.selectOne("community.selectCommunityNameDupleCheck", value);
	}
	
}
