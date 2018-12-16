package org.apache.Test;

public class Producer implements Runnable
{
	private String name;
	private Storage s;
	
	public Producer(String n, Storage s){
		name = n;
		this.s = s;
	}
	
	public void run() {
		while(true){
			s.productData(name);
			try {
				Thread.sleep((int)Math.random()*3000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}

}
