<%@ page contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="dao.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<% 	
	String uid = (String) session.getAttribute("id");
	String feedNo =  request.getParameter("no");
	
    // people > peopleCount 확인
	String jsonstr = (new FeedDAO()).getJsonstrByFeedNo(feedNo);
    JSONObject jsonobj = (JSONObject) (new JSONParser()).parse(jsonstr);

    int people = Integer.parseInt(jsonobj.get("people").toString());
    int peopleJoined = Integer.parseInt(jsonobj.get("peopleJoined").toString());

    
    boolean succeed = true;
   
    
    if (people > peopleJoined) {
    	
    	for (int i=1; i<=peopleJoined; i++) {
        	String userId = "UserId" + Integer.toString(i);
        	if (uid.equals(jsonobj.get(userId).toString())) {
        		succeed = false;
        	}
        }
    } else {
        succeed = false;
    }
    if (succeed) {
    	(new EvalDAO()).setTeamByFeedNoWithId(uid, feedNo, peopleJoined+1);
		out.print("OK"); // 모임에 합류하셨습니다.
	}
	else {
		out.print("ER"); // 모임에 합류할 수 없습니다.
	}
%>