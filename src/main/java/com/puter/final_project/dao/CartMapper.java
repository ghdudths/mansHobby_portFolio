package com.puter.final_project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.puter.final_project.vo.CartVo;

@Mapper
public interface CartMapper {

    List<CartVo> selectMyCart(int userIdx);

    int cartInsert(CartVo vo);

    void updateQuantity(int scIdx, int scamount);

    int cartDelete(int scIdx);

    int selectPIdx(int userIdx);
}
