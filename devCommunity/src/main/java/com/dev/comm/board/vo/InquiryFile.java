package com.dev.comm.board.vo;

import org.springframework.stereotype.Repository;

@Repository
public class InquiryFile {
	
	private int file_idx;
	private int inquiry_idx;
	private String org_file_name;
	private String real_file_path;
	
	public int getFile_idx() {
		return file_idx;
	}
	public void setFile_idx(int file_idx) {
		this.file_idx = file_idx;
	}
	public int getInquiry_idx() {
		return inquiry_idx;
	}
	public void setInquiry_idx(int inquiry_idx) {
		this.inquiry_idx = inquiry_idx;
	}
	public String getOrg_file_name() {
		return org_file_name;
	}
	public void setOrg_file_name(String org_file_name) {
		this.org_file_name = org_file_name;
	}
	public String getReal_file_path() {
		return real_file_path;
	}
	public void setReal_file_path(String real_file_path) {
		this.real_file_path = real_file_path;
	}

	
	
}
