package com.puter.final_project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.puter.final_project.vo.BuyListVo;
import com.puter.final_project.vo.UserVo;

@Mapper
public interface BuyListMapper {

    public int insert(BuyListVo vo);

    public UserVo selectOne(int userIdx);

    public int selectBuyListOne(BuyListVo vo);

    public int orderInsert(int bIdx);

    public List<BuyListVo> selectBuyList();

    public String selectDaAddr(int daIdx);

    public String selectSubDaAddr(int daIdx);

    // 재고수량 업데이트
    public int updateAmount(BuyListVo vo);

    int purchasedProduct(BuyListVo vo);
    
    public int selectOnePrice(int pIdx);

}
