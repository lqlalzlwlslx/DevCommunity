package com.dev.comm.common.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.dev.comm.board.service.BoardService;
import com.dev.comm.board.vo.Board;

@Controller
public class CommonController {
	
	protected final Log log = LogFactory.getLog(getClass());
	
	@Autowired
	private BoardService boardService;
	
	@RequestMapping(value = "/visitorMain", method = RequestMethod.GET)
	public ModelAndView moveToVisitorMain(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		// visitor 구현하기..
		Board b = new Board();
		b.setBoard_scope("A");
		ArrayList<Board> visitorBoardList = boardService.selectVisitorMainBoardList(b);
		if(visitorBoardList != null && visitorBoardList.size() > 0) {
			for(int i = 0; i < visitorBoardList.size(); i++) {
				visitorBoardList.get(i).setReplyList(boardService.selectBoardReplyListAsBidx(visitorBoardList.get(i).getBoard_idx()));
			}
			model.addAttribute("vbList", visitorBoardList);
		}
		
		return new ModelAndView("/visitor/visitorMain2");
	}
	
	
	
	
	

}
