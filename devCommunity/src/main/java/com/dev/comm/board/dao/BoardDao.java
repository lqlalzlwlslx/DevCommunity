package com.dev.comm.board.dao;

import java.util.ArrayList;

import com.dev.comm.board.vo.Board;
import com.dev.comm.board.vo.BoardFile;
import com.dev.comm.board.vo.Reply;
import com.dev.comm.user.vo.User;

public interface BoardDao {

	ArrayList<Board> selectAllCommunityBoardList(long comm_idx) throws Exception;

	Board insertCommunityBoard(Board board) throws Exception;

	void insertCommunityBoardFile(BoardFile boardFile) throws Exception;

	ArrayList<Board> selectVisitorMainBoardList(Board board) throws Exception;

	ArrayList<Board> selectUserMainBoardList() throws Exception;

	ArrayList<Board> selectUserMainBoardList(User user) throws Exception;

	Board selectOneBoardInfoAsIdx(int value) throws Exception;

	void updateBoardStatusAsFlag(Board boardInfo) throws Exception;

	void updateBoardAsIdx(Board board) throws Exception;

	void deleteCommunityBoardFileList(Board board) throws Exception;

	void insertCommunityBoardReply(Reply reply) throws Exception;

	ArrayList<Reply> selectBoardReplyListAsBidx(long board_idx) throws Exception;

	void updateCommunityBoardReplyContent(Reply modifyReply) throws Exception;

	void deleteCommunityBoardReply(Reply delReply) throws Exception;

	ArrayList<Board> selectBoardListAsSearchValues(String condition, String searchTxt) throws Exception;

	ArrayList<Board> selectUserBoardListAsSearchValues(String condition, String searchTxt) throws Exception;

	ArrayList<Board> selectCommunityBoardListAsSearchValue(int cidx, String condition, String searchValue) throws Exception;

	ArrayList<Board> selectAdminBoardManageAsBlockList() throws Exception;

	ArrayList<Board> selectAdminBoardManageAsActiveList() throws Exception;

	void adminUpdateBlockBoardToReleaseAsIdx(Board b) throws Exception;

	void adminUpdateActiveBoardToBlockAsIdx(Board b) throws Exception;

	void adminDeleteCommunityBoardAsIdx(Board board) throws Exception;

	void updateCommunityBoardToFlagAsCommunityManager(int bidx, String flag) throws Exception;

	int updateCommunityBlackBoardToActiveAsCommunityManager(int bidx) throws Exception;

}
