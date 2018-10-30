import numpy as np
from random import shuffle

def softmax_loss_naive(W, X, y, reg):
  """
  Softmax loss function, naive implementation (with loops)

  Inputs have dimension D, there are C classes, and we operate on minibatches
  of N examples.

  Inputs:
  - W: A numpy array of shape (D, C) containing weights.
  - X: A numpy array of shape (N, D) containing a minibatch of data.
  - y: A numpy array of shape (N,) containing training labels; y[i] = c means
    that X[i] has label c, where 0 <= c < C.
  - reg: (float) regularization strength(正则化强度)

  Returns a tuple of:
  - loss as single float
  - gradient with respect to weights W; an array of same shape as W
  """
  # Initialize the loss and gradient to zero.
  loss = 0.0
  dW = np.zeros_like(W)

  #############################################################################
  # Compute the softmax loss and its gradient using explicit loops.           #
  # Store the loss in loss and the gradient in dW. If you are not careful     #
  # here, it is easy to run into numeric instability. Don't forget the        #
  # regularization!                                                           #
  #############################################################################
    
  # Get shapes
  num_train = X.shape[0]
  num_classes = W.shape[1]

  # create loss array
  loss = np.zeros(num_train)

  for i in range(num_train):
    # Compute vector of scores
    # [10×3073]·[3073×1] = [10×1]
    f_i = np.dot(W.T, X[i, :].reshape(X.shape[1], 1))

    # Normalization trick to avoid numerical instability, 
    # per http://cs231n.github.io/linear-classify/#softmax
    # 正则化处理,避免数值过大带来的波动偏差,因为指数的缘故
    log_c = np.max(f_i)
    f_i -= log_c

    # Compute loss (and add to it, divided later)
    # p = exp(f_yi) / \sum_j e^{f_j},将数据x_i分类到j类的概率
    # L_i = - log(p),取负为了最小化代价函数求解最优参数值
    # L_i = - f(x_i)_{y_i} + log \sum_j e^{f(x_i)_j}
    sum_i = 0.0
    for f_i_j in f_i:
      sum_i += np.exp(f_i_j)
    loss[i] += -f_i[y[i]] + np.log(sum_i)

    # Compute gradient
    # dw_j = 1/num_train * [x_i * (p(y_i = j)-Ind{y_i = j})]
    # Here we are computing the contribution to the inner sum for a given i.
    for j in range(num_classes):
      # 在参数W给定下,将数据x_i分类到j类的概率
      p = np.exp(f_i[j])/sum_i
      # 是对某个类的参数W_yi求loss函数的偏导数
      # 对样本x_i而言,其正确分类的参数微分需-1,其他非正确分类不用.
      dW[:, j] += (p-(j == y[i])) * X[i, :]

  # Compute average
  loss = np.mean(loss)
  dW /= num_train

  # Regularization,细微调整loss值
  loss += 0.5 * reg * np.sum(W * W)
  dW += reg*W

  return loss, dW


def softmax_loss_vectorized(W, X, y, reg):
  """
  Softmax loss function, vectorized version.

  Inputs and outputs are the same as softmax_loss_naive.
  """
  # Initialize the loss and gradient to zero.
  loss = 0.0
  dW = np.zeros_like(W)

  #############################################################################
  # Compute the softmax loss and its gradient using no explicit loops.  #
  # Store the loss in loss and the gradient in dW. If you are not careful     #
  # here, it is easy to run into numeric instability. Don't forget the        #
  # regularization!                                                           #
  #############################################################################
  # Get shapes
  num_train = X.shape[0]
  num_classes = W.shape[1]

  # Compute scores,f=[10x500]
  f = np.dot(X, W).T

  # Normalization trick to avoid numerical instability, 
  # per http://cs231n.github.io/linear-classify/#softmax
  f -= np.max(f)

  # Loss: L_i = - f(x_i)_{y_i} + log \sum_j e^{f(x_i)_j}
  # Compute vector of stacked correct f-scores: [f(x_1)_{y_1}, ..., f(x_N)_{y_N}]
  # (where N = num_train)
  # f_correct.shape=(500,),对应某个类下,每张图片的分类概率
  # 索引数组的一个方式,f[y,range(列数量)]=f[y[i],i for i in range(列数量)]
  f_correct = f[y, range(num_train)]
  # 对500个样本的loss值求均值
  loss = np.mean( -np.log(np.exp(f_correct)/np.sum(np.exp(f), axis=0)) )

  # Gradient: dw_j = 1/num_train * \sum_i[x_i * (p(y_i = j)-Ind{y_i = j} )]
  # np.sum(np.exp(f), axis=0).shape=(500,),分类分数按样本相加
  # np.exp(f).shape=(10,500),p.shape=(10,500)
  p = np.exp(f)/np.sum(np.exp(f), axis=0)
  ind = np.zeros(p.shape)
  # 指示正确分类的图片到那个类
  ind[y, range(num_train)] = 1
  # 计算梯度
  dW = np.dot(X.T, (p-ind).T)
  #print(dW.shape)
  dW /= num_train

  # Regularization
  loss += 0.5 * reg * np.sum(W * W)
  dW += reg*W

  return loss, dW

