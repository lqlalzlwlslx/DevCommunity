package com.dev.comm.board.dao;

import java.util.ArrayList;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Repository;

import com.dev.comm.board.vo.Board;
import com.dev.comm.board.vo.BoardFile;
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

}
