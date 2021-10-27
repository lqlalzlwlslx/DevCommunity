package com.dev.comm.common.base;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.context.ApplicationContext;
import org.springframework.scheduling.quartz.QuartzJobBean;

public class CronJobDaily extends QuartzJobBean {

	@Override
	protected void executeInternal(JobExecutionContext context) throws JobExecutionException {
		ApplicationContext ctx = (ApplicationContext) context.getJobDetail().getJobDataMap().get("applicationContext");
		
		SyncJob syncJob = (SyncJob) ctx.getBean("syncJob");
		syncJob.excuteDaily();
		
	}

}
