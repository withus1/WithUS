<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="dao.*" %>
<%@ page import="util.*" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%
	String feedNo = request.getParameter("no");

	String sessionId = (String) session.getAttribute("id");
	String feedId = (new FeedDAO()).getIdByFeedNo(feedNo);
	
	String sessionIdGeo = (new UserDAO()).getUserGeo(sessionId);
	JSONObject sessionIdGeoObj = (JSONObject) (new JSONParser()).parse(sessionIdGeo);	
	Double sessionIdY = Double.parseDouble(sessionIdGeoObj.get("y").toString());
	Double sessionIdX = Double.parseDouble(sessionIdGeoObj.get("x").toString());
	System.out.print("sessionIdy = " + sessionIdY);
	System.out.print("sessionIdX = " + sessionIdX);

	String feedIdGeo = (new UserDAO()).getUserGeo(feedId);
	JSONObject feedIdGeoObj = (JSONObject) (new JSONParser()).parse(feedIdGeo);	
	Double feedIdY = Double.parseDouble(feedIdGeoObj.get("y").toString());
	Double feedIdX = Double.parseDouble(feedIdGeoObj.get("x").toString());
	System.out.print("feedIdY = " + feedIdY);
	System.out.print("feedIdX = " + feedIdX);


	String method = "killometer";
	
	Double a = (new GeoDistance()).distance(sessionIdY, sessionIdX, feedIdY, feedIdX, method);
	
	if (a > 6.0) {
		out.print("ER");
	} else {
		// people > peopleCount 확인
		String jsonstr = (new FeedDAO()).getJsonstrByFeedNo(feedNo);
	    JSONObject jsonobj = (JSONObject) (new JSONParser()).parse(jsonstr);

	    int people = Integer.parseInt(jsonobj.get("people").toString());
	    int peopleJoined = Integer.parseInt(jsonobj.get("peopleJoined").toString());

	    
	    boolean succeed = true;
	   
	    
	    if (people > peopleJoined) {
	    	
	    	for (int i=1; i<=peopleJoined; i++) {
	        	String userId = "UserId" + Integer.toString(i);
	        	if (sessionId.equals(jsonobj.get(userId).toString())) {
	        		succeed = false;
	        	}
	        }
	    } else {
	        succeed = false;
	    }
	    
	    
	    if (succeed) {
	    	(new EvalDAO()).setTeamByFeedNoWithId(sessionId, feedNo, peopleJoined+1);
			out.print("OK"); // 모임에 합류하셨습니다.
		}
		else {
			out.print("ER"); // 모임에 합류할 수 없습니다.
		}
	}
%>