package com.dev.comm.board.dao;

import java.util.ArrayList;

import com.dev.comm.board.vo.Board;
import com.dev.comm.board.vo.BoardFile;
import com.dev.comm.user.vo.User;

public interface BoardDao {

	ArrayList<Board> selectAllCommunityBoardList(long comm_idx) throws Exception;

	Board insertCommunityBoard(Board board) throws Exception;

	void insertCommunityBoardFile(BoardFile boardFile) throws Exception;

	ArrayList<Board> selectVisitorMainBoardList(Board board) throws Exception;

	ArrayList<Board> selectUserMainBoardList() throws Exception;

	ArrayList<Board> selectUserMainBoardList(User user) throws Exception;

}
