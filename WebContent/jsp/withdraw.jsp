<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String uid = (String) session.getAttribute("id");
	String upass = request.getParameter("ps");
	
	//session.invalidate();
	
	UserDAO dao = new UserDAO();
	if (dao.withdraw(uid, upass)) {
		out.print("OK"); //회원탈퇴가 완료되었습니다.
	} else {
		out.print("NA"); //패스워드가 일치하지 않습니다.
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