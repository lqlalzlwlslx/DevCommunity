package com.dev.comm.board.vo;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

@Repository
public class Board {
	
	private long board_idx;
	private long comm_idx;
	private String comm_name;
	private int board_uidx;
	private String board_scope;
	private String board_scope_nm;
	private String board_title;
	private String board_content;
	private String reg_date;
	private String modify_date;
	private String board_stat_cd;
	private String board_stat_nm;
	private ArrayList<Reply> replyList;
	
	private String writer_id;
	private String writer_nick;
	
	private String real_file_name;
	private String res_path;
	
	private int reply_total;
	
	public long getBoard_idx() {
		return board_idx;
	}
	public void setBoard_idx(long board_idx) {
		this.board_idx = board_idx;
	}
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
	public int getBoard_uidx() {
		return board_uidx;
	}
	public void setBoard_uidx(int board_uidx) {
		this.board_uidx = board_uidx;
	}
	public String getBoard_scope() {
		return board_scope;
	}
	public void setBoard_scope(String board_scope) {
		this.board_scope = board_scope;
	}
	public String getBoard_scope_nm() {
		return board_scope_nm;
	}
	public void setBoard_scope_nm(String board_scope_nm) {
		this.board_scope_nm = board_scope_nm;
	}
	public String getBoard_title() {
		return board_title;
	}
	public void setBoard_title(String board_title) {
		this.board_title = board_title;
	}
	public String getBoard_content() {
		return board_content;
	}
	public void setBoard_content(String board_content) {
		this.board_content = board_content;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getModify_date() {
		return modify_date;
	}
	public void setModify_date(String modify_date) {
		this.modify_date = modify_date;
	}
	public String getBoard_stat_cd() {
		return board_stat_cd;
	}
	public void setBoard_stat_cd(String board_stat_cd) {
		this.board_stat_cd = board_stat_cd;
	}
	public String getBoard_stat_nm() {
		return board_stat_nm;
	}
	public void setBoard_stat_nm(String board_stat_nm) {
		this.board_stat_nm = board_stat_nm;
	}
	public ArrayList<Reply> getReplyList() {
		return replyList;
	}
	public void setReplyList(ArrayList<Reply> replyList) {
		this.replyList = replyList;
	}
	public String getWriter_id() {
		return writer_id;
	}
	public void setWriter_id(String writer_id) {
		this.writer_id = writer_id;
	}
	public String getWriter_nick() {
		return writer_nick;
	}
	public void setWriter_nick(String writer_nick) {
		this.writer_nick = writer_nick;
	}
	
	public String getReal_file_name() {
		return real_file_name;
	}
	public void setReal_file_name(String real_file_name) {
		this.real_file_name = real_file_name;
	}
	public String getRes_path() {
		return res_path;
	}
	public void setRes_path(String res_path) {
		this.res_path = res_path;
	}
	public int getReply_total() {
		return reply_total;
	}
	public void setReply_total(int reply_total) {
		this.reply_total = reply_total;
	}
}
