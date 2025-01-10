<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>MansHobby</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap 3.x -->
    <link
      rel="stylesheet"
      href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"
    />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

    <style>
      body {
        font-family: Arial, sans-serif;
        background-color: #f0f0f0;
        color: #333;
        margin: 0;
        padding: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100vh;
      }

      h2 {
        color: black;
        margin-bottom: 20px;
        font-weight: bold;
      }

      form {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
        padding: 30px;
        max-width: 400px;
        width: 100%;
        text-align: center;
      }

      input[type="text"] {
        width: calc(100% - 20px);
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        margin-bottom: 15px;
        box-sizing: border-box;
      }

      input[type="button"],
      button {
        color: white;
        cursor: pointer;
        width: 100%;
        font-size: 16px;
      }
      input[type="button"] {
        margin-top: 10px;
      }

      #searchBtn:hover {
        background-color: #1c61c3;
      }
      #sendEmail:hover {
        background-color: #36a83a;
      }
      #goBackBtn:hover {
        background-color: #d33842;
      }

      .email-option {
        display: flex;
        align-items: center;
        margin-bottom: 10px;
      }

      .email-option input {
        margin-right: 10px;
      }

      p {
        margin-top: 10px;
        margin: 10px 0;
        color: #666;
      }
    </style>

    <script>
      function passwordSearch(f) {
        name = f.name.value.trim();
        id = f.id.value.trim();

        if (name == "") {
          alert("이름을 입력해주세요!");
          f.name.focus();
          return;
        }
        if (id == "") {
          alert("아이디를 입력해주세요!");
          f.id.focus();
          return;
        }

        $.ajax({
          url: "/passwordSearchAjax.do",
          data: { name: name, id: id },
          dataType: "json",
          method: "GET",
          success: function (res_data) {
            html = ``;
            if (res_data.length > 0) {
              $.each(res_data, function (index, vo) {
                html += `
                    <input type="radio" name="email" value="\${vo.email}" id="emailRadio">
                    <label for="emailRadio">\${vo.email}</label>`;
              });

              html += `
                    <p>비밀번호를 찾을 이메일을 선택하세요.</p>
                    <input type="button" class="btn btn-success" id="sendEmail" value="선택완료" onclick="checkEmail()">`;

              $("#emailSearch").html(html);
            } else {
              console.log($("#name").val());
              console.log($("#id").val());
              alert(
                "이메일을 찾을 수 없습니다.\n이름과 아이디를 다시 확인해주세요!"
              );
            }
          },
          error: function (err) {},
        });
      }

      function checkEmail() {
        let email = document.querySelector('input[name="email"]:checked');
        console.log(email);
        if (email) {
          alert("비밀번호를 전송했습니다");
          location.href = "sendEmail.do?email=" + email.value;
        } else {
          alert("이메일을 선택하세요.");
        }
      }

      function goBack() {
        if (confirm("메인화면으로 돌아가시겠습니까?")) {
          location.href = "home.do";
        }
      }
    </script>
  </head>

  <body>
    <h2>비밀번호 찾기</h2>

    <form>
      <div>
        <input
          type="text"
          id="name"
          name="name"
          placeholder="이름을 입력해주세요"
        /><br />
        <input
          type="text"
          id="id"
          name="id"
          placeholder="아이디를 입력해주세요"
        /><br />
        <input
          type="button"
          value="검색"
          id="searchBtn"
          class="btn btn-primary"
          onclick="passwordSearch(this.form)"
        />
      </div>
      <div id="emailSearch"></div>
      <div>
        <input
          id="goBackBtn" 
          type="button" 
          class="btn btn-danger" 
          value="뒤로가기"
          onclick="goBack();"
        />
      </div>
    </form>
  </body>
</html>
