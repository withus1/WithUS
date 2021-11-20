<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%
		String userID = null;
		if (session.getAttribute("id") != null){
			userID = (String) session.getAttribute("id");
		}
		
		if(userID == null){
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어 있지않는 상태입니다.");
			response.sendRedirect("../Login.html");
			return;
		}
	%>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"> <!-- 반응형 웹 -->
	<link rel="stylesheet" href="../css/bootstrap.css"> <!-- bootstrap.css 파일 -->
	<link rel="stylesheet" href="../css/custom.css">
	<script src="../js/jquery-3.6.0.min.js"></script> <!-- jquery 추가 -->
	<script src="../js/bootstrap.js"></script>
	
	<!-- sidebar 관련 (경로가 달라서 따로 추가) -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.2/css/bulma.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
        crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <script src="https://kit.fontawesome.com/d1c6c79e37.js" crossorigin="anonymous"></script>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@200&display=swap');

        html,
        body {
            height: 100%;
        }

        a {
            text-decoration-line: none;
        }
        
        .header {
			height: 7%;
		}
		
		a>.title {
			padding-top: 4%;
			color: rgb(0, 0, 0);
			text-align: center;
			font-size: 2rem;
			font-weight: 900;
			font-family: 'Poppins', sans-serif;
			z-index: 0;
		}
		
		.header>img {
			position: fixed;
			width: 10%;
			height: 10%;
			float: right;
			z-index: 1;
		}

        /* css 추가 */
        /* 사이드메뉴 */
        .sidebar {
            position: absolute;
            top: 0px;
            right: 5px;
            width: 20%;
            margin: 0 0;
        }

        .sidebarNav {
            background-color: rgba(66, 135, 245, 1);
            height: 15%;
            line-height: 15%;

        }

        .sidebarUser {
            display: flex;
            flex-wrap: wrap;

        }

        .sidebarImage {
            width: 15%;
            line-height: 15%;
        }

        .sidebarUserName {
            flex: 1 1 80%;
            font-size: 1.4rem;
            line-height: 10%;
            color: white;
            padding-top: 3%;
            padding-left: 8%;
        }

        .sidebarUserLevel {
            flex: 1 1 30%;
            font-size: 0.9rem;
            padding-top: 10%;
        }

        .sidebarBody {
            background: snow;
            padding: 0 0;
        }

        .sidebarFooter {
            display: flex;
            background-color: rgba(66, 135, 245, 1);
            position: absolute;
            bottom: 0px;
            height:6%;
            width: 100%;
            padding-top: 1.5%;
        }

        .sidebarLogout {
            color: white;
            font-size: 1.4rem;
            width: 50%;
            text-align: center;
        }

        .sidebarDelete {
            color: white;
            font-size: 1.4rem;
            width: 50%;
            text-align: center;
        }

        .btn-toggle {
            background-color: lightgray;
            width: 100%;
            text-align: left;
            font-weight: bold;
        }

        .btn-toggle-nav li {
            padding: 2%;
            margin-left:2%;
            font-weight: bold;
        }
        
        .btn-close {
            width: 100%;
            background: transparent url("image/사이드바닫기.png") center/3rem auto no-repeat;
        }
        
        .bi-caret-down-fill {
            float:right;
            margin-top:1%;
        }

        .sidebarFooterSpace {
            background-color:white;
            width: 0.4%;
            margin: auto auto;
            border-radius: 20px;
        }
		
		/* chat card 관련 */
        .chat {
            margin: 7%;
        }

        .card {
            padding: 5% 5% 0 5%;
            margin-bottom: 5%;
        }

        .otherName {
            font-weight: 700;
        }
        
        .unreadTotal {
        	float: right;
        	margin-top: 3%;
        	margin-right: 5%;
            background-color: #4287F5;
            border-radius: 20%;
            color: #ffffff;
            width: 30px;
            height: 30px;
            line-height: 25px;
            vertical-align: middle;
            text-align: center;
        }

        .unread {
            float: right;
            background-color: #4287F5;
            border-radius: 20%;
            color: #ffffff;
            width: 30px;
            height: 30px;
            line-height: 25px;
            vertical-align: middle;
            text-align: center;
        }

        .content {
            vertical-align: middle;
        }

        .date {
            color: #cacaca;
        }
    </style>
	
	<script type="text/javascript">
	function getUnread() {
		$.ajax({
			 type: "POST",
			 url: "../chatUnread",
			 data: {
				 userID: encodeURIComponent('<%= userID %>'),
			 },
			 success: function(result) {
				 if(result >= 1) {
					 showUnread(result);
				 } else {
					 showUnread("");
				 }
			 }
		});
	}
	
	function getInfiniteUnread() {
		setInterval(function() {
			getUnread();
		}, 4000);
	}
	
	function showUnread(result) {
		$('#unread').html(result);
	}
	
	function chatBoxFunction(){
		var userID = '<%= userID %>';
		$.ajax({
			 type: "POST",
			 url: "../chatBox",
			 data: {
				 userID: encodeURIComponent(userID),
			 },
			 success: function(data) {
				 if(data == "") return;
				 $('#boxTable').html('');
				 var parsed = JSON.parse(data);
				 var result = parsed.result;
				 console.log(result);
				 for(var i = 0; i < result.length; i++) {
					 if(result[i][0].value == userID){
						 result[i][0].value = result[i][1].value;
					 } else {
						 result[i][1].value = result[i][0].value;
					 }
					 addBox(result[i][0].value, result[i][1].value, result[i][2].value, result[i][3].value, result[i][4].value);
				 }
			 }
		});
	}
	
	function addBox(lastID, toID, chatContent, chatTime, unread){
		$('#boxTable').append(
				'<div class="card" onclick="location.href=\'chat.jsp?toID=' + encodeURIComponent(toID) + '\'">' +
				'<div class="info">' +
				'<span class="otherName">' + lastID + '</span>' +
				'<span id="unread" class="label label-info unread">' + unread + '</span>' +
				'</div>' +
				'<p class="content">' + chatContent + '</p>' +
				'<p class="date">' + chatTime + '</p>' +
				'</div>'
		);
	}
	
	function getInfiniteBox() {
		setInterval(function() {
			chatBoxFunction();
		}, 3000);
	}
	</script>
