package com.dev.comm.common.vo;

import org.springframework.stereotype.Repository;

@Repository
public class BlackListLog {
	
	private int bl_log_idx;
	private int bl_idx;
	private int user_idx;
	private String bl_cont;
	private String start_date;
	private String end_date;
	private String release_date;
	public int getBl_log_idx() {
		return bl_log_idx;
	}
	public void setBl_log_idx(int bl_log_idx) {
		this.bl_log_idx = bl_log_idx;
	}
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
	public String getRelease_date() {
		return release_date;
	}
	public void setRelease_date(String release_date) {
		this.release_date = release_date;
	}
	@Override
	public String toString() {
		return "BlackListLog [bl_log_idx=" + bl_log_idx + ", bl_idx=" + bl_idx + ", user_idx=" + user_idx + ", bl_cont="
				+ bl_cont + ", start_date=" + start_date + ", end_date=" + end_date + ", release_date=" + release_date
				+ "]";
	}
	
	

}
