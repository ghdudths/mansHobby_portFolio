package com.puter.final_project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("review")
public class ReviewVo {

    int rvIdx;
    int pIdx;
    int userIdx;
    String rvContent;
    int reviewPoint;
    String rvImg;
    String rvDate;
    int likeCount;

    int gIdx;
    String id;
    String password;
    String nickName;
    String name;
    String phone;
    String addr;
    String subAddr;
    String adminAt;
    int point;
    String createAt;

    int rfIdx;
    
}
