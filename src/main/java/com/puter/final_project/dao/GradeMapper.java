package com.puter.final_project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.puter.final_project.vo.GConditionVo;
import com.puter.final_project.vo.GradeVo;

@Mapper
public interface  GradeMapper {

    List<GradeVo> selectList();

    GradeVo selectOne(int userIdx);

    GConditionVo selectGCodition(int gIdx);
    
}
