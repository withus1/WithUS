<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%
	String no = request.getParameter("no");
	String currentId = (String) session.getAttribute("id");
	String feedId = (new FeedDAO()).getIdByFeedNo(no);
	
	boolean progress = false;
	if (currentId.equals(feedId)) {
		progress = (new FeedDAO()).setFeedStatusFinish(no);
	}
	
	if (progress) {
		out.print("OK");
	} else {
		out.print("ER");
	}
%>