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
	public String feedSearch(String uid) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		try {
			String sql = "SELECT jsonstr FROM feed WHERE id = ?" ;
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, uid);
			rs = stmt.executeQuery();
			
			String str = "[";
			int cnt = 0;
			while(rs.next()) {
				if(cnt++ > 0) str +=",";
				str += rs.getString("jsonstr");
			}
			return str + "]";
			
		} finally {
			if(rs != null) rs.close();
			if(stmt != null) stmt.close();
			if(conn != null) conn.close();
		}
	}
}