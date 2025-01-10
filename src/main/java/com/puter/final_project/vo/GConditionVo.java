package com.puter.final_project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("gCondition")
public class GConditionVo {
    
    int jIdx;
    int gIdx;
    int bpAmount;
    int rCount;
}