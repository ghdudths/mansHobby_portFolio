<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
            <meta charset="UTF-8">
            <title>MansHobby</title>
            <!-- 절대 경로 변경 -->
            <link rel="stylesheet" href="${ pageContext.request.contextPath }/resources/css/home.css">

            <style>
                /* Dialogflow Messenger 스타일 */
                df-messenger {
                    --df-messenger-bot-message: #f5f5f5;
                    --df-messenger-button-titlebar-color: linear-gradient(135deg, #f58529, #dd2a7b, #8134af, #515bd4);
                    --df-messenger-button-titlebar-font-color: #333333;
                    --df-messenger-font-color: #333333;
                    --df-messenger-input-box-color: #ffffff;
                    --df-messenger-input-font-color: #333333;
                    --df-messenger-input-placeholder-font-color: #999999;
                    --df-messenger-minimized-chat-close-icon-color: #ffffff;
                    --df-messenger-send-icon: #6a11cb;
                    --df-messenger-user-message: #ffffff;
                }

                /* 메인 섹션 이미지 */
                .main-section .image-box {
                    background-size: cover;
                    background-position: center;
                    width: 35%;
                    border-radius: 10px;

                }


                /* CTA 버튼 */
                .cta-btn {
                    display: inline-block;
                    padding: 10px 20px;
                    background-color: #f4f4f4;
                    color: #1a1a1a;
                    text-decoration: none;
                    border-radius: 5px;
                    transition: background-color 0.3s ease;
                    margin-top: 20px;
                }

                .cta-btn:hover {
                    background-color: #555;
                }

                /* 서비스 섹션 */
                .services {

                    text-align: center;
                }

                .service-cards {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    gap: 20px;
                    max-width: 1200px;
                    margin: 0 auto;
                }

                .service-cards .card {

                    max-width: 1000px;
                    height: 400px;
                    border: 1px solid #eaeaea;
                    padding: 20px;
                    background-color: #fff;
                    text-align: center;
                    box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
                    transition: transform 0.3s ease;
                    margin-right: 50px;
                }

                .service-cards .card:hover {
                    transform: translateY(-10px);
                }

                /* 연락처 섹션 */
                .container-fluid.bg-grey {
                    background-color: #f6f6f6;
                    padding: 50px 0;
                }

                .contact-info {
                    text-align: left;
                }

                .contact-info .glyphicon {
                    margin-right: 10px;
                }

                /* 메인 화면 배경 이미지 */
                .hero-section {
                    position: relative;
                    height: 100vh;
                    background-image: url('${ pageContext.request.contextPath }/resources/images/광고.gif');
                    background-size: cover;
                    background-position: center;
                }

                .hero-overlay {
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background-color: rgba(0, 0, 0, 0.5);
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    color: #fff;
                    text-align: center;
                }

                .hero-overlay h1 {
                    font-size: 3rem;
                    font-weight: bold;
                }

                .hero-overlay p {
                    font-size: 1.5rem;
                    margin-top: 10px;
                }


                .carousel-inner {
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 300px;
                    /* 높이를 고정하여 균일하게 배치 */
                }

                .carousel-inner .item {
                    width: 100%;
                    height: 100%;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    text-align: center;
                }

                .carousel-inner h4 {
                    font-size: 4.2rem;
                    /* 텍스트 크기 적절히 조정 */
                    line-height: 1.5;
                    margin-bottom: 10px;
                }

                .carousel-inner span {
                    font-style: normal;
                    font-size: 2rem;
                    color: #555;
                }



                .carousel-control {
                    background-image: none;
                    /* 기본 화살표 배경 제거 */
                    color: #333;
                    /* 화살표 색상 변경 */
                }

                .carousel-control:hover {
                    color: #000;
                }

                .simage-box {
                    position: relative;
                    width: 100%;
                    height: 200px;
                    /* 이미지 박스 높이 설정 */
                    background-size: cover;
                    background-position: center;
                    border-radius: 10px;
                }

                .best-badge {
                    position: absolute;
                    top: 10px;
                    left: 10px;
                    background-color: red;
                    color: white;
                    padding: 5px 10px;
                    font-size: 14px;
                    font-weight: bold;
                    border-radius: 5px;
                }
            </style>
        </head>

        <body>

            <!-- 헤더 -->
            <%@ include file="menubar/navbar.jsp" %>

                <!-- 메인 섹션 1 -->
                <section class="hero-section">
                    <div class="hero-overlay">
                        <h1>Mans Hobby</h1>
                        <p>새롭게 태어난 당신이 원하는 모든 것</p>
                        <a href="/sports.do?categoryNo=2" class="cta-btn">더 알아보기</a>
                    </div>
                </section>


                <!-- 메인 섹션 2 -->
                <section class="main-section">
                    <div class="image-container">
                        <div class="image-box" style="background-image: url(../../resources/images/게임.png);">
                            <div class="overlay">
                                <h2>Game</h2>
                                <p>절대 들키지 말 것.</p>
                                <a href="/game.do?categoryNo=1" class="cta-btn">자세히 보기</a>
                            </div>
                        </div>
                        <div class="image-box" style="background-image: url(../../resources/images/메인화면샘플.jpg);">
                            <div class="overlay">
                                <h2>sports</h2>
                                <p>관리하는 사람들의 건전한 취미</p>
                                <a href="/sports.do?categoryNo=2" class="cta-btn">자세히 보기</a>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- 서비스 섹션 -->
                <div class="container-fluid text-center bg-grey">
                    <section class="services">
                        <h2>우리의 서비스</h2>
                        <div class="service-cards">
                            <div class="card">
                                <div class="simage-box"
                                    style="background-image: url('${pageContext.request.contextPath}/resources/images/이미지1.png');">
                                    <div class="best-badge">BEST</div> <!-- BEST 배지 추가 -->
                                </div>
                                <h3>서비스 1</h3>
                                <p>서비스 설명</p>
                            </div>
                            <div class="card">
                                <div class="simage-box"
                                    style="background-image: url('${pageContext.request.contextPath}/resources/images/이미지4.png');">
                                    <div class="best-badge">BEST</div> <!-- BEST 배지 추가 -->
                                </div>
                                <h3>서비스 2</h3>
                                <p>서비스 설명</p>
                            </div>
                            <div class="card">
                                <div class="simage-box"
                                    style="background-image: url('${pageContext.request.contextPath}/resources/images/이미지3.png');">
                                    <div class="best-badge">NEW</div> <!-- BEST 배지 추가 -->
                                </div>
                                <h3>서비스 3</h3>
                                <p>서비스 설명서비스 설명서비스 설명서비스 설명서비스 설명서비스 설명서비스 설명서비스 설명서비스 설명서비스 설명서비스 설명서비스 설명</p>
                            </div>
                        </div>
                    </section>
                </div>

                <div id="myCarousel" class="carousel slide text-center" data-ride="carousel" m>
                    <h2 style=" margin-top: 35px; margin-bottom: 100px; color:  #f6f6f6;">x</h2>

                    <!-- Wrapper for slides -->
                    <div class="carousel-inner" role="listbox">
                        <div class="item active">
                            <h4>"This company is the best. I am so happy with the result!"<br><span>Michael Roe,
                                    Vice President, Comment Box</span></h4>
                        </div>
                        <div class="item">
                            <h4>"One word... WOW!!"<br><span>John Doe, Salesman, Rep Inc</span></h4>
                        </div>
                        <div class="item">
                            <h4>"Could I... BE any more happy with this company?"<br><span>Chandler Bing, Actor,
                                    FriendsAlot</span></h4>
                        </div>
                    </div>

                    <!-- Left and right controls -->
                    <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
                        <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                        <span class="sr-only">Previous</span>
                    </a>
                    <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
                        <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                        <span class="sr-only">Next</span>
                    </a>
                </div>
                </div>



                <!-- 연락처 섹션 -->
                <div class="container-fluid bg-grey" style="background-color: #f6f6f6;">
                    <div class="container" style="max-width: 1800px;">
                        <h2 class="text-center">CONTACT</h2>
                        <div class="row">
                            <div class="col-sm-5">
                                <p>행복한 하루 되세요..</p>
                                <p><span class="glyphicon glyphicon-map-marker"></span> 서울특별시 관악구 관악로 공증빌딩</p>
                                <p><span class="glyphicon glyphicon-phone"></span> 02) 889-8888</p>
                                <p><span class="glyphicon glyphicon-envelope"></span> myemail@something.com</p>
                            </div>
                            <div class="col-sm-7">
                                <div class="row">
                                    <div class="col-sm-6 form-group">
                                        <input class="form-control" id="name" name="name" placeholder="Name" type="text"
                                            required>
                                    </div>
                                    <div class="col-sm-6 form-group">
                                        <input class="form-control" id="email" name="email" placeholder="Email"
                                            type="email" required>
                                    </div>
                                </div>
                                <textarea class="form-control" id="comments" name="comments" placeholder="Comment"
                                    rows="5"></textarea><br>
                                <div class="row">
                                    <div class="col-sm-12 form-group">
                                        <button class="btn btn-default pull-right" type="submit">Send</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>


                <!-- 푸터 -->
                <%@ include file="menubar/footer.jsp" %>

                    <!-- Dialogflow Messenger 추가 -->
                    <script src="https://www.gstatic.com/dialogflow-console/fast/messenger/bootstrap.js?v=1"></script>
                    <df-messenger intent="WELCOME" chat-title="MansHobby"
                        agent-id="192731cf-d2e0-464a-874f-4d8b1be135c6" language-code="ko"></df-messenger>
        </body>

        </html>