<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function send1(f) {
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

            f.action = "reviewWrite.do";
            f.submit();
        }

        function send2(f) {
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

            f.action = "reviewModify.do"; // 리뷰 수정 전송
            f.submit();
        }

        function check_user(rvIdx, userIdx) {
            if ("${not empty user}") {
                if ("${user.userIdx}" == userIdx) {
                    // AJAX 요청으로 리뷰 정보를 가져와서 모달에 채워넣기
                    $.ajax({
                        url: 'getReviewInfo.do',
                        type: 'GET',
                        data: { rvIdx: rvIdx },
                        success: function(data) {
                            // 모달을 열고 데이터를 채웁니다.
                            $('#reviewModifyModal').show();
                            $('textarea[name="rvContent"]').val(data.rvContent);
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
    </script>
    <style>
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgb(0,0,0);
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>

<body>
    <%@ include file="../menubar/navbar.jsp" %>
    <br><br><br><br><br>
    <div class="container div-size" style="min-height: 1000px;">
        <div class="row">
            <div class="col-md-8 col-md-offset-2">
                <div class="row">
                    <div class="col-md-6">
                        <h2>리뷰 목록</h2>
                    </div>
                    <div class="col-md-6 text-right" style="margin-top: 20px;">
                        <c:if test="${ not empty user }">
                            <button type="button" class="btn btn-primary" id="openReviewModal">리뷰 등록</button>
                        </c:if>
                    </div>
                </div>

                <table class="table table-striped" style="margin-top: 20px; table-layout: fixed;">
                    <thead>
                        <tr>
                            <th style="text-align: center;">작성자</th>
                            <th style="text-align: center;">내용</th>
                            <th style="text-align: center;">별점</th>
                            <th style="width: 25%; text-align: center;">작성일</th>
                        </tr>
                    </thead>
                    <tbody style="background-color: white;">
                        <c:if test="${not empty user}">
                            <c:forEach var="vo" items="${list}">
                                <tr onclick="check_user('${vo.rvIdx}', '${vo.userIdx}');">
                                    <td style="text-align: center; background-color: #f1f1f1; color: #303030;">
                                        ${vo.nickName}</td>
                                    <td style="text-align: center; background-color: #f1f1f1; color: #303030;">
                                        ${vo.rvContent}</td>
                                    <td style="text-align: center; background-color: #f1f1f1; color: #303030;">
                                        ${vo.reviewPoint}점</td>
                                    <td style="width: 25%; text-align: center; background-color: #f1f1f1; color: #303030;">
                                        ${vo.rvDate}</td>
                                </tr>
                            </c:forEach>
                        </c:if>
                    </tbody>
                </table>
                <c:if test="${empty user}">
                    <h1 style="text-align: center; margin-top: 50px;">로그인 후에 이용해주세요.</h1>
                </c:if>
            </div>
        </div>
        <c:if test="${not empty user}">
            <!-- 페이지 메뉴 -->
            <div class="pagination-container" style="text-align: center;">
                <nav aria-label="Page navigation">
                    <ul class="pagination">${pageMenu}
                    </ul>
                </nav>
            </div>
        </c:if>
    </div>

    <!-- 리뷰 작성 모달 -->
    <div id="reviewModal" class="modal">
        <div class="modal-content">
          <span class="close" onclick="document.getElementById('reviewModal').style.display='none'">&times;</span>
          <h2>리뷰 작성</h2>
          <form>
            <input type="hidden" name="userIdx" value="${user.userIdx}" />
            상품번호 : <input type="text" name="pIdx" value="1"/><br>
            <div class="form-group" style="color: black;">
                <label for="content" style="color: black;">내용</label>
                <textarea name="rvContent" required style="width: 100%; min-height: 400px;"></textarea>
            </div>
            <button type="button" class="btn btn-primary" onclick="send1(this.form)">등록</button>
          </form>
        </div>
    </div>

    <!-- 리뷰 수정 모달 -->
    <div id="reviewModifyModal" class="modal">
        <div class="modal-content">
          <span class="close" onclick="document.getElementById('reviewModifyModal').style.display='none'">&times;</span>
          <h2>리뷰 수정</h2>
          <form>
            <input type="hidden" name="rvIdx" />
            <input type="hidden" name="userIdx" value="${user.userIdx}" />
            <div class="form-group" style="color: black;">
                <label for="content" style="color: white;">내용</label>
                <textarea name="rvContent" required style="width: 100%; min-height: 400px;"></textarea>
            </div>
            <button type="button" class="btn btn-primary" onclick="send2(this.form)">등록</button>
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
</body>
</html>
