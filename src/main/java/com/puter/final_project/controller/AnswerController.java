package com.puter.final_project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.puter.final_project.dao.AnswerMapper;
import com.puter.final_project.vo.AnswerVo;
import com.puter.final_project.vo.UserVo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import net.minidev.json.JSONObject;

@Controller
@RequestMapping("/answer/")
public class AnswerController {

    @Autowired
    HttpServletRequest request;

    @Autowired
    HttpSession session;

    @Autowired
    AnswerMapper answerMapper;

    // 댓글 목록 불러오기
    @RequestMapping(value = "answerList.do", produces = "application/json; charset=utf-8;")
    @ResponseBody
    public List<AnswerVo> answerList(int inIdx) {
        Map<String, Object> map = new HashMap<>();
        map.put("inIdx", inIdx);

        // 댓글 목록을 가져와 JSON으로 반환
        List<AnswerVo> answerList = answerMapper.selectList(map);

        return answerList; // List<AnswerVo>를 JSON으로 반환
    }

    // 답글 작성
    @RequestMapping(value = "answerInsert.do", produces = "application/json; charset=utf-8;")
    @ResponseBody
    public String answerInsert(AnswerVo vo) {
        // 줄바꿈을 <br> 태그로 변환
        String aContent = vo.getAContent().replaceAll("\n", "<br>");
        vo.setAContent(aContent);
        
        // 댓글을 DB에 추가
        int res = answerMapper.answerInsert(vo);
        
        // 결과를 JSON으로 반환
        JSONObject json = new JSONObject();
        json.put("result", res == 1);
        return json.toString();
    }

    // 답글 삭제
    @RequestMapping(value = "answerDelete.do", produces = "application/json; charset=utf-8;")
    @ResponseBody
    public String answerDelete(int aIdx) {

        System.out.println("=======aIdx=======:"+aIdx);
        UserVo user = (UserVo) session.getAttribute("user");

        JSONObject json = new JSONObject();

        if(user == null) {
            json.put("result", "failure");
            json.put("message", "로그인이 필요합니다.");
            return json.toString();
        }

        AnswerVo vo = answerMapper.selectOne(aIdx);

        if(vo == null) {
            json.put("result", "failure");
            json.put("message", "댓글을 찾을 수 없습니다.");
            return json.toString();
        }

        if (user.getUserIdx() == vo.getUserIdx() || user.getUserIdx() == 1) {
            // 자신의 댓글인 경우 실제로 삭제
            int res = answerMapper.answerDelete(aIdx);
            json.put("result", res == 1);
        } else {
            json.put("result", "failure");
            json.put("message", "삭제 권한이 없습니다.");
        }

        return json.toString();
    }

    // 답글 삭제
    // @RequestMapping("answerDelete.do")
    // public List<AnswerVo> answerDelete(Integer aIdx) {

    //     Map<String, Object> map = new HashMap<>();
    //     map.put("aIdx", aIdx);

    //     // 댓글 목록을 가져와 JSON으로 반환
    //     List<AnswerVo> answerList = answerMapper.selectList(map);

    //     int res = answerMapper.answerDelete(aIdx);

    //     return answerList;
    // }

}
