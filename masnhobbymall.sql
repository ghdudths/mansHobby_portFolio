-- 테이블 삭제
DROP TABLE IF EXISTS Compony;
DROP TABLE IF EXISTS Chat_logs;
DROP TABLE IF EXISTS UserActivity;
DROP TABLE IF EXISTS Answer;
DROP TABLE IF EXISTS Inquiry;
DROP TABLE IF EXISTS Follow;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS SCart;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS BuyList;
DROP TABLE IF EXISTS DStatus;
DROP TABLE IF EXISTS ProductImage;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS DCategory;
DROP TABLE IF EXISTS MCategory;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS CouponBox;
DROP TABLE IF EXISTS Coupon;
DROP TABLE IF EXISTS GCondition;
DROP TABLE IF EXISTS DAddress;
DROP TABLE IF EXISTS Email;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Grade;


-- Grade 테이블
CREATE TABLE Grade (
    gIdx int PRIMARY KEY AUTO_INCREMENT,
    gradeName varchar(200) NOT NULL,
    authority int NOT NULL,
    discount int NOT NULL
);

-- User 테이블
CREATE TABLE User (
    userIdx int PRIMARY KEY AUTO_INCREMENT,
    gIdx int NOT NULL DEFAULT 1,
    id varchar(50) NOT NULL UNIQUE,
    password varchar(50) NOT NULL,
    nickName varchar(50) NOT NULL UNIQUE,
    name varchar(50) NOT NULL,
    phone varchar(50) NOT NULL UNIQUE,
    addr varchar(70) NOT NULL,
    subAddr varchar(45),
    adminAt char(1) NOT NULL DEFAULT 'N',
    point bigint NOT NULL DEFAULT 0,
    createAt DATETIME NOT NULL default now(),
    FOREIGN KEY (gIdx) REFERENCES Grade (gIdx) ON DELETE CASCADE
);

-- Email 테이블
CREATE TABLE Email (
    emailIdx int PRIMARY KEY AUTO_INCREMENT,
    userIdx int NOT NULL,
    email varchar(50) NULL,
    esite varchar(20) NOT NULL,
    FOREIGN KEY (userIdx) REFERENCES User (userIdx) ON DELETE CASCADE
);

-- DAddress 테이블
CREATE TABLE DAddress (
    daIdx int PRIMARY KEY AUTO_INCREMENT,
    userIdx int NOT NULL,
    daAddr LONGTEXT NOT NULL,
    subDaAddr LONGTEXT NOT NULL,
    FOREIGN KEY (userIdx) REFERENCES User (userIdx) ON DELETE CASCADE
);

-- GCondition 테이블
CREATE TABLE GCondition (
    jIdx int PRIMARY KEY AUTO_INCREMENT,
    gIdx int NOT NULL,
    bpAmount BIGINT NOT NULL,
    rCount int NOT NULL,
    FOREIGN KEY (gIdx) REFERENCES Grade (gIdx) ON DELETE CASCADE
);


-- Coupon 테이블
CREATE TABLE coupon (
    cIdx int PRIMARY KEY AUTO_INCREMENT,
    cName varchar(60) NOT NULL,
    discount int NOT NULL,
    dcType char(1) NOT NULL DEFAULT '-'
);

-- CouponBox 테이블
CREATE TABLE CouponBox (
    cbIdx int PRIMARY KEY AUTO_INCREMENT,
    userIdx int NOT NULL,
    cIdx int NOT NULL,
    useAt char(1) NOT NULL DEFAULT 'N',
    FOREIGN KEY (userIdx) REFERENCES User (userIdx) ON DELETE CASCADE,
    FOREIGN KEY (cIdx) REFERENCES Coupon (cIdx) ON DELETE CASCADE
);

-- Category 테이블
CREATE TABLE Category (
    categoryNo int PRIMARY KEY AUTO_INCREMENT,
    categoryName varchar(200) NOT NULL
);

-- MCategory 테이블
CREATE TABLE MCategory (
    mcategoryNo int PRIMARY KEY AUTO_INCREMENT,
    categoryNo int NOT NULL,
    mcategoryName varchar(200) NOT NULL,
    FOREIGN KEY (categoryNo) REFERENCES Category (categoryNo) ON DELETE CASCADE
);

-- DCategory 테이블
CREATE TABLE DCategory (
    dcategoryNo int PRIMARY KEY AUTO_INCREMENT,
    mcategoryNo int NOT NULL,
    dcategoryName varchar(200) NOT NULL,
    FOREIGN KEY (mcategoryNo) REFERENCES MCategory (mcategoryNo) ON DELETE CASCADE
);

