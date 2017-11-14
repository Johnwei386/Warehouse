#!/usr/bin/env python
# _*_ coding:utf-8 _*_

import httplib,urllib
import random
import time
import datetime
from threading import Thread

def get_url():
	switch_dict={
		0:'hadoop',
		1:'spark',
		2:'apple',
		3:'hello',
		4:'mapreduce',
		5:'java',
		6:'python',
		7:'PHP',
		8:'Perl',
		9:'Bash'
	}
	i = int((random.random() * 100) % 10)
	url = 'http://localhost:8765'
	url = url+'/'+switch_dict[i]
	return url

# 多线程操作，定义一个类
class HttpRequest(Thread):
	def __init__(self):
		Thread.__init__(self)
	def http_request(self):
		try:
			url = get_url()
			res = urllib.urlopen(url)
			#print 'Get ',res.geturl()
			res.close()
		except:
			pass
	def run(self):
		self.http_request()

def multi_threads(threads_num):
	for i in range(threads_num):
		worker = HttpRequest()
		worker.daemon = True
		worker.start()

startTime = datetime.datetime.now()
print '生成一百万行日志数据'
print '任务开始于： ',startTime
multi_threads(1000000)
endTime = datetime.datetime.now()
print '任务结束于： ',endTime
print ' 总共花费时间: ',(endTime-startTime).total_seconds(),'s'
