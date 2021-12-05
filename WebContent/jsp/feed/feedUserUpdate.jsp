<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String no = request.getParameter("no");
	String jsonstr = request.getParameter("jsonstr");
	
	FeedDAO dao = new FeedDAO();
	if(dao.feedUserUpdate(no, jsonstr) == true) {
		out.print("OK");
	} else {
		out.print("ER");
	}
	
%>