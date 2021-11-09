package com.dev.comm.community.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dev.comm.board.vo.Board;
import com.dev.comm.community.dao.CommunityDao;
import com.dev.comm.community.vo.Community;
import com.dev.comm.community.vo.CommunityBlackList;
import com.dev.comm.community.vo.CommunityClosure;
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

	@Override
	public Community selectCommunityDetailView(int comm_idx) throws Exception {
		return communityDao.selectCommunityDetailView(comm_idx);
	}

	@Override
	public String selectCommunityUserStatusAsIdx(long comm_idx, int user_idx) throws Exception {
		return communityDao.selectCommunityUserStatusAsIdx(comm_idx, user_idx);
	}

	@Override
	public ArrayList<Community> selectUserCommunityListAsSearchValues(String value, int user_idx) throws Exception {
		return communityDao.selectUserCommunityListAsSearchValues(value, user_idx);
	}

	@Override
	public ArrayList<User> selectCommunityAllMembers(Community comm) throws Exception {
		return communityDao.selectCommunityAllMembers(comm);
	}

	@Override
	public int selectCountCommunityRequestUser(Community comm) throws Exception {
		return communityDao.selectCountCommunityRequestUser(comm);
	}

	@Override
	public ArrayList<User> selectCommunityUsersAsCommIdx(int commIdx) throws Exception {
		return communityDao.selectCommunityUsersAsCommIdx(commIdx);
	}

	@Override
	public int updateCommunityManagerAsMandate(int commIdx, int toIdx) throws Exception {
		return communityDao.updateCommunityManagerAsMandate(commIdx, toIdx);
	}

	@Override
	public void updateCommunityUserAsFromIdx(int commIdx, int fromIdx) throws Exception {
		communityDao.updateCommunityUserAsFromIdx(commIdx, fromIdx);
	}

	@Override
	public void updateCommunityManagerInfoAsMandate(int commIdx, int toIdx, String toNick) throws Exception {
		communityDao.updateCommunityManagerInfoAsMandate(commIdx, toIdx, toNick);
	}

	@Override
	public void updateCommunityIntro(Community comminfo) throws Exception {
		communityDao.updateCommunityIntro(comminfo);
	}

	@Override
	public ArrayList<User> selectCommunitySignRequestUsers(Community comm) throws Exception {
		return communityDao.selectCommunitySignRequestUsers(comm);
	}

	@Override
	public void deleteCommunityRejectUserStatus(int cidx, int uidx) throws Exception {
		communityDao.deleteCommunityRejectUserStatus(cidx, uidx);
	}

	@Override
	public void updateCommunityConfirmUserStatus(int cidx, int uidx, String status) throws Exception {
		communityDao.updateCommunityConfirmUserStatus(cidx, uidx, status);
	}

	@Override
	public void deleteCommunitySignUserCancel(int user_idx, int comm_idx) throws Exception {
		communityDao.deleteCommunitySignUserCancel(user_idx, comm_idx);
	}

	@Override
	public void updateUserCommunityLoginDate(int user_idx, long comm_idx) throws Exception {
		communityDao.updateUserCommunityLoginDate(user_idx, comm_idx);
	}

	@Override
	public int selectCountCommunityBlack(Community comm) throws Exception {
		return communityDao.selectCountCommunityBlack(comm);
	}

	@Override
	public ArrayList<User> selectCommunityBlackListUser(Community comm) throws Exception {
		return communityDao.selectCommunityBlackListUser(comm);
	}

	@Override
	public CommunityBlackList insertCommunityBlackListUser(CommunityBlackList cbl) throws Exception {
		return communityDao.insertCommunityBlackListUser(cbl);
	}

	@Override
	public CommunityBlackList selectCommunityBlackListUserInfo(int uidx, int cidx) throws Exception {
		return communityDao.selectCommunityBlackListUserInfo(uidx, cidx);
	}

	@Override
	public void deleteCommunityUserBlackList(CommunityBlackList comBlinfo) throws Exception {
		communityDao.deleteCommunityUserBlackList(comBlinfo);
	}

	@Override
	public void updateCommunityUserBlackListLogRelease(CommunityBlackList comBlinfo) throws Exception {
		communityDao.updateCommunityUserBlackListLogRelease(comBlinfo);
	}

	@Override
	public void updateCommunityUserBlackListReleaseStatus(int uidx, int cidx) throws Exception {
		communityDao.updateCommunityUserBlackListReleaseStatus(uidx, cidx);
	}

	@Override
	public int selectCountCommunityBlackBoard(Community comm) throws Exception {
		return communityDao.selectCountCommunityBlackBoard(comm);
	}

	@Override
	public ArrayList<Board> selectCommunityBlackBoardList(Community comm) throws Exception {
		return communityDao.selectCommunityBlackBoardList(comm);
	}

	@Override
	public ArrayList<Board> selectCommunityActiveBoardList(Community comm) throws Exception {
		return communityDao.selectCommunityActiveBoardList(comm);
	}

	@Override
	public void insertCommunityClosureRequestAsFlag(CommunityClosure cc) throws Exception {
		communityDao.insertCommunityClosureRequestAsFlag(cc);
	}

	@Override
	public CommunityClosure selectCommunityClosureRequestDataAsCidx(long comm_idx) throws Exception {
		return communityDao.selectCommunityClosureRequestDataAsCidx(comm_idx);
	}

	@Override
	public CommunityClosure deleteCommunityClosureAsManager(int cidx) throws Exception {
		return communityDao.deleteCommunityClosureAsManager(cidx);
	}

	@Override
	public int userCommunityExit(int cidx, int uidx) throws Exception {
		return communityDao.userCommunityExit(cidx, uidx);
	}

	@Override
	public ArrayList<Community> selectUserSignCommunityList(int user_idx) throws Exception {
		return communityDao.selectUserSignCommunityList(user_idx);
	}

	@Override
	public ArrayList<Community> selectUserAllCommunityList(int user_idx) throws Exception {
		return communityDao.selectUserAllCommunityList(user_idx);
	}

	@Override
	public CommunityBlackList deleteCommunityUserBlackList2(CommunityBlackList cbl) throws Exception {
		return communityDao.deleteCommunityUserBlackList2(cbl);
	}
	
}
