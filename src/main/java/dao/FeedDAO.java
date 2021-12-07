package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

import javax.naming.NamingException;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import util.ConnectionPool;

public class FeedDAO {	
	public boolean insert(String uid, String jsonstr) throws NamingException, SQLException, ParseException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null; 
		ResultSet rs = null;
		try {
			synchronized(this) {
				
			String sql = "SELECT no FROM feed ORDER BY no DESC LIMIT 1";
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			int max = (!rs.next()) ? 0 : rs.getInt("no");
			stmt.close(); rs.close();
			
			JSONParser parser = new JSONParser();
			JSONObject jsonobj = (JSONObject) parser.parse(jsonstr);
			jsonobj.put("no", max + 1);
			jsonobj.put("id", uid);
			jsonobj.put("UserId1", uid);
			
			String sql2 = "INSERT INTO feed(no, id, jsonstr) VALUES(?, ?, ?)";
			stmt = conn.prepareStatement(sql2);
			stmt.setInt(1,  max + 1);
			stmt.setString(2, uid);
			stmt.setString(3, jsonobj.toJSONString());
			int count1 = stmt.executeUpdate();
			stmt.close();
			
			String sql3 = "INSERT INTO userfeed(feedNo, userId) VALUES(?, ?)"; 
			stmt = conn.prepareStatement(sql3);
			stmt.setInt(1, max + 1);
			stmt.setString(2, uid);
			
			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;
			}
		} finally {
			if(rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	public boolean insertNotice(String jsonstr) throws NamingException, SQLException, ParseException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null; 
		ResultSet rs = null;
		try {
			synchronized(this) {
				
			String sql = "SELECT no FROM notice ORDER BY no DESC LIMIT 1";
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			int max = (!rs.next()) ? 0 : rs.getInt("no");
			stmt.close(); rs.close();
			
			JSONParser parser = new JSONParser();
			JSONObject jsonobj = (JSONObject) parser.parse(jsonstr);
			jsonobj.put("no", max + 1);
			
			String sql2 = "INSERT INTO NOTICE(no, jsonstr) VALUES(?, ?)";
			stmt = conn.prepareStatement(sql2);
			stmt.setInt(1,  max + 1);
			stmt.setString(2, jsonobj.toJSONString());
			
			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;
			}
		} finally {
			if(rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	public String getNoticeList(String maxNo) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;	
		try {
			String sql = "select jsonstr from notice";
			if(maxNo != null) {
				sql += " where no < " + maxNo;
			}
			sql += " order by NO desc limit 7";
			
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if(cnt ++ > 0) str += ", ";
				str += rs.getString("jsonstr");
			}
			return str + "]";
			
		}finally {
			if(rs != null) rs.close();
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
	}
	
	public String getNoticeDetail(String no) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;	
		try {
			String sql = "select * from notice where no = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, no);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if(cnt ++ > 0) str += ", ";
				str += rs.getString("jsonstr");
			}
			return str + "]";
			
		}finally {
			if(rs != null) rs.close();
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
	}

	public String getFeedList(String maxNo, String category) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;	
		try {
			String sql = "select jsonstr from feed where json_extract(jsonstr, '$.category') = '" + category + "'";
			if(maxNo != null) {
				sql += " and no < " + maxNo;
			}
			sql += " order by NO desc limit 3";
			
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if(cnt ++ > 0) str += ", ";
				str += rs.getString("jsonstr");
			}
			return str + "]";
			
		}finally {
			if(rs != null) rs.close();
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
	}
	
	//isUserJoinFeed.jsp - userfeed로부터 로그인한 사람이 참가한 약속 번호(feedNo) 목록 가져오기
	public String isUserJoinFeed(String uid) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			String sql = "select feedNo from userfeed where userId = '" + uid + "'";
			
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if(cnt ++ > 0) str += ", ";
				str += rs.getString("feedNo");
			}
			return str + "]";
			
		}finally {
			if(rs != null) rs.close();
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
	}
	
	//main 페이지에 가져올 글 4개
	public String getFeedFour(List<String> interest) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;	
		try {			
			String sql = "select * from feed";
			if(interest.size() == 1) {
				sql += " where json_extract(jsonstr, '$.category') in ('" + interest.get(0) + "')";
			} else if(interest.size() == 2) {
				sql += " where json_extract(jsonstr, '$.category') in ('" + interest.get(0) + "', '" + interest.get(1) + "')";
			} else if (interest.size() == 3) {
				sql += " where json_extract(jsonstr, '$.category') in ('" + interest.get(0) + "', '" + interest.get(1) + "', '" + interest.get(2) + "')";
			}
			sql += " order by json_extract(jsonstr, '$.ts') desc limit 4";
			
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if(cnt ++ > 0) str += ", ";
				str += rs.getString("jsonstr");
			}
			return str + "]";
			
		}finally {
			if(rs != null) rs.close();
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
	}
	//여기까지
	
	//--------------나의 약속 관련--------------
	//myToday.html에서 자신이 참여한 글 번호 가져오기 - isUserJoinFeed 이용함
	
	//isUserJoinFeed를 통해 얻어온 no를 통해 해당 날짜의 약속 가져오기
	public String todayFeedList(String no, String date) throws NamingException, SQLException, ParseException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			System.out.println(no);
			String sql = "select jsonstr from feed";
			sql += " where json_extract(jsonstr, '$.date') = '" + date + "'";
			sql += " and no in (" + no + ")";
			
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if(cnt ++ > 0) str += ", ";
				str += rs.getString("jsonstr");
			}
			return str + "]";
			
			
		}finally {
			if(rs != null) rs.close();
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
	}
	
	//main.html 관련 - 현재 날짜 이후의 약속 최대 3개 가져오기
		public String mainMyAppointment(String no, String today) throws NamingException, SQLException, ParseException {
			Connection conn = ConnectionPool.get();
			PreparedStatement stmt = null;
			ResultSet rs = null;

			try {
				System.out.println(no);
				String sql = "select jsonstr from feed";
				sql += " where json_extract(jsonstr, '$.date') >= '" + today + "'";
				sql += " and no in (" + no + ")";
				sql += " order by json_extract(jsonstr, '$.date') limit 3";
				
				stmt = conn.prepareStatement(sql);
				rs = stmt.executeQuery();
				
				String str = "[";
				int cnt = 0;
				while(rs.next()) {
					if(cnt ++ > 0) str += ", ";
					str += rs.getString("jsonstr");
				}
				return str + "]";
				
				
			}finally {
				if(rs != null) rs.close();
				if(stmt != null) stmt.close();
				if(conn != null) conn.close();
			}
		}
	//--------------나의 약속 관련 끝--------------
	
	public String getFeedDetail(String no) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;	
		try {
			String sql = "select * from feed where no = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, no);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if(cnt ++ > 0) str += ", ";
				str += rs.getString("jsonstr");
			}
			return str + "]";
			
		}finally {
			if(rs != null) rs.close();
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
	}
	
	public String getIdByFeedNo(String no) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			String sql = "SELECT id FROM feed where no = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, no);
			rs = stmt.executeQuery();
			String str = "";
			int cnt = 0;
			while(rs.next()) {
				if(cnt ++ > 0) str += ", ";
				str += rs.getString("id");
			}
			return str + "";
			
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}

	public String getJsonstrByFeedNo(String feedNo) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null; 
		ResultSet rs = null;
		try {				
			String sql = "SELECT jsonstr FROM Feed where no = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, feedNo);
			rs = stmt.executeQuery();
			
			
			String jsonstr = "";
			int cnt = 0;
			while(rs.next()) {
				if(cnt ++ > 0) jsonstr += ", ";
				jsonstr += rs.getString("jsonstr");
			}
			return jsonstr + "";
			

		} finally {
			if(rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}

//	공백
	public boolean exists(String uid) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			String sql = "SELECT id FROM user WHERE id = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, uid);
			
			rs = stmt.executeQuery();
			return rs.next(); //�엳�쑝硫� true, �뾾�쑝硫� false
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	public boolean withdraw(String uid) throws NamingException, SQLException{
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		try {
			stmt = conn.prepareStatement("DELETE FROM user WHERE id = ?");
			stmt.setString(1, uid);
			int count = stmt.executeUpdate();
			return (count == 1) ? true : false; 
		} finally {
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
	}
	
	public boolean delete(String uid) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		try {
			String sql = "DELETE FROM user WHERE id = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, uid);
			
			int count = stmt.executeUpdate();
			return (count > 0) ? true : false;
		} finally {
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	public int login(String uid, String upass) throws NamingException, SQLException, ParseException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			String sql = "SELECT jsonstr FROM user WHERE id = ?";	
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, uid);
			
			rs = stmt.executeQuery();
			if (!rs.next()) return 1;
			
			String jsonstr = rs.getString("jsonstr");
			JSONObject obj = (JSONObject) (new JSONParser()).parse(jsonstr);
			String pass = obj.get("password").toString();		
			if (!upass.equals(pass)) return 2;
			
			return 0;
			
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	public String getList() throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			String sql = "SELECT * FROM user";
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if (cnt++ > 0) str += ", ";
				str += rs.getString("jsonstr");
			}
			return str + "]";
			
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	public String feedSearch(String title) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			String sql = "SELECT jsonstr FROM feed"
					+ " WHERE json_extract(jsonstr, '$.title') LIKE ?" ;
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%" + title + "%");
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if(cnt++ > 0) str +=",";
				str += rs.getString("jsonstr");
			}
			return str + "]";
			
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	public boolean setFeedStatusFinish(String no) throws NamingException, SQLException, ParseException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null; 
		ResultSet rs = null;
		try {				
			String sql = "SELECT jsonstr FROM Feed where no = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, no);
			rs = stmt.executeQuery();
			
			String jsonstr = "";
			int cnt = 0;
			while(rs.next()) { 
				if(cnt ++ > 0) jsonstr += ", ";
				jsonstr += rs.getString("jsonstr");
			}
			jsonstr += "";
            
            stmt.close(); rs.close();
            
			JSONParser parser = new JSONParser();
			JSONObject jsonobj = (JSONObject) parser.parse(jsonstr);
			jsonobj.remove("status");
			jsonobj.put("status", "finish");
			
			String sql2 = "UPDATE FEED SET jsonstr = ? where no = ?";
			stmt = conn.prepareStatement(sql2);
			stmt.setString(1, jsonobj.toJSONString());
			stmt.setInt(2, Integer.parseInt(no));
			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;

		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	//여기부터
	//관리자기능 - 전체 게시물 띄우기
	public String adminFeedList() throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;	
		try {
			String sql = "select jsonstr from feed";
			sql += " order by json_extract(jsonstr, '$.ts')";
			
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if(cnt ++ > 0) str += ", ";
				str += rs.getString("jsonstr");
			}
			return str + "]";
			
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	//관리자기능 - 사용자 이름으로 게시물 찾아서 가져오기
	public String feedUserSearch(String uid) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			String sql = "select jsonstr from feed where json_extract(jsonstr, '$.id') = ?" ;
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, uid);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if(cnt ++ > 0) str += ",";
				str += rs.getString("jsonstr");
			}
			return str + "]";
			
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	//관리자기능 - editno를 통해 수정할 feed 내용 가져오기
	public String editFeedInfo(String editno) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			String sql = "select jsonstr from feed where no = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, editno);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if(cnt ++ > 0) str += ",";
				str += rs.getString("jsonstr");
			}
			return str + "]";
			
		} finally {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	//관리자기능 - feed 수정 내용 db에 적용하기
	public boolean feedUpdate(String no, String jsonstr) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		
		try {
			stmt = conn.prepareStatement("update feed set jsonstr = ? where no = ?");
			stmt.setString(1, jsonstr);
			stmt.setString(2, no);
			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;
			
		} finally {
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	//관리자기능 - feed 삭제하기
	public boolean feedDelete(String deleteno) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		
		try {
			stmt = conn.prepareStatement("delete from feed where no = ?");
			stmt.setString(1, deleteno);
			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;
			
		} finally {
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	//해당 공지사항 가져오기: 위에 getNoticeList 중복
	
	//관리자기능 - notice 수정 내용 db에 적용하기
	public boolean noticeUpdate(String no, String jsonstr) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		
		try {
			stmt = conn.prepareStatement("update notice set jsonstr = ? where no = ?");
			stmt.setString(1, jsonstr);
			stmt.setString(2, no);
			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;
			
		} finally {
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	//관리자기능 - notice 삭제하기
	public boolean noticeDelete(String no) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		
		try {
			stmt = conn.prepareStatement("delete from notice where no = ?");
			stmt.setString(1, no);
			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;
			
		} finally {
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	//글 작성자가 자신이 올린 feed 삭제하기 (feedDelete는 관리자만 삭제)
	public boolean feedUserDelete(String no) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		
		try {
			stmt = conn.prepareStatement("delete from feed where no = ?");
			stmt.setString(1, no);
			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;
			
		} finally {
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	//글 작성자가 자신이 올린 feed 수정하기 (feedUpdate는 관리자만 삭제)
	public boolean feedUserUpdate(String no, String jsonstr) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		
		try {
			stmt = conn.prepareStatement("update feed set jsonstr = ? where no = ?");
			stmt.setString(1, jsonstr);
			stmt.setString(2, no);
			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;
			
		} finally {
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
}
