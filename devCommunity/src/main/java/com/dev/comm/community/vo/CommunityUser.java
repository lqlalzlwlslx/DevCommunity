package com.dev.comm.community.vo;

import org.springframework.stereotype.Repository;

@Repository
public class CommunityUser {
	
	private long comm_idx;
	private int user_idx;
	private Short comm_role_cd;
	private String comm_role_nm;
	private String comm_user_stat_cd;
	private String comm_user_stat_nm;
	private String reg_date;
	private String login_date;
	
	public boolean communityManager() {
		return (comm_role_cd == 9);
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
	public Short getComm_role_cd() {
		return comm_role_cd;
	}
	public void setComm_role_cd(Short comm_role_cd) {
		this.comm_role_cd = comm_role_cd;
	}
	public String getComm_role_nm() {
		return comm_role_nm;
	}
	public void setComm_role_nm(String comm_role_nm) {
		this.comm_role_nm = comm_role_nm;
	}
	public String getComm_user_stat_cd() {
		return comm_user_stat_cd;
	}
	public void setComm_user_stat_cd(String comm_user_stat_cd) {
		this.comm_user_stat_cd = comm_user_stat_cd;
	}
	public String getComm_user_stat_nm() {
		return comm_user_stat_nm;
	}
	public void setComm_user_stat_nm(String comm_user_stat_nm) {
		this.comm_user_stat_nm = comm_user_stat_nm;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getLogin_date() {
		return login_date;
	}
	public void setLogin_date(String login_date) {
		this.login_date = login_date;
	}
	@Override
	public String toString() {
		return "CommunityUser [comm_idx=" + comm_idx + ", user_idx=" + user_idx + ", comm_role_cd=" + comm_role_cd
				+ ", comm_role_nm=" + comm_role_nm + ", comm_user_stat_cd=" + comm_user_stat_cd + ", comm_user_stat_nm="
				+ comm_user_stat_nm + ", reg_date=" + reg_date + ", login_date=" + login_date + "]";
	}
	
	

}
