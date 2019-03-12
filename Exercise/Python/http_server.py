#!/usr/bin/env python
# -*- coding: utf-8 -*-

from BaseHTTPServer import HTTPServer,BaseHTTPRequestHandler
class RequestHandler(BaseHTTPRequestHandler):
	def _writeheaders(self):
		print self.path
		print self.headers
		self.send_response(200);
		self.send_header('Content-type','text/html');
		self.end_headers()
	def do_Head(self):
		self._writeheaders()
	def do_GET(self):
		logline = str(self.log_date_time_string())
		logline = logline+"	"
		logline = logline+str(self.path)+"\n"
		files.write(logline)
		print logline
	def do_POST(self):
		pass

#创建日志文件
files = open('access.log', 'w')

#打开服务器
addr = ('',8765)
server = HTTPServer(addr,RequestHandler)
server.serve_forever()
files.close()
