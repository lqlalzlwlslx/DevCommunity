package com.dev.comm.board.vo;

import org.springframework.stereotype.Repository;

@Repository
public class BoardFile {
	
	private int file_idx;
	private long board_idx;
	private String org_file_name;
	private String real_file_path;
	
	
	public int getFile_idx() {
		return file_idx;
	}
	public void setFile_idx(int file_idx) {
		this.file_idx = file_idx;
	}
	public long getBoard_idx() {
		return board_idx;
	}
	public void setBoard_idx(long board_idx) {
		this.board_idx = board_idx;
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