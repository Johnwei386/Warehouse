package org.apache.Test;

public class Storage 
{
	private int count;
	private int size;
	
	public Storage(int s){
		size = s;
	}
	
	/**
	 *  为何此地和下面一样只能用while，而不能用if，因为count是在变化的
	 *  不是说加了锁的代码段，count不能被其他代码访问并修改，因为这里调用
	 *  的是wait，它会放弃所有的锁然后进入等待池，此时当一个消费者取得相关
	 *  的锁，消费了一个count，唤醒生产者之后，该生产者将会执行if语句段之后
	 *  的语句，而不是先判断count的值发生变化没，还有当生产者被唤醒之后不会
	 *  立即获得锁进入等待运行态，而是进入锁定池等待获取一把锁，具体请看线程
	 *  运行图。
	 * @param name
	 */
	public synchronized void productData(String name){
		while(count == size){
			try {
				this.wait();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		
		this.notify();
		count++;
		System.out.println(name+" make data count: "+count);
	}
	
	public synchronized void consumeData(String name){
		while(count == 0){
			try {
				this.wait();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
		
		this.notify();
		System.out.println(name+" use data count: "+count);
		count--;
	}
}
