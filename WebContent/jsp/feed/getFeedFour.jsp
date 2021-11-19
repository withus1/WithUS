<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%@ page import="java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");
	
	String interest1 = request.getParameter("interest1");
	String interest2 = request.getParameter("interest2");
	String interest3 = request.getParameter("interest3");
	
	List<String> interest = new ArrayList<String>();
	if (interest1 != null) interest.add(interest1);
	if (interest2 != null) interest.add(interest2);
	if (interest3 != null) interest.add(interest3);
	//out.print(interest); //[meal, study]
			
	FeedDAO dao = new FeedDAO();
	out.print(dao.getFeedFour(interest));
%>
