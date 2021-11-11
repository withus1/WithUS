<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	String uid = (String)session.getAttribute("id");
	String jsonstr = request.getParameter("jsonstr");
	
	FeedDAO dao = new FeedDAO();
	
	if (dao.insert(uid, jsonstr) == true) {
		out.print("OK");
	}
	else {	
		out.print("ER");
	}
%>