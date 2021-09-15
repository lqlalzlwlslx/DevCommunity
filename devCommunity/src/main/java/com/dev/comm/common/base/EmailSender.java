package com.dev.comm.common.base;

import java.io.FileNotFoundException;
import java.net.URISyntaxException;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;

@Component
public class EmailSender {
	
	@Autowired
	private JavaMailSender mailSender;
	
	public void setMailSender(JavaMailSender mailSender) {
		this.mailSender = mailSender;
	}
	
	public void sendMail(Email mail) throws FileNotFoundException, URISyntaxException {
		
		MimeMessage mimeMsg = mailSender.createMimeMessage();
		
		try {
			
			mimeMsg.setSubject(mail.getSubject());
			mimeMsg.setText(mail.getContent(), "utf-8", "html");
			mimeMsg.setRecipients(MimeMessage.RecipientType.TO, InternetAddress.parse(mail.getMailto()));
			mimeMsg.setFrom(new InternetAddress(mail.getFrom()));
			
			mailSender.send(mimeMsg);
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}

}
