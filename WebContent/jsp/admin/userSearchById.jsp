<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import ="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String searchId = request.getParameter("id");
	
	String str = (new UserDAO()).getProfile(searchId);
	out.print(str);
%>