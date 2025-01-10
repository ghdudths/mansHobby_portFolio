package com.puter.final_project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("pImage")
public class PImageVo {
    public PImageVo(String fileName) {
        //TODO Auto-generated constructor stub
    }

    public PImageVo() {}
    int fileIdx;
    int pIdx;
    String fileName;
    String fileNameLink;
}
