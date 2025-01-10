package com.puter.final_project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import com.puter.final_project.vo.CouponBoxVo;

@Mapper
public interface CouponBoxMapper {

    // 특정 사용자의 쿠폰 목록 조회 (useridx 기준)
    List<CouponBoxVo> selectCouponsByUserId(int useridx);

    // 사용자의 쿠폰함에 새로운 쿠폰 추가
    int insertCouponToBox(CouponBoxVo couponBox);

    // 특정 쿠폰 조회 (couponId 기준)
    CouponBoxVo selectCouponById(int couponId);

    // 쿠폰 사용 상태 업데이트
    int updateCouponUsage(int couponId);

}