<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>고객문의</title>
</head>

<script type="text/javascript">
    $(document).ready(function () {
        var search = "${param.search}";

        if (search !== "") {
            $("#search").val(search);
        }

        if (search === "all") {
            $("#search_text").val("");
        }
    });

    function find() {
        let search = $("#search").val();
        let search_text = $("#search_text").val().trim();

        if (search != "all" && search_text == "") {
            alert("검색어를 입력하세요");
            $("#search_text").val("");
            $("#search_text").focus();
            return;
        }

        location.href = "inquiry.do?search=" + search + "&search_text=" + encodeURIComponent(search_text, "utf-8");
    }

    function check_user(inIdx, userIdx) {
        var currentUserIdx = "${not empty user ? user.userIdx : -1}";
        var isAdmin = "${user.adminAt}" == "Y";

        if ((userIdx == currentUserIdx || isAdmin) && currentUserIdx != -1) {
            location.href = "inquirySelect.do?inIdx=" + inIdx;
        } else {
            alert("해당 내용은 관리자와 본인만 확인 가능합니다.");
        }
    }

    function viewDetail(inIdx) {
        // 상세 페이지로 이동
        location.href = "inquirySelect.do?inIdx=" + inIdx;
    }
</script>

<body>
    <%@ include file="../menubar/navbar.jsp" %>
    <br><br><br><br><br>
    <div class="container div-size" style="min-height: 1000px;">
        <div class="row">
            <div class="col-md-8 col-md-offset-2">
                <div class="row">
                    <div class="col-md-6">
                        <h2>게시글 목록</h2>
                    </div>
                    <div class="col-md-6 text-right" style="margin-top: 20px;">
                        <c:if test="${ not empty user }">
                            <button type="button" class="btn btn-primary"
                                onclick="location.href='inquiryWriteForm.do'">게시글 등록</button>
                        </c:if>
                    </div>
                </div>

                <!-- 검색메뉴 -->
                <div style="text-align: right; margin-bottom: 5px;">
                    <form action="" class="form-inline">
                        <select id="search" class="form-control">
                            <option value="all">전체보기</option>
                            <option value="id">아이디</option>
                            <option value="inType">제목</option>
                        </select>

                        <input id="search_text" class="form-control" value="${ param.search_text }">
                        <input type="button" class="btn btn-primary" value="검색" onclick="find();">
                    </form>
                </div>

                <table class="table table-striped" style="margin-top: 20px; table-layout: fixed;">
                    <thead>
                        <tr>
                            <th style="width: 15%; text-align: center;">번호</th>
                            <th style="width: 15%; text-align: center;">아이디</th>
                            <th style="width: 35%; text-align: center;">제목</th>
                            <th style="width: 25%; text-align: center;">작성일</th>
                            <th style="width: 20%; text-align: center;">답변 여부</th>
                        </tr>
                    </thead>
                    <tbody style="background-color: white; border: 1px solid black;">
                        <!-- 공지사항 먼저 출력 -->
                        <c:forEach var="vo" items="${list}">
                            <c:if test="${vo.inAc eq 'Y'}">
                                <tr onclick="viewDetail('${vo.inIdx}');">
                                    <td style="text-align: center; background-color: #f1f1f1; color: #303030; ">공지사항
                                    </td>
                                    <td style="text-align: center; background-color: #f1f1f1; color: #303030; ">관리자</td>
                                    <td
                                        style="width: 45%; text-align: center; background-color: #f1f1f1; color: #303030; ">
                                        ${vo.inType}</td>
                                    <td
                                        style="width: 25%; text-align: center; background-color: #f1f1f1; color: #303030; ">
                                        ${vo.inDate}</td>
                                    <td
                                        style="width: 20%; text-align: center; background-color: #f1f1f1; color: #303030; "> 공지사항
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>

                        <c:forEach var="vo" items="${list}">
                            <c:if test="${vo.inAc ne 'Y'}">
                                <tr onclick="check_user('${vo.inIdx}', '${vo.userIdx}');">
                                    <td style="text-align: center; background-color: #303030; color: #f1f1f1;">
                                        ${vo.inIdx}</td>
                                    <td style="text-align: center; background-color: #303030; color: #f1f1f1;">
                                        ${vo.id}</td>
                                    <td
                                        style="width: 45%; text-align: center; background-color: #303030; color: #f1f1f1;">
                                        <c:if test="${vo.getPIdx() ne null}">(상품)</c:if> ${vo.inType}
                                    </td>
                                    <td
                                        style="width: 25%; text-align: center; background-color: #303030; color: #f1f1f1;">
                                        ${vo.inDate}
                                    </td>
                                    <td
                                        style="width: 20%; text-align: center; background-color: #303030; color: #f1f1f1;">
                                        <c:choose>
                                            <c:when test="${answerMap[vo.inIdx] eq true}">답변 완료</c:when>
                                            <c:otherwise>답변 미완료</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- 페이지 메뉴 -->
                <div class="pagination-container" style="text-align: center;">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">${pageMenu}</ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>

</body>

</html>