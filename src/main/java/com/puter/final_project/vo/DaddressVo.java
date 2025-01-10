package com.puter.final_project.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("daddress")
public class DaddressVo {

    int daIdx;
    int userIdx;
    String daAddr;
    String subDaAddr;

}
