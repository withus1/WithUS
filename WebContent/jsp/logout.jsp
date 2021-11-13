<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%
	session.invalidate();
%>
<script>
	alert('로그아웃을 완료하였습니다.');
	document.location.href='../Login.html';
</script>
