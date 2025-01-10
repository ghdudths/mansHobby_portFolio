<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8" />
    <title>MansHobby</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/payment.css" />
    <!-- jQuery -->
    <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <!-- iamport.payment.js -->
    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

    <script type="text/javascript">
        var IMP = window.IMP;
        IMP.init("imp33361271");

        var merchant_uid = new Date().getTime() + 0; // 고유한 주문번호 생성

        var bamount = document.getElementById('scamount').value || 1; // 수량 받아오기
        console.log("1" + bamount);

        var originalPrice = parseFloat("${shop.getPrice()}"); // 상품 원래 가격을 숫자로 변환
        var couponDiscount = 0; // 처음에는 쿠폰 할인이 0으로 설정
        var finalPrice = originalPrice - couponDiscount; // 쿠폰 적용 후 가격
        var price = parseFloat("${shop.getPrice()}");

        function applyCoupon() {
            var couponSelect = document.getElementById('coupon');
            var selectedOption = couponSelect.options[couponSelect.selectedIndex];
            var couponType = selectedOption.getAttribute("data-type"); // 쿠폰 타입 ('-' 또는 '%')
            var discountValue = parseFloat(selectedOption.getAttribute("data-discount")); // 쿠폰 할인 값
            var couponid = selectedOption.value; // cbidx (쿠폰 ID)

            var quantity = parseInt(document.querySelector('input[type="number"]').value);
            bamount = quantity;

            var finalPrice = price;

            // 할인 적용
            if (couponType === '-') { // 금액 할인일 경우
                couponDiscount = discountValue;
                finalPrice = originalPrice * bamount - couponDiscount;
            } else if (couponType === '%') { // 퍼센트 할인일 경우
                couponDiscount = originalPrice * bamount * (discountValue / 100);
                console.log("applyCoupon에서 price : " + price);
                finalPrice = originalPrice * bamount - couponDiscount;
            }

            // 최종 금액이 0원 이하일 경우 0원으로 설정
            if (finalPrice < 0) {
                finalPrice = 0;
            }

            // 할인 금액 및 최종 결제 금액 표시 업데이트
            document.getElementById('discountAmount').textContent = couponDiscount.toLocaleString(); // 할인 금액
            document.getElementById('finalPrice').textContent = finalPrice.toLocaleString(); // 최종 금액

            console.log("Selected couponid: " + couponid);
            console.log("Updated Coupon Discount: " + couponDiscount);
            console.log("Updated Final Price: " + finalPrice);
        }

        // 쿠폰 비활성화 여부 체크
        function checkCouponValidity() {
            var couponOptions = document.querySelectorAll("#coupon option");

            couponOptions.forEach(function (option) {
                var discountValue = parseFloat(option.getAttribute("data-discount"));
                var couponType = option.getAttribute("data-type");

                var couponDiscount = 0;

                // 할인 계산
                if (couponType === '-') { // 금액 할인일 경우
                    couponDiscount = discountValue;
                } else if (couponType === '%') { // 퍼센트 할인일 경우
                    couponDiscount = bamount * price * (discountValue / 100);
                    console.log("checkCouponValidity에서 couponDiscount : " + couponDiscount);
                }

                // 금액이 상품 가격보다 크면 적용 불가로 표시
                if (couponDiscount >= price && option.value !== "0") {
                    option.disabled = true; // 비활성화
                    option.textContent += " (적용 불가)";
                }
            });
        }

        // 쿠폰이 없을 때 선택 박스 기본 메시지 설정
        function setDefaultCouponMessage() {
            var couponSelect = document.getElementById('coupon');
            if (couponSelect.options.length <= 1) { // 쿠폰이 없을 때 기본 메시지
                var defaultOption = document.createElement('option');
                defaultOption.text = "사용 가능한 쿠폰이 없습니다";
                defaultOption.value = "0";
                couponSelect.add(defaultOption);
                couponSelect.disabled = true; // 선택 불가하게 만듦
            }
        }

        // 페이지 로드 후 쿠폰 비활성화 여부와 기본 메시지 설정
        window.onload = function () {
            checkCouponValidity();
            setDefaultCouponMessage();
        };

        function requestPay() {

            // 로그인이 안되었으면
            if ("${ empty user }" == "true") {
                if (confirm("로그인 후 충전이 가능합니다.\n로그인 하시겠습니까?") == true) {
                    // 로그인 모달창을 띄웁니다.
                    loginModal.style.display = "flex";

                }
                return;
            }

            let daAddr = $("#address").val();

            if (daAddr == 'none') {
                alert("배송지를 선택해주세요!");
                return;
            }

            let amount = "${ shop.getAmount() }";
            let scamount = $("#scamount").val();
            if (amount - scamount < 0) {
                alert("재고수량이 부족합니다.");
                return;
            }

            IMP.request_pay({
                pg: "uplus",
                pay_method: 'uplus',
                merchant_uid: merchant_uid,
                name: '${shop.getPName()}',
                amount: document.getElementById('finalPrice').textContent.replace(/[^0-9]/g,
                    ''), // 쿠폰 할인 적용된 최종 금액
                buyer_email: '${ user.id }',
                buyer_name: '${ user.name }',
                buyer_tel: '${ user.phone }',
                buyer_addr: daAddr,
                buyer_postcode: ''
            }, function (rsp) { // callback
                //rsp.imp_uid 값으로 결제 단건조회 API를 호출하여 결제결과를 판단합니다.
                console.log(rsp);
                if (rsp.success) {
                    alert("결제 완료하였습니다.");
                    // 결제 성공 시: 결제 승인 또는 가상계좌 발급에 성공한 경우
                    // jQuery로 HTTP 요청
                    jQuery.ajax({
                        url: "../buyList/buy.do",
                        method: "GET",
                        // headers: {
                        //     "Content-Type": "application/json"
                        // },
                        data: {
                            imp_uid: rsp.imp_uid, // 결제 고유번호
                            merchant_uid: rsp.merchant_uid, // 주문번호
                            userIdx: "${ user.userIdx }",
                            pIdx: "${ shop.getPIdx() }",
                            couponid: document.getElementById('coupon').value, // 선택된 쿠폰 ID
                            daIdx: daAddr,
                            // 수정 필요
                            bamount: bamount,
                            buyPrice: rsp.paid_amount
                        },
                        dataType: "json",

                    }).done(function (data) {
                        // 가맹점 서버 결제 API 성공시 로직
                    })
                } else {
                    alert("결제에 실패하였습니다. 에러 내용: " + rsp.error_msg);
                }
            });

        } //end:requestPay()

        function tossPay() {

            // 로그인이 안되었으면
            if ("${ empty user }" == "true") {
                if (confirm("로그인 후 충전이 가능합니다.\n로그인 하시겠습니까?") == true) {
                    // 로그인 모달창을 띄웁니다.
                    loginModal.style.display = "flex";

                }
                return;
            }

            let amount = "${ shop.getAmount() }";
            let scamount = $("#scamount").val();
            if (amount - scamount < 0) {
                alert("재고수량이 부족합니다.");
                return;
            }

            daAddr = $("#address").val();

            if (daAddr == 'none') {
                alert("배송지를 선택해주세요!");
                return;
            }

            // 1. 사전 검증 (IMP.request_pay 호출 전에 실행)
            jQuery.ajax({
                url: "https://api.iamport.kr/payments/prepare",
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                data: JSON.stringify({
                    merchant_uid: merchant_uid, // 가맹점 주문번호
                    amount: document.getElementById('finalPrice').textContent.replace(/[^0-9]/g,
                        '') // 결제 예정 금액
                }),
                success: function (preparationResponse) {
                    console.log("사전 검증 성공:", preparationResponse);

                    IMP.request_pay({
                        pg: "tosspay",
                        pay_method: 'tosspay',
                        merchant_uid: merchant_uid,
                        name: '${ shop.getPName() }',
                        amount: document.getElementById('finalPrice').textContent.replace(/[^0-9]/g,
                            ''), // 쿠폰 할인 적용된 최종 금액
                        buyer_email: '${ user.id }',
                        buyer_name: '${ user.name }',
                        buyer_tel: '${ user.phone }',
                        buyer_addr: daAddr,
                        buyer_postcode: ''
                    }, function (rsp) { // callback
                        //rsp.imp_uid 값으로 결제 단건조회 API를 호출하여 결제결과를 판단합니다.
                        console.log(rsp);
                        if (rsp.success) {
                            alert("결제 완료하였습니다.");
                            // 결제 성공 시: 결제 승인 또는 가상계좌 발급에 성공한 경우
                            // jQuery로 HTTP 요청
                            jQuery.ajax({
                                url: "../buyList/buy.do",
                                method: "GET",
                                // headers: {
                                //     "Content-Type": "application/json"
                                // },
                                data: {
                                    imp_uid: rsp.imp_uid, // 결제 고유번호
                                    merchant_uid: rsp.merchant_uid, // 주문번호
                                    userIdx: "${ user.userIdx }",
                                    pIdx: "${ shop.getPIdx() }",
                                    couponid: document.getElementById('coupon')
                                        .value, // 선택된 쿠폰 ID
                                    daIdx: daAddr,
                                    // 수정 필요
                                    bamount: bamount,
                                    buyPrice: rsp.paid_amount
                                },
                                dataType: "json",

                            }).done(function (data) {
                                // 가맹점 서버 결제 API 성공시 로직
                            })
                        } else {
                            alert("결제에 실패하였습니다. 에러 내용: " + rsp.error_msg);
                        }

                    });


                }
            }); //end:tossPay()
        }

        function kakaoPay() {

            // 로그인이 안되었으면
            if ("${ empty user }" == "true") {
                if (confirm("로그인 후 충전이 가능합니다.\n로그인 하시겠습니까?") == true) {
                    // 로그인 모달창을 띄웁니다.
                    loginModal.style.display = "flex";

                }
                return;
            }

            let amount = "${ shop.getAmount() }";
            let scamount = $("#scamount").val();
            if (amount - scamount < 0) {
                alert("재고수량이 부족합니다.");
                return;
            }

            let daAddr = $("#address").val();

            if (daAddr == 'none') {
                alert("배송지를 선택해주세요!");
                return;
            }

            IMP.request_pay({
                pg: "kakaopay",
                pay_method: 'kakaopay',
                merchant_uid: merchant_uid,
                name: '${ shop.getPName() }',
                amount: document.getElementById('finalPrice').textContent.replace(/[^0-9]/g,
                    ''), // 쿠폰 할인 적용된 최종 금액
                buyer_email: '${ user.id }',
                buyer_name: '${ user.name }',
                buyer_tel: '${ user.phone }',
                buyer_addr: daAddr,
                buyer_postcode: ''
            }, function (rsp) { // callback
                //rsp.imp_uid 값으로 결제 단건조회 API를 호출하여 결제결과를 판단합니다.
                console.log(rsp)

                if (rsp.success) {
                    alert("결제 완료하였습니다.");
                    // 결제 성공 시: 결제 승인 또는 가상계좌 발급에 성공한 경우
                    // jQuery로 HTTP 요청
                    jQuery.ajax({
                            url: "../buyList/buy.do",
                            method: "POST",
                            // headers: {
                            //     "Content-Type": "application/json"
                            // },
                            data: {
                                imp_uid: rsp.imp_uid, // 결제 고유번호
                                orderNumber: rsp.merchant_uid, // 주문번호
                                userIdx: "${ user.userIdx }",
                                pIdx: "${ shop.getPIdx() }",
                                couponid: document.getElementById('coupon')
                                    .value, // 선택된 쿠폰 ID
                                daIdx: daAddr,
                                // 수정 필요
                                bamount: bamount,
                                buyPrice: rsp.paid_amount
                            },
                            dataType: "json",

                        }),
                        // 액세스 토큰 발급 요청
                        jQuery.ajax({
                            url: "http://localhost:8080/api/iamport/token",
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json"
                            },
                            data: JSON.stringify({
                                imp_key: "3672717442038407", // REST API 키
                                imp_secret: "Z0zCEcoGYox8ODy9Ukpd7UGdNg7D9meXKi9zItAoyhwSE2eeCfu98edzsHRTEpxRmjmju70Ot8pa0oD8" // REST API Secret
                            }),
                            dataType: "json",
                            success: function (tokenResponse) {

                                console.log("토큰 발급:", tokenResponse);

                                // response 필드의 access_token 추출
                                var access_token = tokenResponse && tokenResponse
                                    .response ?
                                    tokenResponse.response.access_token : null;

                                if (access_token) {
                                    console.log("발급된 토큰:", access_token);
                                    // 이후 로직 진행
                                } else {
                                    console.error("response 객체가 없습니다. 응답 확인 필요:",
                                        tokenResponse);
                                }

                                // imp_uid로 포트원 서버에서 결제 정보 조회
                                jQuery.ajax({
                                    url: "http://localhost:8080/api.iamport.kr/payments/" +
                                        rsp
                                        .imp_uid,
                                    method: "GET",
                                    headers: {
                                        "Authorization": access_token
                                    },
                                    success: function (paymentResponse) {
                                        var paymentData = paymentResponse
                                            .response; // 결제 정보
                                        console.log("결제 정보:", paymentData);
                                        // 결제 정보 확인 후 처리 로직 추가
                                    },
                                    error: function (err) {
                                        console.error("결제 정보 조회 실패:", err
                                            .responseText);
                                    }
                                });
                            },
                            error: function (err) {
                                console.error("토큰 발급 실패:", err.responseText);
                            }
                        })
                        .done(function (data) {
                            // 가맹점 서버 결제 API 성공시 로직

                        })
                } else {
                    alert("결제에 실패하였습니다. 에러 내용: " + rsp.error_msg);
                }
            });

        } //end:kakaoPay()

        function updateTotalPrice() {
            document.querySelectorAll('.product-container').forEach(item => {
                price = parseFloat(item.querySelector('.price').innerText);
                const quantity = parseInt(item.querySelector('input[type="number"]').value);
                applyCoupon();
                console.log("finalPrice를 계산하기 전의 price : " + price + " / quantity : " +
                    quantity +
                    " / couponDiscount : " + couponDiscount);
                finalPrice = price * quantity - couponDiscount;
                price = originalPrice * quantity;
                bamount = quantity;

                console.log("updateTotalPrice를 진행한 후 finalPrice : " + finalPrice);
                console.log("updateTotalPrice를 진행한 후 quantity : " + quantity);
                console.log("updateTotalPrice를 진행한 후 couponDiscount : " + couponDiscount);

            });
            document.getElementById('finalPrice').textContent = finalPrice.toLocaleString();
            document.getElementById('price').textContent = price.toLocaleString();

        }

        document.querySelectorAll('input[type="number"]').forEach(input => {
            input.addEventListener('change', function () {
                const itemId = this.id.split('-')[1]; // ID에서 상품 ID 추출
                const newQuantity = this.value;

                // AJAX 요청 보내기
                fetch(`/user/updateQuantity1`, {
                        method: 'POST'
                    })
                    .then(response => {
                        if (response.ok) {
                            return response.json(); // 서버에서 JSON 응답을 받음
                        }
                        throw new Error('네트워크 오류 발생');
                    })
                    .then(data => {
                        console.log(data.message);
                        // 총 금액 업데이트
                        updateTotalPrice();
                    })
                    .catch(error => {
                        console.error('오류:', error);
                    });
            });
        });
    </script>
