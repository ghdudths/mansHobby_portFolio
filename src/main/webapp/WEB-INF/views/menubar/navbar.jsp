<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <!DOCTYPE html>
    <html>

    <head>
      <meta charset="UTF-8" />
      <title>MansHobby</title>
      <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
      <!-- Bootstrap 3.x -->
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

      <link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/navbar.css" />
      <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
      <script type="text/javascript">
        //javascript 초기화
        //window.onload = function(){}

        function closeModal(modalId) {
          document.getElementById(modalId).style.display = 'none';
        }

        $(document).ready(function () {
          // 페이지가 로드된 후 URL의 쿼리 파라미터를 확인합니다.
          var urlParams = new URLSearchParams(window.location.search);
          var showSignUpModal = urlParams.get('showSignUpModal') === 'true';

          // showSignUpModal이 true일 경우 회원가입 모달을 표시합니다.
          if (showSignUpModal) {
            $('#registerEmailModal').css('display', 'flex');

            // 쿼리 파라미터에서 showSignUpModal 제거
            urlParams.delete('showSignUpModal');
            window.history.replaceState({}, '', `${location.pathname}?${urlParams}`);
          }

          // showMessage 함수 호출
          showMessage();
        });

        function showMessage() {
          // 현재 URL 가져오기
          let url = new URL(window.location.href);

          // URLSearchParams 객체 생성
          let params = new URLSearchParams(url.search);

          // 'reason' 파라미터의 값 확인
          if (params.get('reason') === 'fail_id') {
            loginModal.style.display = 'flex';
            alert('아이디가 틀립니다.');

            // 'reason' 파라미터 삭제
            params.delete('reason');

            // URL 업데이트
            url.search = params.toString();
            window.history.replaceState({}, '', url.toString()); // 페이지를 새로 로드하지 않고 URL 업데이트
          }

          if (params.get('reason') === 'fail_password') {
            loginModal.style.display = 'flex';
            alert('비밀번호가 틀립니다.');

            // 'reason' 파라미터 삭제
            params.delete('reason');

            // URL 업데이트
            url.search = params.toString();
            window.history.replaceState({}, '', url.toString());
          }

          if (params.get('reason') === 'session_timeout') {
            loginModal.style.display = 'flex';
            alert('로그아웃되었습니다.\n로그인하세요.');

            // 'reason' 파라미터 삭제
            params.delete('reason');

            // URL 업데이트
            url.search = params.toString();
            window.history.replaceState({}, '', url.toString());
          }
        }

      </script>
      <script>
        function send(f) {

          let id = f.id.value.trim();
          let password = f.password.value.trim();

          if (id == '') {
            alert("아이디를 입력하세요!!");
            f.id.value = "";
            f.id.focus();
            return;
          }

          if (password == '') {
            alert("비밀번호를 입력하세요!!");
            f.password.value = "";
            f.password.focus();
            return;
          }

          $("#url").val(location.href);

          f.action = "${pageContext.request.contextPath}/user/login.do";
          f.submit();

        }//end:send()

        function check_id() {

          //회원가입 버튼은 비활성화
          // <input id="btn_register" type="button" ...  disabled="disabled">
          $("#btn_register").prop("disabled", true);


          //           document.getElementById("mem_id").value
          let re_id = $("#re_id").val();

          if (re_id.length == 0) {

            $("#id_msg").html("");
            return;
          }


          if (re_id.length < 3) {

            $("#id_msg").html("id는 3자리 이상 입력하세요").css("color", "red");
            return;
          }

          //서버에 현재 입력된 ID를 체크요청(jQuery Ajax이용)
          $.ajax({
            url: "${pageContext.request.contextPath}/user/check_id.do",     //MemberCheckIdAction
            data: { "id": re_id }, //parameter   => check_id.do?mem_id=one
            dataType: "json",
            success: function (res_data) {
              // res_data = {"result": true}  or {"result": false}
              if (res_data.result) {

                $("#id_msg").html("사용가능한 아이디 입니다").css("color", "blue");

                //가입버튼 활성화
                $("#btn_register").prop("disabled", false);

              } else {

                $("#id_msg").html("이미 사용중인 아이디 입니다").css("color", "red");

              }
            },
            error: function (err) {
              alert(err.responseText);
            }
          });
        }//end:check_id()

        function check_id() {
          //회원가입 버튼은 비활성화
          $("#btn_register").prop("disabled", true);

          let re_id = $("#re_id").val();

          // 아이디가 입력되지 않았을 경우
          if (re_id.length == 0) {
            $("#id_msg").html("");
            return;
          }

          // 아이디 길이 체크
          if (re_id.length < 4 || re_id.length > 20) {
            $("#id_msg").html("아이디는 4자리 이상 20자리 이하로 입력하세요.").css("color", "red");
            return;
          }

          // 정규식 체크
          const re_idText = /^[a-zA-Z0-9]{4,20}$/; // 소문자, 대문자, 숫자 허용
          if (!re_idText.test(re_id)) {
            $("#id_msg").html("아이디는 영문 대소문자 및 숫자만 포함해야 합니다.").css("color", "red");
            return;
          }

          //서버에 현재 입력된 ID를 체크요청(jQuery Ajax이용)
          $.ajax({
            url: "${pageContext.request.contextPath}/user/check_id.do", // MemberCheckIdAction
            data: { "id": re_id }, //parameter => check_id.do?mem_id=one
            dataType: "json",
            success: function (res_data) {
              // res_data = {"result": true}  or {"result": false}
              if (res_data.result) {
                $("#id_msg").html("사용가능한 아이디 입니다").css("color", "blue");

                //가입버튼 활성화
                $("#btn_register").prop("disabled", false);
              } else {
                $("#id_msg").html("이미 사용중인 아이디 입니다").css("color", "red");
              }
            },
            error: function (err) {
              alert(err.responseText);
            }
          });

        } //end:check_id()

        function registerUser(f) {
          let re_id = f.re_id.value.trim();
          let re_password = f.re_password.value.trim();
          let nickName = f.nickName.value.trim();
          let name = f.name.value.trim();
          let phone = f.phone.value.trim();
          let addr = f.addr.value.trim();
          let subAddr = f.subAddr.value.trim();

          const re_idText = /^[a-zA-Z0-9]{4,20}$/; // 소문자, 대문자, 숫자 허용
          const re_passwordText = /^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
          const nameText = /^[가-힣]+$/;
          const nickNameText = /^[가-힣a-zA-Z0-9]{4,20}$/; // 한글, 영문(대소문자), 숫자 허용
          const phoneText = /^\d{3}-\d{3,4}-\d{4}$/;

          if (!re_id) {
            alert("아이디를 입력하세요.");
            f.re_id.focus();
            return;
          }
          if (!re_idText.test(re_id)) {
            alert("아이디는 4~20자의 영문 대소문자 또는 숫자여야 합니다.");
            f.re_id.focus();
            return;
          }

          if (!re_password) {
            alert("비밀번호를 입력하세요.");
            f.re_password.focus();
            return;
          }
          if (!re_passwordText.test(re_password)) {
            alert("비밀번호는 최소 8자 이상, 하나 이상의 대문자, 소문자 및 특수문자를 포함해야 합니다.");
            f.re_password.focus();
            return;
          }

          if (!nickName) {
            alert("닉네임을 입력하세요.");
            f.nickName.focus();
            return;
          }
          if (!nickNameText.test(nickName)) {
            alert("닉네임은 4~20자 한글, 영문(대소문자) 또는 숫자여야 합니다.");
            f.nickName.focus();
            return;
          }

          if (!name) {
            alert("이름을 입력하세요.");
            f.name.focus();
            return;
          }
          if (!nameText.test(name)) {
            alert("이름은 한글로만 입력해야 합니다.");
            f.name.focus();
            return;
          }

          if (!phone) {
            alert("전화번호를 입력하세요.");
            f.phone.focus();
            return;
          }
          if (!phoneText.test(phone)) {
            alert("전화번호 형식이 올바르지 않습니다. 예: 010-1234-5678");
            f.phone.focus();
            return;
          }

          if (!addr) {
            alert("주소를 입력하세요.");
            f.addr.focus();
            return;
          }

          if (!subAddr) {
            alert("상세주소를 입력하세요.");
            f.subAddr.focus();
            return;
          }

          f.action = "${pageContext.request.contextPath}/user/insert.do";
          f.submit();
        }

        function registerEmailUser(f) {
          let em_id = f.em_id.value.trim();
          let em_password = f.em_password.value.trim();
          let em_nickName = f.em_nickName.value.trim();
          let em_name = f.em_name.value.trim();
          let em_phone = f.em_phone.value.trim();
          let em_addr = f.em_addr.value.trim();
          let em_subAddr = f.em_subAddr.value.trim();

          if (em_id == '') {
            alert("아이디를 입력하세요.");
            f.em_id.value = "";
            f.em_id.focus();
            return;
          }

          if (em_password == '') {
            alert("비밀번호를 입력하세요.");
            f.em_password.value = "";
            f.em_password.focus();
            return;
          }

          if (em_nickName == '') {
            alert("닉네임을 입력하세요.");
            f.em_nickName.value = "";
            f.em_nickName.focus();
            return;
          }

          if (em_name == '') {
            alert("이름을 입력하세요.");
            f.em_name.value = "";
            f.em_name.focus();
            return;
          }

          if (em_phone == '') {
            alert("전화번호를 입력하세요.");
            f.em_phone.value = "";
            f.em_phone.focus();
            return;
          }

          if (em_addr == '') {
            alert("주소를 입력하세요.");
            f.em_addr.value = "";
            f.em_addr.focus();
            return;
          }

          f.action = "${pageContext.request.contextPath}/user/emailInsert.do";
          f.submit();
        }//end:registerEmailUser()

        function integration(f) {
          let ig_id = f.ig_id.value.trim();
          let ig_password = f.ig_password.value.trim();

          if (ig_id == '') {
            alert("아이디를 입력하세요.");
            f.ig_id.value = "";
            f.ig_id.focus();
            return;
          }
          if (ig_password == '') {
            alert("비밀번호를 입력하세요.");
            f.ig_password.value = "";
            f.ig_password.focus();
            return;
          }

          f.action = "${pageContext.request.contextPath}/user/integration.do";
          f.submit();
        }

        // 주소검색 API
        function find_addr() {

          new daum.Postcode({
            oncomplete: function (data) {
              $("#addr").val(data.address); 	  //선택한 정보의 주소 넣기
            }
          }).open();
        }//end:find_addr()

      </script>

    </head>

    <body>
      <!-- 네비게이션 바 -->
      <nav class="navbar">
        <div class="logo col-sm-2" style="display: inline-block;"><a href="${pageContext.request.contextPath}/home.do">
            <img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="Logo" style="max-width: 100%;">
          </a></div>
        <div class="col-sm-10" style="display: inline-block; margin-top: 10px;">
          <ul class="menu" style="text-align: right !important;">

            <!--쿠폰 추가 부분-->
            <!-- 유저만 있어야 함 -->
            <c:if test="${ not empty sessionScope.user }">
              <!-- 쿠폰함 -->
              <li id="coupon-box">
                <a href="${pageContext.request.contextPath}/coupon/myCoupons.do?useridx=${sessionScope.user.userIdx}">내
                  쿠폰함</a>
              </li>

              <!-- 쿠폰 목록 보기 버튼 -->
              <%--<li>
                <a href="${pageContext.request.contextPath}/coupon/list.do" class="btn btn-primary">쿠폰 목록 보기</a>
                </li>--%>
            </c:if>



            <li>
              <a href="${ pageContext.request.contextPath }/game.do?categoryNo=1">Gaming</a>
            </li>
            <li>
              <a href="${ pageContext.request.contextPath }/sports.do?categoryNo=2">Sports</a>
            </li>
            <li><a href="${pageContext.request.contextPath}/inquiry/inquiry.do">고객문의</a></li>
            <c:if test="${ not empty user }">
              <c:if test="${ user.getAdminAt() ne 'Y'}">
                <li><a href="${pageContext.request.contextPath}/user/mypage.do">마이페이지</a></li>
              </c:if>
              <c:if test="${ user.getAdminAt() eq 'Y'}">
                <li><a href="${pageContext.request.contextPath}/admin/admin.do">관리페이지</a></li>
              </c:if>
            </c:if>
            <!-- 로그인이 안 된 경우 -->
            <c:if test="${ empty user }">
              <li><input type="button" id="openLoginModal" value="로그인"/>
              </li>
            </c:if>
            <!-- 로그인이 된 경우 -->
            <c:if test="${ not empty user }">
              <li id="userStatus"><b>${ user.nickName }님</b></li>
              <li><a onclick="location.href='${pageContext.request.contextPath}/user/logout.do'">로그아웃</a></li>
            </c:if>
          </ul>
        </div>
      </nav>

      <!-- 로그인 모달 -->
      <div id="loginModal" class="modal">
        <div class="modal-content">
          <span class="close">&times;</span>
          <h2>로그인</h2>
          <form>
            <input type="hidden" name="url" id="url" />
            <input type="text" name="id" id="id" placeholder="아이디" required />
            <input type="password" name="password" id="password" placeholder="비밀번호" required />
            <input type="button" class="login-btn" value="로그인" onclick="send(this.form);" />
            <div class="links">
              <input type="button" class="register-btn" id="openRegisterModal" value="회원가입" />
              <input type="hidden" class="register-btn" id="openRegisterEmailModal" value="회원가입" />
              <a href="password.do">아이디 · 비밀번호 찾기</a>
            </div>
            <div class="divider">또는</div>
            <a href="/oauth2/authorization/naver" class="social-btn naver-btn">네이버로 시작하기</a>
            <a href="/oauth2/authorization/kakao" class="social-btn kakao-btn">카카오로 시작하기</a>
            <a href="/oauth2/authorization/google" class="social-btn google-btn">구글로 시작하기</a>
          </form>
        </div>
      </div>

      <!-- 회원가입 모달 -->
      <div id="registerModal" class="modal">
        <div class="modal-content">
          <span class="close">&times;</span>
          <h2>회원가입</h2>
          <form>
            <input type="text" id="re_id" name="id" placeholder="아이디" onkeyup="check_id();" required /><span
              id="id_msg"></span>
            <input type="password" id="re_password" name="password" placeholder="비밀번호" required />
            <input type="text" id="nickName" name="nickName" placeholder="닉네임" required />
            <input type="text" id="name" name="name" placeholder="이름" required />
            <input type="text" id="phone" name="phone" placeholder="전화번호(ex.010-1234-1234)" required />
            <input type="text" id="addr" name="addr" placeholder="주소" required />
            <input type="text" id="subAddr" name="subAddr" placeholder="상세주소">
            <input class="btn btn-info" type="button" value="주소검색" onclick="find_addr()">
            <input type="button" id="btn_register" class="login-btn" value="회원가입" disabled="disabled"
              onclick="registerUser(this.form);" />
            <!-- <input type="button" class="login-btn" value="회원가입" onclick="registerUser(this.form);" /> -->
          </form>
        </div>
      </div>
      <!-- 이메일 회원가입 모달 -->
      <div id="registerEmailModal" class="modal">
        <div class="modal-content">
          <span class="close">&times;</span>
          <h2>회원가입</h2>
          <form>
            <input type="text" id="em_id" name="id" placeholder="아이디" onkeyup="check_id_email();" required />
            <span id="em_id_msg"></span>
            <input type="password" id="em_password" name="password" placeholder="비밀번호" required />
            <input type="text" id="em_nickName" name="nickName" placeholder="닉네임" required />
            <input type="text" id="em_name" name="name" placeholder="이름" required />
            <input type="text" id="em_phone" name="phone" placeholder="전화번호(ex.010-1234-1234)" required />
            <input type="text" id="em_addr" name="addr" placeholder="주소" required />
            <input type="text" id="em_subAddr" name="subAddr" placeholder="상세주소" required />
            <input type="hidden" id="email" name="email" value="${email}" />
            <input type="hidden" id="esite" name="esite" value="${esite}" />

            <input type="button" id="btn_register_email" class="login-btn" value="회원가입" disabled="disabled"
              onclick="registerEmailUser(this.form);" />

            <div class="divider">통합</div>
            <b>회원가입한 적이 있습니까?</b>
            <input type="button" class="login-btn" id="openIntegrationModal" value="로그인 통합" />
          </form>
        </div>
      </div>

      <!-- 로그인 통합 모달 -->
      <div id="integrationModal" class="modal">
        <div class="modal-content">
          <span class="close">&times;</span>
          <h2>로그인 통합</h2>
          <form>
            <input type="hidden" name="url" id="url" />
            <input type="text" name="id" id="ig_id" placeholder="아이디" required />
            <input type="password" name="password" id="ig_password" placeholder="비밀번호" required />
            <input type="text" id="email" name="email" value="${email}" />
            <input type="text" id="esite" name="esite" value="${esite}" />
            <input type="button" class="login-btn" value="로그인 통합" onclick="integration(this.form);" />
            <div class="links">
              <a href="#">아이디 · 비밀번호 찾기</a>
            </div>
          </form>
        </div>
      </div>

      <script>
        // 로그인 모달 기능
        const loginModal = document.getElementById("loginModal");
        const openLoginModalBtn = document.getElementById("openLoginModal");
        const closeLoginModalBtn = document.getElementsByClassName("close")[0];

        const registerModal = document.getElementById("registerModal");
        const openRegisterModalBtn = document.getElementById("openRegisterModal");
        const closeRegisterModalBtn = document.getElementsByClassName("close")[1];

        const registerEmailModal = document.getElementById("registerEmailModal");
        const openRegisterEmailModalBtn = document.getElementById("openRegisterEmailModal");
        const closeRegisterEmailModalBtn = document.getElementsByClassName("close")[2];

        const integrationModal = document.getElementById("integrationModal");
        const openIntegrationModalBtn = document.getElementById("openIntegrationModal");
        const closeIntegrationModalBtn = document.getElementsByClassName("close")[3];


        // 모달 열기
        openLoginModalBtn.onclick = function () {
          loginModal.style.display = "flex";
        };

        // 모달 닫기
        closeLoginModalBtn.onclick = function () {
          loginModal.style.display = "none";
        };

        // 모달 열기
        openRegisterModalBtn.onclick = function () {
          loginModal.style.display = "none";
          registerModal.style.display = "flex";
        };

        // 모달 닫기
        closeRegisterModalBtn.onclick = function () {
          registerModal.style.display = "none";
        };

        // 모달 열기
        openRegisterEmailModalBtn.onclick = function () {
          loginModal.style.display = "none";
          registerModal.style.display = "none";
          registerEmailModal.style.display = "flex";
        };

        // 모달 닫기
        closeRegisterEmailModalBtn.onclick = function () {
          registerEmailModal.style.display = "none";
        };

        // 모달 열기
        openIntegrationModalBtn.onclick = function () {
          loginModal.style.display = "none";
          registerModal.style.display = "none";
          registerEmailModal.style.display = "none";
          integrationModal.style.display = "flex";
        };

        // 모달 닫기
        closeIntegrationModalBtn.onclick = function () {
          integrationModal.style.display = "none";
        };
      </script>
    </body>

    </html>