-- Product 테이블
CREATE TABLE Product (
    pIdx int PRIMARY KEY AUTO_INCREMENT,
    categoryNo int NOT NULL,
    mcategoryNo int NOT NULL,
    dcategoryNo int NOT NULL,
    pName varchar(200) NOT NULL,
    pEx LONGTEXT NOT NULL,
    amount BIGINT NOT NULL DEFAULT 0,
    price BIGINT NOT NULL DEFAULT 0,
    FOREIGN KEY (categoryNo) REFERENCES Category (categoryNo) ON DELETE CASCADE,
    FOREIGN KEY (mcategoryNo) REFERENCES MCategory (mcategoryNo) ON DELETE CASCADE,
    FOREIGN KEY (dcategoryNo) REFERENCES DCategory (dcategoryNo) ON DELETE CASCADE
);

CREATE TABLE ProductImage (
	fileIdx	int PRIMARY KEY AUTO_INCREMENT,
    pIdx int NOT NULL,
    fileName LONGTEXT,
    fileNameLink char(1) default 'Y',
    FOREIGN KEY (pIdx) REFERENCES Product (pIdx) ON DELETE CASCADE
);

-- DStatus 테이블
CREATE TABLE DStatus (
    dsIdx int PRIMARY KEY AUTO_INCREMENT,
    dsType varchar(30) NOT NULL,
    dsContent LONGTEXT NOT NULL
);

-- BuyList 테이블
CREATE TABLE BuyList (
    bIdx int PRIMARY KEY AUTO_INCREMENT,
    userIdx int NOT NULL,
    pIdx int NOT NULL,
    bamount int NOT NULL,
    buyDate DATETIME NOT NULL DEFAULT now(),
	orderNumber bigint NOT NULL,
    buyPrice bigint NOT NULL,
    daIdx int NULL,
    FOREIGN KEY (userIdx) REFERENCES User (userIdx) ON DELETE CASCADE,
    FOREIGN KEY (pIdx) REFERENCES Product (pIdx) ON DELETE CASCADE,
    FOREIGN KEY (daIdx) REFERENCES DAddress (daIdx) ON DELETE CASCADE
);

-- Orders 테이블
CREATE TABLE Orders (
    oIdx int PRIMARY KEY AUTO_INCREMENT,
    dsIdx int NOT NULL DEFAULT 1,
    bIdx int NOT NULL,
    daStartDate DATETIME NOT NULL DEFAULT now(),
    daEndDate DATETIME NOT NULL DEFAULT now(),
    FOREIGN KEY (dsIdx) REFERENCES DStatus (dsIdx) ON DELETE CASCADE,
	FOREIGN KEY (bIdx) REFERENCES BuyList (bIdx) ON DELETE CASCADE
);

-- SCart 테이블
CREATE TABLE SCart (
    scIdx int PRIMARY KEY AUTO_INCREMENT,
    userIdx int NOT NULL,
    pIdx int NOT NULL,
    scamount int NOT NULL DEFAULT 1,
    FOREIGN KEY (userIdx) REFERENCES User (userIdx)  ON DELETE CASCADE,
    FOREIGN KEY (pIdx) REFERENCES Product (pIdx) ON DELETE CASCADE
);

-- Review 테이블
CREATE TABLE review (
    rvIdx int PRIMARY KEY AUTO_INCREMENT,
    pIdx int NOT NULL,
    userIdx int NOT NULL,
    rvContent LONGTEXT NOT NULL,
    reviewPoint int NOT NULL DEFAULT 5,
    rvImg LONGTEXT NULL,
    rvDate DATETIME NOT NULL DEFAULT now(),
    FOREIGN KEY (pIdx) REFERENCES Product (pIdx) ON DELETE CASCADE,
    FOREIGN KEY (userIdx) REFERENCES User (userIdx) ON DELETE CASCADE
);

-- Follow 테이블
CREATE TABLE Follow (
    rfIdx int PRIMARY KEY AUTO_INCREMENT,
    rvIdx int NOT NULL,
    userIdx int NOT NULL,
    followDate DATETIME NOT NULL DEFAULT now(),
    FOREIGN KEY (rvIdx) REFERENCES Review (rvIdx) ON DELETE CASCADE,
    FOREIGN KEY (userIdx) REFERENCES User (userIdx) ON DELETE CASCADE
);

-- Inquiry 테이블
CREATE TABLE Inquiry (
    inIdx int PRIMARY KEY AUTO_INCREMENT,
    pIdx int,
    userIdx int NOT NULL,
    inType varchar(30) NOT NULL DEFAULT '기타',
    inContent LONGTEXT NOT NULL,
    inDate DATETIME NOT NULL DEFAULT now(),
    inPP LONGTEXT NULL,
    inAc char(1) NOT NULL DEFAULT 'N',
    FOREIGN KEY (pIdx) REFERENCES Product (pIdx) ON DELETE CASCADE,
    FOREIGN KEY (userIdx) REFERENCES User (userIdx) ON DELETE CASCADE
);

