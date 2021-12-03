<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String deleteno = request.getParameter("deleteno");
	
	FeedDAO dao = new FeedDAO();
	if(dao.feedDelete(deleteno) == true){
		out.print("OK");
	} else{
		out.print("ER");
	}
%>