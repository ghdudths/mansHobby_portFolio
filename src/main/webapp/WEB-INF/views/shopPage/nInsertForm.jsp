<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>공지사항 등록</title>
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

            .btn {
                width: 120px;
                margin: 10px;
            }

            textarea {
                resize: none;
                height: 150px;
            }

            .form-actions {
                text-align: center;
                margin-top: 20px;
            }

            @media (max-width: 768px) {
                .form-container {
                    margin-top: 50px;
                }
            }
        </style>

        <script>
            function nInsert(f) {
                let inType = f.inType.value;
                let inContent = f.inContent.value;

                if (inType.trim() === '') {
                    alert("제목을 입력하세요");
                    f.inType.focus();
                    return;
                }

                if (inContent.trim() === '') {
                    alert("내용을 입력하세요");
                    f.inContent.focus();
                    return;
                }

                f.action = "${pageContext.request.contextPath}/admin/nInsert.do";
                f.submit();
            }

            function nInsertCancel() {
                if (confirm("등록을 취소하시겠습니까?\n내용은 저장되지 않습니다.") == false) return;
                location.href = '${pageContext.request.contextPath}/admin/admin.do';
            }
        </script>
    </head>

    <body>
        <%@ include file="../menubar/navbar.jsp" %>
            <br><br><br><br><br>
            <div class="container form-container">
                <h2>공지사항 등록</h2>
                <form>
                    <div class="form-group">
                        <label for="inType">제목</label>
                        <input type="text" class="form-control" name="inType" id="inType" placeholder="제목을 입력하세요">
                    </div>
                    <div class="form-group">
                        <label for="inContent">내용</label>
                        <textarea class="form-control" name="inContent" id="inContent" style="height: 500px;"
                            placeholder=" 내용을 입력하세요"></textarea>
                    </div>
                    <div class="form-actions">
                        <input type="button" class="btn btn-primary" value="등록하기" onclick="nInsert(this.form);">
                        <input type="button" class="btn btn-danger" value="등록취소" onclick="nInsertCancel();">
                    </div>
                </form>
            </div>
    </body>

    </html>