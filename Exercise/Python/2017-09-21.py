#!/usr/bin/env python
# -*- coding: utf-8 -*-

num = raw_input("please submit a num:");
num = int(num)
if num%2 == 0:
	if num%4 == 0:
		print "%d can be division by 4" % num
	else:
		print "%d can be division by 2, is even" % num
else:
	print "%d is odd" % num
