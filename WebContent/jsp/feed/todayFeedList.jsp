<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.stream.Stream" %>
<%
	request.setCharacterEncoding("utf-8");
	String no = request.getParameter("no");
	String date = request.getParameter("date");
	
	/*
	System.out.println(no); //2,3,4
	int[] digits = Stream.of(no.split(",")).mapToInt(Integer::parseInt).toArray();
	String noArray = Arrays.toString(digits);
	System.out.println(noArray); //[2, 3, 4]
	*/
	
	String str = (new FeedDAO()).todayFeedList(no, date);
	out.print(str);
%>