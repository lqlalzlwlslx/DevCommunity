package com.dev.comm.community.vo;

import org.springframework.stereotype.Repository;

@Repository
public class CommunityBlackList {
	
	private int bl_idx;
	private long comm_idx;
	private String comm_name;
	private int user_idx;
	private String user_nick;
	private String bl_comm_cont;
	private int bl_comm_scope;
	private int bl_scope;
	private String start_date;
	private String end_date;
	private String bl_release_date;
	private String bl_flag;
	
	public int getBl_idx() {
		return bl_idx;
	}
	public void setBl_idx(int bl_idx) {
		this.bl_idx = bl_idx;
	}
	public long getComm_idx() {
		return comm_idx;
	}
	public void setComm_idx(long comm_idx) {
		this.comm_idx = comm_idx;
	}
	public int getUser_idx() {
		return user_idx;
	}
	public void setUser_idx(int user_idx) {
		this.user_idx = user_idx;
	}
	public String getComm_name() {
		return comm_name;
	}
	public void setComm_name(String comm_name) {
		this.comm_name = comm_name;
	}
	public String getUser_nick() {
		return user_nick;
	}
	public void setUser_nick(String user_nick) {
		this.user_nick = user_nick;
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
	public String getBl_comm_cont() {
		return bl_comm_cont;
	}
	public void setBl_comm_cont(String bl_comm_cont) {
		this.bl_comm_cont = bl_comm_cont;
	}
	public int getBl_comm_scope() {
		return bl_comm_scope;
	}
	public void setBl_comm_scope(int bl_comm_scope) {
		this.bl_comm_scope = bl_comm_scope;
	}
	public String getBl_release_date() {
		return bl_release_date;
	}
	public void setBl_release_date(String bl_release_date) {
		this.bl_release_date = bl_release_date;
	}
	public int getBl_scope() {
		return bl_scope;
	}
	public void setBl_scope(int bl_scope) {
		this.bl_scope = bl_scope;
	}
	
	

}
