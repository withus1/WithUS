<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*" %>
<%
	String editid = request.getParameter("editid");
	String str = (new UserDAO()).get(editid);
	out.print(str);
%>