<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html>

    <head>
        <!-- Bootstrap 3.x-->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
        <meta charset="UTF-8">
        <title>Admin Page</title>
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
                background: #1a1a1a;
                /* 더 어두운 배경 */
                color: #e0e0e0;
                /* 부드러운 흰색 텍스트 */
                padding-top: 20px;
                min-height: 70px;
            }

            header a {
                color: #e0e0e0;
                text-decoration: none;
                text-transform: uppercase;
                font-size: 16px;
                transition: color 0.3s ease;
            }

            header a:hover {
                color: #00bcd4;
                /* 호버 시 강조된 색상 (파란색 톤) */
            }

            header ul {
                margin: 30px;
                padding: 0;
                list-style: none;
                display: flex;
                justify-content: space-between;
            }

            header ul li {
                width: 25%;
                text-align: center;
            }

            #content {
                background: #fff;
                height: 850px;
                margin-bottom: 50px;
                padding: 20px;
            }

            /* $$$$$$$$ */

            table {

                text-align: center;
                width: 100%;
                border-collapse: collapse;
            }

            th,
            td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }

            th {
                background-color: #f2f2f2;
                width: 12.5%;
                /* 예시로 전체 열 너비를 12.5%로 설정 */
            }


            #menu2 {
                margin: auto;
                width: 80%;
            }

            #menu2 td {

                text-align: center;
            }

            #menu2 th {

                text-align: center;
            }

            #menu3 td {
                text-align: center;
            }

            #menu3 th {
                width: 100px;
                text-align: center;
            }

            select {
                display: inline-block;
                width: 97px;
            }

            #searchs {
                display: inline-block;
            }

            #searchParam {
                width: 300px;
            }



            /* 모든 관리 페이지의 테이블을 동일한 너비로 설정 */
            .table-common {
                width: 80%;
                /* 원하는 너비로 수정 가능 (예: 80%, 600px 등) */
                margin: auto;
                /* 중앙 정렬 */
                border-collapse: collapse;
            }

            .table-common th,
            .table-common td {
                border: 1px solid #ddd;
                padding: 6px;
                /* 기존의 padding을 줄여서 높이를 맞춤 */
                line-height: 1.2em;
                /* line-height를 지정하여 텍스트 높이를 통일 */
                text-align: center;
                vertical-align: middle;
                /* 텍스트를 중앙에 배치 */
            }

            .table-common th {
                background-color: #f2f2f2;
                font-weight: bold;
            }

            .title-center {
                text-align: left;
                font-size: 24px;
                font-weight: bold;
                margin-left: 200px;
            }


            /* 검색 섹션 간격 조정 */
            .search-section {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-bottom: 15px;
            }

            .search-section form {
                display: flex;
                justify-content: center;
                align-items: center;
            }
        </style>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <script>
            function confirmDelete(f) {
                if (confirm("정말 삭제하시겠습니까?") == false) return;

                f.action = "delete.do";
                f.submit();
            }


            function confirmProductDelete(f) {
                if (confirm("정말 삭제하시겠습니까?") == false) return;
                f.action = "pDelete.do";
                f.submit();
            }

            function pUpdate(f) {
                // let pIdx = f.pIdx.value;
                // let categoryName = f.categoryName.value;
                // let mcategoryName = f.mcategoryName.value;
                // let dcategoryName = f.dcategoryName.value;
                // let pName = f.pName.value;
                // let amount = f.amount.value;
                // let price = f.price.value;
                if (confirm("수정하시겠습니까?") == false) return;
                f.action = "pUpdateForm.do";
                f.submit();
            }

            function mcategoryName(val) {
                // 대분류가 전체보기일 때
                if ($("#categorySearch").val() == '전체보기') {
                    let categoryName = val;
                    $.ajax({
                        url: "/admin/adminPListAjax.do",
                        data: {
                            "categoryName": categoryName
                        },
                        dataType: "json",
                        method: 'GET',
                        success: function (res_data) {
                            var mSelect = $('#mcategorySearch');
                            var dSelect = $('#dcategorySearch');
                            var searchParam = $('#searchParam');

                            searchParam.val("");
                            mSelect.empty();
                            dSelect.empty();
                            mSelect.append($('<option></option>').val('선택 안 함').text('선택 안 함'))
                            dSelect.append($('<option></option>').val('선택 안 함').text('선택 안 함'))
                        },
                        error: function (err) {
                            console.log(err.responseText);
                        }
                    });
                    return;
                }
                // 대분류가 전체보기가 아닐 때
                let categoryName = val;
                $.ajax({
                    url: "/admin/adminCategoryAjax.do",
                    data: {
                        "categoryName": categoryName
                    },
                    dataType: "json",
                    method: 'GET',
                    success: function (data) {
                        var mselect = $('#mcategorySearch');
                        var dselect = $('#dcategorySearch');
                        mselect.empty();
                        dselect.empty();
                        mselect.append($('<option disabled selected hidden></option>').val('중분류 선택').text(
                            '중분류 선택'))
                        mselect.append($('<option></option>').val('선택 안 함').text('선택 안 함'))
                        dselect.append($('<option disabled selected hidden></option>').val('소분류 선택').text(
                            '소분류 선택'))
                        dselect.append($('<option></option>').val('선택 안 함').text('선택 안 함'))
                        $.each(data, function (index, item) {
                            mselect.append($('<option></option>').val(item.mcategoryName).text(item
                                .mcategoryName));
                        });
                    },
                    error: function (err) {
                        console.log(err.responseText);
                    }
                });
            }

            function dcategoryName(val) {
                let categoryName = $("#categorySearch").val();
                if (val == '선택 안 함') {
                    let mcategoryName = val;
                    $.ajax({
                        url: "/admin/adminCategoryAjax.do",
                        data: {
                            "mcategoryName": mcategoryName, "categoryName": categoryName
                        },
                        dataType: "json",
                        method: 'GET',
                        success: function (res_data) {
                            var dSelect = $('#dcategorySearch');
                            dSelect.empty();
                            dSelect.append($('<option></option>').val('선택 안 함').text('선택 안 함'))
                        },
                        error: function (err) {
                            console.log(err.responseText);
                        }
                    });
                    return;
                }
                let mcategoryName = val;
                $.ajax({
                    url: "/admin/adminCategoryAjax.do",
                    data: {
                        "mcategoryName": mcategoryName, "categoryName": categoryName
                    },
                    dataType: "json",
                    method: 'GET',
                    success: function (res_data) {
                        console.log(res_data)
                        var dselect = $('#dcategorySearch');
                        dselect.empty();
                        dselect.append($('<option disabled selected hidden></option>').val('소분류 선택').text(
                            '소분류 선택'))
                        dselect.append($('<option></option>').val('선택 안 함').text('선택 안 함'))
                        $.each(res_data, function (index, item) {
                            dselect.append($('<option></option>').val(item.dcategoryName).text(item
                                .dcategoryName));
                        });
                    },
                    error: function (err) {
                        console.log(err.responseText);
                    }
                });
            }

            function pSearch() {
                let searchParam = $("#searchParam").val().trim();
                let categoryName = $("#categorySearch").val();
                let mcategoryName = $("#mcategorySearch").val();
                let dcategoryName = $("#dcategorySearch").val();

                if (categoryName == '대분류 선택') {
                    if (searchParam == "") {
                        alert('카테고리를 선택하거나 검색어를 입력하세요')
                        f.searchParam.focus();
                        return;
                    }
                    categoryName = "";
                }

                if (categoryName == "전체보기" && searchParam == "") {
                    $.ajax({
                        url: "/admin/adminPListAjax.do",
                        dataType: "json",
                        method: 'GET',
                        success: function (res_data) {
                            var pListHtml = ``;
                            $.each(res_data, function (index, pVo) {
                                pListHtml += `
                            <table>
                                <tr id="p_th">
                                    <th>상품번호</th>
                                    <th>대분류</th>
                                    <th>중분류</th>
                                    <th>소분류</th>
                                    <th>상품이름</th>
                                    <th>상품갯수</th>
                                    <th>상품가격</th>
                                    <th>작업</th>
                                </tr>
                                <tr>
                                    <td>\${pVo.pidx}</td>
                                    <td>\${pVo.categoryName}</td>
                                    <td>\${pVo.mcategoryName}</td>
                                    <td>\${pVo.dcategoryName}</td>
                                    <td>\${pVo.pname}</td>
                                    <td>\${pVo.amount}</td>
                                    <td>\${pVo.price}</td>
                                    <td>
                                        <form>
                                            <input type="hidden" name="pIdx" value="\${pVo.pidx}">
                                            <input type="hidden" name="categoryName" value="\${pVo.categoryName}">
                                            <input type="hidden" name="mcategoryName" value="\${pVo.mcategoryName}">
                                            <input type="hidden" name="dcategoryName" value="\${pVo.dcategoryName}">
                                            <input type="hidden" name="pName" value="\${pVo.pname}">
                                            <input type="hidden" name="amount" value="\${pVo.amount}">
                                            <input type="hidden" name="price" value="\${pVo.price}">
                                            <input type="button" class="btn btn-default" value="수정" onclick="pUpdate(this.form);">
                                        </form>
                                        <form>
                                            <input type="hidden" name="pIdx" value="\${pVo.pidx}">
                                            <input type="button" class="btn btn-danger" value="삭제" onclick="confirmProductDelete(this.form);">
                                        </form>
                                    </td>
                                </tr>
                            </table><br><br>`
                            });
                            // HTML을 특정 컨테이너에 삽입
                            $("#pList").html(pListHtml);
                        },
                        error: function (err) {
                            console.log(err.responseText);
                        }
                    });
                } else if (categoryName == "전체보기" && searchParam != "") {
                    alert("카테고리가 '전체보기'일 경우 검색어를 입력할 수 없습니다.")
                    f.searchParam.value = "";
                    return;
                }

                if (mcategoryName == '선택 안 함') {
                    mcategoryName = "";
                }

                if (dcategoryName == '선택 안 함') {
                    dcategoryName = "";
                }

                $.ajax({
                    url: "/admin/adminPListAjax.do",
                    data: {
                        "searchParam": searchParam,
                        "categoryName": categoryName,
                        "mcategoryName": mcategoryName,
                        "dcategoryName": dcategoryName
                    },
                    dataType: "json",
                    method: 'GET',
                    success: function (res_data) {
                        if (res_data.length == 0) {
                            alert("검색결과가 없습니다");
                            return;
                        }
                        var pListHtml = ``;
                        $.each(res_data, function (index, pVo) {
                            pListHtml += `
                            <table>
                                <tr id="p_th">
                                    <th>상품번호</th>
                                    <th>대분류</th>
                                    <th>중분류</th>
                                    <th>소분류</th>
                                    <th>상품이름</th>
                                    <th>상품갯수</th>
                                    <th>상품가격</th>
                                    <th>작업</th>
                                </tr>
                                <tr>
                                    <td>\${pVo.pidx}</td>
                                    <td>\${pVo.categoryName}</td>
                                    <td>\${pVo.mcategoryName}</td>
                                    <td>\${pVo.dcategoryName}</td>
                                    <td>\${pVo.pname}</td>
                                    <td>\${pVo.amount}</td>
                                    <td>\${pVo.price}</td>
                                    <td>
                                        <form>
                                            <input type="hidden" name="pIdx" value="\${pVo.pidx}">
                                            <input type="hidden" name="categoryName" value="\${pVo.categoryName}">
                                            <input type="hidden" name="mcategoryName" value="\${pVo.mcategoryName}">
                                            <input type="hidden" name="dcategoryName" value="\${pVo.dcategoryName}">
                                            <input type="hidden" name="pName" value="\${pVo.pname}">
                                            <input type="hidden" name="amount" value="\${pVo.amount}">
                                            <input type="hidden" name="price" value="\${pVo.price}">
                                            <input type="button" class="btn btn-default" value="수정" onclick="pUpdate(this.form);">
                                        </form>
                                        <form>
                                            <input type="hidden" name="pIdx" value="\${pVo.pidx}">
                                            <input type="button" class="btn btn-danger" value="삭제" onclick="confirmProductDelete(this.form);">
                                        </form>
                                    </td>
                                </tr>
                            </table><br><br>`
                        });
                        // HTML을 특정 컨테이너에 삽입
                        $("#pList").html(pListHtml);
                    },
                    error: function (err) {
                        console.log(err.responseText);
                    }
                });
                return;
            }

            function nModifyForm(f) {
                console.log(f);
                f.action = "${pageContext.request.contextPath}/admin/nModifyForm.do"; // 전송대상
                f.submit(); // 전송
            }

            function pInsert() {
                location.href = "/admin/pInsertForm.do";
            }

            function nInsert() {
                location.href = "${pageContext.request.contextPath}/admin/nInsertForm.do";
            }

            function confirmNoticeDelete(f) {
                if (confirm("정말 삭제하시겠습니까?") == false) return;

                f.action = "nDelete.do";
                f.submit();
            }

            function find() {
                // 검색 조건과 검색어 가져오기
                var searchType = document.getElementById('search').value;
                var searchText = document.getElementById('search_text').value;

                // URL에 검색 조건과 검색어를 쿼리 파라미터로 추가
                var query = '';
                if (searchType === 'name') {
                    query = '?searchType=id&searchText=' + encodeURIComponent(searchText); // 'id'로 검색
                } else {
                    query = '?searchType=all';
                }

                // 검색 요청을 보낼 URL 설정 (현재 페이지에서 검색)
                var url = 'admin.do' + query;

                // 페이지 이동
                window.location.href = url;
            }
            $(document).ready(function () {
                $('#searchParam').on('keypress', function (event) {
                    if (event.key === 'Enter') {
                        event.preventDefault();
                        pSearch();
                    }
                });
            });
        </script>

    </head>

    <body>
        <%@ include file="../menubar/navbar.jsp" %>
            <header>
                <div>
                    <h1>Admin Dashboard</h1>
                    <ul class="nav nav-tabs">
                        <li class="disactive active"><a data-toggle="tab" href="#menu1">회원 관리</a></li>
                        <li class="disactive"><a data-toggle="tab" href="#menu2">상품 관리</a></li>
                        <li class="disactive"><a data-toggle="tab" href="#menu3">주문 관리</a></li>
                        <li class="disactive"><a data-toggle="tab" href="#menu4">공지사항 관리</a></li>
                    </ul>
                </div>
            </header>

            <div class="tab-content" style="min-height: 850px;">
                <div id="menu1" class="tab-pane fade in active">
                    <h2 class="title-center">회원 관리</h2>

                    <!-- 검색메뉴 -->
                    <div style="text-align: left;  margin-top: 25px; margin-bottom: 20px; margin-left: 200px;">
                        <form action="" class="form-inline" style="display: inline-block;">
                            <select id="search" class="form-control" style="width: 200px; margin-right: 10px;">
                                <option value="all">전체보기</option>
                                <option value="name">아이디</option>
                            </select>

                            <input id="search_text" class="form-control" style="width: 300px; margin-right: 1px;"
                                value="${ param.search_text }">
                            <input type="button" class="btn btn-default" name="searchBtn" id="searchBtn" value="검색"
                                onclick="find();">
                        </form>
                    </div>

                    <c:choose>
                        <c:when test="${empty list}">
                            <!-- list2가 null이거나 비어있을 때 표시할 내용 -->
                            <h1 style="text-align: center;">내역이 없습니다.</h1>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="vo" items="${list}">
                                <table class="table-common">
                                    <tr>
                                        <th style="width: 16.67%;">회원 ID</th> <!-- 1 비율 -->
                                        <th style="width: 16.67%;">이름</th> <!-- 1 비율 -->
                                        <th style="width: 25%;">이메일</th> <!-- 1.5 비율 -->
                                        <th style="width: 16.67%;">가입일</th> <!-- 1 비율 -->
                                        <th style="width: 16.67%;">보유포인트</th> <!-- 1 비율 -->
                                        <th style="width: 8.33%;">회원삭제</th> <!-- 0.5 비율 -->
                                    </tr>
                                    <tr>
                                        <td>${vo.getId()}</td>
                                        <td>${vo.getName()}</td>
                                        <td>${vo.getEmail()}</td>
                                        <td>${vo.getCreateAt()}</td>
                                        <td>${vo.getPoint()}</td>
                                        <td>
                                            <form>
                                                <input type="hidden" name="userIdx" value="${vo.getUserIdx()}">
                                                <input type="button" value="삭제" class="btn btn-danger"
                                                    onclick="confirmDelete(this.form);"
                                                    style="display: block; margin: auto; text-align: center;">
                                            </form>
                                        </td>
                                    </tr>
                                </table>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div id="menu2" class="tab-pane">

                    <div style="display: flex; justify-content: space-between; margin-bottom: 3px;">
                        <h2 style="font-size: 24px; font-weight: bold; margin-top: 22px;">상품 관리</h2>

                        <input type="button" class="btn btn-primary" name="pInsert" id="pInsert" onclick="pInsert();"
                            value="상품 등록" style="margin-top: 22px; margin-right: 5px;">
                    </div>
                    <div class="form-group" style="display: inline-block;">
                        <select class="form-control" name="categorySearch" id="categorySearch"
                            onchange="mcategoryName(this.value);" style="width: 150px;">
                            <option value="대분류 선택" hidden selected>대분류 선택</option>
                            <option value="전체보기">전체보기</option>
                            <c:forEach var="vo" items="${categoryName}">
                                <option value="${vo.getCategoryName()}">${vo.getCategoryName()}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group" style="display: inline-block;">
                        <select class="form-control" name="mcategorySearch" id="mcategorySearch"
                            onchange="dcategoryName(this.value);" style="width: 150px;">
                            <option value="중분류 선택" hidden selected disabled>중분류 선택</option>
                            <option value="선택 안 함">선택 안 함</option>
                        </select>
                    </div>

                    <div class="form-group" style="display: inline-block;">
                        <select class="form-control" name="dcategorySearch" id="dcategorySearch" style="width: 150px;">
                            <option value="소분류 선택" hidden selected disabled>소분류 선택</option>
                            <option value="선택 안 함">선택 안 함</option>
                        </select>
                    </div>

                    <form id="searchs">
                        <input type="text" name="searchParam" id="searchParam" style="height: 35px;"
                            placeholder="상품명을 입력하세요" autofocus>
                        <input type="button" class="btn btn-default" name="searchBtn" id="searchBtn" value="검색"
                            onclick="pSearch(this.form);">
                    </form>
                    <c:choose>
                        <c:when test="${empty pList}">
                            <h1 style="text-align: center;">내역이 없습니다.</h1>
                        </c:when>
                        <c:otherwise>
                            <div id="pList">
                                <c:forEach var="pVo" items="${pList}">
                                    <table style="margin-top: 10px;">
                                        <tr id="p_th">
                                            <th style="padding: 6px;">상품번호</th>
                                            <th>대분류</th>
                                            <th>중분류</th>
                                            <th>소분류</th>
                                            <th>상품이름</th>
                                            <th>상품갯수</th>
                                            <th>상품가격</th>
                                            <th>작업</th>
                                        </tr>
                                        <tr style="text-align: center;">
                                            <td style="padding: 6px;">${pVo.getPIdx()}</td>
                                            <td>${pVo.getCategoryName()}</td>
                                            <td>${pVo.getMcategoryName()}</td>
                                            <td style="padding: 12px;">${pVo.getDcategoryName()}</td>
                                            <td>${pVo.getPName()}</td>
                                            <td>${pVo.getAmount()}</td>
                                            <td>${pVo.getPrice()}</td>
                                            <td>
                                                <form style="display: inline-block;">
                                                    <input type="hidden" name="pIdx" value="${pVo.getPIdx()}">
                                                    <input type="hidden" name="categoryName"
                                                        value="${pVo.getCategoryName()}">
                                                    <input type="hidden" name="mcategoryName"
                                                        value="${pVo.getMcategoryName()}">
                                                    <input type="hidden" name="dcategoryName"
                                                        value="${pVo.getDcategoryName()}">
                                                    <input type="hidden" name="pName" value="${pVo.getPName()}">
                                                    <input type="hidden" name="amount" value="${pVo.getAmount()}">
                                                    <input type="hidden" name="price" value="${pVo.getPrice()}">
                                                    <input type="button" class="btn btn-default" value="수정"
                                                        onclick="pUpdate(this.form);">
                                                </form>
                                                <form style="display: inline-block;">
                                                    <input type="hidden" name="pIdx" value="${pVo.getPIdx()}">
                                                    <input type="button" class="btn btn-danger" value="삭제"
                                                        onclick="confirmProductDelete(this.form);">
                                                </form>
                                            </td>
                                        </tr>
                                    </table>
                                    <br>
                                    <br>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div id="menu3" class="tab-pane">
                    <div style="display: inline-block;">
                        <h2 class="title-center">주문 관리</h2>
                    </div>
                    <div style="text-align: left; margin-top: 5px; margin-bottom: 16px; margin-left: 200px;">
                        <form id="searchs">
                            <input type="text" name="searchParam" id="searchParam" style="height: 35px;"
                                placeholder="구매자명을 입력하세요" autofocus>
                            <input type="button" class="btn btn-default" name="searchBtn" id="searchBtn" value="검색"
                                onclick="">
                        </form>
                    </div>

                    <c:choose>
                        <c:when test="${empty buyList}">
                            <h1 style="text-align: center;">주문 받은 내역이 없습니다.</h1>
                        </c:when>
                        <c:otherwise>
                            <div id="buyList">
                                <c:forEach var="bVo" items="${buyList}">
                                    <table class="table-common">
                                        <tr id="b_th">
                                            <th>상품번호</th>
                                            <th>대분류</th>
                                            <th>중분류</th>
                                            <th>소분류</th>
                                            <th>상품이름</th>
                                            <th>구매갯수</th>
                                            <th>구매금액</th>
                                            <th>구매자</th>
                                            <th>구매일자</th>
                                            <th>처리</th> <!-- 환불과 교환 버튼을 위한 컬럼 추가 -->
                                        </tr>
                                        <tr>
                                            <td>${bVo.getPIdx()}</td>
                                            <td>${bVo.getCategoryName()}</td>
                                            <td>${bVo.getMcategoryName()}</td>
                                            <td>${bVo.getDcategoryName()}</td>
                                            <td>${bVo.getPName()}</td>
                                            <td>${bVo.getBamount()}</td>
                                            <td>${bVo.getBuyPrice()}</td>
                                            <td>${bVo.getName()}</td>
                                            <td>${bVo.getBuyDate()}</td>
                                            <td>
                                                <form style="display: inline;">
                                                    <input type="hidden" name="pIdx" value="${bVo.getPIdx()}">
                                                    <input type="hidden" name="bIdx" value="${bVo.getBIdx()}">
                                                    <input type="hidden" name="categoryName"
                                                        value="${bVo.getCategoryName()}">
                                                    <input type="hidden" name="mcategoryName"
                                                        value="${bVo.getMcategoryName()}">
                                                    <input type="hidden" name="dcategoryName"
                                                        value="${bVo.getDcategoryName()}">
                                                    <input type="hidden" name="pName" value="${bVo.getPName()}">
                                                    <input type="hidden" name="amount" value="${bVo.getBamount()}">
                                                    <input type="hidden" name="price" value="${bVo.getBuyPrice()}">
                                                    <input type="hidden" name="orderNumber"
                                                        value="${bVo.getOrderNumber()}">
                                                    <input type="button" class="btn btn-danger" value="환불"
                                                        onclick="cancelPay(this.form)">
                                                </form>
                                                <form style="display: inline; margin-left: 5px;">
                                                    <input type="hidden" name="pIdx" value="">
                                                    <input type="button" class="btn btn-warning" value="교환" onclick="">
                                                </form>
                                            </td>
                                        </tr>
                                    </table>
                                    <br>
                                    <br>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- 공지사항 관리 탭 -->
                <div id="menu4" class="tab-pane">
                    <div style="display: inline-block;">
                        <h2 class="title-center">공지사항 관리</h2>
                        <input type="button" class="btn btn-default" name="nInsert" id="nInsert" onclick="nInsert();"
                            style="text-align: left;  margin-top: 20px; margin-bottom: 17px; margin-left: 200px;"
                            value="공지사항 등록">
                    </div>
                    <c:choose>
                        <c:when test="${empty list2}">
                            <h1 style="text-align: center;">공지사항이 없습니다.</h1>
                        </c:when>
                        <c:otherwise>
                            <table class="table-common">
                                <tr>
                                    <th style="width: 10%;">제목</th>
                                    <th style="width: 60%;">내용</th>
                                    <th style="width: 15%;">작성일</th>
                                    <th style="width: 15%;">작업</th>
                                </tr>
                                <c:forEach var="vo" items="${list2}">
                                    <tr>
                                        <td>${vo.inType}</td>
                                        <td>${vo.inContent}</td>
                                        <td>${vo.inDate}</td>
                                        <td>
                                            <form style="display: inline;">
                                                <input type="hidden" name="inType" value="${vo.inType}" />
                                                <input type="hidden" name="inContent" value="${vo.inContent}" />
                                                <input type="hidden" name="inIdx" value="${vo.inIdx}" />
                                                <input type="button" class="btn btn-success" name="nModify" id="nModify"
                                                    onclick="nModifyForm(this.form);" value="수정" />
                                            </form>
                                            <form style="display: inline; margin-left: 5px;">
                                                <input type="hidden" name="inIdx" value="${vo.getInIdx()}">
                                                <input type="button" class="btn btn-danger" value="삭제"
                                                    onclick="confirmNoticeDelete(this.form);">
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <!-- 푸터 -->
            <%@ include file="../menubar/footer.jsp" %>

                <!-- 환불 취소 요청하기 -->
                <script src="https://code.jquery.com/jquery-3.3.1.min.js"
                    integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous">
                    </script>
                <script>
                    function cancelPay(f) {
                        var merchant_uid = f.orderNumber.value;
                        var cancel_request_amount = f.price.value;
                        var bIdx = f.bIdx.value; // bIdx를 가져오기
                        var reason = "환불사유:" + bIdx; // 환불 사유에 bIdx 포함
                        console.log(merchant_uid);
                        console.log(cancel_request_amount);

                        jQuery.ajax({
                            //url: "../buyList/cancel.do", // 환불 요청을 처리할 서버 엔드포인트
                            url: "cancel",
                            type: "POST",
                            contentType: "application/json",
                            data: JSON.stringify({
                                merchant_uid: f.orderNumber.value, // 주문번호
                                cancel_request_amount: f.price.value, // 환불 금액
                                reason: reason // 환불 사유
                            }),
                            dataType: "json",
                            success: function (result) {
                                if (result.code === 0) {
                                    alert("환불 성공");
                                } else {
                                    alert("환불 실패");
                                }
                            },
                            error: function (err) {
                                alert("환불 요청 중 오류 발생: " + err.responseText);
                            }
                        });
                    }
                </script>

    </body>

    </html>