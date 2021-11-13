<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import ="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String uid = request.getParameter("id");
	
	FeedDAO dao = new FeedDAO();
	String str = dao.feedSearch(uid);
	out.print(str);
%>