<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String adminps = request.getParameter("adminps");
	
	if (adminps.equals("withus1234")) {
		session.setAttribute("id", adminps);
		out.print("OK");
	} else{
		out.print("PE"); //패스워드가 일치하지 않습니다.
	}
%>