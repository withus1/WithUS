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
    
    
    boolean progress = false;
    //  모임 종료 됐는지
    if (jsonobj.get("status").toString().equals("finish")) {
    	
    	  // 내가 참여한 모임인지 확인
        for (int i=1; i<=peopleJoined; i++) {
                String jsonstrUserId = "UserId" + Integer.toString(i);
                if (jsonobj.get(jsonstrUserId).toString().equals(currentUserId)) {
                	
                	// 각 사용자 찾아서
                	for (int j=1; j<=peopleJoined; j++) {
                        String jsonstrUserId2 = "UserId" + Integer.toString(j);
                        
                        // 자신 빼고 evaluation 적용하기
                        if (jsonobj.get(jsonstrUserId2).toString().equals(currentUserId)) {
                            continue;
                        } else {
                        	progress = (new EvalDAO()).evaluateUserById(jsonobj.get(jsonstrUserId2).toString(), evaluation);
                        }
                        
                    }
                	
                }
                
           }
    	  
   	}
	
    if (progress) {
    	out.print("OK");
    } else {
    	out.print("ER");
    }
    
   
%>