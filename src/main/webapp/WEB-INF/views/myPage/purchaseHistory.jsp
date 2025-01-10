<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>구매 내역</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
      }

      .container {
        width: 70%;
        margin: 2rem auto;
        padding: 1.5rem;
        background-color: #fff;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
      }

      h1 {
        text-align: center;
        color: #1a1a1a;
        font-size: 28px;
        margin-bottom: 1.5rem;
      }

      table {
        width: 90%; /* 테이블 너비를 90%로 설정 */
        border-collapse: collapse;
        margin-top: 20px;
        background-color: white;
        border-radius: 3px;
        overflow: hidden;
        table-layout: fixed; /* 열 고정 */
      }

      thead th {
        background-color: #1a1a1a;
        color: white;
        font-weight: bold;
        padding: 12px 15px;
        text-align: center;
        border-bottom: 2px solid #ddd;
      }

      tbody td {
        background-color: #f9f9f9;
        padding: 12px;
        text-align: center;
        color: #333;
        border: 1px solid #ddd;
        overflow: hidden; /* 내용 넘침 방지 */
        white-space: nowrap; /* 줄 바꿈 방지 */
        text-overflow: ellipsis; /* 넘치는 텍스트 생략 부호 */
      }

      tbody tr:nth-child(even) td {
        background-color: #f1f1f1;
      }

      tbody tr:hover td {
        background-color: #aff0f8;
      }

      td,
      th {
        font-size: 16px;
      }

      tbody td {
        padding: 15px;
      }
    </style>
  </head>

  <body>
    <div class="container">
      <h1>구매 내역</h1>
    </div>
    <div class="container" style="width: 1000px; min-height: 600px">
      <table class="table table-striped">
        <thead>
          <tr>
            <th style="text-align: center">상품명</th>
            <th style="text-align: center">상품가격</th>
            <th style="text-align: center">구매 수량</th>
            <th style="text-align: center">구매 금액</th>
            <th style="text-align: center">배송주소</th>
            <th style="text-align: center">구매시간</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="buy" items="${buyList}">
            <tr>
              <td>${buy.getPName()}</td>
              <td>${buy.getPrice()}</td>
              <td>${buy.getBamount()}</td>
              <td>${buy.getBuyPrice()}</td>
              <td>${buy.getDaAddr()}(${buy.getSubDaAddr()})</td>
              <td>${buy.getBuyDate().substring(0, 16)}</td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </body>
</html>