</head>
<body>
	<div class="header">
        <a href="">
            <p class="title">With US</p>
        </a>
            <div class="btn sidebar" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasWithBackdrop" aria-controls="offcanvasWithBackdrop">
                <img src="../image/sidebar.png" alt="" style="width: 100%">
            </div>    
    </div>

    <!-- 사이드메뉴 -->
    <div class="offcanvas offcanvas-start" tabindex="-1" id="offcanvasWithBackdrop"
        aria-labelledby="offcanvasWithBackdropLabel">
        <div class="offcanvas-header sidebarNav">
            <div class="offcanvas-title sidebarUser" id="offcanvasWithBackdropLabel">
                <div class="sidebarImage">
                    <div id="image">
                    	<!-- <img src="image/마이페이지사람.png" style="border-radius: 100%;"> -->
                    </div>
                </div>
                <div class="sidebarUserName">
                    <div id="username">
                    	<!-- 홍길동 -->
                    </div>
                    <div class="sidebarUserLevel" id="level">
                        <div id="level">
	                    	<!-- Lv. 1 -->
	                    </div>
                        <img src="../image/새싹.png" style="width: 15%">
                    </div>
                </div>
            </div>
            <div class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Close">
            </div>
        </div>
        <div class="offcanvas-body sidebarBody">
            <ul class="list-unstyled ps-0">
                <li class="mb-1">
                    <button class="btn btn-toggle collapsed" data-bs-toggle="collapse"
                        data-bs-target="#home-collapse" aria-expanded="true">
                        카테고리
                        <svg xmlns="http://www.w3.org/2000/svg" width="30" height="16" fill="currentColor" class="bi bi-caret-down-fill" viewBox="0 0 16 16">
                            <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
                        </svg>
                    </button>
                    <div class="collapse show" id="home-collapse">
                        <ul class="btn-toggle-nav list-unstyled fw-normal pb-1">
                            <li><a href="#" class="link-dark rounded">추천</a></li>
                            <li><a href="#" class="link-dark rounded">식사</a></li>
                            <li><a href="#" class="link-dark rounded">운동</a></li>
                            <li><a href="#" class="link-dark rounded">스터디</a></li>
                            <li><a href="#" class="link-dark rounded">게임</a></li>
                            <li><a href="#" class="link-dark rounded">구독</a></li>
                        </ul>
                    </div>
                </li>
                <li class="mb-1">
                    <button class="btn btn-toggle collapsed" data-bs-toggle="collapse"
                        data-bs-target="#notice-collapse" aria-expanded="false">
                        공지사항
                        <svg xmlns="http://www.w3.org/2000/svg" width="30" height="16" fill="currentColor" class="bi bi-caret-down-fill" viewBox="0 0 16 16">
                            <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
                        </svg>
                    </button>
                    <div class="collapse" id="notice-collapse">
                        <ul class="btn-toggle-nav list-unstyled fw-normal pb-1">
                            <li><a href="#" class="link-dark rounded">test1</a></li>
                            <li><a href="#" class="link-dark rounded">test2</a></li>
                            <li><a href="#" class="link-dark rounded">test3</a></li>
                            <li><a href="#" class="link-dark rounded">test4</a></li>
                        </ul>
                    </div>
                </li>
                <li class="mb-1">
                    <button class="btn btn-toggle collapsed" data-bs-toggle="collapse"
                        data-bs-target="#chatlist-collapse" aria-expanded="false">
                        채팅목록
                        <svg xmlns="http://www.w3.org/2000/svg" width="30" height="16" fill="currentColor" class="bi bi-caret-down-fill" viewBox="0 0 16 16">
                            <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
                        </svg>
                    </button>
                    <div class="collapse" id="chatlist-collapse">
                        <ul class="btn-toggle-nav list-unstyled fw-normal pb-1">
                            <li><a href="jsp/box.jsp" class="link-dark rounded">채팅목록보기</a></li>
                        </ul>
                    </div>
                </li>
                <li class="mb-1">
                    <button class="btn btn-toggle collapsed" data-bs-toggle="collapse"
                        data-bs-target="#mypage-collapse" aria-expanded="false">
                        마이페이지
                        <svg xmlns="http://www.w3.org/2000/svg" width="30" height="16" fill="currentColor" class="bi bi-caret-down-fill" viewBox="0 0 16 16">
                            <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
                        </svg>
                    </button>
                    <div class="collapse" id="mypage-collapse">
                        <ul class="btn-toggle-nav list-unstyled fw-normal pb-1">
                            <li><a href="mypage.html" class="link-dark rounded">마이페이지 바로가기</a></li>
                            <li><a href="mypage2.html" class="link-dark rounded">프로필 수정하기</a></li>
                        </ul>
                    </div>
                </li>
            </ul>
        </div>

        <div class="sidebarFooter">
            <div class="sidebarLogout" onclick="location.href='jsp/logout.jsp'">
                로그아웃
            </div>
            <div class="sidebarFooterSpace">
                &nbsp;
            </div>
            <div class="sidebarDelete" onclick="location.href='../withdraw.html'">
                탈퇴하기
            </div>
        </div>
    </div>
    
	<!-- navbar
	<div class="container bootstrap snippet">
		<a href="box.jsp">메시지함<span id="unread" class="label label-info unread"></span></a>
	</div>
	-->
	
	<div class="chat">
        <div class="chatTitle">
            <span style="font-size: 2rem;">채팅목록</span>
            <span id="unread" class="label label-info unreadTotal"></span>
            <hr>
        </div>
        
        <div class="chatList" style="overflow-y: auto;">
            <div class="chatCard" id="boxTable">
            	<!-- 여기에 추가됨 -->
            </div>
        </div>
        
	<%
		String messageContent = null;
		if(session.getAttribute("messageContent") != null){
			messageContent = (String) session.getAttribute("messageContent");
		}
		String messageType = null;
		if(session.getAttribute("messageType") != null){
			messageType = (String) session.getAttribute("messageType");
		}
	%>
	
	<%
		if(userID != null){
	%>
	<script type="text/javascript">
		$(document).ready(function(){
			getUnread();
			getInfiniteUnread();
			chatBoxFunction();
			getInfiniteBox();
		});
	</script>
	<%
		}
	%>
	
</body>
</html>