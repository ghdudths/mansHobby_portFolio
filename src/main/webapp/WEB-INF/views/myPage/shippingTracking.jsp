<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>배송 조회</title>
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
                    border-radius: 10px;
                    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                }

                h1 {
                    text-align: center;
                    color: #1a1a1a;
                    font-size: 28px;
                    margin-bottom: 1.5rem;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                    background-color: white;
                    border-radius: 3px;
                    /* 테이블 모서리 둥글게 */
                }

                thead th {
                    background-color: #1a1a1a;
                    color: white;
                    font-weight: bold;
                    padding: 12px 15px;
                    text-align: center;
                }

                tbody td {
                    background-color: #f9f9f9;
                    padding: 12px;
                    text-align: center;
                    color: #333;
                    border: 1px solid #ffffff;
                }

                tbody tr:nth-child(even) td {
                    background-color: #f1f1f1;
                }

                tbody tr:hover td {
                    background-color: #aff0f8;
                }

                table,
                th {
                    border: 1px solid #ddd;
                }

                td,
                th {
                    font-size: 16px;
                }
            </style>

        </head>

        <body>
            <div class="container">
                <h1>배송 조회</h1>
            </div>
            <div class="container">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>상품명</th>
                            <th>구매자</th>
                            <th>배송상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="orders" items="${orderList}">
                            <tr>
                                <td>${orders.getPName()}</td>
                                <td>${orders.getName()}</td>
                                <td>${orders.getDsContent()}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </body>

        </html>