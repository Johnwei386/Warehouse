from __future__ import print_function

import numpy as np
import matplotlib.pyplot as plt

class TwoLayerNet(object):
  """
  A two-layer fully-connected neural network. The net has an input dimension of
  N, a hidden layer dimension of H, and performs classification over C classes.
  We train the network with a softmax loss function and L2 regularization on the
  weight matrices. The network uses a ReLU nonlinearity after the first fully
  connected layer.

  In other words, the network has the following architecture:

  input - fully connected layer - ReLU - fully connected layer - softmax
  (3层神经网络分类器)

  The outputs of the second fully-connected layer are the scores for each class.
  """

  def __init__(self, input_size, hidden_size, output_size, std=1e-4):
    """
    Initialize the model. Weights are initialized to small random values and
    biases are initialized to zero. Weights and biases are stored in the
    variable self.params, which is a dictionary with the following keys:

    W1: First layer weights; has shape (D, H)
    b1: First layer biases; has shape (H,)
    W2: Second layer weights; has shape (H, C)
    b2: Second layer biases; has shape (C,)

    Inputs:
    - input_size: The dimension D of the input data.
    - hidden_size: The number of neurons H in the hidden layer.
    - output_size: The number of classes C.
    """
    self.params = {}
    self.params['W1'] = std * np.random.randn(input_size, hidden_size) # DxH
    self.params['b1'] = np.zeros(hidden_size) # H
    self.params['W2'] = std * np.random.randn(hidden_size, output_size) # HxC
    self.params['b2'] = np.zeros(output_size) # C

  def loss(self, X, y=None, reg=0.0):
    """
    Compute the loss and gradients for a two layer fully connected neural
    network.

    Inputs:
    - X: Input data of shape (N, D). Each X[i] is a training sample.
    - y: Vector of training labels. y[i] is the label for X[i], and each y[i] is
      an integer in the range 0 <= y[i] < C. This parameter is optional; if it
      is not passed then we only return scores, and if it is passed then we
      instead return the loss and gradients.
    - reg: Regularization strength.

    Returns:
    If y is None, return a matrix scores of shape (N, C) where scores[i, c] is
    the score for class c on input X[i].

    If y is not None, instead return a tuple of:
    - loss: Loss (data loss and regularization loss) for this batch of training
      samples.
    - grads: Dictionary mapping parameter names to gradients of those parameters
      with respect to the loss function; has the same keys as self.params.
    """
    # Unpack variables from the params dictionary
    W1, b1 = self.params['W1'], self.params['b1']
    W2, b2 = self.params['W2'], self.params['b2']
    N, D = X.shape

    # Compute the forward pass
    scores = None
    #############################################################################
    # TODO: Perform the forward pass, computing the class scores for the input. #
    # Store the result in the scores variable, which should be an array of      #
    # shape (N, C).                                                             #
    #############################################################################
    #'''原始实现,精确度不高,原因何在?反向传播对relu层的求导其实是对值>0的反馈参数变化
    layer1 = X.dot(W1)+b1 # NxH
    #layer2 = np.maximum(0, layer1) # relu,NxH
    relu = lambda x: np.maximum(0, x)
    layer2 = relu(layer1) # (N, H)
    layer3 = layer2.dot(W2) + b2  # (N, C)    
    scores = layer3
    #'''
    
    '''其它实现
    relu = lambda x: np.maximum(0, x)
    hidden1 = relu(X.dot(W1) + b1) # (N, H)
    scores = hidden1.dot(W2) + b2  # (N, C)
    '''
    #############################################################################
    #                              END OF YOUR CODE                             #
    #############################################################################
    
    # If the targets are not given then jump out, we're done
    if y is None:
      return scores

    # Compute the loss
    loss = None
    #############################################################################
    # TODO: Finish the forward pass, and compute the loss. This should include  #
    # both the data loss and L2 regularization for W1 and W2. Store the result  #
    # in the variable loss, which should be a scalar. Use the Softmax           #
    # classifier loss.                                                          #
    #############################################################################
    #''' 原始实现
    layer3 -= np.max(layer3, axis=1)[:, np.newaxis]
    rows = np.sum(np.exp(layer3), axis=1) # [Nx1]
    # 先计算每一行数据的交叉熵损失,然后除以数据样本总数取平均
    layer4 = np.sum(-layer3[range(N), y] + np.log(rows)) / N
    loss = layer4 + reg * (np.sum(W1 * W1) + np.sum(W2 * W2)) # R(W)
    #'''
    
    '''其它实现
    # 减去最大值,避免分数数值过大
    max_score = np.max(scores, axis=1)
    scores -= max_score[:, np.newaxis]

    row_exp_sum = np.sum(np.exp(scores), axis=1)
    probs = np.exp(scores) / row_exp_sum[:, np.newaxis] # NxC

    data_loss = np.mean(-np.log(probs[np.arange(N), y]))
    reg_loss = reg * (np.sum(W1 * W1) + np.sum(W2 * W2))

    loss = data_loss + reg_loss
    '''
    #############################################################################
    #                              END OF YOUR CODE                             #
    #############################################################################

    # Backward pass: compute gradients
    grads = {}
    #############################################################################
    # TODO: Compute the backward pass, computing the derivatives of the weights #
    # and biases. Store the results in the grads dictionary. For example,       #
    # grads['W1'] should store the gradient on W1, and be a matrix of same size #
    #############################################################################
    #''' 原始实现        
    # layer4(正确分类标记层)对layer3的导数,对交叉熵求one-hot编码的每条数据
    # 的导数,然后取平均,因为在计算layer4的时候除了N.
    dlayer3 = (np.exp(layer3).T / rows).T # NxC
    dlayer3[range(N), y] -= 1
    dlayer3 /= N
    
    # loss对layer2的导数,l3=w2xl2+b2,求l2的偏导数为w2,
    # dloss/dl2 = dloss/dl3 x dl3/dl2
    dlayer2 = np.dot(dlayer3, W2.T) # NxH
    
    # relu层求导,只对满足relu阀值限制的神经元的参数反馈参数变化,对变化本身不做relu操作!
    #dlayer1 = np.maximum(0,dlayer2) # NxH
    relu_mask = layer2 > 0
    dlayer1 = dlayer2 * relu_mask # 满足条件的保留,不满足为0
    
    # 求解梯度
    dW1 = np.dot(X.T, dlayer1) # DxH
    dW2 = np.dot(layer2.T, dlayer3) # HxC
    db1 = np.sum(dlayer1, axis=0) # H
    db2 = np.sum(dlayer3, axis=0) # C
    
    # 正则化处理
    dW1 += 2 * reg * W1
    dW2 += 2 * reg * W2
    #''' 
    
    '''其它实现方式
    # Ref: softmax.py for gradient computing of softmax function
    dscores = probs
    dscores[np.arange(N), y] -= 1
    dscores /= N

    dW2 = hidden1.T.dot(dscores)
    dW2 += 2 * reg * W2

    db2 = dscores.T.dot(np.ones((N, 1)))
    # np.squeeze: Remove single-dimensional entries from the shape of an array.
    db2 = np.squeeze(db2)

    dhidden1 = dscores.dot(W2.T)
    relu_mask = hidden1 > 0
    drelu = dhidden1 * relu_mask

    dW1 = X.T.dot(drelu)
    dW1 += 2 * reg * W1

    db1 = np.ones((1, N)).dot(drelu)
    db1 = np.squeeze(db1)
    '''
    
    # Store
    grads['W1'] = dW1
    grads['W2'] = dW2
    grads['b1'] = db1
    grads['b2'] = db2
    #############################################################################
    #                              END OF YOUR CODE                             #
    #############################################################################

    return loss, grads

  def train(self, X, y, X_val, y_val,
            learning_rate=1e-3, learning_rate_decay=0.95,
            reg=5e-6, num_iters=100,
            batch_size=200, verbose=False):
    """
    Train this neural network using stochastic gradient descent.

    Inputs:
    - X: A numpy array of shape (N, D) giving training data.
    - y: A numpy array f shape (N,) giving training labels; y[i] = c means that
      X[i] has label c, where 0 <= c < C.
    - X_val: A numpy array of shape (N_val, D) giving validation data.
    - y_val: A numpy array of shape (N_val,) giving validation labels.
    - learning_rate: Scalar giving learning rate for optimization.
    - learning_rate_decay: Scalar giving factor used to decay the learning rate
      after each epoch.
    - reg: Scalar giving regularization strength.
    - num_iters: Number of steps to take when optimizing.
    - batch_size: Number of training examples to use per step.
    - verbose: boolean; if true print progress during optimization.
    """
    num_train = X.shape[0]
    iterations_per_epoch = max(num_train / batch_size, 1)

    # Use SGD to optimize the parameters in self.model
    loss_history = []
    train_acc_history = []
    val_acc_history = []

    for it in range(num_iters):
      X_batch = None
      y_batch = None

      #########################################################################
      # TODO: Create a random minibatch of training data and labels, storing  #
      # them in X_batch and y_batch respectively.                             #
      #########################################################################
      indices = np.random.choice(num_train, batch_size)
      X_batch = X[indices]
      y_batch = y[indices]
      #########################################################################
      #                             END OF YOUR CODE                          #
      #########################################################################

      # Compute loss and gradients using the current minibatch
      loss, grads = self.loss(X_batch, y=y_batch, reg=reg)
      loss_history.append(loss)

      #########################################################################
      # TODO: Use the gradients in the grads dictionary to update the         #
      # parameters of the network (stored in the dictionary self.params)      #
      # using stochastic gradient descent. You'll need to use the gradients   #
      # stored in the grads dictionary defined above.                         #
      #########################################################################
      for variable in self.params:
            self.params[variable] -= learning_rate * grads[variable]
      #########################################################################
      #                             END OF YOUR CODE                          #
      #########################################################################

      if verbose and it % 100 == 0:
        print('iteration %d / %d: loss %f' % (it, num_iters, loss))

      # Every epoch, check train and val accuracy and decay learning rate.
      if it % iterations_per_epoch == 0:
        # Check accuracy
        train_acc = (self.predict(X_batch) == y_batch).mean()
        val_acc = (self.predict(X_val) == y_val).mean()
        train_acc_history.append(train_acc)
        val_acc_history.append(val_acc)

        # Decay learning rate
        learning_rate *= learning_rate_decay

    return {
      'loss_history': loss_history,
      'train_acc_history': train_acc_history,
      'val_acc_history': val_acc_history,
    }

  def predict(self, X):
    """
    Use the trained weights of this two-layer network to predict labels for
    data points. For each data point we predict scores for each of the C
    classes, and assign each data point to the class with the highest score.

    Inputs:
    - X: A numpy array of shape (N, D) giving N D-dimensional data points to
      classify.

    Returns:
    - y_pred: A numpy array of shape (N,) giving predicted labels for each of
      the elements of X. For all i, y_pred[i] = c means that X[i] is predicted
      to have class c, where 0 <= c < C.
    """
    y_pred = None

    ###########################################################################
    # TODO: Implement this function; it should be VERY simple!                #
    ###########################################################################
    X1 = np.maximum(X.dot(self.params['W1']) + self.params['b1'], 0)
    X2 = X1.dot(self.params['W2']) + self.params['b2']
    exp_X2 = np.exp(X2) # NxC
    scores = (exp_X2.T / np.sum(exp_X2, axis = 1)).T # NxC
    
    y_pred = np.argmax(scores, axis = 1) # Nx1
    # y_pred = np.argmax(self.loss(X), 1)
    ###########################################################################
    #                              END OF YOUR CODE                           #
    ###########################################################################

    return y_pred


