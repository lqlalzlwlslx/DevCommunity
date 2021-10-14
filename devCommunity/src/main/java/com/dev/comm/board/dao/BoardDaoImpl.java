package com.dev.comm.board.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Repository;

import com.dev.comm.board.vo.Board;
import com.dev.comm.board.vo.BoardFile;
import com.dev.comm.board.vo.Reply;
import com.dev.comm.user.vo.User;

@Repository
public class BoardDaoImpl implements BoardDao {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	@Autowired
	private DataSourceTransactionManager transactionManager;

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Board> selectAllCommunityBoardList(long comm_idx) throws Exception {
		return (ArrayList)sqlSession.selectList("board.selectAllCommunityBoardList", comm_idx);
	}

	@Override
	public Board insertCommunityBoard(Board board) throws Exception {
		Board b = new Board();
		sqlSession.insert("board.insertCommunityBoard", board);
		b = sqlSession.selectOne("board.selectCommunityBoardInfo", board);
		if(b != null) return b;
		else return new Board();
	}

	@Override
	public void insertCommunityBoardFile(BoardFile boardFile) throws Exception {
		sqlSession.insert("board.insertCommunityBoardFile", boardFile);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Board> selectVisitorMainBoardList(Board board) throws Exception {
		return (ArrayList)sqlSession.selectList("board.selectVisitorMainBoardList", board);
	}

	@Override
	public ArrayList<Board> selectUserMainBoardList() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Board> selectUserMainBoardList(User user) throws Exception {
		return (ArrayList)sqlSession.selectList("board.selectUserMainBoardList", user);
	}

	@Override
	public Board selectOneBoardInfoAsIdx(int value) throws Exception {
		return sqlSession.selectOne("board.selectOneBoardInfoAsIdx", value);
	}

	@Override
	public void updateBoardStatusAsFlag(Board boardInfo) throws Exception {
		sqlSession.update("board.updateBoardStatusAsFlag", boardInfo);
	}

	@Override
	public void updateBoardAsIdx(Board board) throws Exception {
		sqlSession.update("board.updateBoardAsIdx", board);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void deleteCommunityBoardFileList(Board board) throws Exception {
		BoardFile bf = null;
		ArrayList<BoardFile> bfList = (ArrayList)sqlSession.selectList("board.selectCommunityBoardFileListAsIdx", board);
		if(bfList != null && bfList.size() > 0) {
			for(int i = 0; i < bfList.size(); i++) {
				bf = bfList.get(i);
				sqlSession.insert("board.insertCommunityBoardFileLog", bf);
			}
		}
		sqlSession.delete("board.deleteCommunityBoardFileAsIdx", board);
	}

	@Override
	public void insertCommunityBoardReply(Reply reply) throws Exception {
		sqlSession.insert("board.insertCommunityBoardReply", reply);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Reply> selectBoardReplyListAsBidx(long board_idx) throws Exception {
		return (ArrayList)sqlSession.selectList("board.selectBoardReplyListAsBidx", board_idx);
	}

	@Override
	public void updateCommunityBoardReplyContent(Reply modifyReply) throws Exception {
		sqlSession.update("board.updateCommunityBoardReplyContent", modifyReply);
	}

	@Override
	public void deleteCommunityBoardReply(Reply delReply) throws Exception {
		sqlSession.update("board.deleteCommunityBoardReply", delReply);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Board> selectBoardListAsSearchValues(String condition, String value) throws Exception {
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("condition", condition);
		map.put("value", value);
		return (ArrayList)sqlSession.selectList("board.selectBoardListAsSearchValues", map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Board> selectUserBoardListAsSearchValues(String condition, String value) throws Exception {
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("condition", condition);
		map.put("value",  value);
		return (ArrayList)sqlSession.selectList("board.selectUserBoardListAsSearchValues", map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Board> selectCommunityBoardListAsSearchValue(int cidx, String condition, String searchValue)
			throws Exception {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("cidx", cidx);
		map.put("condition", condition);
		map.put("value", searchValue);
		return (ArrayList)sqlSession.selectList("board.selectCommunityBoardListAsSearchValue", map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Board> selectAdminBoardManageAsBlockList() throws Exception {
		ArrayList<Board> bList = new ArrayList<Board>();
		ArrayList<Board> temp = (ArrayList) sqlSession.selectList("board.selectAdminBoardManageAsBlockList");
		if(temp != null && temp.size() > 0) {
			for(int i = 0; i < temp.size(); i++) {
				Board board = temp.get(i);
				board.setReplyList((ArrayList)sqlSession.selectList("board.selectBoardReplyListAsBidx", board.getBoard_idx()));
				bList.add(board);
			}
		}
		return bList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public ArrayList<Board> selectAdminBoardManageAsActiveList() throws Exception {
		ArrayList<Board> aList = new ArrayList<Board>();
		ArrayList<Board> temp = (ArrayList) sqlSession.selectList("board.selectAdminBoardManageAsActiveList");
		if(temp != null && temp.size() > 0) {
			for(int i = 0; i < temp.size(); i++) {
				Board board = temp.get(i);
				board.setReplyList((ArrayList)sqlSession.selectList("board.selectBoardReplyListAsBidx", board.getBoard_idx()));
				aList.add(board);
			}
		}
		return aList;
	}

	@Override
	public void adminUpdateBlockBoardToReleaseAsIdx(Board b) throws Exception {
		sqlSession.update("board.adminUpdateBlockBoardToReleaseAsIdx", b);
	}

	@Override
	public void adminUpdateActiveBoardToBlockAsIdx(Board b) throws Exception {
		sqlSession.update("board.adminUpdateActiveBoardToBlockAsIdx", b);
	}

	@Override
	public void adminDeleteCommunityBoardAsIdx(Board board) throws Exception {
		sqlSession.update("board.adminDeleteCommunityBoardAsIdx", board);
	}


}
