<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<!DOCTYPE html>
<html lang="ko">
        <head>
          <!-- Bootstrap 3.x-->
          <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
          <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
          <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
          <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
          <meta charset="UTF-8" />
          <title>쿠폰목록</title>
</head>
<body>
    <h2>전체 쿠폰 목록</h2>

    <table border="1">
        <thead>
            <tr>
                <th>쿠폰 ID</th>
                <th>쿠폰명</th>
                <th>할인 금액</th>
                <th>할인 타입</th>
            </tr>
        </thead>
        <tbody>

            <c:forEach var="vo" items="${couponList}">
                <tr>
                    <td>${ vo.cidx }</td>
                    <td>${ vo.cname }</td>
                    <td>${ vo.discount }</td>
                    <td>${ vo.dctype }</td>  
                    
                </tr>

            </c:forEach>

        </tbody>
    </table>

    <br>
    <a href="${pageContext.request.contextPath}/coupon/addForm.do">새 쿠폰 추가</a>
</body>
</html>