</head>

<body>
    <!-- 고정된 푸터 -->
    <div class="fixed-footer">
        <div class="button-container">
            <button class="btn npay-btn">T Pay 구매하기</button>
            <button class="btn simple-buy-btn">간편구매</button>
            <button class="btn buy-btn">구매하기</button>
        </div>
    </div>

    <!-- 숨겨진 구매 섹션 -->
    <div id="purchaseSection" class="purchase-section">
        <div class="purchase-content">
            <h2>구매 정보</h2>
            <div class="purchase-options">

                <!-- 색상 선택 -->
                <!-- <div class="option">
    <label for="color">색상 *</label>
    <select id="color">
        <option value="white">흰색</option>
        <option value="black">검정색</option>
        <option value="blue">파랑색</option>
    </select>
</div> -->

                <!-- 사이즈 선택 -->
                <!-- <div class="option">
    <label for="size">SIZE *</label>
    <select id="size">
        <option value="small">S</option>
        <option value="medium">M</option>
        <option value="large">L</option>
    </select>
</div> -->

                <!-- 배송 옵션 -->
                <!-- <div class="option">
    <label for="delivery">배송 옵션</label>
    <select id="delivery">
        <option value="standard">택배</option>
        <option value="pickup">방문수령</option>
        <option value="express">퀵배송</option>
    </select>
