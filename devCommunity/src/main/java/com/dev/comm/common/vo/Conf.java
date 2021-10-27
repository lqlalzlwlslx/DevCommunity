package com.dev.comm.common.vo;

import org.springframework.stereotype.Repository;

@Repository
public class Conf {
	
	private String conf_type;
	private String conf_type_cd;
	private String conf_name;
	private String conf_etc;
	
	public String getConf_type() {
		return conf_type;
	}
	public void setConf_type(String conf_type) {
		this.conf_type = conf_type;
	}
	public String getConf_type_cd() {
		return conf_type_cd;
	}
	public void setConf_type_cd(String conf_type_cd) {
		this.conf_type_cd = conf_type_cd;
	}
	public String getConf_name() {
		return conf_name;
	}
	public void setConf_name(String conf_name) {
		this.conf_name = conf_name;
	}
	public String getConf_etc() {
		return conf_etc;
	}
	public void setConf_etc(String conf_etc) {
		this.conf_etc = conf_etc;
	}
	

}