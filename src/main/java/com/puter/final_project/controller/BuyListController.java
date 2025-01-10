package com.puter.final_project.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.puter.final_project.dao.BuyListMapper;
import com.puter.final_project.dao.CartMapper;
import com.puter.final_project.dao.CouponBoxMapper;
import com.puter.final_project.dao.UserActivityMapper;
import com.puter.final_project.vo.BuyListVo;
import com.puter.final_project.vo.UserActivityVo;
import com.puter.final_project.vo.UserVo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import net.minidev.json.JSONObject;

@Controller
@RequestMapping("/buyList/")
public class BuyListController {

    @Autowired
    HttpServletRequest request;

    @Autowired
    HttpSession session;

    @Autowired
    BuyListMapper buyListMapper;

    @Autowired
    CartMapper cartMapper;

    @Autowired
    UserActivityMapper userActivityMapper;

    @Autowired
    CouponBoxMapper couponBoxMapper;

    @PostMapping(value = "/buy.do", produces = "application/json; charset=utf-8")
    public String buy(BuyListVo vo, @RequestParam(value = "couponid", required = false) Integer couponid) {
        // 디버깅 로그 추가
        System.out.println("BuyListVo: " + vo);
        System.out.println("Received couponid: " + couponid);
        System.out.println(vo.getDaIdx());

        UserActivityVo userActVo = new UserActivityVo();
        userActVo.setUserIdx(vo.getUserIdx());
        userActVo.setTotalPurchaseAmount(vo.getBuyPrice());

        String daAddr = buyListMapper.selectDaAddr(vo.getDaIdx());
        String subDaAddr = buyListMapper.selectSubDaAddr(vo.getDaIdx());
        vo.setSubDaAddr(subDaAddr);
        vo.setDaAddr(daAddr);
        System.out.println(vo);
        int res = buyListMapper.insert(vo);

        buyListMapper.updateAmount(vo);

        int bIdx = buyListMapper.selectBuyListOne(vo);

        res = buyListMapper.orderInsert(bIdx);
        res = userActivityMapper.updateTotalBuyPlus(userActVo);
        res = userActivityMapper.callUpdateUserGrade(userActVo.getUserIdx());

        if (res > 0) {
            // 쿠폰 사용 처리: couponid가 있을 경우 N -> Y로 업데이트
            if (couponid != null && couponid != 0) {
                System.out.println("업데이트 시도하려는 couponid: " + couponid);
                int updateRes = couponBoxMapper.updateCouponUsage(couponid);
                if (updateRes > 0) {
                    System.out.println("Coupon successfully updated to 'Y'.");
                } else {
                    System.out.println("Coupon update failed.");
                }
            } else {
                System.out.println("No couponid provided or couponid is 0.");
            }

            session.setAttribute("alertMsg", "결제 완료 되었습니다!");

            UserVo user = (UserVo) session.getAttribute("user");
            user = buyListMapper.selectOne(user.getUserIdx());

            session.setAttribute("user", user);

            // {"result" : true}
            String json = String.format("{\"result\" : %d}", res);

            return json;

        } else {

            session.setAttribute("alertMsg", "결제에 실패했습니다!");
            return "redirect:home.do";
        }

    }

