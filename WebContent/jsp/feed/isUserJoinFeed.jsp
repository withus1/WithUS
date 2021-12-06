<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%
	String uid = (String) session.getAttribute("id");
	
	FeedDAO dao = new FeedDAO();
	out.print(dao.isUserJoinFeed(uid));
%>