-- Answer 테이블
CREATE TABLE Answer (
    aIdx int PRIMARY KEY AUTO_INCREMENT,
    inIdx int NOT NULL,
    userIdx int NOT NULL,
    aContent LONGTEXT NOT NULL,
    aDate DATETIME NOT NULL DEFAULT now(),
    FOREIGN KEY (inIdx) REFERENCES Inquiry (inIdx) ON DELETE CASCADE,
    FOREIGN KEY (userIdx) REFERENCES User (userIdx) ON DELETE CASCADE
);

-- Compony 테이블
CREATE TABLE Compony (
    comIdx int PRIMARY KEY AUTO_INCREMENT,
    comName varchar(200) NOT NULL,
    comAddr LONGTEXT NOT NULL,
    comPhone varchar(50) NOT NULL
);

CREATE TABLE UserActivity (
    userActivityId INT PRIMARY KEY AUTO_INCREMENT,
    userIdx INT NOT NULL,
    totalPurchaseAmount BIGINT NOT NULL DEFAULT 0,
    totalReviewCount INT NOT NULL DEFAULT 0,
    lastUpdated DATETIME NOT NULL DEFAULT NOW(),
    FOREIGN KEY (userIdx) REFERENCES User (userIdx) ON DELETE CASCADE
);


-- Chat_logs 테이블
CREATE TABLE Chat_logs (
    chatIdx int PRIMARY KEY AUTO_INCREMENT,
    userId varchar(50) NULL,
    startTime DATETIME NOT NULL DEFAULT now(),
    inputMode char(1) NOT NULL DEFAULT 'T',
    messaginquiryType varchar(50) NOT NULL DEFAULT '기타',
    messageContent LONGTEXT NOT NULL,
    responseText LONGTEXT NOT NULL,
    endTime DATETIME NOT NULL
);

CREATE OR REPLACE
VIEW `shop_list_view` AS
    SELECT 
        `p`.`pIdx` AS `pIdx`,
        `p`.`categoryNo` AS `categoryNo`,
        `p`.`mcategoryNo` AS `mcategoryNo`,
        `p`.`dcategoryNo` AS `dcategoryNo`,
        `p`.`pName` AS `pName`,
        `p`.`pEx` AS `pEx`,
        `p`.`price` AS `price`,
		`p`.`amount` As `amount`,
        `c`.`categoryName` AS `categoryName`,
        `m`.`mcategoryName` AS `mcategoryName`,
        `d`.`dcategoryName` AS `dcategoryName`
    FROM
        (((`product` `p`
        JOIN `category` `c` ON ((`p`.`categoryNo` = `c`.`categoryNo`)))
        JOIN `mcategory` `m` ON ((`p`.`mcategoryNo` = `m`.`mcategoryNo`)))
        JOIN `dcategory` `d` ON ((`p`.`dcategoryNo` = `d`.`dcategoryNo`)));

CREATE OR REPLACE VIEW LoginUserView AS
SELECT DISTINCT
    u.userIdx,
    u.gIdx,
    u.id,
    u.password,
    u.nickName,
    u.name,
    u.phone,
    u.addr,
    u.subAddr,
    u.adminAt,
    u.point,
    u.createAt,
    g.gradeName,
    g.authority,
    g.discount
FROM User u
INNER JOIN Grade g ON u.gIdx = g.gIdx;

CREATE OR REPLACE VIEW UserStatusView AS
SELECT DISTINCT
    u.userIdx,
    u.gIdx,
    u.id,
    u.password,
    u.nickName,
    u.name,
    u.phone,
    u.addr,
    u.subAddr,
    u.adminAt,
    u.point,
    u.createAt,
    e.emailIdx,
    e.email,
    e.esite,
    g.gradeName,
    g.authority,
    g.discount
FROM Email e
RIGHT JOIN User u ON e.userIdx = u.userIdx
INNER JOIN Grade g ON u.gIdx = g.gIdx;

CREATE OR REPLACE VIEW InquiryView AS
SELECT
    i.inIdx,
    i.pIdx,
    i.userIdx,
    i.inType,
    i.inContent,
    i.inDate,
    i.inPP,
    i.inAc,
    u.name,
    u.id,
    p.pName
FROM Inquiry i
INNER JOIN User u ON i.userIdx = u.userIdx
LEFT JOIN Product p ON i.pIdx = p.pIdx;

