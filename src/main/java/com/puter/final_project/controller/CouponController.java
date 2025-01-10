package com.puter.final_project.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PostMapping;

import com.puter.final_project.dao.CouponMapper;
import com.puter.final_project.vo.CouponVo;

@Controller
@RequestMapping("/coupon/")
public class CouponController {

    @Autowired
    private CouponMapper couponMapper;

    // 쿠폰 추가 폼 페이지로 이동
    @RequestMapping("addForm.do")
    public String addForm() {
        return "shopPage/addCouponForm"; // 쿠폰 추가 폼 JSP 경로
    }

    // 쿠폰 추가 처리 (POST 요청)
	@PostMapping("add.do")
	public String add(CouponVo coupon, @RequestParam(value = "applyToAllUsers", defaultValue = "false") boolean applyToAllUsers, Model model) {
		int result = couponMapper.insertCoupon(coupon);
		if (result > 0) {
			System.out.println("쿠폰 추가 성공");
	
			// 모든 사용자에게 쿠폰을 추가하는 옵션 처리
			if (applyToAllUsers) {
				// 모든 사용자에게 해당 쿠폰 발급 로직 추가
				System.out.println("모든 사용자에게 쿠폰이 발급됩니다.");
				// couponBoxMapper를 사용해 모든 사용자에게 쿠폰 발급
				// 예시 코드: couponBoxMapper.insertCouponToAllUsers(coupon.getCidx());
			}
	
		} else {
			System.out.println("쿠폰 추가 실패");
		}
		return "redirect:/coupon/list.do"; // 쿠폰 목록 페이지로 리다이렉트
	}

    // 쿠폰 목록 페이지
    @RequestMapping("list.do")
    public String list(Model model) {
        List<CouponVo> couponList = couponMapper.selectAllCoupons();
        System.out.println("Coupon List in Controller: " + couponList);
        model.addAttribute("couponList", couponList);
        return "shopPage/couponList"; // 쿠폰 목록 JSP 경로
    }
}
