package org.apache.Test;

public class ThreadsEample {

	public static void main(String[] args) {
		Storage s = new Storage(6);
		Thread p1 = new Thread(new Producer("Producer1", s));
		Thread p2 = new Thread(new Producer("Producer2", s));
		Thread c1 = new Thread(new Comsumer("Consumer1", s));
		
		p1.start();
		p2.start();
		c1.start();
	}

}
