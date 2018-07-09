#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time

name = raw_input("请输入你的姓名:")
age = raw_input("请输入你的年龄:")
age = int(age)

year = time.gmtime().tm_year
birth_year = year - age
year100 = birth_year + 100

print "%s, 当你100岁时，正好是%d年" % (name, year100)
