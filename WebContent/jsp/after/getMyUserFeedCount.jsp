<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%
String sessionId = (String) session.getAttribute("id");

int userFeedCount = (new EvalDAO()).getUserFeedCount(sessionId);

out.print(userFeedCount);
%>