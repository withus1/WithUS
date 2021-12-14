package chat;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.NamingException;

import util.ConnectionPool;

public class ChatDAO {
	
	/*
	private Connection conn;
	
	public ChatDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/withus?serverTimezone=UTC";
			String dbID = "root";
			String dbPassword = "1111";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	*/
	
	public ArrayList<ChatDTO> getChatListByID(String fromID, String toID, String chatID) throws NamingException, SQLException{
		ArrayList<ChatDTO> chatList = null;
		Connection conn = ConnectionPool.get();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String SQL = "select * from chat where ((fromid = ? and toid = ?) or (fromid = ? and toid = ?)) and chatid > ? order by chattime";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);
			pstmt.setString(4, fromID);
			pstmt.setInt(5, Integer.parseInt(chatID));
			rs = pstmt.executeQuery();
			
			chatList = new ArrayList<ChatDTO>();
			while(rs.next()) {
				ChatDTO chat = new ChatDTO();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("chatContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11, 13));
				String timeType = "오전";
				if(chatTime > 12) {
					timeType = "오후";
					chatTime -= 12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0, 11) + " " + timeType + " " + chatTime + ":" + rs.getString("chatTime").substring(14, 16) + "");
				chatList.add(chat);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return chatList;
	}
	
	public ArrayList<ChatDTO> getChatListByRecent(String fromID, String toID, int number) throws NamingException, SQLException{
		ArrayList<ChatDTO> chatList = null;
		Connection conn = ConnectionPool.get();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String SQL = "select * from chat"
				+ " where ((fromid = ? and toid = ?) or (fromid = ? and toid = ?))"
				+ " and chatid > (select max(chatid) - ? from chat"
				+ " where (fromid = ? and toid = ?) or (fromid = ? and toid = ?))"
				+ " order by chattime";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, toID);
			pstmt.setString(4, fromID);
			pstmt.setInt(5, number);
			pstmt.setString(6, fromID);
			pstmt.setString(7, toID);
			pstmt.setString(8, toID);
			pstmt.setString(9, fromID);
			rs = pstmt.executeQuery();
			
			chatList = new ArrayList<ChatDTO>();
			while(rs.next()) {
				ChatDTO chat = new ChatDTO();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("chatContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11, 13));
				String timeType = "오전";
				if(chatTime > 12) {
					timeType = "오후";
					chatTime -= 12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0, 11) + " " + timeType + " " + chatTime + ":" + rs.getString("chatTime").substring(14, 16) + "");
				chatList.add(chat);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return chatList;
	}
	
	//메시지함
	public ArrayList<ChatDTO> getBox(String userID) throws NamingException, SQLException{
		ArrayList<ChatDTO> chatList = null;
		Connection conn = ConnectionPool.get();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String SQL = "select * from chat where chatid in"
				+ " (select max(chatid) from chat"
				+ " where toid = ? or fromid = ? group by fromid, toid)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			pstmt.setString(2, userID);
			rs = pstmt.executeQuery();
			
			chatList = new ArrayList<ChatDTO>();
			while(rs.next()) {
				ChatDTO chat = new ChatDTO();
				chat.setChatID(rs.getInt("chatID"));
				chat.setFromID(rs.getString("fromID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				chat.setToID(rs.getString("toID").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				chat.setChatContent(rs.getString("chatContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				int chatTime = Integer.parseInt(rs.getString("chatTime").substring(11, 13));
				String timeType = "오전";
				if(chatTime > 12) {
					timeType = "오후";
					chatTime -= 12;
				}
				chat.setChatTime(rs.getString("chatTime").substring(0, 11) + " " + timeType + " " + chatTime + ":" + rs.getString("chatTime").substring(14, 16) + "");
				chatList.add(chat);
			}
			
			for (int i = 0; i < chatList.size(); i++) {
				ChatDTO x = chatList.get(i);
				for (int j = 0; j < chatList.size(); j++) {
					ChatDTO y = chatList.get(j);
					//fromID toID 위치만 바뀌고 동일한 경우 -> 최신 메시지만
					if(x.getFromID().equals(y.getToID()) && x.getToID().equals(y.getFromID())) {
						if (x.getChatID() < y.getChatID()) {
							chatList.remove(x);
							i--;
							break;
						} else {
							chatList.remove(y);
							j--;
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return chatList;
	}
	
	public int submit(String fromID, String toID, String chatContent) throws NamingException, SQLException{
		Connection conn = ConnectionPool.get();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String SQL = "insert into chat values (null, ?, ?, ?, now(), 0)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			pstmt.setString(3, chatContent);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return -1;
	}
	
	//매시지 읽음 처리
	public int readChat(String fromID, String toID) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String SQL = "update chat set chatread = 1 where (fromid = ? and toid = ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, toID);
			pstmt.setString(2, fromID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return -1;
	}
	
	public int getAllUnreadChat(String userID) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String SQL = "select count(chatid) from chat where toid = ? and chatread = 0";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt("COUNT(chatID)");
			}
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return -1;
	}
	
	public int getUnreadChat(String fromID, String toID) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String SQL = "select count(chatid) from chat"
				+ " where fromid = ? and toid = ? and chatread = 0";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fromID);
			pstmt.setString(2, toID);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return rs.getInt("COUNT(chatID)");
			}
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return -1;
	}
}