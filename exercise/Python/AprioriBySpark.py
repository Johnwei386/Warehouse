#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time
import csv
import random
import operator
import sys

from scipy.linalg._interpolative import id_srand
from scipy.spatial import distance
from pyspark.sql import SparkSession
from pyspark.sql import  Row

def splitstr(x):
    a = ''
    for i in x:
        a = a + ','.join(i.split(',')) + ','
    a = a.strip(',')
    b = a.split(',')
    return b

# 构建一个SparkSession
spark = SparkSession \
    .builder \
    .appName("Run Apriori by Spark") \
    .getOrCreate()
sc = spark.sparkContext

# 支持度
supp = 800

# 候选项集，初始为空
candidate_sets = []
current_set_let = 1

start_time = time.time()
# 从文件创建一个RDD数据集
input_rdd = sc.textFile("/usr/root/data/Groceries.csv")

# 将RDD数据集中的数据项切分,得到每一个基本的元素项
fr_one = input_rdd.flatMap(lambda x:x.split(","))
# 合并同类项
fr_two = fr_one.groupBy(lambda x:x).map(lambda x:(x[0],list(x[1])))
# 统计各项出现次数
fr_three = fr_two.map(lambda x: (x[0],len(x[1])))
# 按支持度进行剪枝操作
fr_four = fr_three.filter(lambda x: x[1] >= supp)
# 只取频繁项的键
fr_five = fr_four.map(lambda x:str(x[0])).filter(lambda x: x.strip() != '')

# 将频繁1项集存入已知频繁项集
fr_six = fr_four.map(lambda x:str(x)).filter(lambda x: x.strip() != '')
for item in fr_six.collect():
    candidate_sets.append(item)

temp_sets = []
# 生成候选项集
for item in fr_five.collect():
    temp_sets.append(item)
# 构建初始频繁候选项集的RDD数据集
if temp_sets.__len__() > 0:
    current_candidate_set = sc.parallelize(temp_sets)

# 构建全部数据的RDD，每个元素为一个set，set包含一条数据记录所有的元素项
input_rdd_Set = input_rdd.map(lambda x: x.split(',')).map(set)

while True:
  try:
    # 记录当前取频繁项的步数，从2项集开始
    current_set_let = current_set_let + 1

    # 对已经得到的频繁项进行连接操作构建候选的频繁项集，cartesian构建二元组
    apr_one = current_candidate_set.cartesian(current_candidate_set.distinct())

    # 只取当前步数的频繁项集，如取频繁3项集，就不会取4项集
    if current_set_let == 2:
        apr_two = apr_one.map(lambda x: set(x)).filter(lambda x: len(x) == current_set_let)
    else:
        apr_two = apr_one.map(lambda x: list(x)).map(lambda x: splitstr(x)).map(lambda x: set(x)).filter(lambda x: len(x) == current_set_let)

    # 在全部商品数据集中进行项集匹配
    apr_four = apr_two.cartesian(input_rdd_Set).filter(lambda l: set(l[0]).issubset(set(l[1])))

    # reduceByKey作用于RDD的key-value类型的数据
    # reduceByKey(lambda x,y: x + y)对同一个key的两个不同的values相加
    # 这里用来统计频繁项出现的次数
    apr_five = apr_four.map(lambda x: (','.join(list(x[0])),1)).reduceByKey(lambda x,y: x + y)

    # 对得到的频繁项集进行剪枝操作
    apr_six = apr_five.filter(lambda x: x[1] >= supp).map(lambda x:x[0])
    ap_six_val = apr_six.collect()

    if len(ap_six_val) > 0 :
        for candidate in apr_five.filter(lambda x: x[1] >= supp).collect():
            candidate_sets.append(candidate)
        current_candidate_set = apr_six
    else:
        break
  except Exception as e:
      print(e)
      break

for item in candidate_sets:
    print(item)
print("Count of the frequent items are " + str(len(candidate_sets)))
print("Consume Time: %ss" % str(time.time() - start_time))


