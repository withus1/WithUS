<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%
	FeedDAO dao = new FeedDAO();
	out.print(dao.adminFeedList());
%>