<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <script src="https://cdn.ckeditor.com/ckeditor5/34.0.0/classic/ckeditor.js"></script>
    <script src="https://ckeditor.com/apps/ckfinder/3.5.0/ckfinder.js"></script>
    <style>
        .ck-editor__editable {
            min-height: 500px;
        }

        @media (max-width : 768px) {
            .login-container {
                margin-top: 50px;
            }
        }

        .form-button {
            display: flex;
            /* 플렉스 레이아웃 사용 */
            justify-content: space-between;
            /* 버튼들을 양 끝으로 배치 */
            align-items: center;
            /* 수직 정렬 */
        }

        .form-button button {
            padding: 10px 20px;
            /* 버튼의 여백 설정 */
            font-size: 16px;
            /* 버튼의 폰트 크기 */
        }
    </style>
    <script>
        function sendM(f) {

            // 로그인이 안 되었으면
            if ("${ empty user }" == "true") {

                loginModal.style.display = 'flex';
                alert('로그아웃되었습니다.\n로그인하세요.')
                return;
            }


            // // JSP에서 자바스크립트로 값을 전달하기 위해 변수로 변환
            // var currentUserIdx = "${not empty user ? user.userIdx : -1}";
            // var isAdmin = "${user.adminAt}" == "Y"; // 관리자 확인

            // // 사용자가 관리자이거나 본인인지 확인
            // if ((userIdx == currentUserIdx || isAdmin) && currentUserIdx != -1) {
            //     location.href = "inquirySelect.do?inIdx=" + inIdx;
            // } else {
            //     alert("해당 내용은 관리자와 본인만 확인 가능합니다.");
            // }


            //입력값 검증
            let inType = f.inType.value.trim();
            let inContent = editor.getData();

            // 에디터 데이터를 숨겨진 textarea에 설정
            f.inContent.value = inContent;

            if (inType == '') {
                alert("제목을 입력하세요");
                f.inType.value = '';
                f.inType.focus();
                return;
            }

            if (inContent == '') {
                alert("내용을 입력하세요");
                f.inContent.value = '';
                f.inContent.focus();
                return;
            }

            if (f.inPP.files.length === 0) {
                if (!confirm("사진을 선택하지 않았습니다. 등록하시겠습니까?")) return;
            } else if (!confirm("등록하시겠습니까?")) return;

            f.method = "POST";
            f.enctype = "multipart/form-data";
            7
            f.action = "inquiryModify.do"; // 전송대상
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
                <h2>게시글 수정</h2>
                <form>
                    <input type="hidden" name="inIdx" value="${vo.inIdx}">
                    <div class="form-group">
                        <label for="title">제목</label>
                        <select class="form-control" id="inType" name="inType" required>
                            <option value="${ vo.inType }">${ vo.inType }</option>
                            <option value="문의">문의</option>
                            <option value="불만사항">불만사항</option>
                            <option value="칭찬">칭찬</option>
                            <option value="기타">기타</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <input type="file" name="inquiryImg" id="inPP"><br>
                        현재 등록된 사진 : <c:if test="${vo.inPP ne 'NoPhoto' && vo.inPP ne null}">
                            <img src="${pageContext.request.contextPath}/resources/images/inquiry/${vo.inPP}"
                                alt="문의 이미지" style="width: 100px; height: 100px; object-fit: cover;">
                        </c:if>
                        <c:if test="${vo.inPP eq 'NoPhoto' || vo.inPP eq null}">없음</c:if>
                        <div class="form-group" style="color: black;">
                            <label for="content" style="color: black;">내용</label>
                            <div id="editor">
                                <textarea name="inContent"></textarea>
                            </div>
                        </div>

                        <div class="form-button">
                            <button type="button" class="btn btn-info" onclick="goBack()">뒤로가기</button>
                            <button type="button" class="btn btn-primary" onclick="sendM(this.form)">수정</button>
                        </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        let editor;
        // Classic Editor를 생성하고 설정
        ClassicEditor
            .create(document.querySelector('#editor'), {
                removePlugins: [''],
                language: 'ko'
            })
            .then(newEditor => {
                editor = newEditor;
                editor.setData('${ vo.inContent }');
            })
            .catch(error => {
                console.error('에디터 로드 중 오류가 발생했습니다.', error);
            });
    </script>

    <script>
        function goBack() {
            if (document.referrer) { // 이전 페이지가 있는 경우
                history.back(); // 또는 history.go(-1);
            } else {
                alert("이전 페이지가 없습니다.");
            }
        }
    </script>
</body>

</html>