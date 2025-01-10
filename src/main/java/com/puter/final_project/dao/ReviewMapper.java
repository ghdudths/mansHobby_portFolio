package com.puter.final_project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.puter.final_project.vo.ReviewLikeVo;
import com.puter.final_project.vo.ReviewVo;

@Mapper
public interface ReviewMapper {

    // 모든 리뷰 가져오기
    List<ReviewVo> selectList();

    // 특정 리뷰 조회
    ReviewVo getReviewByIdx(int rvIdx);

    ReviewVo getReviewByLike(ReviewLikeVo like);

    int selectMaxRvIdx();

    // 리뷰 작성
    int insertReview(ReviewVo review);

    // 리뷰 수정
    int updateReview(ReviewVo review);

    // 리뷰 삭제
    int deleteReview(int rvIdx);

    ReviewVo getReviewInfo(int rvIdx);

    // 특정 상품에 대한 리뷰 목록 조회
    List<ReviewVo> selectReviewsByProduct(int pIdx);

    // 리뷰 좋아요 추가
    int insertLike(ReviewLikeVo like);

    // 리뷰 좋아요 취소
    int deleteLike(ReviewLikeVo like);

    // 각 리뷰에 대한 좋아요 수
    int countLikes(int rvIdx);

    // 사용자가 특정 리뷰에 좋아요를 눌렀는지 확인
    int LikedByUser(ReviewLikeVo like);

    // 리뷰 삭제 시 해당 리뷰의 좋아요 삭제
    int deleteByReview(int rvIdx);

    // 리뷰 이미지 업로드
    int updateReviewImg(ReviewVo review);

    // 특정 사용자가 특정 상품을 구매했는지 확인
    int purchasedProduct(int userIdx, int pIdx);

}
