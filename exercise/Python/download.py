#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urllib,urllib2
import re

pattern = re.compile(r'(\d+)(\.).*')
file = open('picture.link', 'r')
url = file.readline()
count = 0
while url:
	match = pattern.search(url)
	if match:
		filename = match.group()
		urllib.urlretrieve(url,'./'+filename)
		print filename+' ','has been downloaded'
	url = file.readline()
	count = count + 1
print "总共下载了%d张图片" % count
file.close()
