<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%		
	String no = request.getParameter("no");
	out.print((new FeedDAO()).getNoticeDetail(no));
%>