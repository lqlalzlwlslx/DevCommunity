package com.dev.comm.common.base;

import java.util.ArrayList;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.ContextLoaderListener;

import com.dev.comm.common.vo.BlackList;
import com.dev.comm.community.service.CommunityService;
import com.dev.comm.community.vo.CommunityBlackList;
import com.dev.comm.user.service.UserService;
import com.dev.comm.user.vo.User;

public class SyncJob {
	
	@SuppressWarnings("unused")
	private void initBean() {
		ApplicationContext context = ContextLoaderListener.getCurrentWebApplicationContext();
		
		this.userService = (UserService) context.getBean(UserService.class);
		this.communityService = (CommunityService) context.getBean(CommunityService.class);
	}
	
	protected final Log log = LogFactory.getLog(getClass());
	
	@Autowired(required=false)
	private UserService userService;
	
	@Autowired(required=false)
	private CommunityService communityService;
	
	@Autowired(required=true)
	private EmailSender mailSender;
	
	private String mailFrom;
	private String mailTo;
	private String mailSubject;
	private String mailContent;
	private String mailContentType = "text/html";
	
	private void sendMailToReleaseUser(User user, BlackList blackList, CommunityBlackList communityBlackList) {
		log.info(">> BLACKLIST RELEASE USER SENDMAIL PROCESS.");
		
		try {
			if(blackList != null && communityBlackList == null) {
				if(user == null) user = userService.selectUserInfoAsIdx(blackList.getUser_idx());
				mailFrom = userService.selectAdminEmail();
				mailTo = user.getLogin_id();
				mailSubject = "[DevCommunity] 활동정지 해제 알림";
				mailContent = "안녕하세요, " +  user.getNick_name() + "님.<br />";
				mailContent += "DevCommunity 관리자입니다.<br /><br />";
				mailContent += "활동정지 기간이 종료되어 현 시간부로 정상적인 이용이 가능합니다.<br />감사합니다.";
			}else if(blackList == null && communityBlackList != null) {
				if(user == null) user = userService.selectUserInfoAsIdx(communityBlackList.getUser_idx());
				mailFrom = userService.selectAdminEmail();
				mailTo = user.getLogin_id();
				mailSubject = "[DevCommunity] ["+communityBlackList.getComm_name() +"] 활동정지 해제 알림";
				mailContent = "안녕하세요.<br />";
				mailContent += communityBlackList.getComm_name() + "커뮤니티의 활동정지 기간이 종료되었습니다.<br /><br />";
				mailContent += "현 시간부로 정상적인 이용이 가능합니다.<br />감사합니다.";
			}
			mailSender.sendMail(new Email(mailFrom, mailTo, mailSubject, mailContent, mailContentType));
		}catch(Exception e) {
			e.printStackTrace();
			log.error(">> RELEASE USER SENDMAIL FAILED.");
		}
	}
	
	private void syncBlackListUsers() {
		if(userService == null) initBean();
		User usr = null;
		try {
			ArrayList<BlackList> blackListUsers = userService.selectBlackListUsersDaily();		//사이트 블랙리스트.
			BlackList black = null;
			BlackList black2 = null;
			if(blackListUsers != null) {
				for(int i = 0; i < blackListUsers.size(); i++) {
					black = userService.selectBlackListUserReleaseStatusCheck(blackListUsers.get(i));
					if(black != null) {
						usr = userService.selectUserInfoAsIdx(black.getUser_idx());
						black2 = userService.deleteUserBlackList(usr.getUser_idx());
						
						if(black2 != null) {
							userService.updateUserBlackListLogRelease(black2);
							userService.updateUserBlackListReleaseStatus(usr.getUser_idx());
							sendMailToReleaseUser(usr, black2, null);
						}else {
							log.info(">> BLACKLIST USER DELETE INFO QUERY FAILED...");
							continue;
						}
					}else {
						continue;
					}
				}
				
			}else {
				log.info(">> SyncJob blackListUsersDaily Target Zero.. Process Done.");
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error(">> SyncJob blackListUsersDaily Process Failed");
			log.error(e.getMessage());
		}
	}
	
	private void syncCommunityBlackListUsers() {
		if(userService == null || communityService == null) initBean();
		User usr = null;
		try {
			ArrayList<CommunityBlackList> communityBlackListUsers = userService.selectCommunityBlackListUsersDaily();
			CommunityBlackList cbl = null;
			CommunityBlackList cbl2 = null;
			if(communityBlackListUsers != null) {
				for(int i = 0; i < communityBlackListUsers.size(); i++) {
					cbl = userService.selectCommunityBlackListUserReleaseStatusCheck(communityBlackListUsers.get(i));
					if(cbl != null) {
						usr = userService.selectUserInfoAsIdx(cbl.getUser_idx());
						cbl2 = communityService.deleteCommunityUserBlackList2(cbl);
						if(cbl2 != null) {
							communityService.updateCommunityUserBlackListLogRelease(cbl2);
							communityService.updateCommunityUserBlackListReleaseStatus(cbl2.getUser_idx(), (int)cbl2.getComm_idx());
							sendMailToReleaseUser(usr, null, cbl2);
						}else {
							log.info(">> COMMUNITY BLACKLIST USER DELETE INFO QUERY FAILED...");
							continue;
						}
					}else {
						continue;
					}
				}
			}else {
				log.info(">> SyncJob communityBlackListUsersDaily Target Zero.. Process Done.");
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error(">> SyncJob CommunityBlackListUsersDaily Process Failed");
			log.error(e.getMessage());
		}
	}
	
	public void excuteDaily() {
		long time = System.currentTimeMillis();
		log.info(">> SyncJobDaily Start at: " + time);
		
		syncBlackListUsers();
		syncCommunityBlackListUsers();
		
		log.info(">> SyncJobDaily End at synctime: " + (System.currentTimeMillis() - time) +"ms");
	}

}
