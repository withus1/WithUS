<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%
		String userID = null;
		if (session.getAttribute("id") != null){
			userID = (String) session.getAttribute("id");
		}
		
		String toID = null;
		if (request.getParameter("toID") != null){
			toID = (String) request.getParameter("toID");
		}
	%>
	
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1"> <!-- 반응형 웹 -->
	<link rel="stylesheet" href="../css/bootstrap.css"> <!-- bootstrap.css 파일 -->
	<link rel="stylesheet" href="../css/custom.css">
	<script src="../js/jquery-3.6.0.min.js"></script> <!-- jquery 추가 -->
	<script src="../js/bootstrap.js"></script>
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
		$('#chatList').append('<div class="row">' + 
				'<div class="col-lg-12">' +
				'<div class="media">' +
				'<a class="pull-left" href="#">' +
				'<img class="media-object img-circle img-chat" style="width: 10%; height: 10%;" src="../images/mypage-user.png" alt="">' +
				'</a>' +
				'<div class="media-body">' +
				'<h4 class="media-heading">' +
				chatName +
				'<span class="small pull-right">' +
				chatTime +
				'</span>' +
				'</h4>' +
				'<p>' +
				chatContent +
				'</p>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'</div>' +
				'<hr>');
		$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
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
	<div class="container">
		<div class="container bootstrap snippet">
		<a href="box.jsp">메시지함<span id="unread" class="label label-info"></span></a>
			<div class="row">
				<div class="col-xs-12">
					<div class="portlet portlet-default">
						<div class="portlet-heading">
							<div class="portlet-title">
								<h4><i class="fa fa-circle text-green"></i>실시간 채팅방</h4>
							</div>
							<div class="clearfix"></div>
						</div>
					
						<div id="chat" class="panel-collapse collapse in">
							<!-- overflow-y : auto; 는 아래로 글이 늘어났을 때 자동적으로 늘어남을 의미한다. -->
							<div id="chatList" class="portlet-body chat-widget" style="overflow-y: auto; width: auto; height: 300px;">
							</div>
							<div class="portlet-footer">
								<div class="row" style="height:90px">
									<div class="form-group col-xs-10">
										<textarea style="height:80px;" id="chatContent" class="form-control" placeholder="메시지를 입력하세요" maxlength="100"></textarea>
									</div> 
								</div>
								<div class="form-group col-xs-2">
									<button type="button" class="btn btn-default pull-right" onclick="submitFunction()">전송</button>
									<div class="cleayfix"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="alert alert-success" id="successMessage" style="display: none;">
		<strong>메시지 전송에 성공하였습니다.</strong>
	</div>
	<div class="alert alert-danger" id="dangerMessage" style="display: none;">
		<strong>이름과 내용을 모두 입력해주세요.</strong>
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