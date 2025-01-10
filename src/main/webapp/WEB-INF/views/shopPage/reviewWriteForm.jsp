<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>리뷰 등록</title>
    <style>

        @media (max-width : 768px) {
            .login-container {
                margin-top: 50px;
            }
        }
    </style>
    <script>
        function send1(f) {

            // 로그인이 안 되었으면
            if ("${ empty user }" == "true") {
                loginModal.style.display = 'flex';
                alert('로그아웃되었습니다.\n로그인하세요.')
                return;
            }

            // 입력값 검증
            let rvContent = f.rvContent.value;

            if (rvContent.trim() == '') {
                alert("내용을 입력하세요");
                f.rvContent.focus();
                return;
            }

            f.action = "reviewWrite.do"; // 전송대상
            f.submit(); // 전송
        }
    </script>
</head>

<body>
    <%@ include file="../menubar/navbar.jsp" %>
    <br><br><br><br><br>
    <div class="container">
        <div class="row">
            <div class="col-md-12 col-md-offset-0">
                <h2>리뷰 등록</h2>
                <form>
                    <input type="hidden" name="userIdx" value="${user.userIdx}" />
                    <div class="form-group" style="color: black;">
                        <label for="content" style="color: white;">내용</label>
                        <textarea name="rvContent" required style="width: 100%; min-height: 400px;"></textarea>
                    </div>
                    <button type="button" class="btn btn-primary" onclick="send1(this.form)">등록</button>
                </form>
            </div>
        </div>
    </div>
</body>

</html>
