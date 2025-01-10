package com.puter.final_project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("userActivity")
public class UserActivityVo {
    int userActivityId;
    int userIdx;
    long totalPurchaseAmount;
    long totalReviewCount;
    String lastUpdated;
}
