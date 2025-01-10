package com.puter.final_project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.puter.final_project.vo.CouponVo;

@Mapper
public interface CouponMapper {

    // 전체 쿠폰 목록 조회
    List<CouponVo> selectAllCoupons();

    // 쿠폰 단일 조회 (cIdx로 조회)
    CouponVo selectCouponById(int cIdx);

    // 새로운 쿠폰 추가
    int insertCoupon(CouponVo coupon);

    // 추가: 특정 쿠폰을 모든 사용자에게 발급하는 로직 (사용자에게 쿠폰 발급)
    int insertCouponToAllUsers(int cIdx);

}