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
import org.springframework.web.bind.annotation.RequestBody;
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
import com.dev.comm.board.vo.Reply;
import com.dev.comm.user.vo.User;
import com.dev.comm.util.SessionManager;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

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
		Board b = null;
		
		//Scope All BoardList.
		//가입한 커뮤니티의 글들을 함께 불러와서 order by 해야하지 않나?
		// user를 보내야 가입한 커뮤니티를 알 수 있을거같다...
		//아니면 따로따로 가져와서 다른 ArrayList에 모두 add시켜볼까?
		ArrayList<Board> selectMainBoardList = boardService.selectUserMainBoardList(user);
		ArrayList<Board> userMainBoardList = new ArrayList<Board>();
		
		if(selectMainBoardList != null) {
			for(int i = 0; i < selectMainBoardList.size(); i++) {
				b = selectMainBoardList.get(i);
				b.setReplyList(boardService.selectBoardReplyListAsBidx(b.getBoard_idx()));
				userMainBoardList.add(b);
			}
			mp.addAttribute("result", true);
			mp.addAttribute("ubList", userMainBoardList);
		}
		return mp;
	}
	
	@RequestMapping(value = "/board/userBoardModify", method = RequestMethod.GET)
	public ModelAndView userBoardModifyAsFlag(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		User usr = SessionManager.getUserSession(request);
		if(usr == null) {
			model.addAttribute("result", false);
			model.addAttribute("status", "SESSION_TIMEOUT");
			return new ModelAndView("user/mainUser");
		}
		
		// flag따라 수정 삭제 하는거 구현해야댐.
		Board boardInfo = null;
		try {
			String flag = request.getParameter("flag");
			int board_idx = Integer.parseInt(request.getParameter("idx"));
			
			boardInfo = boardService.selectOneBoardInfoAsIdx(board_idx);
			if(boardInfo != null) {
				if(flag.equals("modify")) {
					model.addAttribute("boardInfo", boardInfo);
					return new ModelAndView("community/communityBoardModify");
				}
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			log.error("PASING ERORR.");
		}
		return new ModelAndView("community/communityBoardModify");
	}
	
	@RequestMapping(value = "/board/userBoardDelete", method = RequestMethod.GET)
	@ResponseBody
	public ModelMap userBoardDeleteAsFlag(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelMap mp = new ModelMap();
		User user = SessionManager.getUserSession(request);
		if(user == null) {
			mp.addAttribute("result", false);
			mp.addAttribute("status", "SESSION_TIMEOUT");
			return mp;
		}
		
		Board boardInfo = null;
		try {
			String flag = request.getParameter("flag");
			int board_idx = Integer.parseInt(request.getParameter("idx"));
			
			boardInfo = boardService.selectOneBoardInfoAsIdx(board_idx);
			if(boardInfo != null) {
				if(flag.equals("delete")) {
					boardInfo.setBoard_stat_cd("I");
					boardService.updateBoardStatusAsFlag(boardInfo);
					mp.addAttribute("result", true);
					mp.addAttribute("status", "DELETE");
					return mp;
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error("PARSING ERROR.");
		}
		
		return mp;
	}
	
	@RequestMapping(value = "/board/modifyCommunityBoard", method = RequestMethod.POST)
	@ResponseBody
	public ModelAndView modifyCommunityBoard(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		User user = SessionManager.getUserSession(request);
		//ModelMap mp = new ModelMap();
		if(user == null) {
			model.addAttribute("result", false);
			model.addAttribute("status", "SESSION_TIMEOUT");
			return new ModelAndView("community/communityBoardModify");
		}
		
		try {
			Board board = new Board();
			BoardFile bf = null;
			
			int comm_idx = Integer.parseInt(request.getParameter("cidx"));
			int user_idx = user.getUser_idx();
			int board_idx = Integer.parseInt(request.getParameter("bidx"));
			
			String title = request.getParameter("board_title");
			String content = request.getParameter("board_content");
			String scope = request.getParameter("boardScopeValue");
			
			String[] realFileNames = request.getParameterValues("realFileName") == null ? null : request.getParameterValues("realFileName");
			String[] resPathValues = request.getParameterValues("resPathValue") == null ? null : request.getParameterValues("resPathValue");
			
			if(content.startsWith("<p><br></p>") || content.endsWith("<p><br></p>")) {
				content = content.replaceAll("<p><br></p>", "<br />");
			}
			
			board.setBoard_idx(board_idx);
			board.setComm_idx(comm_idx);
			board.setBoard_uidx(user_idx);
			board.setBoard_scope(scope);
			board.setBoard_title(title);
			board.setBoard_content(content);
			
			try {
				boardService.updateBoardAsIdx(board);
				
				if(realFileNames != null) {
					boolean[] brr = new boolean[realFileNames.length];
					Arrays.fill(brr, false);
					
					for(int i = 0; i < resPathValues.length; i++) {
						if(board.getBoard_content().indexOf(resPathValues[i]) > -1) brr[i] = true;
					}
					//기존 리스트를 가지고와서, log테이블에 insert후 기존내역 delete.
					boardService.deleteCommunityBoardFileList(board);
					
					for(int i = 0; i < brr.length; i++) {
						if(brr[i]) {
							bf = new BoardFile();
							bf.setBoard_idx(board.getBoard_idx());
							bf.setOrg_file_name(realFileNames[i]);
							bf.setReal_file_path(resPathValues[i]);

							boardService.insertCommunityBoardFile(bf);
						}
					}
				}
				model.addAttribute("result", true);
				model.addAttribute("status", "UPDATE");
				model.addAttribute("msg", "성공했습니다.");
				model.addAttribute("moveToValue", comm_idx);
				return new ModelAndView("community/communityBoardModify");
				
			}catch(Exception e) {
				e.printStackTrace();
				log.error("UPDATE FAILED.");
				model.addAttribute("result", false);
				model.addAttribute("status", "UPDATE_FAILED");
				return new ModelAndView("community/communityBoardModify");
			}
			
			
		}catch(Exception e) {
			e.printStackTrace();
			log.error("PARSING ERROR.");
		}
		return new ModelAndView("error");
	}
	
	@RequestMapping(value = "/board/reply/insertCommunityBoardReply", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String insertCommunityBoardReply(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		User user = SessionManager.getUserSession(request);
		if(user == null) {
			response.sendRedirect(request.getContextPath() + "/");
		}
		JsonObject obj = new JsonObject();
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		try {
			int bidx = element.getAsJsonObject().get("bidx").getAsInt();
			String replyContent = element.getAsJsonObject().get("replyContent").getAsString();
			
			Reply reply = new Reply();
			reply.setBoard_idx(bidx);
			reply.setReply_content(replyContent);
			reply.setReply_uidx(user.getUser_idx());
			
			boardService.insertCommunityBoardReply(reply);
			
			obj.addProperty("result", true);
			obj.addProperty("msg", "성공했습니다.");
			return obj.toString();
			
		}catch(Exception e) {
			e.printStackTrace();
			log.error("REPLY VALUE PARSING ERROR.");
			obj.addProperty("result", false);
			obj.addProperty("msg", "실패했습니다.");
			return obj.toString();
		}
	}
	
	@RequestMapping(value = "/board/reply/updateCommunityBoardReplyContent", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String updateCommunityBoardReplyContent(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		User user = SessionManager.getUserSession(request);
		if(user == null) response.sendRedirect(request.getContextPath() + "/");
		
		JsonObject obj = new JsonObject();
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		Reply modifyReply = new Reply();
		
		try {
			String replyContent = element.getAsJsonObject().get("replyModifyContent").getAsString();
			int ridx = element.getAsJsonObject().get("idx").getAsInt();
			int uidx = user.getUser_idx();
			modifyReply.setReply_uidx(uidx);
			modifyReply.setReply_content(replyContent);
			modifyReply.setReply_idx(ridx);
			
			try {
				boardService.updateCommunityBoardReplyContent(modifyReply);
				
				obj.addProperty("result", true);
				return obj.toString();
			}catch(Exception e) {
				e.printStackTrace();
				log.error("REPLY CONTENT UPDATE FAILED");
				obj.addProperty("result", false);
				obj.addProperty("status", "UPDATE_FAIL");
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			log.error("PARSING ERROR.");
			obj.addProperty("result", false);
			obj.addProperty("status", "PARSING_FAIL");
		}
		return obj.toString();
	}
	
	@RequestMapping(value = "/board/reply/deleteCommunityBoardReply", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String deleteCommunityBoardReply(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		User user = SessionManager.getUserSession(request);
		if(user == null) response.sendRedirect(request.getContextPath() + "/");
		
		JsonObject obj = new JsonObject();
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		try {
			int ridx = element.getAsJsonObject().get("idx").getAsInt();
			Reply delReply = new Reply();
			delReply.setReply_idx(ridx);
			
			try {
				boardService.deleteCommunityBoardReply(delReply);
				obj.addProperty("result", true);
				return obj.toString();
			}catch(Exception e) {
				e.printStackTrace();
				log.error("DELETE FAILED");
				obj.addProperty("result", false);
				obj.addProperty("status", "DELETE_FAILED");
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error("REPLY IDX PARSING ERROR.");
			obj.addProperty("result", false);
			obj.addProperty("status", "PARSING_FAIL");
		}
		
		return obj.toString();
	}
	
	
	

}
