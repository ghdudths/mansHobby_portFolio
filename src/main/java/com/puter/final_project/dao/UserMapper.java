package com.puter.final_project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.puter.final_project.vo.UserVo;

@Mapper
public interface UserMapper {

    List<UserVo> selectList();

    // id 에 해당되는 1건의 정보 얻어온다
    public UserVo selectOneFromId(String id);

    // email에 대한 유저 검색
    public UserVo selectOneFromEmail(String email, String esite);

    // 사용자 추가
    public int insert(UserVo vo);

    // 이메일 추가
    public int emailInsert(UserVo vo);

    int userModify(UserVo vo);


    // 아래부터 비밀번호찾기

    Integer selectNameIdUserIdx(UserVo vo);

    int selectEmailUserIdx(UserVo vo);

    List<UserVo> selectEmailList(int userIdx);

    String selectId(UserVo vo);

    String selectPwd(UserVo vo);

    // 여기까지 비밀번호 찾기
}
