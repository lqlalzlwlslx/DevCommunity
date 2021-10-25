package com.dev.comm.board.vo;

import org.springframework.stereotype.Repository;

@Repository
public class Inquiry {
	private int inquiry_idx;
	private int reg_uidx;
	private String inquiry_title;
	private String inquiry_content;
	private String inquiry_answer;
	private String inquiry_stat;
	private String reg_date;
	private String answer_date;
	
	private String reg_nick;
	private String inquiry_stat_nm;
	
	
	public int getInquiry_idx() {
		return inquiry_idx;
	}
	public void setInquiry_idx(int inquiry_idx) {
		this.inquiry_idx = inquiry_idx;
	}
	public int getReg_uidx() {
		return reg_uidx;
	}
	public void setReg_uidx(int reg_uidx) {
		this.reg_uidx = reg_uidx;
	}
	public String getInquiry_title() {
		return inquiry_title;
	}
	public void setInquiry_title(String inquiry_title) {
		this.inquiry_title = inquiry_title;
	}
	public String getInquiry_content() {
		return inquiry_content;
	}
	public void setInquiry_content(String inquiry_content) {
		this.inquiry_content = inquiry_content;
	}
	public String getInquiry_answer() {
		return inquiry_answer;
	}
	public void setInquiry_answer(String inquiry_answer) {
		this.inquiry_answer = inquiry_answer;
	}
	public String getInquiry_stat() {
		return inquiry_stat;
	}
	public void setInquiry_stat(String inquiry_stat) {
		this.inquiry_stat = inquiry_stat;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getAnswer_date() {
		return answer_date;
	}
	public void setAnswer_date(String answer_date) {
		this.answer_date = answer_date;
	}
	public String getReg_nick() {
		return reg_nick;
	}
	public void setReg_nick(String reg_nick) {
		this.reg_nick = reg_nick;
	}
	public String getInquiry_stat_nm() {
		return inquiry_stat_nm;
	}
	public void setInquiry_stat_nm(String inquiry_stat_nm) {
		this.inquiry_stat_nm = inquiry_stat_nm;
	}
	
	

}

