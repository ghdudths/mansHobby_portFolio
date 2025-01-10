package com.puter.final_project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;
import java.util.Date;

@Alias("coupon")
@Data
public class CouponVo {

    private int cidx; // 쿠폰 ID
    private String cname; // 쿠폰 이름
    private int discount; // 할인 금액
    private String dctype; // 할인 타입 (예: '-' 원 단위)

    // 계산된 만료일 필드 추가
    private String expirationDate; // 계산된 만료일

    private String daysLeft; // D-day 계산 결과 (예: D-100, D-99)

    // 수동으로 getter와 setter 추가
    // public int getCIdx() {
    // return cIdx;
    // }

    // public void setCIdx(int cIdx) {
    // this.cIdx = cIdx;
    // }

    // public String getCName() {
    // return cName;
    // }

    // public void setCName(String cName) {
    // this.cName = cName;
    // }

    // public int getDiscount() {
    // return discount;
    // }

    // public void setDiscount(int discount) {
    // this.discount = discount;
    // }

    // public String getDcType() {
    // return dcType;
    // }

    // public void setDcType(String dcType) {
    // this.dcType = dcType;
    // }
}
