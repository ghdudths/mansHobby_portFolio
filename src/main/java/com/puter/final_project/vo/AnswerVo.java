package com.puter.final_project.vo;
import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("answer")
public class AnswerVo {

    int aIdx;
    int inIdx;
    int userIdx;
    String aContent;
    String aDate;

    String name;
    String adminAt;
}
