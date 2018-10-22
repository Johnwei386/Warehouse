import numpy as np
from random import shuffle

def svm_loss_naive(W, X, y, reg):
  """
  Structured SVM loss function, naive implementation (with loops).

  Inputs have dimension D, there are C classes, and we operate on minibatches
  of N examples.

  Inputs:
  - W: A numpy array of shape (D, C) containing weights.
  - X: A numpy array of shape (N, D) containing a minibatch of data.
  - y: A numpy array of shape (N,) containing training labels; y[i] = c means
    that X[i] has label c, where 0 <= c < C.
  - reg: (float) regularization strength

  Returns a tuple of:
  - loss as single float
  - gradient with respect to weights W; an array of same shape as W
  """
  dW = np.zeros(W.shape) # initialize the gradient as zero

  # compute the loss and the gradient
  num_classes = W.shape[1]
  num_train = X.shape[0]
  loss = 0.0
  for i in range(num_train):
    # i号样本各个类的分值,1x10
    scores = X[i].dot(W)
    # 正确分类的分值
    correct_class_score = scores[y[i]]
    for j in range(num_classes):
      if j == y[i]:
        continue
      # 最优间隔为1
      margin = scores[j] - correct_class_score + 1 # note delta = 1
      # 比最优间隔1大的分类之间的差异,不计算其cost代价值,cost一律为0
      if margin > 0:
        loss += margin
        # 计算w_yi的偏导数为它的梯度,-x_i
        dW[i,y[i]] -= X[i,j]
      else:
        # 计算非w_yi的其他参数的偏导数为它的梯度,+x_i
        dW[i,j] += X[i,j]

  # Right now the loss is a sum over all training examples, but we want it
  # to be an average instead so we divide by num_train.
  loss /= num_train

  # Add regularization to the loss.
  # 正则化惩罚项,使用L2范数,\sum_i w_i^2
  loss += reg * np.sum(W * W)

  #############################################################################
  # Compute the gradient of the loss function and store it dW.                #
  # Rather that first computing the loss and then computing the derivative,   #
  # it may be simpler to compute the derivative at the same time that the     #
  # loss is being computed. As a result you may need to modify some of the    #
  # code above to compute the gradient.                                       #
  #############################################################################
  
  # Gradient regularization that carries through 
  # per https://piazza.com/class/i37qi08h43qfv?cid=118
  # 添加梯度惩罚项
  dW += reg*W

  return loss, dW


def svm_loss_vectorized(W, X, y, reg):
  """
  Structured SVM loss function, vectorized implementation.

  Inputs and outputs are the same as svm_loss_naive.
  """
  loss = 0.0
  dW = np.zeros(W.shape) # initialize the gradient as zero

  #############################################################################
  # Implement a vectorized version of the structured SVM loss, storing the    #
  # result in loss.                                                           #
  #############################################################################
  D = X.shape[0]
  num_classes = W.shape[1]
  num_train = X.shape[0]
  # 得到分数矩阵, 10x500
  scores = np.dot(X, W).T
    
  # 正确分类的分数矩阵,500x1表示500个样本的正确分类的分数
  correct_scores = scores[y, range(num_train)]
  # 过度矩阵,10x500
  mat = scores - correct_scores + 1
  # 正确分类的项,不参与loss值计算
  mat[y, range(num_train)] = 0 
  # 最优间隔大于1的项,不参与loss值计算,置为0
  thresh = np.maximum(np.zeros((num_classes,num_train)), mat)
  # 计算loss值
  loss = np.sum(thresh)
  loss /= num_train

  # 添加正则惩罚项
  loss += 0.5 * reg * np.sum(W * W)

  #############################################################################
  # Implement a vectorized version of the gradient for the structured SVM     #
  # loss, storing the result in dW.                                           #
  #                                                                           #
  # Hint: Instead of computing the gradient from scratch, it may be easier    #
  # to reuse some of the intermediate values that you used to compute the     #
  # loss.                                                                     #
  #############################################################################
  binary = thresh
  # 10x500
  binary[thresh > 0] = 1

  # 500x1,[1,3,4,5,10,8,...a\in(1,10)...,6]
  # 一张图片被分配给间隔>=1的类的数量
  col_sum = np.sum(binary, axis=0)
  # yi对应的分类正确的参数项作-a倍处理
  binary[y, range(num_train)] = -col_sum[range(num_train)]
  dW = np.dot(X.T, binary.T)

  # Divide
  dW /= num_train

  # Regularize
  dW += reg*W

  return loss, dW
