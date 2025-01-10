package com.puter.final_project.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.puter.final_project.vo.AnswerVo;
import com.puter.final_project.vo.InquiryVo;

@Mapper
public interface InquiryMapper {

    List<InquiryVo> selectList();

    // 검색조건별 조회
    List<InquiryVo> selectByCondition(Map<String, String> map);

    // 게시글 추가
    public int inquiryInsert(InquiryVo vo);

    // 게시글 상세 조회
    public InquiryVo selectOne(int inIdx);

    public InquiryVo selectOneP(Integer pIdx);

    // 게시글 삭제
    public int delete(int inIdx);

    // 게시글 수정
    public int update(InquiryVo vo);

    public List<AnswerVo> inquiryAList();

    int nInsert(InquiryVo vo);

    public int nModify(InquiryVo vo);

    int nDelete(int inIdx);

    List<InquiryVo> selectNoticeList();

}
