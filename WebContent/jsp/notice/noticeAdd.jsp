<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	String jsonstr = request.getParameter("jsonstr");
	
	FeedDAO dao = new FeedDAO();
	
	if (dao.insertNotice(jsonstr) == true) {
		out.print("OK");
	}
	else {	
		out.print("ER");
	}
%>