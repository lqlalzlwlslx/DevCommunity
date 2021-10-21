package com.dev.comm.common.vo;

import org.springframework.stereotype.Repository;

@Repository
public class BlackList {
	
	private int bl_idx;
	private int user_idx;
	private String bl_cont;
	private int bl_scope;
	private String start_date;
	private String end_date;
	private String bl_flag;
	
	public int getBl_idx() {
		return bl_idx;
	}
	public void setBl_idx(int bl_idx) {
		this.bl_idx = bl_idx;
	}
	public int getUser_idx() {
		return user_idx;
	}
	public void setUser_idx(int user_idx) {
		this.user_idx = user_idx;
	}
	public String getBl_cont() {
		return bl_cont;
	}
	public void setBl_cont(String bl_cont) {
		this.bl_cont = bl_cont;
	}
	public int getBl_scope() {
		return bl_scope;
	}
	public void setBl_scope(int bl_scope) {
		this.bl_scope = bl_scope;
	}
	public String getStart_date() {
		return start_date;
	}
	public void setStart_date(String start_date) {
		this.start_date = start_date;
	}
	public String getEnd_date() {
		return end_date;
	}
	public void setEnd_date(String end_date) {
		this.end_date = end_date;
	}
	public String getBl_flag() {
		return bl_flag;
	}
	public void setBl_flag(String bl_flag) {
		this.bl_flag = bl_flag;
	}
	@Override
	public String toString() {
		return "BlackList [bl_idx=" + bl_idx + ", user_idx=" + user_idx + ", bl_cont=" + bl_cont + ", start_date="
				+ start_date + ", end_date=" + end_date + "]";
	}
	
	

}
