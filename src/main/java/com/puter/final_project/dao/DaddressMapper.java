package com.puter.final_project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.puter.final_project.vo.DaddressVo;

@Mapper
public interface DaddressMapper {
    
    List<DaddressVo> selectDaddressUser(int userIdx);

    int insertDaddress(DaddressVo daddress);

    int updateDaddress(DaddressVo daddress);

    int deleteDaddress(int daIdx);
}
