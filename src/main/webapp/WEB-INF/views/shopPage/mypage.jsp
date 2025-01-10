<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>My Page</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding: 0;
            }

            .container {
                width: 80%;
                margin: auto;
                overflow: hidden;
            }

            header {
                background: #fff;
                color: #000;
                padding-top: 30px;
                min-height: 70px;
                border-bottom: #fff 3px solid;
            }

            header a {
                color: #000;
                text-decoration: none;
                text-transform: uppercase;
                font-size: 16px;
            }

            header ul {
                margin: 50px;
                padding: 0;
                list-style: none;
                text-align: center;
            }

            header ul li {
                display: inline;
                margin: 0 50px;
                cursor: pointer;
            }

            #content {
                background: #fff;
                margin-bottom: 50px;
                padding: 20px;
                min-height: 850px;
                /* 최소 높이 설정 */
                text-align: center;
                font-size: 24px;
                color: #333;
            }

            .welcome-message {
                font-size: 28px;
                color: #2c3e50;
                margin-top: 100px;
            }
        </style>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            $(document).ready(function () {
                $("header ul li").click(function () {
                    var page = $(this).data("page");
                    $.ajax({
                        url: page,
                        method: 'GET',
                        success: function (data) {
                            $("#content").html(data);
                            if (page == 'cart.do') {
                                //cart.do를 선택하면 footer태그가 보이는 로직
                            }
                        },
                        error: function () {
                            alert("삐빅 오류");
                        }
                    });
                });

                // 기본 콘텐츠로 환영 메시지를 추가합니다.
                $("#content").html('<div class="welcome-message">환영합니다! 여기는 마이페이지입니다.</div>');
                $.ajax({
                    url: "cart.do",
                    method: 'GET',
                    success: function (data) {
                        $("#content").html(data);
                    },
                    error: function () {
                        alert("삐빅 오류");
                    }
                });
            });
        </script>
    </head>

    <body>
        <%@ include file="../menubar/navbar.jsp" %>

            <header>
                <div>
                    <h1>My Page</h1>
                    <ul>
                        <li data-page="deliveryAddress.do">배송지관리</li>
                        <li data-page="cart.do">장바구니</li>
                        <li data-page="purchaseHistory.do">구매내역</li>
                        <li data-page="shippingTracking.do">배송조회</li>
                        <li data-page="accountInfo.do">정보수정</li>
                        <li data-page="grade.do">등급</li>
                    </ul>
                </div>
            </header>

            <div class="container">
                <div id="content" class="col-sm-12">
                    <!-- Default content can be loaded here -->
                    <div style="text-align: center;">
                        <!-- 환영 메시지가 자바스크립트에서 설정됩니다. -->
                    </div>
                </div>
            </div>

    <!-- 푸터 -->
    <%@ include file="../menubar/footer.jsp" %>
</body>

    </html>