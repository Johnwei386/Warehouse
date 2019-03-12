package com.example.hbase.admin;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;

import org.apache.commons.io.FileUtils;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.HColumnDescriptor;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.Admin;
import org.apache.hadoop.hbase.client.Connection;
import org.apache.hadoop.hbase.client.ConnectionFactory;
import org.apache.hadoop.hbase.client.Delete;
import org.apache.hadoop.hbase.client.Get;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Result;
import org.apache.hadoop.hbase.client.ResultScanner;
import org.apache.hadoop.hbase.client.Scan;
import org.apache.hadoop.hbase.client.Table;
import org.apache.hadoop.hbase.util.Bytes;

public class Example {
	public static Configuration config;
	private static Connection connection;
	private static String ColFamily1;
	private static String Qualifier1;
	
	static{
		config = HBaseConfiguration.create();
		String path = "/opt/hbase-1.2.6/conf/hbase-site.xml";
		config.addResource(new Path(path)); 
		ColFamily1 = "Content";
		Qualifier1 = "image";
		try {
			connection = ConnectionFactory.createConnection(config);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args){
		long startTime = System.currentTimeMillis();
		TableName table = TableName.valueOf("Table2");
		//createTable(table);
		//dropTable(table);
		//getRow(table, "row1");
		//scanTable(table);
		//deleteRow(table, "row1");
		//addColFamily(table, "address");
		try{
			//byte[] imageinByte = convertImageToByteArray("/tmp/5.jpg");
			//insertData(table, "row1", imageinByte);
			putImageToHbase(table);
		} catch(IOException e){
			e.printStackTrace();
		}
		long endTime = System.currentTimeMillis();
		System.out.println("Program runing time: "+(double)(endTime-startTime)/(double)1000+"s");
	}
	
	/**
	 *  创建table
	 * @param tableName
	 */
	public static void createTable(TableName tableName){
		try{
			Admin admin = connection.getAdmin();
			if(admin.tableExists(tableName)){
				System.out.println(tableName.getNameAsString()+" already exists");
			} else{
				HTableDescriptor desc = new HTableDescriptor(tableName);
				desc.addFamily(new HColumnDescriptor(ColFamily1));
				admin.createTable(desc);
				System.out.println(tableName.getNameAsString()+" has been built");
			}
			
		}catch(IOException e){
			e.printStackTrace();
		}	
	}

	/**
	 *  插入数据
	 * @param tableName
	 * @param row_key
	 */
	public static void insertData(TableName tableName, String rowKey, byte[] imageBytes){		
		try{
			Table table = connection.getTable(tableName);
			byte[] row1 = Bytes.toBytes(rowKey);
			Put p = new Put(row1);
			p.addImmutable(ColFamily1.getBytes(), Qualifier1.getBytes(), imageBytes);
			table.put(p);
		}catch(IOException e){
			e.printStackTrace();
		}
	}
	
	/**
	 *  删除一张表
	 * @param table
	 */
	public static void dropTable(TableName table){
		try {
			Admin admin = connection.getAdmin();
			admin.disableTable(table);
			admin.deleteTable(table);
			System.out.println("table "+table.getNameAsString()+" has been deleted!");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 *  按行键获取一行数据
	 * @param tableName
	 * @param rowKey
	 */
	public static void getRow(TableName tableName, String rowKey){
		try {
			Table table = connection.getTable(tableName);
			Result result = table.get(new Get(Bytes.toBytes(rowKey)));
			//String greeting = Bytes.toString(result.getValue(ColFamily1.getBytes(), Qualifier1.getBytes()));
			//System.out.println(rowKey+" = "+greeting);
			byte[] imageBytes = result.getValue(ColFamily1.getBytes(), Qualifier1.getBytes());
			FileUtils.writeByteArrayToFile(new File("/tmp/test.jpg"), imageBytes);
			System.out.println("capture image file success!");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 *  遍历一张表
	 * @param tableName
	 */
	public static void scanTable(TableName tableName){
		try {
			Table table = connection.getTable(tableName);
			Scan scan = new Scan();
			ResultScanner rs = table.getScanner(scan);
			byte[] valueBytes;
			for(Result row = rs.next(); row != null; row = rs.next()){
				valueBytes = row.getValue(ColFamily1.getBytes(), Qualifier1.getBytes());
				System.out.println(Bytes.toString(valueBytes));
			}
			rs.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 *  删除一行数据
	 * @param tableName
	 * @param rowKey
	 */
	public static void deleteRow(TableName tableName, String rowKey){
		try {
			Table table = connection.getTable(tableName);
			Delete d = new Delete(rowKey.getBytes());
			table.delete(d);
			System.out.println(rowKey+" has been deleted!");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 *  像一张表中增加列族
	 * @param tableName
	 * @param newFamily
	 */
	public static void addColFamily(TableName tableName, String newFamily){
		try {
			Admin admin = connection.getAdmin();
			admin.disableTable(tableName);
			
			HColumnDescriptor cf1 = new HColumnDescriptor(newFamily);
			admin.addColumn(tableName, cf1);
			//admin.modifyColumn(tableName, cf2); //对列族进行修改
			
			admin.enableTable(tableName);
			System.out.println("add column family success!");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 *  读取图片并将其转换为字节流
	 * @param ImageName
	 * @return
	 * @throws IOException
	 */
	private static byte[] convertImageToByteArray(String ImageName) throws IOException{
		byte[] imageInByte = null;
		BufferedImage originalImage;
		String format;
		ImageInputStream input = ImageIO.createImageInputStream(new File(ImageName));
		Iterator<ImageReader> readers = ImageIO.getImageReaders(input);
		if (readers.hasNext()) {
			ImageReader reader = readers.next();
			reader.setInput(input);
			originalImage = reader.read(0);
			format = reader.getFormatName();
			// convert BufferedImage to byte array
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			ImageIO.write(originalImage, format, output);
			imageInByte = output.toByteArray();
			output.close();
		}		
		return imageInByte;
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
				//System.out.println(files[i].getAbsolutePath());
			}
		}
		return list;
	}
	
	/**
	 *  将目标文件夹下的所有的图片加入到Hbase中，行键按1递增
	 * @param tableName
	 * @throws IOException
	 */
	private static void putImageToHbase(TableName tableName) throws IOException{
		ArrayList<File> list = getFileNameList("/home/john/桌面/picture");
		Iterator<File> iterator = list.iterator();
		int count = 1;
		byte[] imageBytes;
		File file;
		while(iterator.hasNext()){
			file = (File)iterator.next();
			imageBytes = convertImageToByteArray(file.getAbsolutePath());
			insertData(tableName, ""+count, imageBytes);
			System.out.println(count + " Records inserted");
			count++;
		}
	}
}
