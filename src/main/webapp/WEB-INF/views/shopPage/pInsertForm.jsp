<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

            <!DOCTYPE html>
            <html lang="ko">

            <head>
                <meta charset="UTF-8">
                <title>상품등록</title>
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

                <style>
                    body {
                        padding: 20px;
                        background-color: #f7f7f7;
                    }

                    .form-container {
                        background-color: #fff;
                        padding: 20px;
                        border-radius: 8px;
                        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                        max-width: 800px;
                        margin: 0 auto;
                    }

                    h2 {
                        text-align: center;
                        margin-bottom: 20px;
                    }

                    table {
                        width: 100%;
                        margin-bottom: 20px;
                    }

                    th,
                    td {
                        padding: 10px;
                        text-align: left;
                    }

                    th {
                        background-color: #f8f8f8;
                        border-bottom: 1px solid #ddd;
                    }

                    td input,
                    td select,
                    td textarea {
                        width: 100%;
                        padding: 8px;
                        border: 1px solid #ccc;
                        border-radius: 4px;
                    }

                    .btn {
                        width: 120px;
                        margin: 10px;
                    }

                    .form-actions {
                        text-align: center;
                        margin-top: 20px;
                    }

                    textarea {
                        resize: none;
                        height: 150px;
                    }
                </style>

                <script>
                    function pInsert(f) {
                        let pName = f.pName.value.trim();
                        let price = f.price.value.trim();
                        let pEx = f.pEx.value.trim();
                        let categoryName = f.categoryName.value;
                        let mcategoryName = f.mcategoryName.value;
                        let dcategoryName = f.dcategoryName.value;
                        let amount = f.amount.value;

                        const numberRegex = /^[0-9]+$/;

                        if (categoryName == '대분류선택') {
                            alert("대분류를 선택하세요");
                            return;
                        }
                        if (mcategoryName == '중분류선택') {
                            alert("중분류를 선택하세요");
                            return;
                        }
                        if (dcategoryName == '소분류선택') {
                            alert("소분류를 선택하세요");
                            return;
                        }
                        if (pName == "") {
                            alert("상품명을 입력하세요");
                            $("#pName").focus();
                            return;
                        }
                        if (amount == "") {
                            alert("수량을 입력하세요");
                            $("#amount").focus();
                            return;
                        }
                        if (!numberRegex.test(amount)) {
                            alert("상품수량에는 숫자만 입력가능합니다");
                            $("#amount").val("");
                            $("#amount").focus();
                            return;
                        }
                        if (price == "") {
                            alert("가격을 입력하세요");
                            $("#price").focus();
                            return;
                        }
                        if (!numberRegex.test(price)) {
                            alert("가격은 숫자만 입력가능합니다");
                            $("#price").val("");
                            $("#price").focus();
                            return;
                        }
                        if (pEx == "") {
                            alert("상품설명을 입력하세요");
                            $("#pEx").focus();
                            return;
                        }
                        if (confirm("등록하시겠습니까?") == false) {
                            return;
                        }

                        f.method = "POST";
                        f.enctype = "multipart/form-data";
                        f.action = "/admin/pInsert.do";
                        f.submit();
                    }

                    function mcategoryNameSearch(val) {
                        let categoryName = val;
                        $.ajax({
                            url: "/admin/adminCategoryAjax.do",
                            data: { "categoryName": categoryName },
                            dataType: "json",
                            method: 'GET',
                            success: function (res_data) {
                                var mselect = $('#mcategorySearch');
                                var dselect = $('#dcategorySearch');
                                mselect.empty();
                                dselect.empty();
                                mselect.append($('<option disabled selected hidden></option>').val('중분류선택').text('중분류선택'))
                                dselect.append($('<option disabled selected hidden></option>').val('소분류선택').text('소분류선택'))
                                $.each(res_data, function (index, item) {
                                    mselect.append($('<option></option>').val(item.mcategoryName).text(item.mcategoryName));
                                });
                            },
                            error: function (err) {
                                console.log(err.responseText);
                            }
                        });
                    }

                    function dcategoryNameSearch(val) {
                        let categoryName = $("#categorySearch").val();
                        if ($("#mcategorySearch").val() == '중분류 선택') {
                            let mcategoryName = val;
                            $.ajax({
                                url: "/admin/adminCategoryAjax.do",
                                data: { "mcategoryName": mcategoryName, "categoryName": categoryName },
                                dataType: "json",
                                method: 'GET',
                                success: function (res_data) {
                                    var dSelect = $('#dcategorySearch');
                                    dSelect.empty();
                                    dSelect.append($('<option disabled selected hidden></option>').val('소분류선택').text('소분류선택'))
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
                            data: { "mcategoryName": mcategoryName, "categoryName": categoryName },
                            dataType: "json",
                            method: 'GET',
                            success: function (res_data) {
                                var select = $('#dcategorySearch');
                                select.empty();
                                select.append($('<option disabled selected hidden></option>').val('소분류선택').text('소분류선택'))
                                $.each(res_data, function (index, item) {
                                    select.append($('<option></option>').val(item.dcategoryName).text(item.dcategoryName));
                                });
                            },
                            error: function (err) {
                                console.log(err.responseText);
                            }
                        });
                    }

                    function insertCancel() {
                        if (confirm("등록을 취소하시겠습니까?\n내용은 저장되지 않습니다.") == false) return;
                        location.href = '/admin/admin.do'
                    }

                    function pImageDelete(fileName, fileIdx, pIdx) {
                        if (confirm("이미지를 삭제하시겠습니까?") == false) return;
                        $.ajax({
                            url: "/admin/pImageDelete.do",
                            data: { "fileIdx": fileIdx, "pIdx": pIdx, "fileName": fileName },
                            dataType: "json",
                            method: 'POST',
                            success: function (res_data) {
                                let pImgTable = $("#pImgTable");
                                pImgTable.empty();
                                let pImgTableHtml = `
                        <tr>
                            <th>상품사진</th>
                            <td><input type="file" name="photo" id="pImg" multiple></td>
                        </tr>
                        <tr>
                            <th>현재등록된 상품사진</th>
                            `;

                                if (res_data.length == 0 || res_data == null) {
                                    pImgTableHtml += `등록된 사진이 없습니다`;
                                } else {
                                    $.each(res_data, function (i, photoList) {
                                        pImgTableHtml += `
                            <td style="display: inline-block; width: 200px; height: 160px;"><img src="/resources/images/${photoList.fileName}"
                            onclick="pImageDelete('${photoList.fileName}', 
                            '${photoList.fileIdx}', '${photoList.pidx}')">
                            </td>`;
                                    });
                                }
                                pImgTableHtml += `</tr>`;

                                $('#pImgTable').html(pImgTableHtml);
                            },
                            error: function (err) {
                                console.log(err.responseText);
                            }
                        });
                    }
                </script>
            </head>

            <body>
                <div class="container form-container">
                    <h2>상품 등록</h2>
                    <form>
                        <table class="table table-bordered">
                            <tr>
                                <th>카테고리</th>
                                <td>
                                    <select class="form-control" name="categoryName" id="categorySearch"
                                        onchange="mcategoryNameSearch(this.value);">
                                        <option value="대분류선택" hidden selected>대분류선택</option>
                                        <c:forEach var="vo" items="${categoryName}">
                                            <option value="${vo.categoryName}">${vo.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                    <br>
                                    <select class="form-control" name="mcategoryName" id="mcategorySearch"
                                        onchange="dcategoryNameSearch(this.value);">
                                        <option value="중분류선택">중분류선택</option>
                                    </select>
                                    <br>
                                    <select class="form-control" name="dcategoryName" id="dcategorySearch">
                                        <option value="소분류선택">소분류선택</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>상품이름</th>
                                <td><input type="text" class="form-control" value="" name="pName" id="pName"
                                        placeholder="상품명을 입력하세요"></td>
                            </tr>
                            <tr>
                                <th>상품수량</th>
                                <td><input type="text" class="form-control" value="" name="amount" id="amount"
                                        placeholder="상품수량을 입력하세요"></td>
                            </tr>
                            <tr>
                                <th>상품가격</th>
                                <td><input type="text" class="form-control" value="" name="price" id="price"
                                        placeholder="가격을 입력하세요"></td>
                            </tr>
                        </table>
                        <table class="table table-bordered" id="pImgTable">
                            <tr>
                                <th>상품사진등록</th>
                                <td><input type="file" name="photo" id="pImg" multiple></td>
                            </tr>
                            <tr>
                                <th>상품설명</th>
                                <td><textarea name="pEx" id="pEx" cols="50" rows="5"
                                        class="form-control">${pEx}</textarea>
                                </td>
                            </tr>
                        </table>

                        <div class="form-actions">
                            <input type="button" class="btn btn-default" id="updateBtn" value="등록하기"
                                onclick="pInsert(this.form);">
                            <input type="button" class="btn btn-danger" id="canselBtn" value="등록취소"
                                onclick="insertCancel();">
                        </div>
                    </form>
                </div>
            </body>

            </html>