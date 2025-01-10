package com.puter.final_project.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.time.Instant;
import java.time.ZoneId;
import java.sql.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.puter.final_project.dao.CouponBoxMapper;
import com.puter.final_project.vo.CouponBoxVo;

@Controller
@RequestMapping("/coupon/")
public class CouponBoxController {

    @Autowired
    private CouponBoxMapper couponBoxMapper;

    @RequestMapping("addCouponToBox.do")
    public String addCouponToBox(CouponBoxVo couponBox, Model model) {
        int result = couponBoxMapper.insertCouponToBox(couponBox);
        if (result > 0) {
            System.out.println("쿠폰 추가 성공");
        } else {
            System.out.println("쿠폰 추가 실패");
        }
        return "redirect:/coupon/main.do?useridx=" + couponBox.getUseridx();
    }

    @RequestMapping("myCoupons.do")
    public String myCoupons(int useridx, Model model) {
        List<CouponBoxVo> myCouponList = couponBoxMapper.selectCouponsByUserId(useridx);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd"); // 날짜 포맷 지정
        LocalDate today = LocalDate.now(); // 현재 날짜

        // 각 쿠폰에 대해 D-day 계산

        for (CouponBoxVo coupon : myCouponList) {
            Date signupDate = coupon.getCreateAt(); // 회원가입일 가져오기
            if (signupDate != null) {
                // Date -> LocalDate 변환
                LocalDate signupLocalDate = Instant.ofEpochMilli(signupDate.getTime())
                        .atZone(ZoneId.systemDefault())
                        .toLocalDate();

                // 회원가입일을 포맷하여 createAtStr에 설정
                String formattedSignupDate = signupLocalDate.format(formatter);
                coupon.setCreateAtStr(formattedSignupDate); // 포맷된 회원가입일 설정

                // 유효기간 계산
                String expirationDate = calculateExpirationDate(signupLocalDate);
                coupon.getCoupon().setExpirationDate(expirationDate);

                // D-day 계산
                LocalDate expirationLocalDate = LocalDate.parse(expirationDate,
                        DateTimeFormatter.ofPattern("yyyy.MM.dd"));
                long daysLeft = ChronoUnit.DAYS.between(today, expirationLocalDate);

                // D-day 값 설정 (예: D-100, D-99 등)
                coupon.getCoupon().setDaysLeft("D-" + daysLeft);
            }
        }

        model.addAttribute("myCouponList", myCouponList);
        return "shopPage/couponMain";
    }

    // 유효기간 계산 로직
    private String calculateExpirationDate(LocalDate signupLocalDate) {
        // 가입일로부터 100일 더함
        LocalDate expirationDate = signupLocalDate.plusDays(100);

        // 포맷 지정 (yyyy.MM.dd)
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy.MM.dd");

        // 계산된 만료일 반환
        return expirationDate.format(formatter);
    }

    @RequestMapping("applyCouponToProduct.do")
    public String applyCouponToProduct(@RequestParam("useridx") int useridx,
            @RequestParam("pIdx") int pIdx,
            Model model) {
        // 사용자의 쿠폰 리스트를 가져옴
        List<CouponBoxVo> couponList = couponBoxMapper.selectCouponsByUserId(useridx);

        // 로그 추가
        System.out.println("쿠폰 리스트: " + couponList);

        model.addAttribute("couponList", couponList);
        model.addAttribute("pIdx", pIdx);

        return "menubar/payment";
    }

}