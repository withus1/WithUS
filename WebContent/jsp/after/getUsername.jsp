<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%
String uid = (String)session.getAttribute("id");

String jsonstr = (new UserDAO()).get(uid);
JSONObject jsonobj = (JSONObject) (new JSONParser()).parse(jsonstr);

String username = jsonobj.get("username").toString();

out.print(username);

%>