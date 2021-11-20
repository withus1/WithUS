<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%
String category = request.getParameter("category");
String maxNo = request.getParameter("maxNo");
out.print((new FeedDAO()).getFeedList(maxNo, category));
%>