package com.puter.final_project.vo;

import org.apache.ibatis.type.Alias;
import lombok.Data;
import java.sql.Date;

@Data
@Alias("couponBox")
public class CouponBoxVo {

    int cbidx; // 쿠폰박스 ID
    int useridx; // 사용자 ID
    int cidx; // 쿠폰 ID
    String useat; // 사용 여부 ('N' 사용 전, 'Y' 사용 완료)

    // 쿠폰 정보를 포함할 CouponVo 객체 추가
    CouponVo coupon; // Coupon 정보 필드

    // User 테이블에서 가져온 회원가입일
    Date createAt; // 회원가입일 (User 테이블에서 가져옴)

      // 포맷된 회원가입일
      String createAtStr;  // 포맷된 회원가입일

}