CREATE OR REPLACE VIEW AnswerView AS
SELECT
    a.aIdx,
    a.inIdx,
    a.userIdx,
    a.aContent,
    a.aDate,
    u.name,
    u.adminAt
FROM Answer a
INNER JOIN User u ON a.userIdx = u.userIdx;

CREATE OR REPLACE VIEW ShippingView AS
SELECT
    o.oIdx,
    o.dsIdx,
    o.bIdx,
    o.daStartDate,
    o.daEndDate,
    b.userIdx,
    b.pIdx,
    b.bamount,
    b.buyDate,
    b.buyPrice,
    ds.dsContent,
    u.name,
    p.pName,
    p.price,
    da.daIdx,
    da.daAddr,
    da.subDaAddr
FROM Orders o
INNER JOIN Buylist b ON o.bIdx = b.bIdx
INNER JOIN DStatus ds ON o.dsIdx = ds.dsIdx
INNER JOIN User u ON b.userIdx = u.userIdx
INNER JOIN Product p ON b.pIdx = p.pIdx
INNER JOIN daddress da ON b.daIdx = da.daIdx;

CREATE OR REPLACE VIEW ReviewView AS
SELECT
    r.rvIdx,
    r.pIdx,
    r.userIdx,
    r.rvContent,
    r.reviewPoint,
    r.rvImg,
    r.rvDate,
    u.gIdx,
    u.id,
    u.password,
    u.nickName,
    u.name,
    u.phone,
    u.addr,
    u.subAddr,
    u.adminAt,
    u.point,
    u.createAt
FROM review r
INNER JOIN User u ON r.userIdx = u.userIdx;

CREATE OR REPLACE VIEW CartView AS
SELECT
    c.scIdx,
    c.userIdx,
    c.pIdx,
    c.scamount,
    p.categoryNo,
    p.dcategoryNo,
    p.mcategoryNo,
    p.pName,
    p.pEx,
    p.price,
    i.fileName
FROM Scart c
INNER JOIN Product p ON c.pIdx = p.pIdx
LEFT JOIN ProductImage i ON p.pIdx = i.pIdx;

CREATE OR REPLACE VIEW productListView AS
SELECT
    p.categoryNo,
    p.mcategoryNo,
    p.dcategoryNo,
    p.pName,
    p.pEx,
    p.amount,
    p.price,
    p.pIdx,
    i.fileIdx,
    i.fileName,
    i.fileNameLink
FROM Product p
LEFT JOIN (
    SELECT pIdx, MIN(fileIdx) AS minFileIdx
    FROM productimage
    GROUP BY pIdx
) AS minImages ON p.pIdx = minImages.pIdx
LEFT JOIN productimage i ON minImages.pIdx = i.pIdx AND minImages.minFileIdx = i.fileIdx;

CREATE OR REPLACE VIEW productOneView AS
SELECT DISTINCT
    p.categoryNo,
    p.mcategoryNo,
    p.dcategoryNo,
    p.pName,
    p.pEx,
    p.amount,
    p.price,
	i.pIdx,
    i.fileIdx,
    i.fileName
FROM Product p
LEFT JOIN productimage i ON p.pIdx = i.pIdx;

CREATE OR REPLACE VIEW BuyListView AS
SELECT
    p.pIdx,
    c.categoryName,
    m.mcategoryName,
    d.dcategoryName,
    p.pName,
    b.bamount,
    (p.price*bamount) as price,
    u.name,
    b.buyDate,
    b.buyPrice,
    b.bIdx,
    b.orderNumber
FROM BuyList b
INNER JOIN Product p ON b.pIdx = p.pIdx
INNER JOIN User u ON b.userIdx = u.userIdx
INNER JOIN Category c ON p.categoryNo = c.categoryNo
INNER JOIN MCategory m ON p.mcategoryNo = m.mcategoryNo
INNER JOIN DCategory d ON p.dcategoryNo = d.dcategoryNo;

CREATE OR REPLACE VIEW gradeAllView AS
SELECT
    ua.userIdx,
    ua.totalPurchaseAmount,
    ua.totalReviewCount,
    g.gIdx,
    g.gradeName,
    g.discount
FROM userActivity ua
INNER JOIN User u ON ua.userIdx = u.userIdx
INNER JOIN grade g ON u.gIdx = g.gIdx;

-- Grade 테이블에 샘플 데이터 삽입
INSERT INTO Grade(gradeName, authority, discount)
VALUES ('브론즈', 1, 0),
	('실버', 1, 3),
	('골드', 2, 3),
	('다이아', 2, 5),
	('마스터', 3, 5);

