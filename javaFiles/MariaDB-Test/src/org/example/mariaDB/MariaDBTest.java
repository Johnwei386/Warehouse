package org.example.mariaDB;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;

public class MariaDBTest {
	public static void main(String[] args) {
		long startTime = System.currentTimeMillis();
		MariaDBConnector connector = new MariaDBConnector();
		Connection conn = null;
		try {
			conn = connector.getConn();
			//addAllImageDataToDB(conn, "/home/john/桌面/picture");
			selectData(conn, "1017.jpg", "/tmp/test.jpg");
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		long endTime = System.currentTimeMillis();
		System.out.println("Program runing time: "+(double)(endTime-startTime)/(double)1000+"s");
	}
	
	/**
	 *  向数据库中插入一行图片数据
	 * @param file 图片文件所在全路径名称
	 * @return
	 * @throws SQLException
	 * @throws FileNotFoundException 
	 */
	public static boolean insertData(Connection conn, File file) throws SQLException, FileNotFoundException{
		boolean isStoreSuccess = false;
		FileInputStream imageContent = null;
		String pname = file.getName();
		long imageLength = file.length();
		imageContent = new FileInputStream(file);
		String sql = "insert into image(pname, content) values(?,?)";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1, pname);
		ps.setBinaryStream(2, imageContent, imageLength);
		int affectedRows = ps.executeUpdate();
		if(affectedRows > 0) isStoreSuccess = true;
		return isStoreSuccess;
	}
	
	/**
	 *  将图片文件的输入流装换为目标文件并存起来
	 * @param imageStream
	 * @param targetPath
	 */
	public static void convertImageBinaryToFile(InputStream imageStream, String targetPath){
		FileOutputStream out = null;
		byte[] buffer = new byte[1024];
		try {
			out = new FileOutputStream(new File(targetPath));
			for(int len = imageStream.read(buffer); len != -1; len = imageStream.read(buffer))
				out.write(buffer, 0, len);
			out.flush(); //将暂存区的数据写入磁盘文件
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally{
			if(out != null){
				try {
					out.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/**
	 *  从数据库中读取一行图片数据
	 * @param conn
	 * @param pname
	 * @param targetPath
	 * @throws SQLException
	 */
	public static void selectData(Connection conn, String pname, String targetPath) throws SQLException{
		String sql = "select * from image where pname=?";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setString(1, pname);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			InputStream in = rs.getBinaryStream("content");
			convertImageBinaryToFile(in, targetPath);
		}
		rs.close();
		ps.close();
	}
	
	/**
	 *  得到目录下的所有文件名并将其存入一个列表，只遍历一层目录，不进行递归处理
	 * @param path
	 * @return
	 */
	private static ArrayList<File> getFileNameList(String path)
	{
		File catalog = new File(path);
		ArrayList<File> list = new ArrayList<File>();
		if(catalog.exists()){
			File[] files = catalog.listFiles();
			for(int i = 0; i < files.length; i++){
				list.add(files[i]);
			}
		}
		return list;
	}
	
	/**
	 *  将目录下的所有图片文件都插入到数据库中
	 * @param conn
	 * @param path
	 * @throws SQLException
	 * @throws FileNotFoundException
	 */
	public static void addAllImageDataToDB(Connection conn, String path) throws SQLException, FileNotFoundException{
		ArrayList<File> list = getFileNameList(path);
		Iterator<File> iterator = list.iterator();
		int count = 1;
		File imageFile;
		while(iterator.hasNext()){
			imageFile = iterator.next();
			if(insertData(conn, imageFile))
				System.out.println(count + " Records inserted");
			count++;
		}
	}
}
