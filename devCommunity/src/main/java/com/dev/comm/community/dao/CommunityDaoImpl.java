package com.dev.comm.community.dao;

import java.util.ArrayList;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Repository;

import com.dev.comm.community.vo.Community;
import com.dev.comm.user.vo.User;

@Repository
public class CommunityDaoImpl implements CommunityDao {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private DataSourceTransactionManager transactionManager;

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Community> selectUserCommunityList(User user) throws Exception {
		return (ArrayList) sqlSession.selectList("community.selectUserCommunityList", user);
	}

	@Override
	public String communityNameDupleCheck(String value) throws Exception {
		return sqlSession.selectOne("community.selectCommunityNameDupleCheck", value);
	}

	@Override
	public int insertCommunity(Community community) throws Exception {
		return sqlSession.insert("community.insertCommunity", community);
	}

	@Override
	public int selectCommunityStatus(String value) throws Exception {
		return sqlSession.selectOne("community.selectCommunityStatus", value);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Community> selectAllCommunityList() throws Exception {
		return (ArrayList)sqlSession.selectList("community.selectAllCommunityList");
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Community> selectConfirmCommunityList() throws Exception {
		return (ArrayList) sqlSession.selectList("community.selectConfirmCommunityList");
	}
	
}
