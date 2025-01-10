package com.puter.final_project.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/home")
public class HomeInController {

    @GetMapping("/do")
    public String home() {
        // 여기에 홈 페이지에 대한 로직을 추가하세요.
        // JSP 파일을 반환하거나, 뷰 이름을 반환합니다.
        return "home";  // "home.jsp" 뷰로 포워딩
    }
}
