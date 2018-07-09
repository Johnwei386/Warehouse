#!/usr/bin/env python
# -*- coding: utf-8 -*-

#
# 真分数a/7化为循环小数后，若从小数点后第一位数字开始连续若干位数字之和是1992
# 求a
#

for a in range(1,7):
	i = a/7.0
	s = str(i) # 将小数转换为字符串序列
	s = s[2:] # 去除0.
	key = s[0] # 设置比较值，这里不严谨，因为只从第1位判断相似度

	# 得到循环小数的循环因子，即与第1位不同的最小数集
	j = 1
	while(1):
		if s[j] == key:
			break
		j = j+1
	seq = s[:j]
	
	# 求1992与循环因子各位数和的余数
	div = 0
	for k in range(0,j):
		div = div + int(seq[k])
	ran = 1992 % div
	
	# 在循环因子中累次相加，看是否等于余数，等即是所求之a
	su = 0
	for k in range(0,j):
		su = su + int(seq[k])
		if su == ran:
			print a

	#print seq,div,ran

