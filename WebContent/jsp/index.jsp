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
	
	/*
	function active(){
		$('.nav-container li:nth-child(1)').addClass('active');
	}
	*/
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
								<div class="row">
									<div class="form-group col-xs-4">
										<input style="height: 40px;" type="text" id="chatName" class="form-control" placeholder="이름" maxlength="20">
									</div>
								</div>
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
	
	<%
		if(userID != null){
	%>
	<script type="text/javascript">
		$(document).ready(function() {
			getUnread();
			getInfiniteUnread();
			//active();
		});
	</script>
	<%
		}
	%>

</body>
</html>