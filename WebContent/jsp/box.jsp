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
		
		if(userID == null){
			session.setAttribute("messageType", "오류 메시지");
			session.setAttribute("messageContent", "현재 로그인이 되어 있지않는 상태입니다.");
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
				'<tr onclick="location.href=\'chat.jsp?toID=' + encodeURIComponent(toID) + '\'">' +
				'<td style="width: 150px">' + '<h5>' + lastID + '</h5>' + '</td>' +
				'<td>' +
				'<h5>' + chatContent + '<span class="label label-info">' + unread + '</span>' + '</h5>' +
				'<div class="pull-right">' + chatTime + '</div>' +
				'</td>' +
				'</tr>'
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
	<div class="container">
		<!-- navbar -->
		<div class="container bootstrap snippet">
			<a href="box.jsp">메시지함<span id="unread" class="label label-info"></span></a>
		</div>
	
		<!-- 메시지 목록 -->
		<table class="table" style="margin: 0 auto;">
			<thead>
				<tr>
					<th><h4>주고받은 메시지 목록</h4></th>
				</tr>
			</thead>
			<div style="overflow-y: auto; width: 100%; max-height: 450px;">
				<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #ddd; margin: 0 auto;">
					<tbody id="boxTable">
					</tbody>
				</table>
			</div>
		</table>
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