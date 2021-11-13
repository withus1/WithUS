<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="dao.*" %>
<%@ page import="util.*" %>
<%
	String uid = (String) session.getAttribute("id");
	session.setAttribute("id", uid);
	
	String str = (new UserDAO()).getProfile(uid);
	out.print(str);
%>