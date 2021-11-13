<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*" %>
<%
	String uid = request.getParameter("id");
	String str = (new UserDAO()).get(uid);
	out.print(str);
%>