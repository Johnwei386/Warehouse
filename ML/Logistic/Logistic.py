#!/usr/bin/env python
# _*_ coding:UTF8 _*_

import numpy as np
import matplotlib.pyplot as plt

def loadDataSet(file_name):
    dataMat = []
    labelMat = []
    fr = open(file_name)
    for line in fr.readlines():
        lineArr = line.strip().split()
        if len(lineArr) == 0:
            continue
        dataMat.append([1.0, float(lineArr[0]), float(lineArr[1])])
        labelMat.append(int(lineArr[2]))
    return dataMat,labelMat

# 梯度上升优化参数, alpha为学习率, epochs为训练迭代次数
# 按照吴恩达的Logistic回归分类的思路，梯度即代价函数对应参数的偏导数
# 效果不是很好，每次执行后的结果，随机性很高
def gradAscent(dataMatrix, classLabels, alpha=0.01, epochs=150):
    m, n = np.shape(dataMatrix)
    # 生成数据矩阵，m×3矩阵
    dataMat = np.mat(dataMatrix)
    # 生成标签向量，列向量形式
    y = np.mat(classLabels).reshape(m, 1)
    # 从高斯分布中采样，随机生成初始化参数
    w = np.random.randn(n, 1)

    for i in range(epochs):
        nw = np.zeros(w.shape)
        # 在整个训练数据集上进行操作
        for j in range(m):
            z = float(np.dot(dataMat[j], w))
            sp = sigmoid_prime(z)
            hz = sigmoid(z)
            # 见文本说明，这是对样本数据求导后的固定项和Sigmoid导数的积
            delta = ((y[j] - hz)/(hz * (1-hz))) * sp
            # 将所有根据每个样本已经得到的参数的改变量累加
            nw = nw + (delta * dataMat[j]).transpose()
        # 梯度上升，优化参数，对参数的改变量取平均
        w = w + (alpha / m) * nw

    return w

def plotBestFit(dataArr, labelMat, weights):
    n = np.shape(dataArr)[0]

    # 不同颜色绘制正类与负类散点图
    xcord1 = []
    ycord1 = []
    xcord2 = []
    ycord2 = []
    for i in range(n):
        if int(labelMat[i]) == 1:
            xcord1.append(dataArr[i, 1])
            ycord1.append(dataArr[i, 2])
        else:
            xcord2.append(dataArr[i, 1])
            ycord2.append(dataArr[i, 2])

    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.scatter(xcord1, ycord1, s=30, c='red', marker='s')
    ax.scatter(xcord2, ycord2, s=30, c='green')

    # 绘制划分直线
    x = np.arange(-3.0, 3.0, 0.1)
    theta = np.array(weights)
    y = (-theta[0] - theta[1] * x) / theta[2]
    ax.plot(x, y)
    plt.xlabel('X')
    plt.ylabel('Y')
    plt.show()

# sigmoid函数
def sigmoid(z):
    return 1.0/(1.0+np.exp(-z))

# sigmoid函数的导数
def sigmoid_prime(z):
    return sigmoid(z)*(1-sigmoid(z))

if __name__ == "__main__":
    dataMatrix, classLabels = loadDataSet("TestSet.txt")
    dataArr = np.array(dataMatrix)
    weights = gradAscent(dataMatrix, classLabels)
    plotBestFit(dataArr, classLabels, weights)