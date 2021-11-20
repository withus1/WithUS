<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%
	request.setCharacterEncoding("utf-8");
	String maxNo = request.getParameter("maxNo");
	String date = request.getParameter("date");
	String uid = (String) session.getAttribute("id");
	
	String str = (new FeedDAO()).todayFeedList(maxNo, date, uid);
	out.print(str);
%>