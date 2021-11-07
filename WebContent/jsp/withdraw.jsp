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