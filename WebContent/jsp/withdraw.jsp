<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String uid = (String) session.getAttribute("id");
	session.invalidate();
	
	UserDAO dao = new UserDAO();
	
	if (!dao.exists(uid)){
		%>
		<script>
		alert("존재하지 않는 아이디입니다.");
		window.location.href = "../Start.html";
		</script>
		<%
	}
	else if (dao.withdraw(uid)) {
		%>
	    <script>
	    alert("회원탈퇴가 완료되었습니다.");
		window.location.href = "../Start.html";
		</script>
	    <%
	}
	else {
		%>
		<script>
		alert("회원탈퇴 도중 오류가 발생하였습니다.");
		window.location.href = "../Start.html";
		</script>
		<%
	}
%>

<%-- 
<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	session.invalidate();
	String uid = request.getParameter("id");
	
	UserDAO dao = new UserDAO();
	
	if (!dao.exists(uid)){
		out.print("NA");
	}
	else if (dao.withdraw(uid)) {
	    out.print("OK");
	}
	else {
	    out.print("ER");
	}
%>
 --%>