INSERT INTO GCondition (gIdx, bpAmount, rCount) VALUES
	(1, 0, 0),
	(2, 100000, 5),
	(3, 500000, 20),
	(4, 1000000, 50),
	(5, 2000000, 100);

-- User 테이블에 샘플 데이터 삽입
INSERT INTO User(gIdx, id, password, nickName, name, phone, addr, subAddr, adminAt, point)
VALUES (5, 'admin', 'admin', '관리자', '관리자', '미공개', '서울시 관악구', '미공개', 'Y', 10000000),
	(1, 'user1', 'user1', '김원진', '김원진', '010-1111-1111', '미공개', '미공개', 'N', default),
	(2, 'user2', 'user2', '배현진', '배현진', '010-2222-2222', '미공개', '미공개', 'N', default),
	(3, 'user3', 'user3', '강민경', '강민경', '010-3333-3333', '미공개', '미공개', 'N', default),
	(4, 'user4', 'user4', '손호영', '손호영', '010-4444-4444', '미공개', '미공개', 'N', default),
	(5, 'user5', 'user5', '매니저(심우림)', '심우림', '010-5555-5555', '미공개', '미공개', 'N', 1000000);

-- UserActivity 테이블에 샘플 데이터 삽입
INSERT INTO UserActivity (userIdx, totalPurchaseAmount, totalReviewCount)
VALUES (2, 0, 0),
    (3, 0, 0),
    (4, 0, 0),
    (5, 0, 0),
    (6, 0, 0);

-- 대 카테고리 데이터 추가
INSERT INTO category values(null,'게임');
INSERT INTO category values(null,'스포츠');

-- 중 카테고리 데이터 추가 게임
INSERT INTO mcategory values(null,1,'키보드');
INSERT INTO mcategory values(null,1,'마우스');
INSERT INTO mcategory values(null,1,'노트북');

-- 중 카테고리 데이터 추가 스포츠
INSERT INTO mcategory values(null,2,'축구');
INSERT INTO mcategory values(null,2,'야구');
INSERT INTO mcategory values(null,2,'농구');

-- 소 카테고리 데이터 추가  
-- 키보드
INSERT INTO dcategory values(null,1,'키보드패드');
INSERT INTO dcategory values(null,1,'기계식키보드');
INSERT INTO dcategory values(null,1,'멤브레인키보드');
INSERT INTO dcategory values(null,1,'게이밍키보드');

-- 마우스
INSERT INTO dcategory values(null,2,'손목받침대');
INSERT INTO dcategory values(null,2,'마우스패드');
INSERT INTO dcategory values(null,2,'손목보호마우스');
INSERT INTO dcategory values(null,2,'게이밍마우스');

-- 노트북
INSERT INTO dcategory values(null,3,'게이밍노트북');
INSERT INTO dcategory values(null,3,'사무용노트북');
INSERT INTO dcategory values(null,3,'노트북거치대');
INSERT INTO dcategory values(null,3,'노트북가방');

-- 스포츠 축구
INSERT INTO dcategory values(null,4,'축구화');
INSERT INTO dcategory values(null,4,'축구공');
INSERT INTO dcategory values(null,4,'축구용품');
INSERT INTO dcategory values(null,4,'축구의상');

-- 스포츠 야구
INSERT INTO dcategory values(null,5,'야구배트');
INSERT INTO dcategory values(null,5,'야구공');
INSERT INTO dcategory values(null,5,'글러브');
INSERT INTO dcategory values(null,5,'야구의상');

-- 스포츠 농구
INSERT INTO dcategory values(null,6,'농구공');
INSERT INTO dcategory values(null,6,'농구화');
INSERT INTO dcategory values(null,6,'농구의상');
INSERT INTO dcategory values(null,6,'무릎보호대');

-- 상품 데이터 추가 대 1=게임 2=스포츠 / 중 1=키보드 2=마우스 5=축구 6=야구 / 소 1~8까지 게임카테고리 9~16까지 스포츠카테고리
-- 소카테고리 하나당 상품 3개씩 키보드패드
insert into product values(null, 1, 1, 1, '각청 장패드', '각청이 그려진 장패드', 5, 50000);
insert into product values(null, 1, 1, 1, '일반 장패드', '꾸밈 없는 장패드', 6, 20000);
insert into product values(null, 1, 1, 1, '커스텀 장패드', '원하는 그림이 그려진 장패드', 7, 80000);

-- 소카테고리 하나당 상품 3개씩 기계식키보드
insert into product values(null, 1, 1, 2, '기계식키보드1', '흑축키보드', 3, 170000);
insert into product values(null, 1, 1, 2, '기계식키보드2', '갈축키보드', 1, 80000);
insert into product values(null, 1, 1, 2, '기계식키보드3', '적축키보드', 4, 110000);

