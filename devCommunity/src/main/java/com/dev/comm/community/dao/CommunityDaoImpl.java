package com.dev.comm.community.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Repository;

import com.dev.comm.board.vo.Board;
import com.dev.comm.community.vo.Community;
import com.dev.comm.community.vo.CommunityBlackList;
import com.dev.comm.community.vo.CommunityClosure;
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

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<User> selectCommunityAllMembers(Community comm) throws Exception {
		return (ArrayList)sqlSession.selectList("community.selectCommunityAllMembers", comm);
	}

	@Override
	public int selectCountCommunityRequestUser(Community comm) throws Exception {
		return sqlSession.selectOne("community.selectCountCommunityRequestUser", comm);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<User> selectCommunityUsersAsCommIdx(int commIdx) throws Exception {
		return (ArrayList) sqlSession.selectList("community.selectCommunityUsersAsCommIdx", commIdx);
	}

	@Override
	public int updateCommunityManagerAsMandate(int commIdx, int toIdx) throws Exception {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("comm_idx", commIdx);
		map.put("to_idx", toIdx);
		return sqlSession.update("community.updateCommunityManagerAsMandate", map);
	}

	@Override
	public void updateCommunityUserAsFromIdx(int commIdx, int fromIdx) throws Exception {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("comm_idx", commIdx);
		map.put("from_idx", fromIdx);
		sqlSession.update("community.updateCommunityUserAsFromIdx", map);
	}

	@Override
	public void updateCommunityManagerInfoAsMandate(int commIdx, int toIdx, String toNick) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("comm_idx", commIdx);
		map.put("to_idx", toIdx);
		map.put("to_nick", toNick);
		sqlSession.update("community.updateCommunityManagerInfoAsMandate", map);
	}

	@Override
	public void updateCommunityIntro(Community comminfo) throws Exception {
		sqlSession.update("community.updateCommunityIntro", comminfo);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<User> selectCommunitySignRequestUsers(Community comm) throws Exception {
		return (ArrayList) sqlSession.selectList("community.selectCommunitySignRequestUsers", comm);
	}

	@Override
	public void deleteCommunityRejectUserStatus(int cidx, int uidx) throws Exception {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("comm_idx", cidx);
		map.put("user_idx", uidx);
		sqlSession.delete("community.deleteCommunityRejectUserStatus", map);
	}

	@Override
	public void updateCommunityConfirmUserStatus(int cidx, int uidx, String status) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("comm_idx", cidx);
		map.put("user_idx", uidx);
		map.put("comm_user_stat_cd", status);
		sqlSession.update("community.updateCommunityConfirmUserStatus", map);
	}

	@Override
	public void deleteCommunitySignUserCancel(int user_idx, int comm_idx) throws Exception {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("user_idx", user_idx);
		map.put("comm_idx", comm_idx);
		sqlSession.delete("community.deleteCommunitySignUserCancel", map);
	}

	@Override
	public void updateUserCommunityLoginDate(int user_idx, long comm_idx) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("user_idx", user_idx);
		map.put("comm_idx", comm_idx);
		sqlSession.update("community.updateUserCommunityLoginDate", map);
	}

	@Override
	public int selectCountCommunityBlack(Community comm) throws Exception {
		return sqlSession.selectOne("community.selectCountCommunityBlack", comm);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<User> selectCommunityBlackListUser(Community comm) throws Exception {
		return (ArrayList) sqlSession.selectList("community.selectCommunityBlackListUser", comm);
	}

	@Override
	public CommunityBlackList insertCommunityBlackListUser(CommunityBlackList cbl) throws Exception {
		sqlSession.insert("community.insertCommunityBlackListUser", cbl);
		CommunityBlackList commBlackList = new CommunityBlackList();
		commBlackList = sqlSession.selectOne("community.selectCommunityBlackListUserForLog", cbl);
		return commBlackList;
	}

	@Override
	public CommunityBlackList selectCommunityBlackListUserInfo(int uidx, int cidx) throws Exception {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("uidx", uidx);
		map.put("cidx", cidx);
		return sqlSession.selectOne("community.selectCommunityBlackListUserInfo", map);
	}

	@Override
	public void deleteCommunityUserBlackList(CommunityBlackList comBlinfo) throws Exception {
		sqlSession.delete("community.deleteCommunityUserBlackList", comBlinfo);
	}

	@Override
	public void updateCommunityUserBlackListLogRelease(CommunityBlackList comBlinfo) throws Exception {
		sqlSession.update("community.updateCommunityBlackListLogRelease", comBlinfo);
	}

	@Override
	public void updateCommunityUserBlackListReleaseStatus(int uidx, int cidx) throws Exception {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("uidx", uidx);
		map.put("cidx", cidx);
		sqlSession.update("community.updateCommunityUserBlackListReleaseStatus", map);
	}

	@Override
	public int selectCountCommunityBlackBoard(Community comm) throws Exception {
		return sqlSession.selectOne("community.selectCountCommunityBlackBoard", comm);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Board> selectCommunityBlackBoardList(Community comm) throws Exception {
		return (ArrayList) sqlSession.selectList("community.selectCommunityBlackBoardList", comm);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Board> selectCommunityActiveBoardList(Community comm) throws Exception {
		return (ArrayList) sqlSession.selectList("community.selectCommunityActiveBoardList", comm);
	}

	@Override
	public void insertCommunityClosureRequestAsFlag(CommunityClosure cc) throws Exception {
		sqlSession.insert("community.insertCommunityClosureRequestAsFlag", cc);
	}

	@Override
	public CommunityClosure selectCommunityClosureRequestDataAsCidx(long comm_idx) throws Exception {
		return sqlSession.selectOne("community.selectCommunityClosureRequestDataAsCidx", (int)comm_idx);
	}

	@Override
	public CommunityClosure deleteCommunityClosureAsManager(int comm_idx) throws Exception {
		CommunityClosure ccinfo = sqlSession.selectOne("community.selectCommunityClosureRequestDataAsCidx", comm_idx);
		sqlSession.delete("community.deleteCommunityClosureAsManager", comm_idx);
		return ccinfo;
	}

	@Override
	public int userCommunityExit(int cidx, int uidx) throws Exception {
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("cidx", cidx);
		map.put("uidx", uidx);
		return sqlSession.delete("community.userCommunityExit", map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Community> selectUserSignCommunityList(int user_idx) throws Exception {
		return (ArrayList) sqlSession.selectList("community.selectUserSignCommunityList", user_idx);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Community> selectUserAllCommunityList() throws Exception {
		return (ArrayList) sqlSession.selectList("community.selectUserAllCommunityList");
	}

	@Override
	public CommunityBlackList deleteCommunityUserBlackList2(CommunityBlackList cbl) throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("uidx", cbl.getUser_idx());
		map.put("cidx", cbl.getComm_idx());
		CommunityBlackList cb = sqlSession.selectOne("community.selectCommunityBlackListUserInfo", map);
		sqlSession.delete("community.deleteCommunityUserBlackList", cbl);
		return cb;
	}
	
}
