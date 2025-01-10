package com.puter.final_project.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.puter.final_project.dao.CartMapper;
import com.puter.final_project.dao.ShopMapper;
import com.puter.final_project.vo.ShopVo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import net.minidev.json.JSONObject;

@Controller
public class PaymentControllor {

    @Autowired
    HttpServletRequest request;

    @Autowired
    HttpSession session;

    @Autowired
    CartMapper cartMapper;

    @Autowired
    ShopMapper shopMapper;

    // 최종 결제 금액
    @PostMapping("/user/updateQuantity1")
    @ResponseBody
    public ResponseEntity<Map<String, String>> updateQuantity() {

        Map<String, String> response = new HashMap<>();
        response.put("message", "수량이 성공적으로 업데이트되었습니다.");
        return ResponseEntity.ok(response);
    }

    @PostMapping(value = "/payments/prepare", produces = "application/json; charset=UTF-8")
    public ResponseEntity<String> prepare(@RequestBody ShopVo shopVo) {

        // 포트원 API Key 및 Secret 설정
        String impKey = "3672717442038407";
        String impSecret = "Z0zCEcoGYox8ODy9Ukpd7UGdNg7D9meXKi9zItAoyhwSE2eeCfu98edzsHRTEpxRmjmju70Ot8pa0oD8";

        // 토큰 발급 URL 및 사전 검증 요청 URL
        String tokenUrl = "https://api.iamport.kr/users/getToken";
        String prepareUrl = "https://api.iamport.kr/payments/prepare";

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

        try {
            // DTO에서 merchantUid와 amount를 가져옵니다.
            long merchantUid = shopVo.getPIdx(); // merchant_uid를 PIdx로 사용한다고 가정
            int amount = shopVo.getPrice(); // 가격을 결제 금액으로 사용
    
            // 사전 검증 요청 데이터 생성
            JsonNode prepareNode = objectMapper.createObjectNode()
                    .put("merchant_uid", merchantUid) // 가맹점 주문번호
                    .put("amount", amount); // 결제 금액
    
            // 사전 검증 요청 JSON 변환
            String prepareJson = objectMapper.writeValueAsString(prepareNode);
    
            // 사전 검증을 위한 헤더 설정 (발급된 토큰 추가)
            HttpHeaders prepareHeaders = new HttpHeaders();
            prepareHeaders.setContentType(MediaType.APPLICATION_JSON);
            prepareHeaders.setBearerAuth(accessToken); // Authorization: Bearer {accessToken}
    
            // 엔터티 설정 (사전 검증 요청용)
            HttpEntity<String> prepareEntity = new HttpEntity<>(prepareJson, prepareHeaders);
    
            // 사전 검증 요청 전송
            ResponseEntity<String> prepareResponse = restTemplate.exchange(prepareUrl, HttpMethod.POST, prepareEntity, String.class);
    
            // 사전 검증 응답 출력 (성공 시)
            System.out.println("사전 검증 성공: " + prepareResponse.getBody());
    
            // 응답 결과에 따라 추가 처리 가능
            return new ResponseEntity<>("사전 검증 및 요청 성공", HttpStatus.OK);
    
        } catch (Exception e) {
            // 기타 서버 오류 처리
            return new ResponseEntity<>("서버 오류 발생", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // @PostMapping(value = "/api/iamport/token", produces = "application/json; charset=UTF-8")
    // public ResponseEntity<String> getToken() {
    //     // 포트원 API URL 및 헤더 설정
    //     String url = "https://api.iamport.kr/users/getToken";
    //     HttpHeaders headers = new HttpHeaders();
    //     headers.setContentType(MediaType.APPLICATION_JSON);

    //     // 포트원 REST API Key 및 Secret 설정
    //     JSONObject request = new JSONObject();
    //     request.put("imp_key", "3672717442038407");
    //     request.put("imp_secret", "Z0zCEcoGYox8ODy9Ukpd7UGdNg7D9meXKi9zItAoyhwSE2eeCfu98edzsHRTEpxRmjmju70Ot8pa0oD8");

    //     HttpEntity<String> entity = new HttpEntity<>(request.toString(), headers);

    //     // RestTemplate을 이용해 포트원 서버에 요청
    //     RestTemplate restTemplate = new RestTemplate();
    //     ResponseEntity<String> response = restTemplate.postForEntity(url, entity, String.class);

    //     // 서버 응답 반환
    //     return ResponseEntity.ok(response.getBody());
    // }

    // @GetMapping(value = "/api.iamport.kr/payments/{imp_uid}", produces = "application/json; charset=UTF-8")
    // public ResponseEntity<String> getPayments(@PathVariable String imp_uid) {
    //     // 포트원 API URL 및 헤더 설정
    //     String url = "https://api.iamport.kr/payments/" + imp_uid; // imp_uid를 URL에 포함
    //     HttpHeaders headers = new HttpHeaders();
    //     headers.setContentType(MediaType.APPLICATION_JSON);

    //     HttpEntity<String> entity = new HttpEntity<>(headers);

    //     // RestTemplate을 이용해 포트원 서버에 요청
    //     RestTemplate restTemplate = new RestTemplate();
    //     ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);

    //     // 서버 응답 반환
    //     return ResponseEntity.ok(response.getBody());
    // }

}