-- 소카테고리 하나당 상품 3개씩 멤브레인키보드
insert into product values(null, 1, 1, 3, '멤브레인키보드1', '가격이 저렴한 멤브레인키보드1', 17, 20000);
insert into product values(null, 1, 1, 3, '멤브레인키보드2', '가격이 저렴한 멤브레인키보드2', 14, 10000);
insert into product values(null, 1, 1, 3, '멤브레인키보드3', '기계식인척하는 멤브레인키보드', 4, 40000);

-- 소카테고리 하나당 상품 3개씩 게이밍키보드
insert into product values(null, 1, 1, 4, '게이밍키보드1', '아무튼 반짝이는 화려한 키보드1', 7, 70000);
insert into product values(null, 1, 1, 4, '게이밍키보드2', '아무튼 반짝이는 화려한 키보드2', 4, 200000);
insert into product values(null, 1, 1, 4, '게이밍키보드3', '아무튼 반짝이는 화려한 키보드3', 3, 120000);

-- 소카테고리 하나당 상품 3개씩
insert into product values(null, 1, 2, 5, '실리콘 손목받침대', '실리콘 손목받침대', 3, 5000);
insert into product values(null, 1, 2, 5, '원목 손목받침대', '원목 손목받침대', 3, 20000);

-- 소카테고리 하나당 상품 3개씩
insert into product values(null, 1, 2, 6, '라이덴 마우스패드', '쇼군이 그려진 마우스패드', 5, 40000);
insert into product values(null, 1, 2, 6, '일반 마우스패드', '그냥 마우스패드', 5, 10000);
insert into product values(null, 1, 2, 6, '대형 마우스패드', 'fps게임에 유리한 대형 마우스패드', 5, 20000);

-- 소카테고리 하나당 상품 3개씩
insert into product values(null, 1, 2, 7, '손목보호 마우스1', '인체공학적으로 만들어진 손목보호마우스1', 5, 30000);
insert into product values(null, 1, 2, 7, '손목보호 마우스2', '인체공학적으로 만들어져 야근에 적합한 손목보호마우스2', 5, 40000);
insert into product values(null, 1, 2, 7, '손목보호 업무용 마우스3', '인체공학적으로 만들어져 사무용으로 적합한 손목보호마우스3', 5, 25000);

-- 소카테고리 하나당 상품 3개씩
insert into product values(null, 1, 2, 8, '게이밍마우스1', '반응이 빠른 게이밍 마우스', 5, 70000);
insert into product values(null, 1, 2, 8, '게이밍마우스2', '반응이 빠르고 내구성이 좋은 게이밍 마우스', 5, 170000);
insert into product values(null, 1, 2, 8, '게이밍마우스1', '내구성이 좋은 게이밍 마우스', 5, 100000);

-- 소카테고리 하나당 상품 3개씩
insert into product values(null, 2, 5, 9, '유명한 축구화', '대중적인 축구화', 30, 210000);
insert into product values(null, 2, 5, 9, '코난 운동화', '다이얼을 돌리고 차면 10배 강하게 나간다', 1, 21000000);
insert into product values(null, 2, 5, 9, '그냥 축구화', '그냥 축구화', 3, 100000);

-- 소카테고리 하나당 상품 3개씩 
insert into product values(null, 2, 5, 10, '그냥 축구공', '그냥 축구공', 3, 20000);
insert into product values(null, 2, 5, 10, '자블라니', '개같은 축구공', 3, 50000);
insert into product values(null, 2, 5, 10, '바람 넣는 펌프', '공에 바람을 넣는 펌프', 3, 20000);

-- 소카테고리 하나당 상품 3개씩 
insert into product values(null, 2, 5, 11, '토트넘 유니폼', '등번호 7번', 3, 200000);
insert into product values(null, 2, 5, 11, '체육복', '아무데나 입기 좋은 트레이닝복 세트', 3, 40000);
insert into product values(null, 2, 5, 11, '양말', '시멘트 바닥에 굴러도 끄떡없는 양말', 3, 10000);

-- 소카테고리 하나당 상품 3개씩 
insert into product values(null, 2, 5, 12, '기타상품', '나도몰라잉', 1, 1000);

-- 소카테고리 하나당 상품 3개씩 
insert into product values(null, 2, 6, 13, '알루미늄배트', '부산행 찍기 딱 좋은 빠따', 4, 51000);
insert into product values(null, 2, 6, 13, '나무배트', '홈런 치기 딱 좋은 빠따', 4, 101000);
insert into product values(null, 2, 6, 13, '티타늄배트', '손목 박살나기 딱 좋은 빠따', 4, 201000);

