<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<!DOCTYPE html>
<html>
<head>
   <%
      String userID = null;
      if (session.getAttribute("id") != null){
         userID = (String) session.getAttribute("id");
      }
      
      if(userID == null) {
         session.setAttribute("messageType", "오류 메시지");
         session.setAttribute("messageContent", "현재 로그인이 되어 있지않는 상태입니다.");
         response.sendRedirect("index.jsp");
         return;
      }
      
      String toID = null;
      if (request.getParameter("toID") != null) {
         toID = (String) request.getParameter("toID");
      }
      
      if(toID == null || toID.equals("")) {
         session.setAttribute("messageType", "오류 메시지");
         session.setAttribute("messageContent", "대화 상대가 지정되지 않았습니다.");
         response.sendRedirect("index.jsp");
         return;
      }
      
      if(userID.equals(URLDecoder.decode(toID, "UTF-8"))) {
         session.setAttribute("messageType", "오류 메시지");
         session.setAttribute("messageContent", "자기 자신에게는 쪽지를 보낼 수 없습니다.");
         response.sendRedirect("index.jsp");
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
        
        /* chat input */
        .send {
            position: fixed;
            width: 90%;
            bottom: 2%;
            padding: 1% 8%;
            border: 3px solid rgba(202, 202, 202, 1);
            border-radius: 15px;
        }

        .send>input {
            width: 100%;
            height: 40px;
            border: 0px;
            border-radius: 10px;
            padding-left: 10px;
            font-size: 1rem;
            color: black;
            padding-right: 40px;
        }

        .send>input:focus {
            outline-width: 0;
        }

        .fa-paper-plane {
            background-color: transparent;
            border: none;
            position: absolute;
            right: 8px;
            top: 30%;
            font-size: 1.4rem;
            color: rgba(202, 202, 202, 1);
            margin-right: 8%;
        }
    </style>
   
   <script type="text/javascript">
   function autoClosingAlert(selector, delay) {
      var alert = $(selector).alert();
      alert.show();
      window.setTimeout(function(){ alert.hide() }, delay);
   }
   
   function submitFunction() {
      var fromID = '<%= userID %>';
      var toID = '<%= toID %>';
      var chatContent = $('#chatContent').val();
      console.log(fromID, toID, chatContent);
      $.ajax({
         type: "POST",
         url: "../chatSubmitServlet",
         data: {
            fromID: encodeURIComponent(fromID),
            toID: encodeURIComponent(toID),
            chatContent: encodeURIComponent(chatContent)
         },
         success: function(result) {
            if(result == 1) {
               autoClosingAlert('#successMessage', 2000);
            } else if(result == 0) {
               autoClosingAlert('#dangerMessage', 2000);
            } else {
               autoClosingAlert('#warningMessage', 2000);
            }
         }
      });
      $('#chatContent').val("");
   }
   
   var lastID = 0;
   function chatListFunction(type) {
      var fromID = '<%= userID %>';
      var toID = '<%= toID %>';
      $.ajax({
         type: "POST",
         url: "../chatListServlet",
         data: {
            fromID: encodeURIComponent(fromID),
            toID: encodeURIComponent(toID),
            listType: type
         },
         success: function(data) {
            if(data == "") return;
            var parsed = JSON.parse(data);
            var result = parsed.result;
            for (var i = 0; i < result.length; i++) {
               addChat(result[i][0].value, result[i][2].value, result[i][3].value);
            }
            lastID = Number(parsed.last);
         }
      });
   }
   
   function addChat(chatName, chatContent, chatTime) {
      if (chatName == "<%= userID %>") {
	      $('#chatList').append('<div class="msg" style="width: 75%; margin-bottom: 2%; float: right;">' + 
	              '<div class="msg-info">' + 
	              '<span class="msg-time" style="padding-left: 2%; color: #cacaca; float: right;">' + chatTime + '</span>' + 
	              '</div><br>' + 
	              '<div class="msg-content" style="border-radius: 15px; padding: 3%; color: #fff; background-color: #4287F5;" float: right;">' + chatContent + '</div>' + 
	              '</div>');
	        $('#chatList').scrollTop($('#chatList')[0].scrollHeight);
	  }
      else {
    	  $('#chatList').append('<div class="msg" style="width: 75%; margin-bottom: 2%;">' + 
	              '<div class="msg-info">' + 
	              '<span class="msg-user" style="font-size: 1.2rem; padding-left: 2%; font-weight: 777;">' + chatName + '</span>' + 
	              '<span class="msg-time" style="padding-left: 2%; color: #cacaca;">' + chatTime + '</span>' + 
	              '</div>' + 
	              '<div class="msg-content" style="border-radius: 15px; padding: 3%; background-color: #cacaca;">' + chatContent + '</div>' + 
	              '</div>');
	        $('#chatList').scrollTop($('#chatList')[0].scrollHeight);
      }
   }
	
   function getInifniteChat() {
      setInterval(function() {
         chatListFunction(lastID);
      }, 3000); 
   }
   
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
    
   <div class="container">
        <div class="container bootstrap snippet">
        	<!-- <a href="box.jsp">메시지함<span id="unread" class="label label-info unread"></span></a>  -->
      
         	<div class="chat">
                <div class="chatTitle">
                	<span style="font-size: 2rem;">채팅</span>
                  	<hr>
                </div>

				<div id="chat" class="mainChat">
					<div id="chatList" style="overflow-y: auto; height: 550px;">	
					</div>
	              
	            	<div class="send">
                    	<input type="text" id="chatContent"/>
                    	<button type="submit" id="send" class="fas fa-paper-plane" onclick="submitFunction()"></button>
                    </div>
	            </div>
            
            </div>
        </div>
   </div>
   
    
   <div class="alert alert-success" id="successMessage" style="display: none;">
      <strong>메시지 전송에 성공하였습니다.</strong>
   </div>
   <div class="alert alert-danger" id="dangerMessage" style="display: none;">
      <strong>내용을 입력해주세요.</strong>
   </div>
   <div class="alert alert-warning" id="warningMessage" style="display: none;">
      <strong>데이터베이스 오류가 발생했습니다.</strong>
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
   
   <script type="text/javascript">
      $(document).ready(function() {
         getUnread();
         chatListFunction('0');
         getInifniteChat();
         getInfiniteUnread();
      })
   </script>
</body>
</html>