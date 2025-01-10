package com.puter.final_project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("product")
public class ProductVo {

    int pIdx;
    int categoryNo;
    int dcategoryNo;
    int mcategoryNo;
    String pName;
    String pEx;
    int amount;
    int price;

    int fileIdx;
    String fileName;
    String fileNameLink;

}
