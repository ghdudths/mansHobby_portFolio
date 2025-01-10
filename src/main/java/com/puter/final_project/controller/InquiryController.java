package com.puter.final_project.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.puter.final_project.dao.InquiryMapper;
import com.puter.final_project.vo.AnswerVo;
import com.puter.final_project.vo.InquiryVo;
import com.puter.final_project.vo.UserVo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/inquiry/")
public class InquiryController {

    @Autowired
    HttpServletRequest request;

    @Autowired
    HttpSession session;

    @Autowired
    InquiryMapper inquiryMapper;

    // 고객문의 페이지
    @RequestMapping("inquiry.do")
    public String inquiry(Model model) {

        // 1. parameter 받기
        String search = request.getParameter("search");
        String search_text = request.getParameter("search_text");

        if (search == null)
            search = "all";

        // 검색조건을 담을 맵
        Map<String, String> map = new HashMap<String, String>();

        // 이름 + 제목
        // if (search.equals("name")) {

        // map.put("name", search_text);
        // map.put("inType", search_text);

        // } else
        if (search.equals("id")) { // search == "name" (X)

            // 이름
            map.put("id", search_text);

        } else if (search.equals("inType")) {

            // 제목
            map.put("inType", search_text);

        }
        List<InquiryVo> list = inquiryMapper.selectByCondition(map);

        // 게시물의 답변 상태를 맵에 저장
        Map<Integer, Boolean> answerMap = new HashMap<>();
        List<AnswerVo> comments = inquiryMapper.inquiryAList();
        for (AnswerVo comment : comments) {
            answerMap.put(comment.getInIdx(), true); // 답변이 존재하면 true
        }

        model.addAttribute("list", list);
        model.addAttribute("answerMap", answerMap);
        model.addAttribute("search", search);
        model.addAttribute("search_text", search_text);

        return "inquiry/inquiry";
    }

    // 게시글 상세 조회
    @RequestMapping("inquirySelect.do")
    public String inquirySelect(int inIdx, Model model) {

        InquiryVo vo = inquiryMapper.selectOne(inIdx);

        model.addAttribute("vo", vo);

        return "inquiry/inquirySelect";
    }

    // 게시글 작성폼 이동
    @RequestMapping("inquiryWriteForm.do")
    public String inquiryWriteForm(@RequestParam(value = "pIdx", required = false) Integer pIdx, Model model) {

        InquiryVo vo = inquiryMapper.selectOneP(pIdx);

        model.addAttribute("vo", vo);

        return "inquiry/inquiryWriteForm";
    }

    // 게시글 작성
    @RequestMapping("inquiryWrite.do")
    public String inquiryWrite(InquiryVo vo, String url, HttpSession session, Model model,
            @RequestParam("inquiryImg") List<MultipartFile> inPP,
            HttpServletRequest request) {

        UserVo user = (UserVo) session.getAttribute("user");

        vo.setUserIdx(user.getUserIdx());

        // 이미지 저장 경로 설정
        String absPath = request.getServletContext().getRealPath("/resources/images/inquiry/");
        List<String> filenameList = new ArrayList<>();

        for (MultipartFile file : inPP) {
            if (!file.isEmpty()) {
                String filename = file.getOriginalFilename();
                File f = new File(absPath, filename);

                // 동일한 파일이 존재할 경우 파일명 변경
                if (f.exists()) {
                    long tm = System.currentTimeMillis();
                    filename = String.format("%d_%s", tm, filename);
                    f = new File(absPath, filename);
                }

                // 파일 저장
                try {
                    file.transferTo(f);
                    filenameList.add(filename);
                } catch (Exception e) {
                    e.printStackTrace();
                    model.addAttribute("error", "이미지 업로드에 실패했습니다.");
                    return "redirect:inquiry.do";
                }
            }
        }

        // 모든 이미지 파일명을 ReviewVo에 저장 (여러 이미지를 처리)
        if (!filenameList.isEmpty()) {
            for (String filename : filenameList) {
                // 이미지 정보를 DB에 저장하는 로직 추가
                vo.setInPP(filename); // 각 이미지 파일명을 설정
                int res = inquiryMapper.inquiryInsert(vo);
            }
        }else{
            vo.setInPP("NoPhoto");
            int res = inquiryMapper.inquiryInsert(vo);
        }

        return "redirect:inquiry.do";
    }


    // 게시글 삭제
    @RequestMapping("inquiryDelete.do")
    public String inquiryDelete(int inIdx) {

        int res = inquiryMapper.delete(inIdx);

        return "redirect:inquiry.do";
    }

    // 게시글 수정폼 이동
    @RequestMapping("inquiryModifyForm.do")
    public String inquiryModifyForm(int inIdx, Model model) {

        InquiryVo vo = inquiryMapper.selectOne(inIdx);

        model.addAttribute("vo", vo);

        return "inquiry/inquiryModifyForm";
    }

    // 게시글 수정
    @RequestMapping("inquiryModify.do")
    public String inquiryModify(InquiryVo vo, Model model, @RequestParam("inquiryImg") List<MultipartFile> inPP) {
    
        // inPP가 null일 경우 빈 리스트로 초기화
        if (inPP == null || inPP.isEmpty()) {
            inPP = new ArrayList<>();
        }
    
        // 이미지 저장 경로 설정
        String absPath = request.getServletContext().getRealPath("/resources/images/inquiry/");
        List<String> filenameList = new ArrayList<>();
    
        // 파일 업로드 처리
        for (MultipartFile file : inPP) {
            if (!file.isEmpty()) {
                String filename = file.getOriginalFilename();
                File f = new File(absPath, filename);
    
                // 동일한 파일이 존재할 경우 파일명 변경
                if (f.exists()) {
                    long tm = System.currentTimeMillis();
                    filename = String.format("%d_%s", tm, filename);
                    f = new File(absPath, filename);
                }
    
                // 파일 저장
                try {
                    file.transferTo(f);
                    filenameList.add(filename);
                } catch (Exception e) {
                    System.out.println("error : "+filename);

                    e.printStackTrace();
                    model.addAttribute("error", "이미지 업로드에 실패했습니다.");
                    return "redirect:inquiry.do";
                }
                vo.setInPP(filename);
                System.out.println(filename);
            }
        }
    
        // 데이터베이스 업데이트 수행
        int res = inquiryMapper.update(vo);
    
        return "redirect:inquiry.do";
    }
    

}
