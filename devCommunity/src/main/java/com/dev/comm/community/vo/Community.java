package com.dev.comm.community.vo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.dev.comm.board.vo.Board;
import com.dev.comm.user.vo.User;

@Repository
public class Community {
	
	private long comm_idx;
	private String comm_name;
	private String comm_type_cd;
	private String comm_type_nm;
	private String comm_stat_cd;
	private String comm_stat_nm;
	private short comm_role_cd;
	private String reg_date;
	private ArrayList<Board> boardList;
	private ArrayList<Board> blackBoardList;
	private ArrayList<User> userList;
	private ArrayList<User> reqUserList;
	private ArrayList<User> blackUserList;
	
	private String comm_reg_cont;
	
	private String comm_type_j;
	private String comm_type_c;
	private String comm_type_p;
	private String comm_type_d;
	
	private int manager_idx;
	private String manager_name;
	
	private String status;
	
	private String comm_intro;
	private int total_member;
	private int total_black;
	private int total_board;
	private int total_black_board;
	
	private String comm_user_stat_cd;
	
	private int comm_sign_request;
	
	private String comm_extra;
	
	public long getComm_idx() {
		return comm_idx;
	}
	public void setComm_idx(long comm_idx) {
		this.comm_idx = comm_idx;
	}
	public String getComm_name() {
		return comm_name;
	}
	public void setComm_name(String comm_name) {
		this.comm_name = comm_name;
	}
	public String getComm_type_cd() {
		return comm_type_cd;
	}
	public void setComm_type_cd(String comm_type_cd) {
		this.comm_type_cd = comm_type_cd;
	}
	public String getComm_type_nm() {
		return comm_type_nm;
	}
	public void setComm_type_nm(String comm_type_nm) {
		this.comm_type_nm = comm_type_nm;
	}
	public String getComm_stat_cd() {
		return comm_stat_cd;
	}
	public void setComm_stat_cd(String comm_stat_cd) {
		this.comm_stat_cd = comm_stat_cd;
	}
	public String getComm_stat_nm() {
		return comm_stat_nm;
	}
	public void setComm_stat_nm(String comm_stat_nm) {
		this.comm_stat_nm = comm_stat_nm;
	}
	public short getComm_role_cd() {
		return comm_role_cd;
	}
	public void setComm_role_cd(short comm_role_cd) {
		this.comm_role_cd = comm_role_cd;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public ArrayList<Board> getBoardList() {
		return boardList;
	}
	public void setBoardList(ArrayList<Board> boardList) {
		this.boardList = boardList;
	}
	public ArrayList<User> getUserList() {
		return userList;
	}
	public void setUserList(ArrayList<User> userList) {
		this.userList = userList;
	}
	public ArrayList<User> getReqUserList() {
		return reqUserList;
	}
	public void setReqUserList(ArrayList<User> reqUserList) {
		this.reqUserList = reqUserList;
	}
	public ArrayList<User> getBlackUserList() {
		return blackUserList;
	}
	public void setBlackUserList(ArrayList<User> blackUserList) {
		this.blackUserList = blackUserList;
	}
	public String getComm_reg_cont() {
		return comm_reg_cont;
	}
	public void setComm_reg_cont(String comm_reg_cont) {
		this.comm_reg_cont = comm_reg_cont;
	}
	public String getComm_type_j() {
		return comm_type_j;
	}
	public void setComm_type_j(String comm_type_j) {
		this.comm_type_j = comm_type_j;
	}
	public String getComm_type_c() {
		return comm_type_c;
	}
	public void setComm_type_c(String comm_type_c) {
		this.comm_type_c = comm_type_c;
	}
	public String getComm_type_p() {
		return comm_type_p;
	}
	public void setComm_type_p(String comm_type_p) {
		this.comm_type_p = comm_type_p;
	}
	public String getComm_type_d() {
		return comm_type_d;
	}
	public void setComm_type_d(String comm_type_d) {
		this.comm_type_d = comm_type_d;
	}
	public String getManager_name() {
		return manager_name;
	}
	public void setManager_name(String manager_name) {
		this.manager_name = manager_name;
	}
	
	public int getManager_idx() {
		return manager_idx;
	}
	public void setManager_idx(int manager_idx) {
		this.manager_idx = manager_idx;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getComm_intro() {
		return comm_intro;
	}
	public void setComm_intro(String comm_intro) {
		this.comm_intro = comm_intro;
	}
	public int getTotal_member() {
		return total_member;
	}
	public void setTotal_member(int total_member) {
		this.total_member = total_member;
	}
	public int getTotal_board() {
		return total_board;
	}
	public void setTotal_board(int total_board) {
		this.total_board = total_board;
	}
	public int getTotal_black() {
		return total_black;
	}
	public void setTotal_black(int total_black) {
		this.total_black = total_black;
	}
	public String getComm_user_stat_cd() {
		return comm_user_stat_cd;
	}
	public void setComm_user_stat_cd(String comm_user_stat_cd) {
		this.comm_user_stat_cd = comm_user_stat_cd;
	}
	public int getComm_sign_request() {
		return comm_sign_request;
	}
	public void setComm_sign_request(int comm_sign_request) {
		this.comm_sign_request = comm_sign_request;
	}
	public ArrayList<Board> getBlackBoardList() {
		return blackBoardList;
	}
	public void setBlackBoardList(ArrayList<Board> blackBoardList) {
		this.blackBoardList = blackBoardList;
	}
	public int getTotal_black_board() {
		return total_black_board;
	}
	public void setTotal_black_board(int total_black_board) {
		this.total_black_board = total_black_board;
	}
	public String getComm_extra() {
		return comm_extra;
	}
	public void setComm_extra(String comm_extra) {
		this.comm_extra = comm_extra;
	}

}
