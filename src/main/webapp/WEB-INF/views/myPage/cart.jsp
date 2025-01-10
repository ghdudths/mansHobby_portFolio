<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>장바구니</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 0;
                    background-color: #f8f9fa;
                }


                main {
                    padding: 2rem;
                    max-width: 1200px;
                    margin: 0 auto;
                }

                .cart-items {
                    width: 80%;
                    /* 너비를 80%로 줄임 */
                    background-color: white;
                    padding: 1.5rem;
                    border-radius: 10px;
                    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                    margin: 0 auto 2rem auto;
                    /* 상단 0, 좌우 auto, 하단 2rem으로 중앙 정렬 */
                }

                .cart-item {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    flex-wrap: wrap;
                    /* 이 부분을 추가하여 큰 화면에서 깨지는 레이아웃 방지 */
                    background-color: #ffffff;
                    padding: 1.5rem;
                    border-radius: 10px;
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                    margin-bottom: 1.5rem;
                    position: relative;
                    /* 체크박스 위치 조정을 위한 상대 위치 */
                }

                .item-checkbox {
                    position: absolute;
                    top: 10px;
                    /* 이미지와 상단 간격 조정 */
                    left: 5px;
                    /* 이미지와 좌측 간격 조정 */
                    margin-right: 100px;
                    /* 간격 조정 */
                    transform: scale(1.2);
                    /* 체크박스 크기 약간 확대 */
                }

                .cart-item img {
                    width: 100px;
                    height: 100px;
                    object-fit: cover;
                    margin-left: 1rem;
                    margin-right: 1rem;
                    /* 이미지와 텍스트 사이 간격 조정 */
                }

                .item-content {
                    display: flex;
                    align-items: center;
                    flex: 1;
                    flex-wrap: wrap;
                    /* 상품 정보가 공간이 부족하면 아래로 내려가도록 */
                }

                .item-details {
                    flex: 1;
                    margin-left: 1rem;
                    text-align: left;
                    min-width: 150px;
                }

                .item-details h2 {
                    font-size: 18px;
                    margin: 0 0 10px;
                    color: #333;
                }

                .item-details p {
                    margin: 0;
                    color: #666;
                    font-size: 14px;
                }

                .item-controls {
                    margin-top: 10px;
                    font-size: 15px;
                    display: flex;
                    align-items: center;
                }

                .item-controls input[type="number"] {
                    width: 40px;
                    padding: 3px;
                    border: 1px solid #ddd;
                    text-align: center;
                }

                .remove-btn {
                    background-color: #e74c3c;
                    color: white;
                    border: none;
                    padding: 5px 12px;
                    font-size: 16px;
                    cursor: pointer;
                    border-radius: 5px;
                    margin-left: 1rem;
                    /* 삭제 버튼이 텍스트와 겹치지 않도록 간격 조정 */
                }

                .remove-btn:hover {
                    background-color: #c0392b;
                }

                .cart-summary {
                    width: 80%;
                    /* 너비를 80%로 설정 */
                    margin: 20px auto 0;
                    /* 상단 20px, 좌우 중앙 배치, 하단 0 */
                    text-align: right;

                }

                .cart-summary p {
                    font-size: 24px;
                }

                .checkout-btn {
                    background-color: #2ecc71;
                    color: white;
                    border: none;
                    padding: 10px 20px;
                    font-size: 1.2rem;
                    cursor: pointer;
                    border-radius: 5px;
                    width: 120px;
                    margin-top: 20px;
                }

                .checkout-btn:hover {
                    background-color: #27ae60;
                }

                .container {
                    width: 70%;
                    margin: 2rem auto;
                    padding: 1.5rem;
                    background-color: #fff;
                    border-radius: 10px;
                    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                }

                h1 {
                    text-align: center;
                    color: #1a1a1a;
                    font-size: 28px;
                    margin-bottom: 1.5rem;
                }

                header {
                    background: #fff;
                    color: #000;
                    padding-top: 30px;
                    min-height: 70px;
                    border-bottom: #fff 3px solid;
                    font-size: 1.4rem;
                    margin-bottom: 10px;
                    /* 간격을 줄이기 위해 margin-bottom을 추가 */
                }
                #paymentModal {
            display: none; /* 기본적으로 숨김 */
            position: fixed; /* 고정 위치 */
            z-index: 1000; /* 다른 요소 위에 표시 */
            left: 0;
            top: 0;
            width: 100%; /* 전체 화면 너비 */
            height: 100%; /* 전체 화면 높이 */
            background-color: rgba(0, 0, 0, 0.5); /* 반투명 배경 */
        }

        .modal-content {
            background-color: white;
            margin: 15% auto; /* 중앙 정렬 */
            padding: 20px;
            border: 1px solid #888;
            width: 80%; /* 너비 조절 */
        }
            </style>
            <script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
            <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
            <script>
                function openModal() {
                    document.getElementById('paymentModal').style.display = 'block';
                }

                function closeModal() {
                    document.getElementById('paymentModal').style.display = 'none';
                }
                function submitPayment() {
                    const selectedItems = [];
                    const selectedItemAmount = [];
                    const scIdxList = [];
                    let selectedTotalPrice = 0; // 선택한 상품의 총 합계 초기화
                    let productName = "";
                    let isFirstItem = true;
                    document.querySelectorAll('.item-checkbox:checked').forEach(item => {
                        const itemId = item.id.split('-')[1]; // 선택된 아이템 ID 추출
                        const productNo = document.querySelector(`#productNo-`+itemId).value;
                        const quantity = parseInt(document.querySelector(`#scamount-`+itemId).value); // 해당 아이템 수량 추출 및 숫자로 변환
                        const price = parseFloat(document.querySelector(`#scamount-`+itemId).closest('.item-details').querySelector('.price').innerText.replace(/[^0-9]/g, '')); // 가격을 숫자로 변환

                        if (isFirstItem) { // 첫 번째 항목일 때만 실행
                            productName = document.querySelector(`#pName-` + itemId).innerText; // 상품 이름 추출
                            console.log(`첫 번째 상품 이름: `+productName);
                            isFirstItem = false; // 첫 번째 항목을 처리했으므로 플래그를 false로 설정
                        }

                        scIdxList.push({scIdx: itemId});
                        selectedItems.push({ pIdx: productNo});
                        selectedItemAmount.push({scamount: quantity});
                        selectedTotalPrice += price * quantity; // 총 합계 계산
                    });

                    if (selectedItems.length === 0) {
                        alert("선택된 상품이 없습니다.");
                        return;
                    }

                    // 선택한 상품 목록과 총 합계를 모달에 표시
                    const selectedItemsContainer = document.getElementById('selectedItemsContainer');
                    selectedItemsContainer.innerHTML = selectedItems.map((item, index) =>
                        (`<p>상품 ID: `+item.pIdx+`, 수량: `+selectedItemAmount[index].scamount+`</p>`)
                    ).join('');

                    document.getElementById('selectedTotalPrice').innerText = selectedTotalPrice;

                    var IMP = window.IMP;
                    IMP.init("imp33361271");
                    var merchant_uid = new Date().getTime() + 0; // 고유한 주문번호 생성
                    console.log("merchant_uid : "+merchant_uid);
                    // IAMPORT 결제 요청 코드
                    console.log("결제 요청 데이터:", {
                        pg: "kakaopay",
                        pay_method: 'kakaopay',
                        merchant_uid: merchant_uid,
                        name: productName + selectedItems.length + '개',
                        amount: selectedTotalPrice,
                        buyer_email: '${user.id}',
                        buyer_name: '${user.name}',
                        buyer_tel: '${user.phone}',
                        buyer_addr: '${user.addr}',
                        buyer_postcode: ''
                    }); // 결제 요청 데이터 로그

                    // IAMPORT 결제 요청 코드
                    IMP.request_pay({
                        pg: "kakaopay",
                        pay_method: 'kakaopay',
                        merchant_uid: merchant_uid,
                        name: productName+' 외 ' + (selectedItems.length-1) + '개',
                        amount: selectedTotalPrice, // 직접 계산한 총 금액으로 설정
                        buyer_email: '${ user.id }',
                        buyer_name: '${ user.name }',
                        buyer_tel: '${ user.phone }',
                        buyer_addr: '${ user.addr }',
                        buyer_postcode: ''
                    }, function (rsp) { // callback
                        console.log(rsp);
                        if (rsp.success) {
                            alert("결제 완료하였습니다.");
                            // 결제 성공 시 처리 로직 추가
                            // 아래 AJAX 요청은 필요한 대로 수정하세요.
                            jQuery.ajax({
                                url: "../buyList/cartBuy.do",
                                method: "POST",
                                data: {
                                    imp_uid: rsp.imp_uid,
                                    orderNumber: rsp.merchant_uid,
                                    userIdx: "${ user.userIdx }",
                                    scIdxList: scIdxList.map(scIdxs => scIdxs.scIdx),
                                    pIdxList: selectedItems.map(item => item.pIdx),
                                    bamountList: selectedItemAmount.map(amount => amount.scamount),
                                    buyPrice: rsp.paid_amount
                                },
                                dataType: "json",
                            }).done(function (data) {
                                // 가맹점 서버 결제 API 성공 시 로직
                                console.log(data);
                                closeModal();
                            });
                        } else {
                            closeModal();
                            alert("결제에 실패하였습니다. 에러 내용: " + rsp.error_msg);
                        }
                    });
                }

            </script>
            <script>
                function updateTotalPrice() {
                    let totalPrice = 0;
                    document.querySelectorAll('.cart-item').forEach(item => {
                        const price = parseFloat(item.querySelector('.price').innerText);
                        const quantity = parseInt(item.querySelector('input[type="number"]').value);
                        totalPrice += price * quantity;
                    });
                    document.querySelector('.total-price').innerText = totalPrice;
                }

                document.querySelectorAll('input[type="number"]').forEach(input => {
                    input.addEventListener('change', function () {
                        const itemId = this.id.split('-')[1]; // ID에서 상품 ID 추출
                        const newQuantity = this.value;

                        // AJAX 요청 보내기
                        fetch(`/user/updateQuantity?scIdx=` + itemId + `&scamount=` + newQuantity, {
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

                // 페이지 로드 시 총 금액 초기 계산
                document.addEventListener('DOMContentLoaded', updateTotalPrice, IMP.init("imp33361271"));

                function cartDelete(scIdx) {
                    if (confirm("장바구니에서 빼시겠습니까?") == false) return;

                    // AJAX 요청 보내기
                    fetch(`/user/cartDelete.do?scIdx=` + scIdx, {
                        method: 'DELETE'
                    })
                        .then(response => {
                            if (response.ok) {
                                return response.json(); // 서버에서 JSON 응답을 받음
                            }
                            throw new Error('네트워크 오류 발생');
                        })
                        .then(data => {
                            console.log(data.message);
                            const itemElement = document.getElementById(`item-` + scIdx);

                            if (itemElement) {
                                itemElement.closest('.cart-item').remove(); // itemElement가 null이 아닐 경우에만 closest 호출
                                // 총 금액 업데이트
                                updateTotalPrice();
                            } else {
                                console.error('아이템을 찾을 수 없습니다:', scIdx);
                            }
                        })
                        .catch(error => {
                            console.error('오류:', error);
                        });
                }
            </script>

        </head>

        <body>
            <header class="container">
                <h1>장바구니</h1>
            </header>
            <main>
                <c:set var="totalPrice" value="0" />
                <c:if test="${!cartList.isEmpty()}">
                    <c:forEach var="i" begin="0" end="${cartList.size()-1}">
                        <c:set var="cart" value="${cartList[i]}" />
                        <c:set var="image" value="${imageList[i]}" />
                        <div class="cart-item">
                            <input type="checkbox" id="item-${cart.getScIdx()}" class="item-checkbox">
                            <label for="item-${cart.getScIdx()}" class="item-content">
                                <c:if test="${image.fileNameLink == 'Y'}">
                                    <img src="${image.fileName}" alt="상품이미지"> <!-- 상품 이미지 URL -->
                                </c:if>
                                <c:if test="${image.fileNameLink == 'N'}">
                                    <img src="${pageContext.request.contextPath}/resources/images/${image.fileName}"
                                        alt="상품이미지"> <!-- 상품 이미지 URL -->
                                </c:if>
                                <div class="item-details">
                                    <h2 id="pName-${cart.getScIdx()}">${cart.getPName()}</h2> <!-- 상품 이름 -->
                                    <p>상품 가격: <span class="price">${cart.getPrice()}</span></p> <!-- 상품 가격 -->
                                    <label for="quantity-${cart.getPIdx()}">수량:</label>
                                    <input type="number" id="scamount-${cart.getScIdx()}" name="scamount"
                                        value="${cart.getScamount()}" min="1"> <!-- 수량 -->
                                    <input type="hidden" id="productNo-${cart.getScIdx()}" value="${cart.getPIdx()}"/>
                                </div>
                                <button class="remove-btn" onclick="cartDelete('${cart.getScIdx()}')">삭제</button>
                            </label>
                        </div>
                        <c:set var="totalPrice" value="${totalPrice + cart.price * cart.scamount}" />
                    </c:forEach>
                </c:if>

                <div class="cart-summary">
                    <p>총 합계: <span class="total-price" id="finalPrice">${totalPrice}</span></p> <!-- 총 합계 -->
                    <button class="checkout-btn" onclick="submitPayment()">결제하기</button>
                </div>
            </main>

            <div id="paymentModal">
                <div class="modal-content">
                    <span class="close-btn" onclick="closeModal()">&times;</span>
                    <h2>결제하기</h2>
                    <p>선택한 상품에 대한 결제를 진행합니다.</p>
                    <div id="selectedItemsContainer"></div> <!-- 선택한 상품 목록 -->
                    <p>총 합계: <span id="selectedTotalPrice"></span></p> <!-- 선택한 상품의 총 합계 -->
                    <button onclick="submitPayment()">결제 진행</button>
                </div>
            </div>
        </body>

        </html>
