package com.puter.final_project.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.puter.final_project.dao.UserMapper;
import com.puter.final_project.service.EmailService;
import com.puter.final_project.vo.UserVo;

@Controller
public class MailController {

    @Autowired
    private EmailService emailService;

    @Autowired
    UserMapper userMapper;

    @RequestMapping("/password.do")
    public String password(){

        return "menubar/password";
    }

    @GetMapping("/sendEmail.do")
    public String sendEmail(UserVo vo) {

        int userIdx = userMapper.selectEmailUserIdx(vo);
        vo.setUserIdx(userIdx);
        String id = userMapper.selectId(vo);
        vo.setId(id);
        String password = userMapper.selectPwd(vo);

        emailService.sendEmail(vo.getEmail(), "MansHobbyMall 비밀번호 찾기 결과", "회원님의 비밀번호는 "+password+" 입니다");
        return "redirect:password.do";
    }

    @RequestMapping("/passwordSearchAjax.do")
    @ResponseBody
    public List<UserVo> passwordSearch(UserVo vo) {
        
        Integer userIdx = userMapper.selectNameIdUserIdx(vo);
        if(userIdx == null) {
            userIdx=0;
        }
        
        List<UserVo> emailList = userMapper.selectEmailList(userIdx);
        return emailList;
    }
}
