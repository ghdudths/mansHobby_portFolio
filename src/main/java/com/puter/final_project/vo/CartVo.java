package com.puter.final_project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("cart")
public class CartVo {
    
    int scIdx;
    int userIdx;
    int pIdx;
    int scamount;

    int categoryNo;
    int dcategoryNo;
    int mcategoryNo;
    String pName;
    String pEx;
    int price;

}
