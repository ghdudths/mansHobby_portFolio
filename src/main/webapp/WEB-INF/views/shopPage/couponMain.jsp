<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8" />
    <title>내 쿠폰함</title>
    <!-- Bootstrap 3.x -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

    <!-- Custom CSS -->
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            padding-top: 50px; /* 네비게이션 바 아래 공간 확보 */
        }

        .container {
            max-width: 1200px;
            margin: 50px auto; /* 상단에 충분한 마진 추가 */
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #333;
            margin: 30px 0;
            font-size: 28px;
            text-align: center;
        }

        /* 쿠폰 카드 스타일 */
        .coupon-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        /* 왼쪽 쿠폰 정보 영역 */
        .coupon-info {
            flex: 1;
            padding-right: 20px;
            border-right: 2px dashed #ddd; /* 세로 점선 */
            margin-right: 10px;
        }

        /* 쿠폰 제목 스타일 */
        .coupon-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        /* 할인 금액 스타일 */
        .coupon-discount {
            font-size: 18px;
            color: #333;
            margin-bottom: 10px;
        }

        /* 유효 기간 스타일 */
        .coupon-terms {
            font-size: 14px;
            color: #777;
        }

        /* 오른쪽 상태 및 적용 정보 스타일 */
        .coupon-status {
            padding-left: 20px;
            text-align: right;
            font-weight: bold;
            font-size: 18px;
        }

        .online-label {
            background-color: #fce4ec;
            color: #e91e63;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .apply-info {
            font-size: 16px;
            color: #333;
        }

        .apply-highlight {
            color: #e91e63;
            font-weight: bold;
        }
    </style>
</head>

<body>
    <!-- 메뉴바 -->
    <%@ include file="../menubar/navbar.jsp" %>

    <!-- 본문 내용 -->
    <div class="container">
        <h2>내 쿠폰함</h2>

        <c:forEach var="coupon" items="${myCouponList}">
            <c:if test="${coupon.useat == 'N'}">
                <div class="coupon-card">
                    <div class="coupon-info">
                        <div class="coupon-title">${coupon.coupon.cname}</div>
                        <div class="coupon-discount">
                            <c:choose>
                                <c:when test="${coupon.coupon.dctype == '-'}">
                                    ${coupon.coupon.discount}원 할인
                                </c:when>
                                <c:otherwise>
                                    ${coupon.coupon.discount}% 할인
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="coupon-terms">
                            유효 기간: ${coupon.createAtStr} ~ ${coupon.coupon.expirationDate} (${coupon.coupon.daysLeft})
                        </div>
                    </div>
                    <!-- 오른쪽 상태 영역 -->
                    <div class="coupon-status">
                        <div class="online-label">온라인</div>
                        <div class="apply-info">
                            결제 시 <br>
                            <span class="apply-highlight">자동적용</span>
                        </div>
                    </div>
                </div>
            </c:if>
        </c:forEach>
    </div>

    <!-- 푸터 -->
    <%@ include file="../menubar/footer.jsp" %>
</body>

</html>
