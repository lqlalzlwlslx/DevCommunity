package com.dev.comm.board.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dev.comm.board.dao.BoardDao;
import com.dev.comm.board.vo.Board;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	private BoardDao boardDao;

	@Override
	public ArrayList<Board> selectAllCommunityBoardList(long comm_idx) throws Exception {
		return boardDao.selectAllCommunityBoardList(comm_idx);
	}

}
