package com.dev.comm.board.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dev.comm.board.dao.BoardDao;
import com.dev.comm.board.vo.Board;
import com.dev.comm.board.vo.BoardFile;
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

}
