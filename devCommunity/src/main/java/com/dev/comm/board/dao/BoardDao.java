package com.dev.comm.board.dao;

import java.util.ArrayList;

import com.dev.comm.board.vo.Board;

public interface BoardDao {

	ArrayList<Board> selectAllCommunityBoardList(long comm_idx) throws Exception;

}
