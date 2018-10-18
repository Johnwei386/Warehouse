#!/usr/bin/env python
# _*_ coding: UTF8 _*_
"""
network_test
~~~~~~~~~~~~
搭建一个神经网络并使用MNIST数据集训练这个网络
"""

import mnist_loader
import network

# 载入MNIST数据集
training_data, validation_data, test_data = mnist_loader.load_data_wrapper()

# 构建神经网络，三层，其中隐藏层有30个神经元
net = network.Network([784, 30, 10])

# 使用随机梯度下降训练这个网络
# 训练代数30，mini-batch大小为10，学习率为3.0
net.SGD(training_data, 30, 10, 3.0, test_data=test_data)