</div> -->

                <!-- 쿠폰 선택 박스 -->
                <div class="option">
                    <label for="coupon">쿠폰 선택</label>
                    <select id="coupon" onchange="applyCoupon()">
                        <option value="0" data-type="" data-discount="0">쿠폰을 선택하세요</option>
                        <c:choose>
                            <c:when test="${not empty couponList}">
                                <c:forEach var="coupon" items="${couponList}">
                                    <!-- 사용하지 않은 쿠폰만 표시 -->
                                    <c:if test="${coupon.useat == 'N'}">
                                        <option value="${coupon.cbidx}" data-type="${coupon.coupon.dctype}"
                                            data-discount="${coupon.coupon.discount}">
                                            ${coupon.coupon.cname}:
                                            <c:if test="${coupon.coupon.dctype == '-'}">
                                                ${coupon.coupon.discount}원 할인
                                            </c:if>
                                            <c:if test="${coupon.coupon.dctype == '%'}">
                                                ${coupon.coupon.discount}% 할인
                                            </c:if>
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <option value="0" disabled>적용 가능한 쿠폰이 없습니다</option>
                            </c:otherwise>
                        </c:choose>
                    </select>
                </div>

                <!-- 가격 표시 -->
                <div class="price">
                    <p>판매가: <span id="price">${shop.getPrice()}</span>원</p>
                    <p>할인 금액: <span id="discountAmount">0</span>원</p>
                    <p>최종 결제 금액: <span id="finalPrice">${shop.getPrice()}</span>원</p>
                </div>

                <!-- 배송지 선택 -->
                <div class="address">
                    <c:if test="${user ne null}">
                        <p>배송지: <span id="address-id">
                                <select name="address" id="address">
                                    <option value="none">배송지를 선택하세요</option>
                                    <c:forEach var="ad" items="${daAddrList}">
                                        <option value="${ad.daIdx}">${ad.daAddr}(${ad.subDaAddr})</option>
                                    </c:forEach>
                                </select>
                            </span></p>
                    </c:if>
                    <c:if test="${user eq null}">
                        <p>배송지를 입력하려면 로그인하세요</p>
                    </c:if>
                </div>

                <!-- 구매 버튼 -->
                <div class="purchase-actions">
                    <button class="btn npay-btn" onclick="tossPay()">Toss Pay 구매하기</button>
                    <button class="btn simple-buy-btn" onclick="kakaoPay()">카카오 간편구매</button>
                    <button class="btn buy-btn" onclick="requestPay()">구매하기</button>
                </div>
            </div>

            <!-- 닫기 버튼 -->
            <button id="closeButton" class="close-btn">닫기</button>
        </div>
    </div>

    <script>
        document.querySelector('.button-container').addEventListener('click', function () {
            document.getElementById('purchaseSection').style.bottom = '0';
        });

        document.getElementById('closeButton').addEventListener('click', function () {
            document.getElementById('purchaseSection').style.bottom = '-100%';
        });
    </script>

</body>

</html>