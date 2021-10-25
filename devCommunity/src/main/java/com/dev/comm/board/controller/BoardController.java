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
import com.dev.comm.board.vo.Inquiry;
import com.dev.comm.board.vo.InquiryFile;
import com.dev.comm.board.vo.Reply;
import com.dev.comm.community.service.CommunityService;
import com.dev.comm.community.vo.Community;
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
	
	@Autowired
	private CommunityService communityService;
	
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
		
		Board b = null;
		
		ArrayList<Board> vBoardList = boardService.selectVisitorMainBoardList(board);
		ArrayList<Board> visitBoardList = new ArrayList<Board>();
		if(vBoardList != null) {
			for(int i = 0; i < vBoardList.size(); i++) {
				b = vBoardList.get(i);
				b.setReplyList(boardService.selectBoardReplyListAsBidx(b.getBoard_idx()));
				visitBoardList.add(b);
			}
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
			return new ModelAndView("redirect:/");
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
			
//			if(content.contains("<p><br></p><p><br></p>")) content = content.replaceAll("<p><br></p><p><br></p>", "<br />");
//			if(content.startsWith("<p><br></p>") || content.endsWith("<p><br></p>") || content.contains("<p><br></p>")) {
//				content = content.replaceAll("<p><br></p>", "");
//			}
			content = content.replaceAll("<p>", "");
			content = content.replaceAll("<br>", "");
			content = content.replaceAll("</p>", "<br />");
			
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
		User user = SessionManager.getUserSession(request);
		if(user == null) {
			model.addAttribute("result", false);
			model.addAttribute("status", "SESSION_TIMEOUT");
			return new ModelAndView("user/mainUser");
		}
		
		// flag따라 수정 삭제 하는거 구현해야댐.
		Board boardInfo = null;
		try {
			String flag = request.getParameter("flag");
			String enFlag = request.getParameter("enterFlag");
			int board_idx = Integer.parseInt(request.getParameter("idx"));
			
			boardInfo = boardService.selectOneBoardInfoAsIdx(board_idx);
			ArrayList<Community> userCommunityList = communityService.selectUserCommunityList(user);
			
			if(boardInfo != null) {
				if(flag.equals("modify")) {
					if(userCommunityList != null) model.addAttribute("ucList", userCommunityList);
					model.addAttribute("enFlag", enFlag);
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
	
	@RequestMapping(value = "/board/userBoardDelete", method = RequestMethod.POST)
	@ResponseBody
	public String userBoardDeleteAsFlag(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		JsonObject obj = new JsonObject();
		User user = SessionManager.getUserSession(request);
		if(user == null) {
			obj.addProperty("result", false);
			obj.addProperty("status", "SESSION_TIMEOUT");
			return obj.toString();
		}
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		Board boardInfo = null;
		try {
			String flag = element.getAsJsonObject().get("boardFlag").getAsString();
			int board_idx = element.getAsJsonObject().get("idx").getAsInt();
			
			boardInfo = boardService.selectOneBoardInfoAsIdx(board_idx);
			if(boardInfo != null) {
				if(flag.equals("delete")) {
					boardInfo.setBoard_stat_cd("I");
					boardService.updateBoardStatusAsFlag(boardInfo);
					obj.addProperty("result", true);
					obj.addProperty("status", "DELETE");
					return obj.toString();
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error("PARSING ERROR.");
		}
		
		return obj.toString();
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
			
//			if(content.contains("<p><br></p><p><br></p>")) content.replaceAll("<p><br></p><p><br></p>", "<br />");
//			if(content.startsWith("<p><br></p>") || content.endsWith("<p><br></p>") || content.contains("<p><br></p>")) {
//				content = content.replaceAll("<p><br></p>", "");
//			}
			content = content.replaceAll("<p>", "");
			content = content.replaceAll("<br>", "");
			content = content.replaceAll("</p>", "<br />");
			
			board.setBoard_idx(board_idx);
			board.setComm_idx(comm_idx);
			board.setBoard_uidx(user_idx);
			board.setBoard_scope(scope);
			board.setBoard_title(title);
			board.setBoard_content(content);
			
			try {
				boardService.updateBoardAsIdx(board);
				
				ArrayList<Community> userCommunityList = communityService.selectUserCommunityList(user);
				
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
				if(userCommunityList != null) model.addAttribute("ucList", userCommunityList);
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
	
	@RequestMapping(value = "/console/board/boardManage", method = RequestMethod.GET)
	public ModelAndView adminBoardManage(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.info("=== adminBoardManage ===");
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) {
			return new ModelAndView("redirect:/console/logout.do");
		}
		
		ArrayList<Board> blockBoardList = null;
		ArrayList<Board> activeBoardList = null;
		
		try {
			blockBoardList = boardService.selectAdminBoardManageAsBlockList();
			activeBoardList = boardService.selectAdminBoardManageAsActiveList();
			
			for(int i = 0; i < blockBoardList.size(); i++) blockBoardList.get(i).setReplyList(boardService.selectBoardReplyListAsBidx(blockBoardList.get(i).getBoard_idx()));
			for(int i = 0; i < activeBoardList.size(); i++) activeBoardList.get(i).setReplyList(boardService.selectBoardReplyListAsBidx(activeBoardList.get(i).getBoard_idx()));
			
			model.addAttribute("bbList", blockBoardList);
			model.addAttribute("abList", activeBoardList);
		}catch(Exception e) {
			e.printStackTrace();
			log.error("DATA LOAD FAIL");
		}
		return new ModelAndView("console/boardManage");
	}
	
	@RequestMapping(value = "/console/board/blockBoardToReleaseAsIdx", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String adminBlockBoardToRelease(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		JsonObject obj = new JsonObject();
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) {
			obj.addProperty("result", false);
			obj.addProperty("msg", "SESSION_TIMEOUT");
			return obj.toString();
		}
		
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		try {
			int bidx = element.getAsJsonObject().get("idx").getAsInt();
			Board b = new Board();
			b.setBoard_idx(bidx);
			
			try {
				boardService.adminUpdateBlockBoardToReleaseAsIdx(b);
				
				obj.addProperty("result", true);
				obj.addProperty("msg", "성공했습니다.");
				return obj.toString();
			}catch(Exception e) {
				e.printStackTrace();
				log.error("BLOCK TO RELEASE UPDATE FAIL");
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error("ADMIN CONSOLE BLOCK BOARD TO RELEASE IDX PARSING FAIL");
		}
		
		return null;
	}
	
	@RequestMapping(value = "/console/board/activeBoardToBlockAsIdx", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String adminActiveBoardToBlock(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		JsonObject obj = new JsonObject();
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) {
			obj.addProperty("result", false);
			obj.addProperty("msg", "SESSION_TIMEOUT");
			return obj.toString();
		}
		
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		try {
			int bidx = element.getAsJsonObject().get("idx").getAsInt();
			Board b = new Board();
			b.setBoard_idx(bidx);
			
			try {
				boardService.adminUpdateActiveBoardToBlockAsIdx(b);
				
				obj.addProperty("result", true);
				obj.addProperty("msg", "성공했습니다."); 
				return obj.toString();
			}catch(Exception e) {
				e.printStackTrace();
				log.error("ACTIVE TO BLOCK UPDATE FAIL");
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error("ADMIN CONSOLE ACTIVE BOARD TO BLOCK IDX PARSING FAIL");
		}
		
		return null;
	}
	
	private boolean adminBoardDeleteRequest(HttpServletRequest request, HttpServletResponse response, String data) throws Exception {
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) return false;
		
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		try {
			int bidx = element.getAsJsonObject().get("idx").getAsInt();
			Board board = new Board();
			board.setBoard_idx(bidx);
			
			try {
				boardService.adminDeleteCommunityBoardAsIdx(board);
				return true;
			}catch(Exception e) {
				e.printStackTrace();
				log.error("BOARD DELETE FAIL");
				return false;
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error("DELETE BOARD IDX PARSING FAIL");
			return false;
		}
	}
	
	@RequestMapping(value = "/console/board/blockBoardToDeleteAsIdx", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String adminBlockBoardToDelete(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		JsonObject obj = new JsonObject();
		
		if(adminBoardDeleteRequest(request, response, data)) {
			obj.addProperty("result", true);
			obj.addProperty("msg", "성공했습니다.");
			return obj.toString();
		}
		obj.addProperty("result", false);
		obj.addProperty("msg", "SESSION_TIMEOUT");
		return obj.toString();
	}
	
	@RequestMapping(value = "/console/board/activeBoardToDeleteAsIdx", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String adminActiveBoardToDelete(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		JsonObject obj = new JsonObject();
		
		if(adminBoardDeleteRequest(request, response, data)) {
			obj.addProperty("result", true);
			obj.addProperty("msg", "성공했습니다.");
			return obj.toString();
		}
		obj.addProperty("result", false);
		obj.addProperty("msg", "SESSION_TIMEOUT");
		return obj.toString();
	}
	
	private int communityActiveBoardToFlag(HttpServletRequest request, HttpServletResponse response, String data, String flag) throws Exception {
		boolean result;
		User user = SessionManager.getUserSession(request);
		if(user == null) response.sendRedirect(request.getContextPath() + "/logout.do");
		
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		try {
			int bidx = element.getAsJsonObject().get("bidx").getAsInt();
			if(bidx > 0) {
				boardService.updateCommunityBoardToFlagAsCommunityManager(bidx, flag);
				return bidx;
			}else {
				return -1;
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			log.error("COMMUNITY ACTIVE BOARD TO FLAG VALUE PARSING ERROR.");
		}
		
		return 0;
	}
	
	@RequestMapping(value = "/board/communityActiveBoardToBlack", method = RequestMethod.POST, produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String communityActiveBoardToBlack(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		JsonObject obj = new JsonObject();
		
		int bidx = communityActiveBoardToFlag(request, response, data, "black");
		if(bidx > 0) {
			obj.addProperty("result", true);
			obj.addProperty("msg", "성공했습니다.");
			obj.addProperty("bidx", bidx);
			return obj.toString();
		}
		obj.addProperty("result", false);
		return obj.toString();
	}
	
	@RequestMapping(value = "/board/communityActiveBoardToDelete", method = RequestMethod.POST, produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String communityActiveBoardToDelete(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		JsonObject obj = new JsonObject();
		
		int bidx = communityActiveBoardToFlag(request, response, data, "delete");
		if(bidx > 0) {
			obj.addProperty("result", true);
			obj.addProperty("msg", "성공했습니다.");
			obj.addProperty("bidx", bidx);
			return obj.toString();
		}
		obj.addProperty("result", false);
		return obj.toString();
	}
	
	@RequestMapping(value = "/board/communityBlackBoardToActive", method = RequestMethod.POST, produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String communityBlackBoardToActive(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		JsonObject obj = new JsonObject();
		User user = SessionManager.getUserSession(request);
		if(user == null) response.sendRedirect(request.getContextPath() + "/logout.do");
		
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		try {
			int bidx = element.getAsJsonObject().get("bidx").getAsInt();
			if(bidx > 0) {
				if(boardService.updateCommunityBlackBoardToActiveAsCommunityManager(bidx) > 0) {
					obj.addProperty("result", true);
					obj.addProperty("msg", " 성공했습니다.");
					obj.addProperty("bidx", bidx);
				}else {
					obj.addProperty("result", false);
					obj.addProperty("msg", "실패했습니다.");
				}
			}else {
				obj.addProperty("result", false);
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error("COMMUNITY BLACK BOARD TO ACTIVE VALUE PARSING FAIL");
		}
		
		return obj.toString();
	}
	
	@RequestMapping(value = "/board/insertFaq", method = RequestMethod.POST)
	@ResponseBody
	public ModelAndView insertBoardFaq(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		User user = SessionManager.getUserSession(request);
		if(user == null) return new ModelAndView("redirect:/");
		
		//faq insert 구현하자..
		try {
			Inquiry inquiry = new Inquiry();
			InquiryFile inquiryFile = null;
			
			int uidx = user.getUser_idx();
			String title = request.getParameter("faq_title");
			String content = request.getParameter("faq_content");
			
			String[] realFileNames = request.getParameterValues("realFileName") == null ? null : request.getParameterValues("realFileName");
			String[] resPathValues = request.getParameterValues("resPathValue") == null ? null : request.getParameterValues("resPathValue");
			
			content = content.replaceAll("<p>", "");
			content = content.replaceAll("<br>", "");
			content = content.replaceAll("</p>", "<br />");
			
			if(content.isEmpty()) {
				model.addAttribute("result", false);
				model.addAttribute("msg", "내용을 작성해주세요.");
				return new ModelAndView("config/inquiry");
			}
			
			try {
				inquiry.setReg_uidx(uidx);
				inquiry.setInquiry_title(title);
				inquiry.setInquiry_content(content);
				
				Inquiry inquiryinfo = boardService.insertCommunityInquiryToAdmin(inquiry);
				if(inquiryinfo != null) {
					if(realFileNames == null) {
						model.addAttribute("result", true);
						return new ModelAndView("config/inquiry");
					}else {
						boolean[] brr = new boolean[realFileNames.length];
						Arrays.fill(brr, false);
						for(int i = 0; i < resPathValues.length; i++) if(inquiryinfo.getInquiry_content().indexOf(resPathValues[i]) > -1) brr[i] = true;
						
						try {
							for(int i = 0; i < brr.length; i++) {
								if(brr[i]) {
									inquiryFile = new InquiryFile();
									inquiryFile.setInquiry_idx(inquiryinfo.getInquiry_idx());
									inquiryFile.setOrg_file_name(realFileNames[i]);
									inquiryFile.setReal_file_path(resPathValues[i]);
									
									boardService.insertCommunityInquiryFile(inquiryFile);
								}
							}
							model.addAttribute("result", true);
							return new ModelAndView("config/inquiry");
						}catch(Exception e) {
							e.printStackTrace();
							log.error("INQUIRY INFO FILE QUERY FAIL");
						}
					}
				}else {
					model.addAttribute("result", false);
					model.addAttribute("msg", "처리에 실패했습니다.");
					return new ModelAndView("config/inquiry");
				}
				
			}catch(Exception e) {
				e.printStackTrace();
				log.error("INQUIRY QUERY FAIL");
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			log.error("INQUIRY DATA PARSING FAIL");
		}
		
		return new ModelAndView("config/inquiry");
	}
	
	@RequestMapping(value = "/console/board/inquiryManage", method = RequestMethod.GET)
	public ModelAndView adminBoardInquiryManage(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.info("== adminBoardInquiryManage ===");
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) return new ModelAndView("redirect:/console/logout.do");
		
		try {
			ArrayList<Inquiry> inquiryList = boardService.selectAdminBoardInquiryManageList();
			model.addAttribute("inquiryList", inquiryList);
		}catch(Exception e) {
			e.printStackTrace();
			log.error("INQUIRY DATA LOAD FAIL");
		}
		
		return new ModelAndView("console/inquiryManage");
	}
	
	@RequestMapping(value = "/console/board/updateInquiryAnswerAsIdx", method = RequestMethod.POST, produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String adminUpdateInquiryAnswerAsIdx(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		log.info("=== adminUpdateInquiryAnswer ===");
		JsonObject obj = new JsonObject();
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) response.sendRedirect(request.getContextPath() + "/console/logout.do");
		
		JsonParser parser = new JsonParser();
		JsonElement element = parser.parse(data);
		
		try {
			int inquiry_idx = element.getAsJsonObject().get("idx").getAsInt();
			String inquiry_answer = element.getAsJsonObject().get("inquiryAnswer").getAsString();
			
			Inquiry inquiryInfo = boardService.selectAdminBoardInquiryInfo(inquiry_idx);
			if(inquiryInfo != null && inquiryInfo.getInquiry_stat().equals("R")) {
				inquiryInfo.setInquiry_answer(inquiry_answer);
				inquiryInfo.setInquiry_stat("S");
				
				boardService.updateBoardInquiryAnswerFromAdmin(inquiryInfo);
				
				obj.addProperty("result", true);
				obj.addProperty("msg", "성공했습니다.");
			}else if(inquiryInfo != null && inquiryInfo.getInquiry_stat().equals("S")){
				obj.addProperty("result", false);
				obj.addProperty("msg", "답변이 완료된 문의입니다.");
			}else {
				obj.addProperty("result", false);
				obj.addProperty("msg", "조회결과가 없습니다.");
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error("ADMIN INQUIRY ANSWER DATA PARSING FAIL");
		}
		return obj.toString();
	}
	
	@RequestMapping(value = "/console/board/modifyInquiryAnswerAsIdx", method = RequestMethod.POST, produces = "text/plain;charset=utf-8")
	@ResponseBody
	public String adminModifyInquiryAnswerAsIdx(HttpServletRequest request, HttpServletResponse response, @RequestBody String data) throws Exception {
		log.info("=== adminModifyInquiryAnswer ===");
		JsonObject obj = new JsonObject();
		User admin = SessionManager.getAdminSession(request);
		if(admin == null) response.sendRedirect(request.getContextPath() + "/console/logout.do");
		
		try {
			int inquiry_idx = new JsonParser().parse(data).getAsJsonObject().get("idx").getAsInt();
			String modifyAnswer = new JsonParser().parse(data).getAsJsonObject().get("modifyAnswerTxt").getAsString();
			
			Inquiry inquiryInfo = boardService.selectAdminBoardInquiryInfo(inquiry_idx);
			if(inquiryInfo != null && (inquiryInfo.getInquiry_stat().equals("S") || inquiryInfo.getInquiry_stat().equals("M"))) {
				inquiryInfo.setInquiry_stat("M");
				inquiryInfo.setInquiry_answer(modifyAnswer);
				
				boardService.modifyBoardInquiryAnswerFromAdmin(inquiryInfo);
				obj.addProperty("result", true);
				obj.addProperty("msg", "성공했습니다.");
			}else {
				obj.addProperty("result", false);
				obj.addProperty("msg", "답변이 등록되지 않은 문의입니다.");
			}
		}catch(Exception e) {
			e.printStackTrace();
			log.error("ADMIN INQUIRY ANSWER MODIFY DATA PARSING FAIL");
		}
		return obj.toString();
	}
	
	
	

}
