package com.dev.comm.board.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dev.comm.board.dao.BoardDao;
import com.dev.comm.board.vo.Board;
import com.dev.comm.board.vo.BoardFile;
import com.dev.comm.board.vo.Reply;
import com.dev.comm.user.vo.User;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	private BoardDao boardDao;

	@Override
	public ArrayList<Board> selectAllCommunityBoardList(long comm_idx) throws Exception {
		return boardDao.selectAllCommunityBoardList(comm_idx);
	}

	@Override
	public Board insertCommunityBoard(Board board) throws Exception {
		return boardDao.insertCommunityBoard(board);
	}

	@Override
	public void insertCommunityBoardFile(BoardFile boardFile) throws Exception {
		boardDao.insertCommunityBoardFile(boardFile);
	}

	@Override
	public ArrayList<Board> selectVisitorMainBoardList(Board board) throws Exception {
		return boardDao.selectVisitorMainBoardList(board);
	}

	@Override
	public ArrayList<Board> selectUserMainBoardList(User user) throws Exception {
		return boardDao.selectUserMainBoardList(user);
	}

	@Override
	public Board selectOneBoardInfoAsIdx(int value) throws Exception {
		return boardDao.selectOneBoardInfoAsIdx(value);
	}

	@Override
	public void updateBoardStatusAsFlag(Board boardInfo) throws Exception {
		boardDao.updateBoardStatusAsFlag(boardInfo);
	}

	@Override
	public void updateBoardAsIdx(Board board) throws Exception {
		boardDao.updateBoardAsIdx(board);
	}

	@Override
	public void deleteCommunityBoardFileList(Board board) throws Exception {
		boardDao.deleteCommunityBoardFileList(board);
	}

	@Override
	public void insertCommunityBoardReply(Reply reply) throws Exception {
		boardDao.insertCommunityBoardReply(reply);
	}

	@Override
	public ArrayList<Reply> selectBoardReplyListAsBidx(long board_idx) throws Exception {
		return boardDao.selectBoardReplyListAsBidx(board_idx);
	}

	@Override
	public void updateCommunityBoardReplyContent(Reply modifyReply) throws Exception {
		boardDao.updateCommunityBoardReplyContent(modifyReply);
	}

	@Override
	public void deleteCommunityBoardReply(Reply delReply) throws Exception {
		boardDao.deleteCommunityBoardReply(delReply);
	}

	@Override
	public ArrayList<Board> selectBoardListAsSearchValues(String condition, String searchTxt) throws Exception {
		return boardDao.selectBoardListAsSearchValues(condition, searchTxt);
	}

	@Override
	public ArrayList<Board> selectUserBoardListAsSearchValues(String condition, String searchTxt) throws Exception {
		return boardDao.selectUserBoardListAsSearchValues(condition, searchTxt);
	}

	@Override
	public ArrayList<Board> selectCommunityBoardListAsSearchValue(int cidx, String condition, String searchValue)
			throws Exception {
		return boardDao.selectCommunityBoardListAsSearchValue(cidx, condition, searchValue);
	}

	@Override
	public ArrayList<Board> selectAdminBoardManageAsBlockList() throws Exception {
		return boardDao.selectAdminBoardManageAsBlockList();
	}

	@Override
	public ArrayList<Board> selectAdminBoardManageAsActiveList() throws Exception {
		return boardDao.selectAdminBoardManageAsActiveList();
	}

}
