<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%
    // getFeedNo(String no)
	String feedNo = request.getParameter("no");


    // getUserIdBySession -> session.getAttribute()
    String currentUserId = (String) session.getAttribute("id");


    // getJsonstrByFeedNo(int feedNo)
	String jsonstr = (new FeedDAO()).getJsonstrByFeedNo(feedNo);
    JSONObject jsonobj = (JSONObject) (new JSONParser()).parse(jsonstr);
    

    // currentUserId가 평가 값(evaluation) 가져오기
    String evaluation = request.getParameter("evaluation");


    // UserId 꺼내오기 : peopleJoined 만큼
    int peopleJoined = Integer.parseInt(jsonobj.get("peopleJoined").toString());
    
    for (int i=1; i<=peopleJoined; i++) {
        String jsonstrUserId = "UserId" + Integer.toString(i);
        // evaluation 적용하기
        if (jsonobj.get(jsonstrUserId).toString().equals(currentUserId)) {
            continue;
        } else {
        	(new EvalDAO()).evaluateUserById(jsonobj.get(jsonstrUserId).toString(), evaluation);
        }
    }
%>