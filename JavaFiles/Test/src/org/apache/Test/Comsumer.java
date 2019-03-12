package org.apache.Test;

public class Comsumer implements Runnable
{
	private String name;
	private Storage s;

	public Comsumer(String n, Storage s){
		name = n;
		this.s = s;
	}
	
	public void run() {
		while(true){
			s.consumeData(name);
			try {
				Thread.sleep((int)Math.random()*3000);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
	}

}
