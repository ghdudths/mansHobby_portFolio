package com.puter.final_project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.puter.final_project.vo.BuyListVo;
import com.puter.final_project.vo.DaddressVo;
import com.puter.final_project.vo.PImageVo;
import com.puter.final_project.vo.ProductVo;
import com.puter.final_project.vo.ShopVo;

@Mapper
public interface ShopMapper {
    
    // 게임카테고리 전체조회
    List<ShopVo> selectListGame(int categoryNo);
    
    // 스포츠카테고리 전체조회
    List<ProductVo> selectListSports(int categoryNo);

    List<Long> selectListGameP(int merchantUid);

    List<Long> selectListSportsP(int merchantUid);
    
    // 메인카테고리 번호만 조회
    int selectRowTotalSports(int categoryNo);
    
    List<ShopVo> selectMCategoryNameList(int categoryNo);
    
    List<ShopVo> selectMCategoryNoList(int categoryNo);
    
    int selectMCategoryNo(ShopVo shop);
    
    List<ShopVo> selectdCategoryNameList(int mCategoryNo);
    
    // int selectDCategoryNo(ShopVo shop);
    
    List<ProductVo> selectProductMCategoryList(int mCategoryNo);
    
    List<ProductVo> selectProductDCategoryList(int dCategoryNo);
    
    ShopVo selectProductInfoList(int categoryNo, int pIdx);

    List<PImageVo> selectAdminPImageList(int pIdx);
    
    List<ShopVo> selectAdminList();
    
    String selectPEx(int pIdx);

    int selectAdminCategoryNo(ShopVo shop);
    
    int selectAdminMcategoryNo(ShopVo shop);
    
    int selectAdminDcategoryNo(ShopVo shop);

    int selectMaxPIdx();

    int productInsert(ShopVo shop);

    int insertPImage(PImageVo pImage);

    int productUpdate(ShopVo shop);

    List<ShopVo> selectCategoryNameList();

    List<ShopVo> selectMcategoryNameList(String categoryName);

    List<ShopVo> selectDcategoryNameList(String mcategoryName);

    List<ShopVo> selectSearchList(ShopVo shop);

    List<ShopVo> selectCategoryList(ShopVo shop);

    List<ShopVo> selectCategorySearchList(ShopVo shop);

    List<ShopVo> selectMcategoryList(ShopVo shop);

    List<ShopVo> selectMcategorySearchList(ShopVo shop);

    List<ShopVo> selectDcategoryList(ShopVo shop);

    List<ShopVo> selectDcategorySearchList(ShopVo shop);

    List<PImageVo> selectPImageList(int pIdx);

    int deletePImageOne(int fileIdx);

    int pImageDelete(int pIdx);

    List<PImageVo> selectMaxPImageList(int pIdx);

    // 추가: pIdx로만 상품 정보 조회
    ShopVo selectProductInfoListById(int pIdx);


    // DB데이터추가용 
    List<ShopVo> DBMcategoryName(int categoryNo);

    String selectCategoryName(int categoryNo);

    int selectDcategoryNo(ShopVo shopVo);

    ProductVo selectFile(int pIdx);

    int selectCategoryNo(String categoryName);

    ProductVo selectProductSearch(int pIdx);

    // int selectFileIdx(int pIdx);

    // String selectFileLinkList(int pIdx);

    List<DaddressVo> selectDaAddrList(int userIdx);
    

    

}
