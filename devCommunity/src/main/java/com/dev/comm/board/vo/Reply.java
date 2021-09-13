package com.dev.comm.board.vo;

import org.springframework.stereotype.Repository;

@Repository
public class Reply {
	
	private int reply_idx;
	private int board_idx;
	private int reply_uidx;
	private String reply_nick;			//누가 쓴것인지... 닉네임.
	private String reply_content;
	private String reg_date;
	private String modify_date;
	private String reply_stat_cd;
	private String reply_stat_nm;
	public int getReply_idx() {
		return reply_idx;
	}
	public void setReply_idx(int reply_idx) {
		this.reply_idx = reply_idx;
	}
	public int getBoard_idx() {
		return board_idx;
	}
	public void setBoard_idx(int board_idx) {
		this.board_idx = board_idx;
	}
	public int getReply_uidx() {
		return reply_uidx;
	}
	public void setReply_uidx(int reply_uidx) {
		this.reply_uidx = reply_uidx;
	}
	public String getReply_nick() {
		return reply_nick;
	}
	public void setReply_nick(String reply_nick) {
		this.reply_nick = reply_nick;
	}
	public String getReply_content() {
		return reply_content;
	}
	public void setReply_content(String reply_content) {
		this.reply_content = reply_content;
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
	public String getReply_stat_cd() {
		return reply_stat_cd;
	}
	public void setReply_stat_cd(String reply_stat_cd) {
		this.reply_stat_cd = reply_stat_cd;
	}
	public String getReply_stat_nm() {
		return reply_stat_nm;
	}
	public void setReply_stat_nm(String reply_stat_nm) {
		this.reply_stat_nm = reply_stat_nm;
	}
	@Override
	public String toString() {
		return "Reply [reply_idx=" + reply_idx + ", board_idx=" + board_idx + ", reply_uidx=" + reply_uidx
				+ ", reply_nick=" + reply_nick + ", reply_content=" + reply_content + ", reg_date=" + reg_date
				+ ", modify_date=" + modify_date + ", reply_stat_cd=" + reply_stat_cd + ", reply_stat_nm="
				+ reply_stat_nm + "]";
	}
	
	

}
