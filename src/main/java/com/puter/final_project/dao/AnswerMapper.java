package com.puter.final_project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.puter.final_project.vo.AnswerVo;

@Mapper
public interface AnswerMapper {

    // 전체 조회
    public List<AnswerVo> selectList(Map<String, Object> map);

    // 부분 조회
    public AnswerVo selectOne(int aIdx);

    // 댓글 추가
    public int answerInsert(AnswerVo vo);

    // 댓글 삭제
    public int answerDelete(int aIdx);


}
