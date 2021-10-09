package com.dev.comm.community.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Repository;

import com.dev.comm.community.vo.Community;
import com.dev.comm.community.vo.CommunityUser;
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

	@Override
	public void updateCommunityApprovalAsStatus(Community community) throws Exception {
		sqlSession.update("community.updateCommunityApprovalAsStatus", community);
	}

	@Override
	public void insertCommunityManager(HashMap<String, Integer> map) throws Exception {
		sqlSession.insert("community.insertCommunityManager", map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Community> selectCommunityListAsSearchValues(String value) throws Exception {
		return (ArrayList) sqlSession.selectList("community.selectCommunityListAsSearchValues", value);
	}

	@Override
	public int selectCountCommunityUser(Community comm) throws Exception {
		return sqlSession.selectOne("community.selectCountCommunityUser", comm);
	}

	@Override
	public void insertCommunityUser(CommunityUser cu) throws Exception {
		sqlSession.insert("community.insertCommunityUser", cu);
	}

	@Override
	public int selectCountCommunityBoard(Community comm) throws Exception {
		return sqlSession.selectOne("community.selectCountCommunityBoard", comm);
	}

	@Override
	public Community selectCommunityDetailView(int comm_idx) throws Exception {
		return sqlSession.selectOne("community.selectCommunityDetailView", comm_idx);
	}

	@Override
	public String selectCommunityUserStatusAsIdx(long comm_idx, int user_idx) throws Exception {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("comm_idx", (int)comm_idx);
		map.put("user_idx", user_idx);
		return sqlSession.selectOne("community.selectCommunityUserStatusAsIdx", map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Community> selectUserCommunityListAsSearchValues(String value) throws Exception {
		return (ArrayList)sqlSession.selectList("community.selectUserCommunityListAsSearchValues", value);
	}
	
}
