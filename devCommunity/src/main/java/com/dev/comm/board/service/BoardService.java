package com.dev.comm.board.service;

import java.util.ArrayList;

import org.springframework.stereotype.Service;

import com.dev.comm.board.vo.Board;

@Service
public interface BoardService {
	
	ArrayList<Board> selectAllCommunityBoardList(long comm_idx) throws Exception;

}
