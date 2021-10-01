package com.dev.comm.board.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.dev.comm.board.service.BoardService;
import com.dev.comm.board.vo.Board;
import com.dev.comm.board.vo.BoardFile;
import com.dev.comm.user.vo.User;
import com.dev.comm.util.SessionManager;
import com.google.gson.JsonObject;

@Controller
public class BoardController {
	
	@Autowired
	private Environment env;
	
	@Autowired
	private BoardService boardService;
	
	protected final Log log = LogFactory.getLog(getClass());
	
	@RequestMapping(value = "/user/board/tempImagesUpload", produces = "text/plain;charset=utf-8", method = RequestMethod.POST)
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
		obj.addProperty("realFileName", fileName);
		return obj.toString();
	}
	
	@RequestMapping(value = "/board/visitMainBoardList", method = RequestMethod.GET)
	@ResponseBody
	public ModelMap visitorMainBoardList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelMap mp = new ModelMap();
		
		Board board = new Board();
		board.setBoard_scope("A");
		
		ArrayList<Board> visitBoardList = boardService.selectVisitorMainBoardList(board);
		if(visitBoardList != null) {
			mp.addAttribute("result", true);
			mp.addAttribute("vbList", visitBoardList);
			return mp;
		}else {
			mp.addAttribute("result", false);
			mp.addAttribute("msg", "등록된 게시글이 없습니다.");
		}
		return mp;
	}
	
	@RequestMapping(value = "/board/insertCommunityBoard", method = RequestMethod.POST)
	@ResponseBody
	public ModelAndView insertCommunityBoard(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		User user = SessionManager.getUserSession(request);
		if(user == null) {
			model.addAttribute("msg", "세션이 만료되었습니다.");
			return new ModelAndView("error");
		}
		
		try {
			Board board = new Board();
			BoardFile boardFile = null;
			
			int comm_idx = Integer.parseInt(request.getParameter("cidx"));
			int user_idx = user.getUser_idx();
			String title = request.getParameter("board_title");
			String content = request.getParameter("board_content");
			String scope = request.getParameter("boardScopeValue");
			
			String[] realFileNames = request.getParameterValues("realFileName") == null ? null : request.getParameterValues("realFileName");
			String[] resPathValues = request.getParameterValues("resPathValue") == null ? null : request.getParameterValues("resPathValue");
			
			if(content.startsWith("<p><br></p>") || content.endsWith("<p><br></p>")) {
				content = content.replaceAll("<p><br></p>", "<br />");
			}
			
			log.debug(content.isEmpty());
			if(content.isEmpty()) {
				model.addAttribute("result", false);
				model.addAttribute("msg", "내용을 작성해주세요.");
				return new ModelAndView("community/communityBoardWrite");
			}
			
			board.setComm_idx(comm_idx);
			board.setBoard_uidx(user_idx);
			board.setBoard_scope(scope);
			board.setBoard_title(title);
			board.setBoard_content(content);
			
			try {
				Board b = boardService.insertCommunityBoard(board);
				if(b != null && resPathValues != null) {
					boolean[] brr = new boolean[resPathValues.length];
					Arrays.fill(brr, false);
					for(int i = 0; i < resPathValues.length; i++) {
						if(b.getBoard_content().indexOf(resPathValues[i]) > -1) brr[i] = true;
					}
					try {
						for(int i = 0; i < brr.length; i++) {
							if(brr[i]) {
								boardFile = new BoardFile();
								boardFile.setBoard_idx(b.getBoard_idx());
								boardFile.setOrg_file_name(realFileNames[i]);
								boardFile.setReal_file_path(resPathValues[i]);

								boardService.insertCommunityBoardFile(boardFile);
							}
						}

						model.addAttribute("result", true);
						model.addAttribute("msg", "성공했습니다.");
						model.addAttribute("moveToValue", b.getComm_idx());
						return new ModelAndView("community/communityBoardWrite");
					}catch(Exception e) {
						e.printStackTrace();
						log.error("BOARDFILE INSERT ERROR.");
					}
				} else {
					//파일이 없으면 그냥 return 해도 될듯?
					model.addAttribute("result", true);
					model.addAttribute("msg", "성공했습니다.");
					model.addAttribute("moveToValue", b.getComm_idx());
					return new ModelAndView("community/communityBoardWrite");
				}
			}catch(Exception e) {
				e.printStackTrace();
				log.error("BOARD INSERT ERROR.");
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			log.error("VALUE PARSING ERROR.");
		}
		return new ModelAndView("error");
	}
	
	@RequestMapping(value = "/board/userMainBoardList", method = RequestMethod.GET)
	@ResponseBody
	public ModelMap userMainBoardList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelMap mp = new ModelMap();
		User user = SessionManager.getUserSession(request);
		if(user == null) {
			mp.addAttribute("result", false);
		}
		
		//Scope All BoardList.
		//가입한 커뮤니티의 글들을 함께 불러와서 order by 해야하지 않나?
		// user를 보내야 가입한 커뮤니티를 알 수 있을거같다...
		//아니면 따로따로 가져와서 다른 ArrayList에 모두 add시켜볼까?
		ArrayList<Board> userMainBoardList = boardService.selectUserMainBoardList(user);
		
		if(userMainBoardList != null) {
			mp.addAttribute("result", true);
			mp.addAttribute("ubList", userMainBoardList);
		}
		return mp;
	}
	
	@RequestMapping(value = "/board/userBoardModify", method = RequestMethod.GET)
	public ModelAndView userBoardModifyAsFlag(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		User usr = SessionManager.getUserSession(request);
		// flag따라 수정 삭제 하는거 구현해야댐.
		
		return new ModelAndView("community/communityBoardModify");
	}
	
	
	

}