    @PostMapping(value = "cartBuy.do", produces = "application/json; charset=utf-8")
    public String cartBuy(BuyListVo vo, @RequestParam(value = "pIdxList") List<Integer> pIdxList, @RequestParam(value = "bamountList") List<Integer> bamountList, @RequestParam(value = "scIdxList") List<Integer> scIdxList ) {

        UserActivityVo userActVo = new UserActivityVo();
        userActVo.setUserIdx(vo.getUserIdx());
        userActVo.setTotalPurchaseAmount(vo.getBuyPrice());

        int res = 0;
        int bIdx = 0;

        for (int i = 0; i < pIdxList.size(); i++){
            vo.setPIdx(pIdxList.get(i));
            vo.setBamount(bamountList.get(i));
            vo.setBuyPrice(buyListMapper.selectOnePrice(pIdxList.get(i)) * vo.getBamount());
            res = buyListMapper.insert(vo);
            buyListMapper.updateAmount(vo);
            bIdx = buyListMapper.selectBuyListOne(vo);
            res = buyListMapper.orderInsert(bIdx);
            cartMapper.cartDelete(scIdxList.get(i));
        }
        
        
        userActivityMapper.updateTotalBuyPlus(userActVo);
        userActivityMapper.callUpdateUserGrade(userActVo.getUserIdx());
        if (res > 0) {
            session.setAttribute("alertMsg", "결제 완료 되었습니다!");

            // {"result" : true}
            String json = String.format("{\"result\" : %d}", res);
            return json;

        } else {
            session.setAttribute("alertMsg", "결제에 실패했습니다!");
            return "redirect:../home.do";
        }

    }

    @RequestMapping(value = "/cancel.do", produces = "application/json; charset=utf-8")
    public String cancelPay(BuyListVo vo) {

        // //토큰 발급을 위해 아임포트에서 제공해주는 rest api 사용.(gradle로 의존성 추가)
        // private final IamportClient iamportClientApi;

        // //생성자로 rest api key와 secret을 입력해서 토큰 바로생성.
        // public PaymentsApiController() {
        // this.iamportClientApi = new IamportClient("3672717442038407",
        // "Z0zCEcoGYox8ODy9Ukpd7UGdNg7D9meXKi9zItAoyhwSE2eeCfu98edzsHRTEpxRmjmju70Ot8pa0oD8");
        // }

        // try {
        // // 환불 요청 정보 받기
        // String merchant_uid = refundRequest.getMerchantUid();
        // String reason = refundRequest.getReason();
        // int cancel_request_amount = refundRequest.getCancelRequestAmount();

        // // 결제 정보 조회 (DB)
        // BuyListVo payment = buyListMapper.findByMerchantUid(merchant_uid);
        // if (payment == null) {
        // return new ResponseEntity<>("결제 정보를 찾을 수 없습니다.", HttpStatus.NOT_FOUND);
        // }

        // // 환불 가능 금액 계산
        // int cancelableAmount = payment.getAmount() - payment.getCancelAmount();
        // if (cancelableAmount <= 0) {
        // return new ResponseEntity<>("이미 전액환불된 주문입니다.", HttpStatus.BAD_REQUEST);
        // }

        // // 포트원 Access Token 발급
        // String access_token = portOneService.getPortOneAccessToken();

        // // 환불 요청 API 호출
        // RestTemplate restTemplate = new RestTemplate();
        // JSONObject requestBody = new JSONObject();
        // requestBody.put("reason", reason);
        // requestBody.put("imp_uid", payment.getImpUid());
        // requestBody.put("amount", cancel_request_amount);
        // requestBody.put("checksum", cancelableAmount);

        // HttpHeaders headers = new HttpHeaders();
        // headers.set("Authorization", access_token);
        // headers.set("Content-Type", "application/json");

        // HttpEntity<String> entity = new HttpEntity<>(requestBody.toString(),
        // headers);
        // ResponseEntity<String> cancelResponse =
        // restTemplate.postForEntity("https://api.iamport.kr/payments/cancel",
        // entity, String.class);

        // // 환불 성공 시 DB 업데이트
        // if (cancelResponse.getStatusCode().is2xxSuccessful()) {
        // payment.setCancelAmount(payment.getCancelAmount() + cancel_request_amount);
        // buyListMapper.updatePayment(payment);
        // return new ResponseEntity<>("환불 성공", HttpStatus.OK);
        // } else {
        // return new ResponseEntity<>("환불 요청 실패", HttpStatus.BAD_REQUEST);
        // }

        // } catch (Exception e) {
        // e.printStackTrace();
        // return new ResponseEntity<>("환불 처리 중 오류 발생: " + e.getMessage(),
        // HttpStatus.INTERNAL_SERVER_ERROR);
        // }
        return "";
    }

}
