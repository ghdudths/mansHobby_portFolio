package com.puter.final_project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.puter.final_project.vo.OrdersVo;

@Mapper
public interface OrdersMapper {

    List<OrdersVo> selectList(int userIdx);

    List<OrdersVo> selectBuyList();

    void deleteBuyList(int bIdx);
    
}