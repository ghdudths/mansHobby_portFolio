package com.puter.final_project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("like")
public class ReviewLikeVo {
    int rfIdx;
    int rvIdx;
    int userIdx;

    int pIdx;
    String rvContent;
    int reviewPoint;
    String rvImg;
    String rvDate;
    int likeCount;
}
