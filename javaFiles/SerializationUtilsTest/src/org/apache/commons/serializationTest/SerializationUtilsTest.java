package org.apache.commons.serializationTest;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.Serializable;
import java.util.Iterator;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.ImageWriter;
import javax.imageio.stream.ImageInputStream;
import javax.imageio.stream.ImageOutputStream;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.SerializationUtils;
import org.apache.hadoop.hbase.util.Bytes;

/*
 * static Object   clone(Serializable object)  //Deep clone an Object using serialization.
 * static Object   deserialize(byte[] objectData) //Deserializes a single Object from an array of bytes.
 * static Object   deserialize(InputStream inputStream)  //Deserializes an Object from the specified stream.
 * static byte[]   serialize(Serializable obj) //Serializes an Object to a byte array for storage/serialization.
 * static void serialize(Serializable obj, OutputStream outputStream) //Serializes an Object to the specified stream.
 * FileUtils.writeByteArrayToFile(new File("pathname"), myByteArray); //copy this file to new file
 */

public class SerializationUtilsTest {
	public static void main(String[] args) {
		try{
			/*
			// File to serialize object to it can be your image or any media file
			String fileName = "/tmp/serialization.test";			
			// New file output stream for the file
			FileOutputStream fos = new FileOutputStream(fileName);			
			// Serizalize String
			SerializationUtils.serialize("SERIALIZE THIS FILE", fos);			
			// Open FileInputStream to the file
			FileInputStream fis = new FileInputStream(fileName);			
			// Deserialize and cast into String
			String ser = (String)SerializationUtils.deserialize(fis);
			System.out.println(ser);
			fis.close();*/
			
			//BufferedImage image = ImageIO.read(new File("/tmp/k194.png"));
			byte[] imageBytes = convertImageToByteArray("/tmp/k194.png");
			FileUtils.writeByteArrayToFile(new File("/tmp/test.png"), imageBytes);
			System.out.println("Read and Write image file success!");
		} catch(Exception e){
			e.printStackTrace();
		}
	}

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
	
	private static void getImageFormatName(String filePath) throws IOException{
		ImageInputStream input = ImageIO.createImageInputStream(new File(filePath));
		ByteArrayOutputStream outputFileOrStream = new ByteArrayOutputStream();
		try {
			Iterator<ImageReader> readers = ImageIO.getImageReaders(input);
			if (readers.hasNext()) {
				ImageReader reader = readers.next();
				try {
					reader.setInput(input);
					BufferedImage image = reader.read(0);  // Read the same image as ImageIO.read
					String format = reader.getFormatName(); // Get the format name for use later
					if (!ImageIO.write(image, format, outputFileOrStream)) {
						// ...handle not written
					}
					ImageWriter writer = ImageIO.getImageWriter(reader); // Get best suitable writer

					try {
						ImageOutputStream output = ImageIO.createImageOutputStream(outputFileOrStream);
						try {
							writer.setOutput(output);
							writer.write(image);
						}
						finally {
							output.close();
						}
					}
					finally {
						writer.dispose();
					}
				}
				finally {
					reader.dispose();
				}
			}
		}
		finally {
			input.close();
			outputFileOrStream.close();
		}
	}
}
