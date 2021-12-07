<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%
	request.setCharacterEncoding("utf-8");
	String no = request.getParameter("no");
	String today = request.getParameter("today");
	
	String str = (new FeedDAO()).mainMyAppointment(no, today);
	out.print(str);
%>