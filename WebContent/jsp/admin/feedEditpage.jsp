<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import ="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String editno = request.getParameter("editno");
	
	FeedDAO dao = new FeedDAO();
	out.print(dao.editFeedInfo(editno));
%>