-- 소카테고리 하나당 상품 3개씩 
insert into product values(null, 2, 6, 14, '그냥 야구공', '언제나 쓰기 적당한 야구공', 4, 20000);
insert into product values(null, 2, 6, 14, '말랑한 야구공', '애들이 갖고 놀아도 안전한 야구공', 4, 30000);
insert into product values(null, 2, 6, 14, '장식용 가짜 싸인볼', '그냥 집에 장식하는 용도', 4, 10000);

-- 소카테고리 하나당 상품 3개씩 
insert into product values(null, 2, 6, 15, '그냥 글러브', '누구나 쓰기 좋은 글러브', 4, 31000);
insert into product values(null, 2, 6, 15, '튼튼한 글러브', '내구성이 좋은 글러브', 4, 101000);
insert into product values(null, 2, 6, 15, '아동용 글러브', '아이들이 쓰기 좋은 글러브', 4, 21000);

-- 소카테고리 하나당 상품 3개씩 
insert into product values(null, 2, 6, 16, '기타', '모자?', 4, 100);

-- Email 테이블 더미 데이터
insert into email values(null, 3, 'bhj12674@gmail.com', 'google');

-- DStatus 테이블 예시 데이터
INSERT INTO DStatus (dsType, dsContent) VALUES ('pending', '주문 접수 완료');
INSERT INTO DStatus (dsType, dsContent) VALUES ('preparing', '배송 준비중');
INSERT INTO DStatus (dsType, dsContent) VALUES ('shipping', '배송중');
INSERT INTO DStatus (dsType, dsContent) VALUES ('completed', '배송 완료');


select * from product;
-- BuyList 테이블 예시 데이터
INSERT INTO BuyList (userIdx, pIdx, bamount, orderNumber, buyPrice) VALUES (2, 43, 1, 1234, 10000);
INSERT INTO BuyList (userIdx, pIdx, bamount, orderNumber, buyPrice) VALUES (2, 4, 1, 2345, 20000);
INSERT INTO BuyList (userIdx, pIdx, bamount, orderNumber, buyPrice) VALUES (2, 21, 1, 3456, 1000);
INSERT INTO BuyList (userIdx, pIdx, bamount, orderNumber, buyPrice) VALUES (6, 43, 1, 4567, 2000);

-- Orders 테이블에 주문 데이터 삽입
INSERT INTO Orders (dsIdx, bIdx, daStartDate, daEndDate) VALUES ((SELECT dsIdx FROM DStatus WHERE dsType = 'pending'),1, NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY));
INSERT INTO Orders (dsIdx, bIdx, daStartDate, daEndDate) VALUES ((SELECT dsIdx FROM DStatus WHERE dsType = 'pending'),2, NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY));
INSERT INTO Orders (dsIdx, bIdx, daStartDate, daEndDate) VALUES ((SELECT dsIdx FROM DStatus WHERE dsType = 'pending'),3, NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY));
INSERT INTO Orders (dsIdx, bIdx, daStartDate, daEndDate) VALUES ((SELECT dsIdx FROM DStatus WHERE dsType = 'pending'),4, NOW(), DATE_ADD(NOW(), INTERVAL 2 DAY));

-- Coupon 테이블 쿼리 추가
INSERT INTO Coupon (cName, discount, dcType)
VALUES ('회원가입 축하 쿠폰', 5000, '-');
INSERT INTO Coupon (cName, discount, dcType)
VALUES ('오픈 기념 쿠폰', 10, '%');
INSERT INTO Coupon (cName, discount, dcType)
VALUES ('가을맞이 쿠폰', 5, '%');
INSERT INTO Coupon (cName, discount, dcType)
VALUES ('첫 이용기념', 1000, '-');
INSERT INTO Coupon (cName, discount, dcType)
VALUES ('생일 축하합니다:)', 10000, '-');
-- CouponBox 테이블 쿼리 추가
INSERT INTO CouponBox (userIdx, cIdx, useAt) VALUES
(1, 1, 'N'),
(1, 2, 'N'),
(1, 3, 'N'),
(1, 4, 'N'),
(2, 1, 'N'),
(2, 2, 'N'),
(2, 3, 'N'),
(2, 4, 'N'),
(3, 1, 'N'),
(3, 2, 'N'),
(3, 3, 'N'),
(3, 4, 'N'),
(4, 1, 'N'),
(4, 2, 'N'),
(4, 3, 'N'),
(4, 4, 'N'),
(5, 1, 'N'),
(5, 2, 'N'),
(5, 3, 'N'),
(5, 4, 'N'),
(6, 1, 'N'),
(6, 2, 'N'),
(6, 3, 'N'),
(6, 4, 'N');

