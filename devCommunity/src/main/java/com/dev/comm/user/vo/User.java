package com.dev.comm.user.vo;

import org.springframework.stereotype.Repository;

@Repository
public class User {
	
	private int user_idx;
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
	
	private String user_stat_nm;
	
	private String access_status;
	private String access_ip;
	
	private String black_sdate;
	private String black_edate;
	
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

	public String getSecond_mail() {
		return second_mail;
	}

	public void setSecond_mail(String second_mail) {
		this.second_mail = second_mail;
	}

	@Override
	public String toString() {
		return "User [user_idx=" + user_idx + ", user_stat_cd=" + user_stat_cd + ", user_name=" + user_name
				+ ", login_id=" + login_id + ", nick_name=" + nick_name + ", password=" + password + ", user_role_cd="
				+ user_role_cd + ", reg_date=" + reg_date + ", login_date=" + login_date + ", pwd_date=" + pwd_date
				+ ", profile_src=" + profile_src + ", user_stat_nm=" + user_stat_nm + ", access_status=" + access_status
				+ ", access_ip=" + access_ip + ", black_sdate=" + black_sdate + ", black_edate=" + black_edate
				+ ", tryed=" + tryed + ", second_mail=" + second_mail + ", bl_scope=" + bl_scope + "]";
	}

	

}