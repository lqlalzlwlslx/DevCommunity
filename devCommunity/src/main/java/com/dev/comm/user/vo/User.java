package com.dev.comm.user.vo;

import org.springframework.stereotype.Repository;

@Repository
public class User {
	
	private int user_idx;
	private int comm_idx;
	private String user_stat_cd;
	private String user_name;
	private String login_id;
	private String nick_name;
	private String password;
	private short user_role_cd;
	private String reg_date;
	private String login_date;
	private String pwd_date;
	private String profile_src;
	private String login_flag;
	
	private String user_comm_idxs;
	private String user_comm_req_idxs;
	
	private String user_stat_nm;
	
	private String access_status;
	private String access_ip;
	
	private String black_cont;
	private int black_scope;
	private String black_sdate;
	private String black_edate;
	
	private int user_comm_role;
	private String user_comm_req_date;
	private String user_comm_login_date;
	private String user_comm_stat_cd;
	private String user_comm_stat_nm;
	
	private int user_comm_board_count;
	
	private int tryed;
	
	private String second_mail;
	
	private String bl_scope;
	
	public boolean isAdmin() {
		return (user_role_cd == 99);
	}
	
	public int getUser_idx() {
		return user_idx;
	}
	public void setUser_idx(int user_idx) {
		this.user_idx = user_idx;
	}
	public int getComm_idx() {
		return comm_idx;
	}

	public void setComm_idx(int comm_idx) {
		this.comm_idx = comm_idx;
	}

	public String getUser_stat_cd() {
		return user_stat_cd;
	}
	public void setUser_stat_cd(String user_stat_cd) {
		this.user_stat_cd = user_stat_cd;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getLogin_id() {
		return login_id;
	}
	public void setLogin_id(String login_id) {
		this.login_id = login_id;
	}
	public String getNick_name() {
		return nick_name;
	}
	public void setNick_name(String nick_name) {
		this.nick_name = nick_name;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public short getUser_role_cd() {
		return user_role_cd;
	}
	public void setUser_role_cd(short user_role_cd) {
		this.user_role_cd = user_role_cd;
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
	public String getPwd_date() {
		return pwd_date;
	}
	public void setPwd_date(String pwd_date) {
		this.pwd_date = pwd_date;
	}
	
	public String getUser_stat_nm() {
		return user_stat_nm;
	}
	public void setUser_stat_nm(String user_stat_nm) {
		this.user_stat_nm = user_stat_nm;
	}

	public String getAccess_status() {
		return access_status;
	}

	public void setAccess_status(String access_status) {
		this.access_status = access_status;
	}

	public String getAccess_ip() {
		return access_ip;
	}

	public void setAccess_ip(String access_ip) {
		this.access_ip = access_ip;
	}
	
	public int getTryed() {
		return tryed;
	}

	public void setTryed(int tryed) {
		this.tryed = tryed;
	}

	public String getProfile_src() {
		return profile_src;
	}

	public void setProfile_src(String profile_src) {
		this.profile_src = profile_src;
	}

	public String getBl_scope() {
		return bl_scope;
	}

	public void setBl_scope(String bl_scope) {
		this.bl_scope = bl_scope;
	}

	public String getBlack_sdate() {
		return black_sdate;
	}

	public void setBlack_sdate(String black_sdate) {
		this.black_sdate = black_sdate;
	}

	public String getBlack_edate() {
		return black_edate;
	}

	public void setBlack_edate(String black_edate) {
		this.black_edate = black_edate;
	}

	public int getUser_comm_role() {
		return user_comm_role;
	}

	public void setUser_comm_role(int user_comm_role) {
		this.user_comm_role = user_comm_role;
	}

	public String getUser_comm_req_date() {
		return user_comm_req_date;
	}

	public void setUser_comm_req_date(String user_comm_req_date) {
		this.user_comm_req_date = user_comm_req_date;
	}

	public String getSecond_mail() {
		return second_mail;
	}

	public void setSecond_mail(String second_mail) {
		this.second_mail = second_mail;
	}

	public String getUser_comm_login_date() {
		return user_comm_login_date;
	}

	public void setUser_comm_login_date(String user_comm_login_date) {
		this.user_comm_login_date = user_comm_login_date;
	}

	public int getUser_comm_board_count() {
		return user_comm_board_count;
	}

	public void setUser_comm_board_count(int user_comm_board_count) {
		this.user_comm_board_count = user_comm_board_count;
	}

	public String getBlack_cont() {
		return black_cont;
	}

	public void setBlack_cont(String black_cont) {
		this.black_cont = black_cont;
	}

	public int getBlack_scope() {
		return black_scope;
	}

	public void setBlack_scope(int black_scope) {
		this.black_scope = black_scope;
	}

	public String getUser_comm_stat_cd() {
		return user_comm_stat_cd;
	}

	public void setUser_comm_stat_cd(String user_comm_stat_cd) {
		this.user_comm_stat_cd = user_comm_stat_cd;
	}

	public String getUser_comm_stat_nm() {
		return user_comm_stat_nm;
	}

	public void setUser_comm_stat_nm(String user_comm_stat_nm) {
		this.user_comm_stat_nm = user_comm_stat_nm;
	}

	public String getUser_comm_idxs() {
		return user_comm_idxs;
	}

	public void setUser_comm_idxs(String user_comm_idxs) {
		this.user_comm_idxs = user_comm_idxs;
	}

	public String getLogin_flag() {
		return login_flag;
	}

	public void setLogin_flag(String login_flag) {
		this.login_flag = login_flag;
	}

	public String getUser_comm_req_idxs() {
		return user_comm_req_idxs;
	}

	public void setUser_comm_req_idxs(String user_comm_req_idxs) {
		this.user_comm_req_idxs = user_comm_req_idxs;
	}


}