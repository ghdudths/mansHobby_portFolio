package com.puter.final_project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.puter.final_project.vo.UserActivityVo;

@Mapper
public interface UserActivityMapper {

    List<UserActivityVo> selectList();
    
    int updateTotalBuyPlus(UserActivityVo vo);

    int updateTotalBuyMinus(UserActivityVo vo);

    int updateTotalReviewPlus(int userIdx);

    int updateTotalReviewMinus(int userIdx);

    int callUpdateUserGrade(int userIdx);
}
