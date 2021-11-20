<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%
	String y = request.getParameter("y");
	String x = request.getParameter("x");
	String uid = (String)session.getAttribute("id");

	
	boolean is = (new UserDAO()).insertGeo(y, x, uid);
	
	if (is) {
		out.print("OK");
	} else {
		out.print("ER");
	}
%>