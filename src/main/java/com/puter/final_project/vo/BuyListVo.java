package com.puter.final_project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("buy")
public class BuyListVo {

    int bIdx;
    int userIdx;
    int pIdx;
    int bamount;
    String buyDate;
    long orderNumber;
    long buyPrice;
    int daIdx;
    String daAddr;
    String subDaAddr;

}