drop procedure if exists update_order_status;

DELIMITER //

CREATE PROCEDURE update_order_status()
BEGIN
    -- 배송준비중 상태로 변경 (pending 상태로 1시간 경과)
    UPDATE Orders
    JOIN DStatus AS ds ON Orders.dsIdx = ds.dsIdx
    SET Orders.dsIdx = (SELECT dsIdx FROM DStatus WHERE dsType = 'preparing')
    WHERE ds.dsType = 'pending' AND TIMESTAMPDIFF(MINUTE, Orders.daStartDate, NOW()) >= 1;
    
    -- 배송중 상태로 변경 (preparing 상태로 2시간 경과)
    UPDATE Orders
    JOIN DStatus AS ds ON Orders.dsIdx = ds.dsIdx
    SET Orders.dsIdx = (SELECT dsIdx FROM DStatus WHERE dsType = 'shipping')
    WHERE ds.dsType = 'preparing' AND TIMESTAMPDIFF(MINUTE, Orders.daStartDate, NOW()) >= 2;
    
    -- 배송 완료 상태로 변경 (shipping 상태로 3시간 경과)
    UPDATE Orders
    JOIN DStatus AS ds ON Orders.dsIdx = ds.dsIdx
    SET Orders.dsIdx = (SELECT dsIdx FROM DStatus WHERE dsType = 'completed')
    WHERE ds.dsType = 'shipping' AND TIMESTAMPDIFF(MINUTE, Orders.daStartDate, NOW()) >= 3;
END //

DELIMITER ;

-- 이벤트 스케줄러가 활성화되어 있는지 확인
SHOW VARIABLES LIKE 'event_scheduler';

-- 이벤트 스케줄러 활성화 (활성화되어 있지 않다면)
SET GLOBAL event_scheduler = ON;

drop event if exists update_order_status_event;
-- 상태 업데이트 이벤트 생성
CREATE EVENT update_order_status_event
ON SCHEDULE EVERY 1 MINUTE
DO
    CALL update_order_status();

Drop PROCEDURE IF EXISTS UpdateUserGrade;

-- 등급 조정 관련 DB 정리
DELIMITER $$

CREATE PROCEDURE UpdateUserGrade(IN userId INT)
BEGIN
    -- 변수 선언
    DECLARE currentGrade INT;
    DECLARE newGrade INT;
    DECLARE userBpAmount BIGINT;
    DECLARE userRCount INT;
    DECLARE currentGradeBpAmount BIGINT;
    DECLARE currentGradeRCount INT;

    -- 현재 등급 가져오기
    SELECT gIdx INTO currentGrade FROM User WHERE userIdx = userId;

    -- 사용자의 총 구매 금액과 리뷰 수 가져오기
    SELECT totalPurchaseAmount, totalReviewCount INTO userBpAmount, userRCount
    FROM UserActivity WHERE userIdx = userId;

    -- 현재 상태 출력
    SELECT '현재 등급: ', currentGrade, '구매 금액: ', userBpAmount, '리뷰 수: ', userRCount;

    -- 하락 조건 체크
    decrease_loop: WHILE currentGrade > 1 DO
        -- 현재 등급 조건 가져오기
        SELECT bpAmount, rCount INTO currentGradeBpAmount, currentGradeRCount
        FROM GCondition WHERE gIdx = currentGrade;

        IF (userBpAmount < currentGradeBpAmount OR userRCount < currentGradeRCount) THEN
            SET currentGrade = currentGrade - 1; -- 등급 하락
            UPDATE User SET gIdx = currentGrade WHERE userIdx = userId;
            SELECT '등급 하락: ', currentGrade;  -- 하락한 등급 출력
        ELSE
            LEAVE decrease_loop; -- 조건이 충족되면 종료
        END IF;
    END WHILE;

    -- 상승 조건 체크
    increase_loop: WHILE currentGrade < (SELECT MAX(gIdx) FROM Grade) DO
        SET newGrade = currentGrade + 1;

        -- 신규 등급 조건 가져오기
        SELECT bpAmount, rCount INTO currentGradeBpAmount, currentGradeRCount
        FROM GCondition WHERE gIdx = newGrade;

        IF (userBpAmount >= currentGradeBpAmount AND userRCount >= currentGradeRCount) THEN
            SET currentGrade = newGrade; -- 등급 상승
            UPDATE User SET gIdx = currentGrade WHERE userIdx = userId;
            SELECT '등급 상승: ', currentGrade;  -- 상승한 등급 출력
        ELSE
            LEAVE increase_loop; -- 조건이 충족되지 않으면 종료
        END IF;
    END WHILE;
END $$

select * from buylistview



