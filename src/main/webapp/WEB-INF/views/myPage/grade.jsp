<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>등급 관리</title>
            <link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/accountInfo.css">
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                    margin: 0;
                    padding: 0;
                }

                .panel {
                    width: 70%;
                    /* 테이블 너비를 70%로 설정 */
                    margin: 2rem auto;
                    padding: 1.5rem;
                    background-color: #fff;
                    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                }

                .panel-body {
                    display: flex;
                    flex-direction: column;
                    gap: 15px;
                }

                .panel-item {
                    display: flex;
                    justify-content: space-between;
                    font-size: 20px;
                }

                .next-grade {
                    color: #d9534f;
                }

                h1 {
                    text-align: center;
                }

                .panel-data {
                    font-weight: bold;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <h1>사용자 등급 정보</h1>
            </div>
            <div class="panel">
                <div class="panel-body">
                    <div class="panel-item">
                        <span>총 구매 금액:</span> <span class="panel-data">${gvo.totalPurchaseAmount}원</span>
                    </div>
                    <div class="panel-item">
                        <span>후기 수:</span> <span class="panel-data">${gvo.totalReviewCount}개</span>
                    </div>
                    <div class="panel-item">
                        <span>현재 등급:</span> <span class="panel-data">${gvo.gradeName}</span>
                    </div>
                    <div class="panel-item">
                        <span>할인율:</span> <span class="panel-data">${gvo.discount}%</span>
                    </div>
                    <hr style="border: 0; height: 1px; background: linear-gradient(to right, #ccc, #333, #ccc);">
                    <c:choose>
                        <c:when test="${gvo.gradeName != '마스터'}">
                            <div class="panel-item next-grade">
                                <span>다음 등급까지 남은 금액:</span> <span class="panel-data">${gcvo.bpAmount -
                                    gvo.totalPurchaseAmount}원</span>
                            </div>
                            <div class="panel-item next-grade">
                                <span>다음 등급까지 남은 후기:</span> <span class="panel-data">${gcvo.getRCount() -
                                    gvo.totalReviewCount}개</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="panel-item next-grade" style="justify-content: center;">
                                최고 등급입니다!
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </body>

        </html>