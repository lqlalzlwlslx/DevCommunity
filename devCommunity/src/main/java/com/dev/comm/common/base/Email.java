package com.dev.comm.common.base;

import org.springframework.stereotype.Repository;

@Repository
public class Email {
	
	private String from;
	private String mailto;
	private String mailcc;
	private String mailbcc;
	private String subject;
	private String content;
	private String templateName;
	private String contentType;
	
	public Email() {
		contentType = "text/html";
	}
	
	public Email(String from, String mailto, String mailcc, String mailbcc, String subject, String content, String templateName, String contentType) {
		super();
		this.from = from;
		this.mailto = mailto;
		this.mailcc = mailcc;
		this.mailbcc = mailbcc;
		this.subject = subject;
		this.content = content;
		this.templateName = templateName;
		this.contentType = contentType;
	}

	public String getFrom() {
		return from;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public String getMailto() {
		return mailto;
	}

	public void setMailto(String mailto) {
		this.mailto = mailto;
	}

	public String getMailcc() {
		return mailcc;
	}

	public void setMailcc(String mailcc) {
		this.mailcc = mailcc;
	}

	public String getMailbcc() {
		return mailbcc;
	}

	public void setMailbcc(String mailbcc) {
		this.mailbcc = mailbcc;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getTemplateName() {
		return templateName;
	}

	public void setTemplateName(String templateName) {
		this.templateName = templateName;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	@Override
	public String toString() {
		return "Email [from=" + from + ", mailto=" + mailto + ", mailcc=" + mailcc + ", mailbcc=" + mailbcc
				+ ", subject=" + subject + ", content=" + content + ", templateName=" + templateName + ", contentType="
				+ contentType + "]";
	}
	
	

}
