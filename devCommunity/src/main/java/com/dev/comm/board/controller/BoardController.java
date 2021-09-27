package com.dev.comm.board.controller;

import java.io.File;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.dev.comm.board.service.BoardService;
import com.dev.comm.user.vo.User;
import com.dev.comm.util.SessionManager;
import com.google.gson.JsonObject;

@Controller
public class BoardController {
	
	@Autowired
	private Environment env;
	
	@Autowired
	private BoardService boardService;
	
	@RequestMapping(value = "/user/board/tempImagesUpload", produces = "text/plain", method = RequestMethod.POST)
	@ResponseBody
	public String userBoardTempImagesUpload(HttpServletRequest request, HttpServletResponse response, @RequestParam("file") MultipartFile uploadFile) throws Exception {
		JsonObject obj = new JsonObject();
		User user = SessionManager.getUserSession(request);
		if(user == null) {
			obj.addProperty("result", false);
			obj.addProperty("msg", "세션이 만료되었습니다. 메인페이지로 이동합니다.");
			return obj.toString();
		}
		
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		MultipartFile files = multipartRequest.getFile("file");
		
		File file = null;
		String tempPath = env.getProperty("file.community.board.temp.path");
		String resPath = env.getProperty("file.community.board.res.path");
		String fileName = files.getOriginalFilename();
		String renameFile = null;
		String extension = fileName.substring(fileName.lastIndexOf(".")+1);
		
		file = new File(tempPath);
		if(!file.exists()) {
			file.mkdirs();
		}
		
		renameFile = user.getUser_idx() + "_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString() + "." + extension;
		File tmpFile = new File(tempPath, renameFile);
		files.transferTo(tmpFile);
		
		obj.addProperty("result", true);
		obj.addProperty("msg", "success");
		obj.addProperty("url", resPath + "temp/" + renameFile);
		
		return obj.toString();
	}

}
