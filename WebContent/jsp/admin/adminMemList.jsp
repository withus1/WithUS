<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%
	UserDAO dao = new UserDAO();
	out.print(dao.getList());
%>