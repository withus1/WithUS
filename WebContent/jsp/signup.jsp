<%@ page contentType="text/html" pageEncoding="utf-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="dao.*" %>
<%@ page import="util.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	String uid = request.getParameter("id");
	String jsonstr = null, ufname = null;
	byte[] ufile= null;
	
	ServletFileUpload sfu = new ServletFileUpload(new DiskFileItemFactory());
	List items = sfu.parseRequest(request);
	Iterator iter = items.iterator();
	while(iter.hasNext()) {
		FileItem item = (FileItem) iter.next();
		String name = item.getFieldName(); //name 속성값
		if(item.isFormField()) {
			String value = item.getString("utf-8");
			if (name.equals("jsonstr")) jsonstr = value;
		}
		else {
			if (name.equals("image")) {
				ufname = item.getName(); //filename
				ufile = item.get(); //byte 배열 형태의 파일 컨텐츠
				String root = application.getRealPath(java.io.File.separator);
				FileUtil.saveImage(root, ufname, ufile);
			}
		}
	}
	
	UserDAO dao = new UserDAO();
	if (dao.exists(uid)) {
		out.print("EX"); //이미 가입한 회원입니다.
		return;
	}
	
	if (dao.insert(jsonstr) == true) {
		session.setAttribute("id", uid);
		out.print("OK"); //회원 가입이 완료되었습니다.
	}
	else {
		out.print("ER"); //회원 가입 중 오류가 발생하였습니다.
	}
%>