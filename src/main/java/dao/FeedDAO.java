package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
			
			String sql2 = "INSERT INTO feed(no, id, jsonstr) VALUES(?, ?, ?)";
			stmt = conn.prepareStatement(sql2);
			stmt.setInt(1,  max + 1);
			stmt.setString(2, uid);
			stmt.setString(3, jsonobj.toJSONString());
			
			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;
			}
		} finally {
			if(rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (conn != null) conn.close();
		}
	}
	
	public String getFeedList(String maxNo) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;	
		try {
			String sql = "select jsonstr from feed";
			if(maxNo != null) {
				sql += " where no < " + maxNo;
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
}
