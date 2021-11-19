<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%		
	String uid = (String) session.getAttribute("id");
	String no = request.getParameter("no");
	
	String maxNo = request.getParameter("maxNo");
	out.print((new FeedDAO()).getNoticeList(maxNo));
%>