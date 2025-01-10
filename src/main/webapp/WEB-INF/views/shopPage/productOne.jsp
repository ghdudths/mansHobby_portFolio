<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>상품 상세 페이지</title>
                <!-- Bootstrap 3.x -->
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
                <style>
                    .container {
                        width: 73%;
                        margin-top: 102.2px;
                        background-color: #fff;
                        padding: 20px;
                        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                    }

                    .product-container {
                        display: flex;
                        flex-wrap: wrap;
                        margin: 20px 0;
                    }

                    .product-image {
                        flex: 1;
                        padding: 20px;
                    }

                    .product-details {
                        flex: 1.7;
                        padding: 20px;
                    }

                    .product-image img {
                        max-width: 100%;
                        height: 95%;
                    }

                    .product-details h1 {
                        font-size: 2em;
                        margin-bottom: 20px;
                    }

                    .product-details p {
                        font-size: 1.2em;
                        margin-bottom: 20px;
                    }

                    .product-details .price {
                        font-size: 1.5em;
                        color: black;
                    }

                    .product-details .add-to-cart:hover,
                    .share-to-other:hover {
                        background-color: #f5f1f1 !important;
                        color: #00bcd4 !important;
                        transition: background-color 0.3s ease, color 0.3s ease;
                        border: 1px solid #f5f1f1;

                    }

                    /* 제목과 문의 버튼을 포함한 컨테이너 스타일 정의 */
                    .product-title-inquiry {
                        margin-bottom: 20px;
                    }
                
                    /* 문의 버튼 스타일 */
                    .product-title-inquiry .inquiry-button {
                        float: right;
                        font-size: 1em;
                        padding: 10px 15px;
                        background-color: #00bcd4;
                        color: white;
                        border: none;
                        cursor: pointer;
                        transition: background-color 0.3s ease;
                    }
                
                    .product-title-inquiry .inquiry-button:hover {
                        background-color: #0097a7;
                    }

                    .quantity-box {
                        display: flex;
                        align-items: center;
                    }

                    .quantity-field {
                        width: 70px;
                        text-align: center;
                        font-size: 1.2em;
                        border: 1px solid #ccc;
                        margin: 0 5px;
                        border-radius: 5px;
                        height: 40px;
                        line-height: 40px;
                    }

                    .button-group {
                        display: flex;
                        justify-content: space-between;
                        /* 버튼 간격을 동일하게 배치 */
                        margin-top: 20px;
                    }

                    .add-to-cart,
                    .share-to-other {
                        flex: 1;
                        /* 각 버튼이 같은 비율로 차지하도록 설정 */
                        margin: 0 10px;
                        /* 버튼 사이에 적당한 간격 */
                        text-align: center;
                        border-radius: 5px;
                    }

                    .add-to-cart {
                        background-color: black !important;
                        color: white;
                        border: none;
                        padding: 15px 20px;
                        font-size: 1.2em;
                        cursor: pointer;
                        border-radius: 5px;
                    }

                    .share-to-other {
                        background-color: white;
                        color: #333;
                        border: 1px solid #333;
                        /* 유효한 border 스타일 */
                        padding: 15px 20px;
                        font-size: 1.2em;
                        cursor: pointer;
                        border-radius: 5px;
                        text-align: center;
                    }

                    .description-box {
                        background-color: #f0f0f0;
                        padding: 20px 30px;
                        border-radius: 10px;
                        color: #333;
                        font-size: 1.2em;
                        width: 100%;
                        height: 100px;
                        box-sizing: border-box;
                        display: flex;
                        align-items: flex-start;
                        justify-content: flex-start;
                        margin-top: 20px;
                    }

                    .carousel-image {
                        width: 100%;
                        /* 부모 컨테이너의 전체 너비를 채움 */
                        height: 400px;
                        /* 고정된 높이 */
                        object-fit: cover;
                        /* 이미지 비율을 유지하면서 컨테이너 크기에 맞게 자름 */
                    }

                    /* 캐러셀 전체에 대한 추가 스타일링 */
                    .carousel-inner {
                        max-height: 400px;
                        max-width: 400px;
                        /* 이미지의 최대 높이를 고정 */
                    }
                    
                    /* 모달을 화면 가운데 정렬 */
                    .centered {
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%);
                    }

                    /* 리뷰 모달 관련 
                    #reviewModifyModal {
                        display: none;
                        position: fixed;
                        z-index: 1;
                        left: 50%;
                        top: 50%;
                        transform: translate(-50%, -50%);
                        width: 100%;
                        height: 100%;
                        background-color: rgba(0, 0, 0, 0.4);
                        justify-content: center;
                        align-items: center;
                    }

                    #reviewModifyModal .modal-content {
                        background-color: #fff;
                        padding: 20px;
                        border: 1px solid #888;
                        width: 30%;
                        border-radius: 8px;
                        box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
                    } */

                    /* 좌우 버튼의 배경색을 투명하게 만들고 그림자 제거 */
                    .carousel-control.left,
                    .carousel-control.right {
                        background: none !important;
                        box-shadow: none !important;
                    }

                    /* 아이콘 색상 */
                    .carousel-control.left span,
                    .carousel-control.right span {
                        color: black;
                    }

                    /* 호버 시에도 배경색 및 그림자 없도록 설정 */
                    .carousel-control:hover {
                        background: none !important;
                        box-shadow: none !important;
                    }


                    .carousel-indicators li {
                        background-color: white !important;
                        border-color: black !important;
                    }

                    .carousel-indicators .active {
                        background-color: black !important;
                    }
                </style>
                <script>
                    // 장바구니 추가 함수
                    function addToCart() {
                        if ("${empty user}" == "true") {
                            alert("장바구니는 로그인 후 이용가능합니다");
                            return;
                        } else {
                            alert('장바구니에 추가되었습니다!');
                            const scAmount = document.getElementById("scamount").value;
                            console.log(scAmount);
                            location.href = `${pageContext.request.contextPath}/cartInsert.do?pIdx=${shop.getPIdx()}&scamount=` + scAmount;
                        }
                    }

                    // 좋아요 토글 함수
                    function toggleLike(rvIdx, btn) {
                        console.log("==========toggleLike 호출==========");
                        console.log("rvIdx:", rvIdx);

                        $.ajax({
                            url: "${pageContext.request.contextPath}/review/toggle.do", // 컨트롤러의 좋아요 토글 URL
                            type: "GET",
                            data: { rvIdx: rvIdx },
                            dataType: "json",
                            success: function (response) {
                                if (response.result === "success") {
                                    var likeBtn = $("#like-btn-" + rvIdx);
                                    var likeCount = $("#like-count-" + rvIdx);

                                    if (response.action === "added") {
                                        $(btn).addClass("liked");
                                    } else {
                                        $(btn).removeClass("liked");
                                    }
                                    likeCount.text(response.count); // 좋아요 수 업데이트
                                } else {
                                    alert(response.message || "오류가 발생했습니다.");
                                }
                            },
                            error: function (jqXHR, textStatus, errorThrown) {
                                alert("서버 오류가 발생했습니다.");
                            }
                        });
                    }

                    function updateLikeCount(rvIdx) {
                        $.ajax({
                            url: "${pageContext.request.contextPath}/review/count.do",
                            data: { rvIdx: rvIdx },
                            dataType: "json",
                            success: function (response) {
                                $("#like-count-" + rvIdx).text(response.count);
                            }
                        });
                    }


                    $(document).ready(function () {

                        // 초기화 작업 수행
                        $(".like-button").each(function () {
                            var rvIdx = $(this).data("rvidx");
                            var btn = this;
                            $.ajax({
                                url: "${pageContext.request.contextPath}/review/isLiked.do",
                                data: { rvIdx: rvIdx },
                                dataType: "json",
                                success: function (response) {
                                    if (response.isLiked) {
                                        $(btn).addClass("liked");
                                    }
                                }
                            });
                            updateLikeCount(rvIdx);
                        });
                    });


                    function send1(f) {

                        let url = new URL(window.location.href);
                        if ("${empty user}" == "true") {
                            alert('로그아웃되었습니다.\n로그인하세요.');
                            return;
                        }

                        let rvContent = f.rvContent.value;

                        if (rvContent.trim() === '') {
                            alert("내용을 입력하세요");
                            f.rvContent.focus();
                            return;
                        }

                        if (f.rvImg.files.length === 0) {
                            if (!confirm("사진을 선택하지 않았습니다. 등록하시겠습니까?")) return;
                        } else if (!confirm("등록하시겠습니까?")) return;

                        f.url.value = url.href;
                        f.method = "POST";
                        f.enctype = "multipart/form-data";
                        f.action = "${pageContext.request.contextPath}/review/reviewWrite.do";
                        f.submit();
                    }

                    function send2(f) {
                        let url = new URL(window.location.href);
                        if ("${ empty user }" == "true") {
                            alert('로그아웃되었습니다.\n로그인하세요.');
                            return;
                        }

                        let rvContent = f.rvContent.value;

                        if (rvContent.trim() == '') {
                            alert("내용을 입력하세요");
                            f.rvContent.focus();
                            return;
                        }
                        f.url.value = url.href;

                        f.action = "${pageContext.request.contextPath}/review/reviewModify.do"; // 리뷰 수정 전송
                        f.submit();
                    }

                    function check_user(rvIdx, userIdx) {
                        if ("${not empty user}") {
                            if ("${user.userIdx}" == userIdx) {
                                // AJAX 요청으로 리뷰 정보를 가져와서 모달에 채워넣기
                                $.ajax({
                                    url: '${pageContext.request.contextPath}/review/getReviewInfo.do',
                                    type: 'GET',
                                    data: { rvIdx: rvIdx },
                                    success: function (data) {
                                        // 모달을 열고 데이터를 채웁니다.
                                        $('#reviewModifyModal').show();
                                        //    $('#reviewModifyModal').css('display', 'flex');로 대체
                                        $('textarea[id="reviewModifyContent"]').val(data.rvContent);
                                        $('input[name="rvIdx"]').val(data.rvIdx);
                                    },
                                    error: function () {
                                        alert('리뷰 정보를 가져오는 데 실패했습니다.');
                                    }
                                });
                                return;
                            }
                        }
                        alert('수정 권한이 없습니다.');
                    }


                    $('.close').on('click', function () {
                        $('#reviewModifyModal').css('display', 'none');  // 닫기 버튼을 누르면 모달을 숨김
                    });


                    function deleteReview(rvIdx) {
                        if (confirm('정말로 삭제하시겠습니까?')) {
                            $.ajax({
                                type: 'GET',
                                url: '${pageContext.request.contextPath}/review/deleteReview.do',
                                data: { rvIdx: rvIdx },
                                dataType: 'json',
                                success: function (response) {
                                    if (response.result === 'success') {
                                        alert('삭제되었습니다.');
                                        // 페이지를 새로 고침하여 삭제된 리뷰를 제거할 수 있습니다.
                                        location.reload();
                                    } else {
                                        alert('삭제 실패했습니다.');
                                    }
                                },
                                error: function (xhr, status, error) {
                                    alert('삭제 중 오류가 발생했습니다.');
                                }
                            });
                        }
                    }



                    $(document).ready(function () {
                        // 이미지 개수 확인
                        const itemCount = $('#productCarousel .carousel-inner .item').length;

                        // 이미지가 1개 이하일 경우 인디케이터와 화살표 숨기기
                        if (itemCount <= 1) {
                            $('#productCarousel .carousel-control').hide(); // 화살표 숨기기
                            $('#productCarousel .carousel-indicators').hide(); // 인디케이터 숨기기
                        }
                    });

                </script>
            </head>

            <body>
                <!-- 메뉴바 -->
                <%@ include file="../menubar/navbar.jsp" %>
                    <br>
                    <div class="container">
                        <div class="product-container">
                            <div id="productCarousel" class="carousel slide" data-ride="carousel">
                                <!-- 인디케이터 -->
                                <ol class="carousel-indicators">
                                    <c:forEach var="product" items="${product}" varStatus="status">
                                        <li data-target="#productCarousel" data-slide-to="${status.index}"
                                            class="${status.first ? 'active' : ''}"></li>
                                    </c:forEach>
                                </ol>

                                <!-- 캐러셀 안의 이미지 -->
                                <div class="carousel-inner">
                                    <c:forEach var="product" items="${product}" varStatus="status">
                                        <div class="item ${status.first ? 'active' : ''}">
                                            <c:if test="${product.fileNameLink == 'Y'}">
                                                <img src="${product.fileName}" alt="상품 이미지" class="carousel-image">
                                            </c:if>
                                            <c:if test="${product.fileNameLink == 'N'}">
                                                <img src="${pageContext.request.contextPath}/resources/images/${product.fileName}"
                                                    alt="상품 이미지" class="carousel-image">
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- 이전/다음 버튼 -->
                                <a class="left carousel-control" href="#productCarousel" role="button"
                                    data-slide="prev">
                                    <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                                    <span class="sr-only">이전</span>
                                </a>
                                <a class="right carousel-control" href="#productCarousel" role="button"
                                    data-slide="next">
                                    <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                                    <span class="sr-only">다음</span>
                                </a>
                            </div>

                            <div class="product-details">
                                <h1 id="product-name">${shop.getPName()}</h1>
                                <p class="price" id="product-price">${shop.getPrice()} 원</p>
                                <hr style="border: 0; height: 2px; background: linear-gradient(to right, #ccc, #333, #ccc);">
                                <div class="product-title-inquiry">
                                    <span style="font-size: 1.5em;">수량:</span> <input type="number" id="scamount" name="scamount" value="1" min="1" class="quantity-field">
                                    <p style="display: inline-block; font-size: 1.5em;"> 재고수량: ${shop.getAmount()}</p>
                                    <!-- 문의 버튼 -->
                                    <button class="inquiry-button" onclick="openInquiryForm('${shop.getPIdx()}')">문의하기</button>
                                </div>
                                <p id="product-description" class="description-box">${shop.getPEx()}</p>
                                <div class="button-group">
                                    <button class="add-to-cart" onclick="addToCart()">장바구니에 추가</button>
                                    <button class="share-to-other" onclick="copyLinkToClipboard()">공유하기</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 후기와 리뷰 등록 버튼 중앙 정렬 -->
                    <div class="container d-flex justify-content-between align-items-center" style="margin-top: 50px;">
                        <h2 style="margin-right: 20px;">후기</h2>
                        <br>
                        <c:if test="${not empty user}">
                            <c:if test="${purchaseCount > 0}">
                                <button type="button" class="btn btn-primary btn-sm"
                                    style="padding: 10px 15px; font-size: 15px; border-radius: 4px; background-color: black !important;"
                                    id="openReviewModal">리뷰
                                    등록</button>
                            </c:if>
                            <c:if test="${purchaseCount <= 0}">
                                <span style="color: red; font-size: 14px;">이 상품을 구매한 후 리뷰를 작성할 수 있습니다.</span>
                            </c:if>
                        </c:if>
                        <c:if test="${empty user}">
                            <span style="color: red; font-size: 14px;">로그인 후 리뷰를 작성할 수 있습니다.</span>
                        </c:if>
                    </div>
                    <br>

                    <c:forEach var="review" items="${reviewList}">
                        <div class="container" style="margin-top: 0px; margin-bottom: 10px; position: relative;">
                            <!-- 리뷰 목록 출력 -->
                            <div class="review-item">
                                <!-- 수정 및 삭제 버튼을 오른쪽 상단에 배치 -->
                                <div style="position: absolute; top: 0; right: 0;">
                                    <c:if test="${user.userIdx == review.userIdx}">
                                        <!-- 리뷰 수정 버튼 -->
                                        <button class="btn btn-warning"
                                            style="padding: 3px 8px; margin-right: 0px; margin-top: 15px;"
                                            onclick="check_user('${review.rvIdx}', '${review.userIdx}')">
                                            수정
                                        </button>

                                        <!-- 리뷰 삭제 버튼 -->
                                        <button class="btn btn-danger"
                                            style="padding: 3px 8px; margin-right: 20px; margin-top: 15px;"
                                            onclick="deleteReview('${review.rvIdx}')">
                                            삭제
                                        </button>
                                    </c:if>
                                </div>

                                <p><strong>작성자&nbsp;&nbsp;&nbsp;:</strong> ${review.nickName}님</p>
                                <p><strong>평점&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;:</strong>
                                    ${review.reviewPoint}점
                                </p>
                                <hr style="border: 0; height: 1px; background-color: #ddd;">
                                <p style="font-size: large;">${review.rvContent}</p>
                                <c:if test="${review.rvImg ne null && review.rvImg ne ''}">
                                    <img src="${pageContext.request.contextPath}/resources/images/review/${review.rvImg}"
                                        alt="리뷰 이미지" style="width: 300px; height: 300px; object-fit: cover;">
                                </c:if>

                                <!-- 좋아요 버튼과 좋아요 수를 이미지 아래에 배치 -->
                                <div style="margin-top: 10px; display: flex; align-items: center;">
                                    <!-- 좋아요 이미지와 숫자를 담은 버튼 -->
                                    <button id="like-btn-${review.rvIdx}" class="like-button"
                                        data-rvIdx="${review.rvIdx}" onclick="toggleLike('${review.rvIdx}', this)"
                                        style="border: none; background: none; display: flex; align-items: center; padding: 0;">
                                        <div
                                            style="border: 1px solid #ccc; border-radius: 20px; padding: 5px 10px; display: flex; align-items: center;">
                                            <img src="${pageContext.request.contextPath}/resources/images/좋아요.png"
                                                alt="좋아요 이미지" style="width: 23px; height: 23px; margin-right: 5px;">
                                            <span id="like-count-${review.rvIdx}"
                                                style="font-size: 1.2em;">${review.likeCount}</span>
                                        </div>
                                    </button>
                                    <!-- 도움 문구 -->
                                    <span style="margin-left: 10px; font-size: 1.1em; color: #007bff;">이 리뷰가 도움이
                                        되었다면
                                        꾹!</span>
                                </div>

                            </div>
                        </div>
                    </c:forEach>

                    <!-- 푸터 -->
                    <footer style="position: static; margin-top: 100px; padding-bottom: 20px;">
                        <%@ include file="../menubar/payment.jsp" %>
                    </footer>


                    <!-- 리뷰 작성 모달 -->
                    <div id="reviewModal" class="modal">
                        <div class="modal-content">
                            <span class="close"
                                onclick="document.getElementById('reviewModal').style.display='none'">&times;</span>
                            <h2>리뷰 작성</h2>
                            <form>
                                <input type="hidden" name="url" id="url" value="../home.do" />
                                <input type="hidden" name="userIdx" value="${user.userIdx}" />
                                상품번호 : <input type="text" name="pIdx" value="${shop.getPIdx()}" readonly /><br>
                                <div class="form-group" style="color: black;">
                                    <label for="content" style="color: black;">내용</label>
                                    <textarea name="rvContent" required
                                        style="width: 100%; min-height: 200px;"></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="reviewImage">리뷰 이미지 업로드</label>
                                    <input type="file" name="reviewImg" id="rvImg">
                                </div>
                                <button type="button" class="btn btn-primary" onclick="send1(this.form)">등록</button>
                            </form>
                        </div>
                    </div>

                    <!-- 리뷰 수정 모달 -->
                    <div id="reviewModifyModal" class="modal">
                        <div class="modal-content centered">
                            <span class="close"
                                onclick="document.getElementById('reviewModifyModal').style.display='none'">&times;</span>
                            <h2>리뷰 수정</h2>
                            <form enctype="multipart/form-data">
                                <input type="hidden" name="url" id="url" value="../home.do" />
                                <input type="hidden" name="rvIdx" />
                                <input type="hidden" name="userIdx" value="${user.userIdx}" />
                                <div class="form-group" style="color: black;">
                                    <label for="content" style="color: white;">내용</label>
                                    <textarea id="reviewModifyContent" name="rvContent" required
                                        style="width: 100%; min-height: 200px;"></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="reviewImage">리뷰 이미지 업로드</label>
                                    <input type="file" name="rvImg" id="rvImg">
                                </div>
                                <button type="button" class="btn btn-primary" onclick="send2(this.form)">수정</button>
                            </form>
                        </div>
                    </div>

                    <script>
                        const reviewModal = document.getElementById("reviewModal");
                        const openReviewModalBtn = document.getElementById("openReviewModal");
                        const reviewModifyModal = document.getElementById("reviewModifyModal");

                        openReviewModalBtn.onclick = function () {
                            reviewModal.style.display = "flex";
                        };

                        document.querySelectorAll(".close").forEach(el => {
                            el.onclick = function () {
                                el.closest(".modal").style.display = "none";
                            };
                        });
                    </script>

                    <script>
                        function copyLinkToClipboard() {
                            const url = window.location.href; // 현재 페이지의 URL 가져오기

                            // 클립보드에 URL 복사
                            navigator.clipboard.writeText(url).then(() => {
                                alert("링크가 복사되었습니다!"); // 알림창 표시
                            }).catch(err => {
                                console.error('링크 복사 실패: ', err);
                            });
                        }
                    </script>
                    <script>
                        function openInquiryForm() {

                            location.href = `inquiry/inquiryWriteForm.do?pIdx=${shop.getPIdx()}`;
                        }
                    </script>
            </body>

            </html>