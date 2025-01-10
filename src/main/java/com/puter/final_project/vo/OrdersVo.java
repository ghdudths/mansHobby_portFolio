package com.puter.final_project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("orders")
public class OrdersVo {
    
    // Order, BuyList, DStatus, User, Product

    int oIdx;
    int dsIdx;
    int bIdx;
    String daStartDate;
    String daEndDate;
    String daAddr;
    String subDaAddr;

    int userIdx;
    int pIdx;
    int bamount;
    Long buyPrice;
    String buyDate;
    Long orderNumber;

    String dsContent;

    String name;

    String pName;
    int price;
    String categoryName;
    String mcategoryName;
    String dcategoryName;
}
