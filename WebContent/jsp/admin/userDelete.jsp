<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import ="dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String deleteid = request.getParameter("deleteid");
	
	UserDAO dao = new UserDAO();
	if (dao.delete(deleteid)) {
		out.print("OK");
	} else {
		out.print("NA");
	}
%>