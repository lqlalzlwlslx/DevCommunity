package com.dev.comm.common.vo;

import org.springframework.stereotype.Repository;

@Repository
public class Conf {
	
	private String conf_type;
	private String conf_type_cd;
	private String conf_name;
	private String etc;
	
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
	public String getEtc() {
		return etc;
	}
	public void setEtc(String etc) {
		this.etc = etc;
	}
	@Override
	public String toString() {
		return "Conf [conf_type=" + conf_type + ", conf_type_cd=" + conf_type_cd + ", conf_name=" + conf_name + ", etc="
				+ etc + "]";
	}
	

}
/*
create table dec_conf (
  conf_type             varchar(10)                    not null,                                                // type: user_stat, comm_stat ...
  conf_type_cd          varchar(64)                    not null,                                                // cd : 00, 01, 02 ...
  conf_name             varchar(256)                                default '',                                 // cd_name : 활성, 비활성 ...
  conf_etc              varchar(128)                                default '',                                 // etc...

  primary key(conf_type, conf_type_cd)
) default charset=utf8;
*/