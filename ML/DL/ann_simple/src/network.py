#!/usr/bin/env python
# _*_ coding: UTF8 _*_
"""
network.py
~~~~~~~~~~

A module to implement the stochastic gradient descent learning
algorithm for a feedforward neural network.  Gradients are calculated
using backpropagation.  Note that I have focused on making the code
simple, easily readable, and easily modifiable.  It is not optimized,
and omits many desirable features.
"""

#### Libraries
# Standard library
import random

# Third-party libraries
import numpy as np

class Network(object):

    def __init__(self, sizes):
        """The list ``sizes`` contains the number of neurons in the
        respective layers of the network.  For example, if the list
        was [2, 3, 1] then it would be a three-layer network, with the
        first layer containing 2 neurons, the second layer 3 neurons,
        and the third layer 1 neuron.  The biases and weights for the
        network are initialized randomly, using a Gaussian
        distribution with mean 0, and variance 1.  Note that the first
        layer is assumed to be an input layer, and by convention we
        won't set any biases for those neurons, since biases are only
        ever used in computing the outputs from later layers."""
        # sizes每一个元素存储每一层的神经元数量，它的大小就是神经网络的层数
        self.num_layers = len(sizes)
        self.sizes = sizes
        # 从一个标准的正态分布中去采样数据来初始化偏差biases和权重weight
        # randn(y, x)生成x*y个权值，对应第i-1层与第i层之间全连接的权重值
        # zip([1,2], [4,5]) = [(1,4),(2,5)], sizes[:-1]表示除最后一个元素外的所有元素
        self.biases = [np.random.randn(y, 1) for y in sizes[1:]]
        self.weights = [np.random.randn(y, x)
                        for x, y in zip(sizes[:-1], sizes[1:])]

    def feedforward(self, a):
        """Return the output of the network if ``a`` is input."""
        # 输入a，这里a为一张图片的所有像素值(灰度)
        # 输出，网络识别这张图片上面的数字的识别向量y‘
        for b, w in zip(self.biases, self.weights):
            # zip(biases,weight) = (b偏差向量，w权重向量)
            # np.dot矩阵的点乘，w为权重矩阵的某一列向量
            # a为输入的上一层神经元的激活值矢量，b为对应某层的偏差向量
            # 计算每一个神经元的激活值
            a = sigmoid(np.dot(w, a)+b)
        return a

    def SGD(self, training_data, epochs, mini_batch_size, eta,
            test_data=None):
        """Train the neural network using mini-batch stochastic
        gradient descent.  The ``training_data`` is a list of tuples
        ``(x, y)`` representing the training inputs and the desired
        outputs.  The other non-optional parameters are
        self-explanatory.  If ``test_data`` is provided then the
        network will be evaluated against the test data after each
        epoch, and partial progress printed out.  This is useful for
        tracking progress, but slows things down substantially."""
        # 随机梯度下降，训练整个网络
        # mini_batch_size: 切分原始数据集的单位
        # eta: 学习率
        # epochs: 训练的代数
        if test_data: n_test = len(test_data)
        n = len(training_data)
        for j in xrange(epochs):
            # 每一代训练都会将原始数据集中的元素重新排序
            random.shuffle(training_data)
            # 以mini_batch_size为步长切分原始数据集
            mini_batches = [
                training_data[k:k+mini_batch_size]
                for k in xrange(0, n, mini_batch_size)]
            # 每次计算一个小数据集，直到计算完整个的数据集
            for mini_batch in mini_batches:
                # 每次使用这些切分后的小数据片更新网络的权重和偏差
                self.update_mini_batch(mini_batch, eta)
            if test_data:
                # 如果给定了测试数据，则在每一代训练后，评估训练后的网络，并反馈进度
                print "Epoch {0}: {1} / {2}".format(
                    j, self.evaluate(test_data), n_test)
            else:
                print "Epoch {0} complete".format(j)

    def update_mini_batch(self, mini_batch, eta):
        """Update the network's weights and biases by applying
        gradient descent using backpropagation to a single mini batch.
        The ``mini_batch`` is a list of tuples ``(x, y)``, and ``eta``
        is the learning rate."""
        # b.shape指的是biases这个大数组中每个元素的大小
        # np.zeros(N)创建一个大小为N的数组，数组元素用0填充(0矩阵)
        nabla_b = [np.zeros(b.shape) for b in self.biases]
        nabla_w = [np.zeros(w.shape) for w in self.weights]
        for x, y in mini_batch:
            # 使用反向传播算法得到权重与偏差的更新值，每次只处理一个训练样本
            # 将一个mini_batch下的所有样本得到的改变量全加起来
            delta_nabla_b, delta_nabla_w = self.backprop(x, y)
            # 现将每个样本训练后得到的梯度改变量全加起来
            nabla_b = [nb+dnb for nb, dnb in zip(nabla_b, delta_nabla_b)]
            nabla_w = [nw+dnw for nw, dnw in zip(nabla_w, delta_nabla_w)]
        # 在正式要更新整个网络的参数时，对参数的改变量取平均
        self.weights = [w-(eta/len(mini_batch))*nw
                        for w, nw in zip(self.weights, nabla_w)]
        self.biases = [b-(eta/len(mini_batch))*nb
                       for b, nb in zip(self.biases, nabla_b)]

    def backprop(self, x, y):
        """Return a tuple ``(nabla_b, nabla_w)`` representing the
        gradient for the cost function C_x.  ``nabla_b`` and
        ``nabla_w`` are layer-by-layer lists of numpy arrays, similar
        to ``self.biases`` and ``self.weights``."""
        nabla_b = [np.zeros(b.shape) for b in self.biases]
        nabla_w = [np.zeros(w.shape) for w in self.weights]
        # feedforward
        activation = x
        activations = [x] # list to store all the activations, layer by layer
        zs = [] # list to store all the z vectors, layer by layer
        # 初始化计算整个网络各个神经元的激活值
        for b, w in zip(self.biases, self.weights):
            z = np.dot(w, activation)+b
            zs.append(z)
            activation = sigmoid(z)
            activations.append(activation)
        # backward pass
        # 定义代价函数的目的是要训练网络，最小化代价函数是目标
        # 在这个目标下，通过训练网络得到正确的参数才是关键
        # 代价函数的定义是1/2×cost,在求导之后就去掉了那个2倍的量
        # 代价函数求导后返回的是一个向量
        # 先计算最后一层的参数改变量(梯度)
        delta = self.cost_derivative(activations[-1], y) * \
            sigmoid_prime(zs[-1])
        nabla_b[-1] = delta
        nabla_w[-1] = np.dot(delta, activations[-2].transpose())
        # Note that the variable l in the loop below is used a little
        # differently to the notation in Chapter 2 of the book.  Here,
        # l = 1 means the last layer of neurons, l = 2 is the
        # second-last layer, and so on.  It's a renumbering of the
        # scheme in the book, used here to take advantage of the fact
        # that Python can use negative indices in lists.
        # 反向传播去计算自最后一层往前的各层的参数的改变量(梯度)
        for l in xrange(2, self.num_layers):
            z = zs[-l]
            sp = sigmoid_prime(z)
            delta = np.dot(self.weights[-l+1].transpose(), delta) * sp
            nabla_b[-l] = delta
            nabla_w[-l] = np.dot(delta, activations[-l-1].transpose())
        return (nabla_b, nabla_w)

    def evaluate(self, test_data):
        """Return the number of test inputs for which the neural
        network outputs the correct result. Note that the neural
        network's output is assumed to be the index of whichever
        neuron in the final layer has the highest activation."""
        # 返回神经网络正确识别的图像数量，按照最后一层的输出
        # 拥有最大激活值的神经元对应的那个数字的索引就是一次识别的结果
        # 如果与y(期望的数字)相等，则即为正确识别了这个图像
        # argmax返回数组序列中拥有最大数值的元素的索引，这里将索引与图像的数字对应起来了
        test_results = [(np.argmax(self.feedforward(x)), y)
                        for (x, y) in test_data]
        return sum(int(x == y) for (x, y) in test_results)

    def cost_derivative(self, output_activations, y):
        """Return the vector of partial derivatives \partial C_x /
        \partial a for the output activations."""
        return (output_activations-y)

#### Miscellaneous functions
def sigmoid(z):
    """The sigmoid function."""
    return 1.0/(1.0+np.exp(-z))

def sigmoid_prime(z):
    """Derivative of the sigmoid function."""
    return sigmoid(z)*(1-sigmoid(z))
