package com.dev.comm.board.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dev.comm.board.dao.BoardDao;
import com.dev.comm.board.vo.Board;
import com.dev.comm.board.vo.BoardFile;
import com.dev.comm.board.vo.Inquiry;
import com.dev.comm.board.vo.InquiryFile;
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

	@Override
	public void adminUpdateBlockBoardToReleaseAsIdx(Board b) throws Exception {
		boardDao.adminUpdateBlockBoardToReleaseAsIdx(b);
	}

	@Override
	public void adminUpdateActiveBoardToBlockAsIdx(Board b) throws Exception {
		boardDao.adminUpdateActiveBoardToBlockAsIdx(b);
	}

	@Override
	public void adminDeleteCommunityBoardAsIdx(Board board) throws Exception {
		boardDao.adminDeleteCommunityBoardAsIdx(board);
	}

	@Override
	public void updateCommunityBoardToFlagAsCommunityManager(int bidx, String flag) throws Exception {
		boardDao.updateCommunityBoardToFlagAsCommunityManager(bidx, flag);
	}

	@Override
	public int updateCommunityBlackBoardToActiveAsCommunityManager(int bidx) throws Exception {
		return boardDao.updateCommunityBlackBoardToActiveAsCommunityManager(bidx);
	}

	@Override
	public Inquiry insertCommunityInquiryToAdmin(Inquiry inquiry) throws Exception {
		return boardDao.insertCommunityInquiryToAdmin(inquiry);
	}

	@Override
	public void insertCommunityInquiryFile(InquiryFile inquiryFile) throws Exception {
		boardDao.insertCommunityInquiryFile(inquiryFile);
	}

	@Override
	public ArrayList<Inquiry> selectUserInquiryList(User user) throws Exception {
		return boardDao.selectUserInquiryList(user);
	}

	@Override
	public ArrayList<Inquiry> selectAdminBoardInquiryManageList() throws Exception {
		return boardDao.selectAdminBoardInquiryManageList();
	}

	@Override
	public Inquiry selectAdminBoardInquiryInfo(int inquiry_idx) throws Exception {
		return boardDao.selectAdminBoardInquiryInfo(inquiry_idx);
	}

	@Override
	public void updateBoardInquiryAnswerFromAdmin(Inquiry inquiryInfo) throws Exception {
		boardDao.updateBoardInquiryAnswerFromAdmin(inquiryInfo);
	}

	@Override
	public void modifyBoardInquiryAnswerFromAdmin(Inquiry inquiryInfo) throws Exception {
		boardDao.modifyBoardInquiryAnswerFromAdmin(inquiryInfo);
	}

}
