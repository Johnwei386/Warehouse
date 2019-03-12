package org.example.mariaDB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MariaDBConnector {
	public static final String DRIVER_CLASS_NAME = "org.mariadb.jdbc.Driver";
	public static final String URL = "jdbc:mariadb://localhost:3306/MariaDB";
	private static final String UserName="john";
	private static final String PassWord="debian";
	
	//注册驱动
	static{
		try {
			Class.forName(DRIVER_CLASS_NAME);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 *  得到一个连接实例
	 * @return
	 * @throws SQLException
	 */
	public Connection getConn() throws SQLException{
		return DriverManager.getConnection(URL, UserName, PassWord);
	}
	
	/**
	 *  关闭连接实例
	 * @param conn
	 */
	public void closeConn(Connection conn){
		if(conn != null){
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}
