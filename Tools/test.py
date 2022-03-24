#!/usr/bin/env python
# -*- coding:utf8 -*-

from collections import OrderedDict
from sklearn.cross_validation import train_test_split
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
import pandas as pd

examDict={
    '学习时间':[0.50, 0.75,1.00,1.25,1.50,1.75,1.75,2.00,2.25,
            2.50,2.75,3.00,3.25,3.50,4.00,4.25,4.50,4.75,5.00,5.50],
    '分数':    [10,  22,  13,  43,  20,  22,  33,  50,  62,  
              48,  55,  75,  62,  73,  81,  76,  64,  82,  90,  93]
}
examOrderDict = OrderedDict(examDict)
exam = pd.DataFrame(examOrderDict)

#从DataFrame中把标签和特征导出来
exam_X = exam['学习时间']
exam_Y = exam['分数']

#绘制散点图，通过画图判断适不适合用线性回归的模型，判断完之后要注释掉
plt.scatter(exam_X, exam_Y, color = 'green')
#设定X,Y轴标签和title
#plt.ylabel('Scores')
#plt.xlabel('Times(h)')
#plt.title('Exam Data')
#plt.show()

#比例为7：3
X_train, X_test, Y_train, Y_test = train_test_split(exam_X, exam_Y, train_size = 0.8)

#导入线性回归模型
#sklearn 要求输入的特征为二维数组类型。
#数据集只有1个特征，需要用array.reshape(-1, 1)来改变数组的形状

#改变一下数组的形状
X_train = X_train.values.reshape(-1, 1)
X_test = X_test.values.reshape(-1, 1)

print(X_train)
print(Y_train.shape)

#创建一个模型
model = LinearRegression()
#训练一下
model.fit(X_train, Y_train)

a = model.intercept_
b = model.coef_
a = float(a)
b = float(b)
print('该模型的简单线性回归方程为y = {} + {} * x'.format(a, b))

#绘制散点图
plt.scatter(exam_X, exam_Y, color = 'green', label = 'train data')
#设定X,Y轴标签和title
plt.ylabel('Scores')
plt.xlabel('Times(h)')

#绘制最佳拟合曲线
Y_train_pred = model.predict(X_train)
plt.plot(X_train, Y_train_pred, color = 'black', label = 'best line')

#输出效果图
plt.legend(loc = 2)
plt.show()


