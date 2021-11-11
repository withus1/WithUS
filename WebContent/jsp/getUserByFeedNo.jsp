<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%
	String no = request.getParameter("no");
	String uid = (new FeedDAO()).getIdByFeedNo(no);
	String str = (new UserDAO()).myInfo(uid);
	out.print(str);
%>