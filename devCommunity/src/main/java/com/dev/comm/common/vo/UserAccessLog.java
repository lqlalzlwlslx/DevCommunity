package com.dev.comm.common.vo;

import org.springframework.stereotype.Repository;

@Repository
public class UserAccessLog {
	
	private String access_date;
	private String access_status;
	private String access_ip;
	private String login_id;
	
	
	public String getAccess_date() {
		return access_date;
	}
	public void setAccess_date(String access_date) {
		this.access_date = access_date;
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
	public String getLogin_id() {
		return login_id;
	}
	public void setLogin_id(String login_id) {
		this.login_id = login_id;
	}
	
}
