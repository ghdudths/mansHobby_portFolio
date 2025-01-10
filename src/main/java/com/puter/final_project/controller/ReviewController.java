package com.puter.final_project.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.puter.final_project.dao.ReviewMapper;
import com.puter.final_project.dao.UserActivityMapper;
import com.puter.final_project.vo.ReviewLikeVo;
import com.puter.final_project.vo.ReviewVo;
import com.puter.final_project.vo.UserVo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import net.minidev.json.JSONObject;

@Controller
@RequestMapping("/review/")
public class ReviewController {

    @Autowired
    HttpServletRequest request;

    @Autowired
    HttpSession session;

    @Autowired
    ReviewMapper reviewMapper;

    @Autowired
    UserActivityMapper userActivityMapper;

    @RequestMapping("review.do")
    public String list(Model model) {

        // 전체 리뷰 불러오기
        List<ReviewVo> list = reviewMapper.selectList();

        model.addAttribute("list", list);

        return "shopPage/review";
    }

    @RequestMapping("reviewWrite.do")
    public String reviewWrite(ReviewVo vo, String url, HttpSession session, Model model, 
                            @RequestParam("reviewImg") List<MultipartFile> rvImg, 
                            HttpServletRequest request) {
        UserVo user = (UserVo) session.getAttribute("user");

        // 유저 정보 세팅
        vo.setUserIdx(user.getUserIdx());

        // 리뷰 데이터 삽입
        int res = reviewMapper.insertReview(vo);

        if (res > 0) {
            // 저장된 리뷰의 ID 가져오기
            int rvIdx = reviewMapper.selectMaxRvIdx();
            vo.setRvIdx(rvIdx);  // vo 객체에 rvIdx 설정

            // 이미지 저장 경로 설정
            String absPath = request.getServletContext().getRealPath("/resources/images/review/");
            List<String> filenameList = new ArrayList<>();

            for (MultipartFile file : rvImg) {
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
                        return "redirect:" + url;
                    }
                }
            }

            // 모든 이미지 파일명을 ReviewVo에 저장 (여러 이미지를 처리)
            if (!filenameList.isEmpty()) {
                for (String filename : filenameList) {
                    // 이미지 정보를 DB에 저장하는 로직 추가
                    vo.setRvImg(filename); // 각 이미지 파일명을 설정
                    reviewMapper.updateReviewImg(vo); // vo 객체로 업데이트
                }
            }

            res = userActivityMapper.updateTotalReviewPlus(user.getUserIdx());
            res = userActivityMapper.callUpdateUserGrade(user.getUserIdx());

            return "redirect:" + url;  // 성공적으로 처리 후 리다이렉트
        } else {
            model.addAttribute("error", "리뷰 작성에 실패했습니다.");
            return "redirect:" + url;  // 실패 시 리다이렉트
        }
    }

    @GetMapping("getReviewInfo.do")
    public ResponseEntity<ReviewVo> getReviewInfo(@RequestParam("rvIdx") int rvIdx) {
        ReviewVo reviewVo = reviewMapper.getReviewInfo(rvIdx);
        if (reviewVo != null) {
            return ResponseEntity.ok(reviewVo); // 200 OK와 함께 JSON 반환
        } else {
            return ResponseEntity.notFound().build(); // 404 Not Found
        }

    }

    @RequestMapping("/reviewModify.do")
    public String modifyReview(ReviewVo vo, String url, HttpSession session, Model model) {
        
        UserVo user = (UserVo) session.getAttribute("user");

        // 사용자가 로그인했는지 확인
        if (user == null) {
            model.addAttribute("error", "로그인 후 수정할 수 있습니다.");
            return "redirect:" + url; // 로그인 페이지로 리다이렉트
        }

        // 유저 정보 세팅
        vo.setUserIdx(user.getUserIdx());

        // 데이터 수정
        int res = reviewMapper.updateReview(vo);

        if (res > 0) {
            return "redirect:" + url; // 수정 성공 시 원래 페이지로 리다이렉트
        } else {
            model.addAttribute("error", "리뷰 수정에 실패했습니다.");
            return "redirect:" + url; // 실패 시 에러 메시지와 함께 폼으로 돌아감
        }
    }

    @RequestMapping(value = "toggle.do", produces = "application/json; charset=utf-8;")
    @ResponseBody
    public String toggle(@RequestParam("rvIdx") int rvIdx) {
        UserVo user = (UserVo) session.getAttribute("user"); // 세션에서 userIdx 가져오기
        
        JSONObject json = new JSONObject();
        if (user == null) {
            json.put("result", "failure");
            json.put("message", "로그인이 필요합니다.");
            return json.toString();
        }

        ReviewLikeVo vo = new ReviewLikeVo();
        vo.setRvIdx(rvIdx);
        vo.setUserIdx(user.getUserIdx());

        ReviewVo rvo = reviewMapper.getReviewByLike(vo);
        if(rvo != null){
            vo.setRfIdx(rvo.getRfIdx());
        }

        boolean isLiked = reviewMapper.LikedByUser(vo) > 0;
        int res;

        if (isLiked) {
            // 좋아요 취소
            res = reviewMapper.deleteLike(vo);
            json.put("action", "removed");
        } else {
            // 좋아요 추가
            res = reviewMapper.insertLike(vo);
            json.put("action", "added");
        }

        int likeCount = reviewMapper.countLikes(rvIdx); // 리뷰의 최신 좋아요 수 조회
        json.put("count", likeCount);
        json.put("result", res == 1 ? "success" : "failure");
        return json.toString();
    }

    @RequestMapping(value = "count.do", produces = "application/json; charset=utf-8;")
    @ResponseBody
    public String count(@RequestParam("rvIdx") int rvIdx) {
        int count = reviewMapper.countLikes(rvIdx);

        JSONObject json = new JSONObject();
        json.put("count", count);
        return json.toString();
    }

    @RequestMapping(value = "isLiked.do", produces = "application/json; charset=utf-8;")
    @ResponseBody
    public String isLiked(@RequestParam("rvIdx") int rvIdx) {
        Integer userIdx = (Integer) request.getSession().getAttribute("userIdx"); // 세션에서 userIdx 가져오기
    
        JSONObject json = new JSONObject();
        if (userIdx == null) {
            json.put("isLiked", false);
            return json.toString();
        }
    
        ReviewLikeVo vo = new ReviewLikeVo();
        vo.setRvIdx(rvIdx);
        vo.setUserIdx(userIdx);
    
        boolean isLiked = reviewMapper.LikedByUser(vo) > 0;
    
        json.put("isLiked", isLiked);
        return json.toString();
    }
   
    @RequestMapping(value = "deleteReview.do", produces = "application/json; charset=utf-8;")
    @ResponseBody
    public String deleteReview(@RequestParam("rvIdx") int rvIdx) {
        UserVo user = (UserVo) session.getAttribute("user");
        System.out.println("=================== rvIdx ================="+rvIdx);
        int res = reviewMapper.deleteByReview(rvIdx);
        System.out.println("=================== res ================="+res);
        if (res > 0){
            res = userActivityMapper.updateTotalReviewMinus(user.getUserIdx());
            System.out.println("=================== res1 ================="+res);
            res = userActivityMapper.callUpdateUserGrade(user.getUserIdx());
            System.out.println("=================== res2 ================="+res);
            if(res == -1) res = 1;
        }
        System.out.println("=================== res3 ================="+res);

        JSONObject json = new JSONObject();
        json.put("result", res > 0 ? "success" : "failure");
        return json.toString();
    }
}
