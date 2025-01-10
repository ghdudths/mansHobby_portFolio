package com.puter.final_project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.puter.final_project.vo.UserVo;

@Mapper
public interface AdminMapper {

    List<UserVo> selectList();

    public int userUpdate(int userIdx);

    public int userDelete(int userIdx);

    List<UserVo> selectListUserView();

    List<UserVo> selectUsersById(String id);
}
