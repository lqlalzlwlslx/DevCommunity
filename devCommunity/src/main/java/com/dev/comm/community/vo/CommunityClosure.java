package com.dev.comm.community.vo;

import org.springframework.stereotype.Repository;

@Repository
public class CommunityClosure {
	
	private int comm_idx;
	private int reg_uidx;
	private String reg_date;
	private String closure_date;
	
	public int getComm_idx() {
		return comm_idx;
	}
	public void setComm_idx(int comm_idx) {
		this.comm_idx = comm_idx;
	}
	public int getReg_uidx() {
		return reg_uidx;
	}
	public void setReg_uidx(int reg_uidx) {
		this.reg_uidx = reg_uidx;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getClosure_date() {
		return closure_date;
	}
	public void setClosure_date(String closure_date) {
		this.closure_date = closure_date;
	}
	
	

}
