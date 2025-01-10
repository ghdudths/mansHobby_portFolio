package com.puter.final_project.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.puter.final_project.dao.AdminMapper;
import com.puter.final_project.dao.InquiryMapper;
import com.puter.final_project.dao.OrdersMapper;
import com.puter.final_project.dao.ProductMapper;
import com.puter.final_project.dao.ShopMapper;
import com.puter.final_project.vo.InquiryVo;
import com.puter.final_project.vo.OrdersVo;
import com.puter.final_project.vo.PImageVo;
import com.puter.final_project.vo.ShopVo;
import com.puter.final_project.vo.UserVo;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import net.minidev.json.JSONObject;

@Controller
@RequestMapping("/admin/")
public class AdminController {

    // 자동연결(요청시 마다 Injection)
    @Autowired
    HttpServletRequest request;

    @Autowired
    HttpSession session;

    @Autowired
    AdminMapper adminMapper;

    @Autowired
    OrdersMapper ordersMapper;

    @Autowired
    InquiryMapper inquiryMapper;

    @Autowired
    ProductMapper productMapper;

    @Autowired
    ShopMapper shopMapper;

    @Autowired
    ServletContext application;

    @RequestMapping("admin.do")
    public String list(@RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "searchText", required = false) String searchText,
            Model model) {

        UserVo user = (UserVo) session.getAttribute("user");
        if (user == null || "N".equals(user.getAdminAt())) {
            return "redirect:../home.do";
        }

        List<UserVo> list;
        if ("id".equals(searchType) && searchText != null && !searchText.isEmpty()) {
            // 아이디로 검색
            list = adminMapper.selectUsersById(searchText); // id로 검색
        } else {
            // 전체 보기
            list = adminMapper.selectListUserView();
        }

        List<ShopVo> pList = shopMapper.selectAdminList();
        List<ShopVo> categoryName = shopMapper.selectCategoryNameList();
        List<OrdersVo> buyList = ordersMapper.selectBuyList();
        List<InquiryVo> list2 = inquiryMapper.selectNoticeList();

        model.addAttribute("categoryName", categoryName);
        model.addAttribute("list", list);
        model.addAttribute("pList", pList);
        model.addAttribute("buyList", buyList);
        model.addAttribute("list2", list2);

        return "shopPage/adminMain";
    }

    @RequestMapping("adminCategoryAjax.do")
    @ResponseBody
    public List<ShopVo> adminCategoryAjax(String categoryName, String mcategoryName) {
        ShopVo shop = new ShopVo();
        int categoryNo = shopMapper.selectCategoryNo(categoryName);

        shop.setCategoryNo(categoryNo);
        shop.setMcategoryName(mcategoryName);
        if (categoryName != null && !categoryName.equals("전체보기")
                && mcategoryName == null) {
            List<ShopVo> mcategoryNameList = shopMapper.selectMcategoryNameList(categoryName);
            return mcategoryNameList;
        }

        if (mcategoryName != null && !mcategoryName.equals("선택 안 함")) {
            int mcategoryNo = shopMapper.selectMCategoryNo(shop);
            List<ShopVo> dcategoryNameList = shopMapper.selectdCategoryNameList(mcategoryNo);
            return dcategoryNameList;
        }

        return Collections.emptyList();
    }

    @RequestMapping("adminPListAjax.do")
    @ResponseBody
    public List<ShopVo> adminPListAjax(@RequestParam(defaultValue = "") String searchParam,
            @RequestParam(defaultValue = "") String categoryName,
            @RequestParam(defaultValue = "") String mcategoryName,
            @RequestParam(defaultValue = "") String dcategoryName) {

        ShopVo shop = new ShopVo();
        shop.setPName(searchParam);
        shop.setCategoryName(categoryName);
        shop.setMcategoryName(mcategoryName);
        shop.setDcategoryName(dcategoryName);

        if (categoryName.equals("전체보기")) {
            List<ShopVo> productList = shopMapper.selectAdminList();
            return productList;
        } else if (!categoryName.equals("")) {
            int categoryNo = shopMapper.selectAdminCategoryNo(shop);
            shop.setCategoryNo(categoryNo);
            if (!mcategoryName.equals("")) {
                int mcategoryNo = shopMapper.selectAdminMcategoryNo(shop);
                shop.setMcategoryNo(mcategoryNo);
                if (!dcategoryName.equals("")) {
                    int dcategoryNo = shopMapper.selectAdminDcategoryNo(shop);
                    shop.setDcategoryNo(dcategoryNo);
                }
            }
        }

        // 검색어(상품명)만 입력한 경우
        if (categoryName.equals("")) {
            List<ShopVo> searchList = shopMapper.selectSearchList(shop);
            return searchList;
        }

        // 대분류만 검색한 경우
        if (!categoryName.equals("") && searchParam.equals("") && mcategoryName.equals("")) {
            List<ShopVo> categoryList = shopMapper.selectCategoryList(shop);
            return categoryList;
        }

        // 대분류와 검색어(상품명)를 검색한 경우
        if (!categoryName.equals("") && !searchParam.equals("") && mcategoryName.equals("")) {
            List<ShopVo> categorySearchList = shopMapper.selectCategorySearchList(shop);
            return categorySearchList;
        }

        // 중분류를 검색한 경우
        if (!mcategoryName.equals("") && searchParam.equals("") && dcategoryName.equals("")) {
            List<ShopVo> mcategorySearchList = shopMapper.selectMcategoryList(shop);
            return mcategorySearchList;
        }

        // 중분류와 검색어(상품명)를 검색한 경우
        if (!mcategoryName.equals("") && !searchParam.equals("") && dcategoryName.equals("")) {
            List<ShopVo> mcategorySearchList = shopMapper.selectMcategorySearchList(shop);
            return mcategorySearchList;
        }

        // 소분류만 검색한 경우
        if (!dcategoryName.equals("") && searchParam.equals("")) {
            List<ShopVo> dcategoryList = shopMapper.selectDcategoryList(shop);
            return dcategoryList;
        }

        // 소분류와 검색어(상품명)를 검색한 경우
        if (!dcategoryName.equals("") && !searchParam.equals("")) {
            List<ShopVo> dcategorySearchList = shopMapper.selectDcategorySearchList(shop);
            return dcategorySearchList;
        }

        return Collections.emptyList(); // 그냥 리턴 적으려고 쓴 코드 실제로 작동안함
    }

    @RequestMapping("delete.do")
    public String delete(int userIdx) {
        int res = adminMapper.userDelete(userIdx);

        if (res > 0) {
            session.setAttribute("alertMsg", "탈퇴되었습니다.");
        } else {
            session.setAttribute("alertMsg", "탈퇴 실패했습니다.");
        }

        return "redirect:admin.do";
    }

    @RequestMapping("pDelete.do")
    public String pDelete(int pIdx) {
        int res = productMapper.pDelete(pIdx);
        int res2 = shopMapper.pImageDelete(pIdx);
        return "redirect:admin.do";
    }

    @RequestMapping("pInsertForm.do")
    public String pInsertForm(ShopVo shop, Model model) {

        // int maxPIdx = shopMapper.selectMaxPIdx();
        List<ShopVo> categoryName = shopMapper.selectCategoryNameList();
        List<ShopVo> mcategoryName = shopMapper.selectMcategoryNameList(shop.getCategoryName());
        List<ShopVo> dcategoryName = shopMapper.selectDcategoryNameList(shop.getMcategoryName());
        // model.addAttribute("maxPIdx", maxPIdx+1);
        model.addAttribute("categoryName", categoryName);
        model.addAttribute("mcategoryName", mcategoryName);
        model.addAttribute("dcategoryName", dcategoryName);
        model.addAttribute("shop", shop);
        return "shopPage/pInsertForm";
    }

    @PostMapping("pInsert.do")
    public String pInsert(ShopVo shop, Model model, List<MultipartFile> photo) throws Exception {
        int categoryNo = shopMapper.selectCategoryNo(shop.getCategoryName());
        shop.setCategoryNo(categoryNo);
        int mcategoryNo = shopMapper.selectMCategoryNo(shop);
        shop.setMcategoryNo(mcategoryNo);
        int dcategoryNo = shopMapper.selectDcategoryNo(shop);
        shop.setDcategoryNo(dcategoryNo);
        int res = shopMapper.productInsert(shop);

        List<String> filename_list = new ArrayList<String>();

        String absPath = application.getRealPath("/resources/images/");

        for (MultipartFile photoOne : photo) {
            if (!photoOne.isEmpty()) {
                String filename = photoOne.getOriginalFilename();

                filename = photoOne.getOriginalFilename();

                File f = new File(absPath, filename);

                if (f.exists()) {// 동일한 파일이 존재하냐?

                    // 시간_파일명 이름변경
                    long tm = System.currentTimeMillis();
                    filename = String.format("%d_%s", tm, filename);

                    f = new File(absPath, filename);
                }

                // spring이 저장해놓은 임시파일을 복사한다.
                photoOne.transferTo(f);

                filename_list.add(filename);
            }
        }

        int pIdx = shopMapper.selectMaxPIdx();

        PImageVo pImageVo = new PImageVo();

        for (int i = 0; i < filename_list.size(); i++) {
            String filename = filename_list.get(i);
            pImageVo.setPIdx(pIdx);
            pImageVo.setFileName(filename);
            pImageVo.setFileNameLink("N");
            shopMapper.insertPImage(pImageVo);
        }
        return "redirect:admin.do";
    }

    @RequestMapping("pUpdateForm.do")
    public String pUpdateForm(ShopVo shop, Model model) {

        String pEx = shopMapper.selectPEx(shop.getPIdx());

        List<ShopVo> categoryName = shopMapper.selectCategoryNameList();
        List<ShopVo> mcategoryName = shopMapper.selectMcategoryNameList(shop.getCategoryName());
        List<ShopVo> dcategoryName = shopMapper.selectDcategoryNameList(shop.getMcategoryName());
        List<PImageVo> pImageList = shopMapper.selectPImageList(shop.getPIdx());

        model.addAttribute("pImageList", pImageList);
        model.addAttribute("categoryName", categoryName);
        model.addAttribute("mcategoryName", mcategoryName);
        model.addAttribute("dcategoryName", dcategoryName);
        model.addAttribute("shop", shop);
        model.addAttribute("pEx", pEx);

        return "shopPage/pUpdateForm";
    }

    @RequestMapping("pUpdate.do")
    public String pUpdate(ShopVo shop, Model model, List<MultipartFile> photo) throws Exception {

        int categoryNo = shopMapper.selectAdminCategoryNo(shop);
        int mcategoryNo = shopMapper.selectAdminMcategoryNo(shop);
        int dcategoryNo = shopMapper.selectAdminDcategoryNo(shop);

        shop.setCategoryNo(categoryNo);
        shop.setMcategoryNo(mcategoryNo);
        shop.setDcategoryNo(dcategoryNo);

        model.addAttribute(shopMapper.productUpdate(shop));

        List<String> filename_list = new ArrayList<String>();

        String absPath = application.getRealPath("/resources/images/");

        for (MultipartFile photoOne : photo) {
            if (!photoOne.isEmpty()) {
                String filename = photoOne.getOriginalFilename();

                filename = photoOne.getOriginalFilename();

                File f = new File(absPath, filename);

                if (f.exists()) {// 동일한 파일이 존재하냐?

                    // 시간_파일명 이름변경
                    long tm = System.currentTimeMillis();
                    filename = String.format("%d_%s", tm, filename);

                    f = new File(absPath, filename);
                }

                // spring이 저장해놓은 임시파일을 복사한다.
                photoOne.transferTo(f);

                filename_list.add(filename);
            }
        }

        int pIdx = shopMapper.selectMaxPIdx();

        PImageVo pImageVo = new PImageVo();

        for (int i = 0; i < filename_list.size(); i++) {
            String filename = filename_list.get(i);
            pImageVo.setPIdx(pIdx);
            pImageVo.setFileName(filename);
            pImageVo.setFileNameLink("N");
            shopMapper.insertPImage(pImageVo);
        }

        return "redirect:admin.do";
    }

    @RequestMapping("nInsertForm.do")
    public String nInsertForm() {

        return "shopPage/nInsertForm";
    }

    @RequestMapping("nInsert.do")
    public String nInsert(InquiryVo inquiry) throws Exception {

        UserVo user = (UserVo) session.getAttribute("user");
        inquiry.setUserIdx(user.getUserIdx());
        int res = inquiryMapper.nInsert(inquiry);

        return "redirect:admin.do";
    }

    @RequestMapping("nModifyForm.do")
    public String nModifyForm(int inIdx, Model model) {

        InquiryVo vo = inquiryMapper.selectOne(inIdx);

        model.addAttribute("vo", vo);

        return "shopPage/nModifyForm";
    }

    @RequestMapping("nModify.do")
    public String nModify(InquiryVo vo) {

        int res = inquiryMapper.nModify(vo);

        return "redirect:admin.do";
    }

    @RequestMapping("nDelete.do")
    public String confirmNoticeDelete(int inIdx) {

        int res = inquiryMapper.nDelete(inIdx);

        return "redirect:admin.do";
    }

    @RequestMapping("pImageDelete.do")
    @ResponseBody
    public List<PImageVo> pImageDelete(PImageVo pImage) {

        int res = shopMapper.deletePImageOne(pImage.getFileIdx());
        // 선택한 사진을 지운 후 남은 사진들의 리스트
        List<PImageVo> deleteAfterList = shopMapper.selectPImageList(pImage.getPIdx());
        return deleteAfterList;
    }

    @PostMapping(value = "cancel", produces = "application/json; charset=UTF-8")
    public ResponseEntity<String> cancelPay(@RequestBody Map<String, Object> requestData) {

        System.out.println("requestData: " + requestData);
        Long merchantUid = Long.valueOf(requestData.get("merchant_uid").toString());
        Long cancelRequestAmount = Long.valueOf(requestData.get("cancel_request_amount").toString());
        String reason = requestData.get("reason").toString(); // reason에서 환불 사유를 가져옴
        int bIdx = extractBIdxFromReason(reason); // reason에서 bIdx 추출

        // 포트원 API Key 및 Secret 설정
        String impKey = "3672717442038407";
        String impSecret = "Z0zCEcoGYox8ODy9Ukpd7UGdNg7D9meXKi9zItAoyhwSE2eeCfu98edzsHRTEpxRmjmju70Ot8pa0oD8";

        // 토큰 발급 URL 및 환불 요청 URL
        String tokenUrl = "https://api.iamport.kr/users/getToken";
        String cancelUrl = "https://api.iamport.kr/payments/cancel";

        // ObjectMapper 및 RestTemplate 객체 생성
        ObjectMapper objectMapper = new ObjectMapper();
        RestTemplate restTemplate = new RestTemplate();

        // 토큰 발급 요청
        String accessToken = "";
        try {
            // 포트원 REST API Key 및 Secret 설정
            JsonNode requestNode = objectMapper.createObjectNode()
                    .put("imp_key", impKey)
                    .put("imp_secret", impSecret);

            // JSON 데이터 문자열로 변환
            String requestJson = objectMapper.writeValueAsString(requestNode);

            // 토큰 발급을 위한 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            // 엔터티 설정
            HttpEntity<String> entity = new HttpEntity<>(requestJson, headers);

            // 토큰 발급 요청 전송
            ResponseEntity<String> response = restTemplate.exchange(tokenUrl, HttpMethod.POST, entity, String.class);

            // 응답 JSON 파싱하여 access_token 추출
            JsonNode tokenResponse = objectMapper.readTree(response.getBody());
            accessToken = tokenResponse.path("response").path("access_token").asText();
            System.out.println("발급된 Access Token: " + accessToken);

        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("토큰 발급 실패", HttpStatus.INTERNAL_SERVER_ERROR);
        }

        // 발급된 토큰을 이용하여 결제 취소 API 호출
        try {
            // 환불 요청 데이터 설정
            JSONObject cancelRequest = new JSONObject();
            cancelRequest.put("reason", "테스트 결제 환불"); // 환불 사유
            cancelRequest.put("merchant_uid", merchantUid); // 환불하려는 결제의 merchant_uid
            cancelRequest.put("amount", cancelRequestAmount); // 환불 요청 금액
            cancelRequest.put("checksum", cancelRequestAmount); // [권장] 환불 가능 금액 입력

            // 환불 요청 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", accessToken);

            // 환불 요청 엔터티 설정
            HttpEntity<String> cancelEntity = new HttpEntity<>(cancelRequest.toString(), headers);

            // 환불 요청 전송
            ResponseEntity<String> cancelResponse = restTemplate.exchange(cancelUrl, HttpMethod.POST, cancelEntity,
                    String.class);

                    // 응답 JSON 파싱
            JsonNode responseJson = objectMapper.readTree(cancelResponse.getBody());
            System.out.println("환불 요청 결과: " + responseJson.toString());

            // 환불 요청 결과 처리
            if (responseJson.path("code").asInt() == 0) {
                // 성공 시 주문 삭제
                ordersMapper.deleteBuyList(bIdx);
                return new ResponseEntity<>(responseJson.toString(), HttpStatus.OK);
            } else {
                return new ResponseEntity<>(responseJson.toString(), HttpStatus.BAD_REQUEST);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("환불 요청 실패", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    // reason에서 bIdx 추출하는 메소드
    private int extractBIdxFromReason(String reason) {
        // 예시: "환불 사유: 123" 형식으로 되어 있으므로, ':' 뒤의 값을 추출
        String[] parts = reason.split(":");
        if (parts.length > 1) {
            return Integer.parseInt(parts[1].trim()); // bIdx를 정수로 변환
        }
        throw new IllegalArgumentException("잘못된 환불 사유 형식입니다.");
    }
}
