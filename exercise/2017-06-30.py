#!/usr/bin/env python
# _*_ coding: UTF8 _*_

# for中的else的判断标准与while一致
def intersect(*args):
	res = []
	for x in args[0]:
		for other in args[1:]:
			if x not in other: break
		else: # 执行完整个循环之后，看有无break发生，没有执行else
			res.append(x)
	return res

def union(*args):
	res = []
	for seq in args:
		for x in seq:
			if not x in res:
				res.append(x)
	return res

# while中的else判断标准为若没遇上break语句则执行
def isprim(y):
	x = y/2
	while x > 2:
		if y % x == 0:
			print y,'存在因子',x
			break
		x = x-1
	else:
		print y,'是素数' #默认返回的就是个空值

s1, s2, s3 = "spam", "scam", "blam"
print intersect(s1, s2, s3), union(s1, s2, s3)
print isprim(5),
print isprim(12),
