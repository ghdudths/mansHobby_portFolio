<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>회원 정보 수정</title>
            <link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/accountInfo.css">

            <script>

                function userModifySend(f) {
                    let nickName = f.nickName.value.trim();
                    let name = f.name.value.trim();
                    let phone = f.phone.value.trim();
                    let addr = f.addr.value.trim();
                    let subAddr = f.subAddr.value.trim();

                    if (nickName == "") {
                        alert("닉네임을 입력해주세요.")
                        f.nickName.value = "";
                        f.nickName.focus();
                        return;
                    }
                    if (name == "") {
                        alert("이름을 입력해주세요.")
                        f.name.value = "";
                        f.name.focus();
                        return;
                    }
                    if (phone == "") {
                        alert("전화번호를 입력해주세요.")
                        f.phone.value = "";
                        f.phone.focus();
                        return;
                    }
                    if (addr == "") {
                        alert("주소를 입력해주세요.")
                        f.addr.value = "";
                        f.addr.focus();
                        return;
                    }
                    if (subAddr == "") {
                        alert("상세 주소를 입력해주세요.")
                        f.subAddr.value = "";
                        f.subAddr.focus();
                        return;
                    }

                    f.action = "${pageContext.request.contextPath}/user/userModify.do";
                    f.submit();
                }

                // 주소검색 API
                function find_addr2() {

                    new daum.Postcode({
                        oncomplete: function (data) {
                            $("#myPageAddr").val(data.address); 	  //선택한 정보의 주소 넣기
                        }
                    }).open();
                }//end:find_addr()
            </script>
        </head>

        <body>
            <div class="container">
                <h1>회원 정보 수정</h1>
            </div>
            <div class="container">
                <form>
                    <input type="hidden" name="userIdx" value="${user.userIdx}" />
                    <div class="form-group">
                        <label for="id">아이디</label>
                        <input type="text" id="id" name="id" value="${user.id}" readonly />
                    </div>

                    <div class="form-group">
                        <label for="password">비밀번호</label>
                        <input type="password" id="password" name="password" value="${user.password}" readonly />
                    </div>

                    <div class="form-group">
                        <label for="nickName">닉네임</label>
                        <input type="text" id="nickName" name="nickName" value="${user.nickName}" />
                    </div>

                    <div class="form-group">
                        <label for="name">이름</label>
                        <input type="text" id="name" name="name" value="${user.name}" />
                    </div>

                    <div class="form-group">
                        <label for="phone">핸드폰 번호</label>
                        <input type="text" id="phone" name="phone" value="${user.phone}" />
                    </div>


                    <div class="form-group">
                        <label for="addr">주소</label>
                        <div class="inline-address">
                            <input type="text" id="myPageAddr" name="addr" value="${user.addr}" />
                            <input type="button" value="주소검색" onclick="find_addr2()">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="subAddr">상세주소</label>
                        <div class="inline-address">
                            <input type="text" id="subAddr" name="subAddr" value="${user.subAddr}" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="gradeName">등급</label>
                        <input type="text" id="gradeName" name="gradeName" value="${user.gradeName}" readonly />
                    </div>

                    <div class="form-group">
                        <label for="point">포인트</label>
                        <input type="text" id="point" name="point" value="${user.point}" readonly />
                    </div>

                    <div class="form-group">
                        <input type="button" value="정보 수정" onclick="userModifySend(this.form)" />
                    </div>
                </form>
            </div>

        </body>

        </html>