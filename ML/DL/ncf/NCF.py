# _*_ coding:utf8 _*_
import numpy as np
import pandas as pd
import tensorflow as tf

import sys
#import ncf.metrics
import metrics


class NCF(object):
    def __init__(self, embed_size, user_size, item_size, lr,
                 optim, initializer, loss_func, activation_func,
                 regularizer_rate, iterator, topk, dropout, is_training):
        """
        Important Arguments.
        embed_size: The final embedding size for users and items.
        optim: The optimization method chosen in this model.
        initializer: The initialization method.
        loss_func: Loss function, we choose the cross entropy.
        regularizer_rate: L2 is chosen, this represents the L2 rate.
        iterator: Input dataset.
        topk: For evaluation, computing the topk items.
        """

        self.embed_size = embed_size # 16
        self.user_size = user_size # 1508
        self.item_size = item_size # 2071
        self.lr = lr
        self.initializer = initializer
        self.loss_func = loss_func
        self.activation_func = activation_func
        self.regularizer_rate = regularizer_rate
        self.optim = optim
        self.topk = topk # 10
        self.dropout = dropout
        self.is_training = is_training
        self.iterator = iterator


    def get_data(self):
        sample = self.iterator.get_next() # 得到Dataset中的数据
        self.user = sample['user']
        self.item = sample['item']
        # 转换tensor为一个新类型
        self.label = tf.cast(sample['label'],tf.float32)

    def inference(self):
        # 设置参数初始化方式、损失函数、参数更新方式(优化器)
        """ Initialize important settings """
        self.regularizer = tf.contrib.layers.l2_regularizer(self.regularizer_rate)

        if self.initializer == 'Normal':
            self.initializer = tf.truncated_normal_initializer(stddev=0.01)
        elif self.initializer == 'Xavier_Normal':
            self.initializer = tf.contrib.layers.xavier_initializer()
        else:
            self.initializer = tf.glorot_uniform_initializer()

        if self.activation_func == 'ReLU':
            self.activation_func = tf.nn.relu
        elif self.activation_func == 'Leaky_ReLU':
            self.activation_func = tf.nn.leaky_relu
        elif self.activation_func == 'ELU':
            self.activation_func = tf.nn.elu

        if self.loss_func == 'cross_entropy':
            self.loss_func = tf.nn.sigmoid_cross_entropy_with_logits

        if self.optim == 'SGD':
            self.optim = tf.train.GradientDescentOptimizer(self.lr,name='SGD')
        elif self.optim == 'RMSProp':
            self.optim = tf.train.RMSPropOptimizer(self.lr, 
                                                   decay=0.9,
                                                   momentum=0.0, 
                                                   name='RMSProp')
        elif self.optim == 'Adam':
            self.optim = tf.train.AdamOptimizer(self.lr, name='Adam')


    def create_model(self):
        with tf.name_scope('input'):
            # [0,1,...,0]指示某个用户的one-hot编码矩阵,大小为 Nx1508
            # N为样本总数,训练集就是训练集总数,测试集就是测试集总数,1508是用户数
            self.user_onehot = tf.one_hot(self.user,self.user_size,name='user_onehot')
            # Nx2071,指示那个item被选中,2071为item的数量
            self.item_onehot = tf.one_hot(self.item,self.item_size,name='item_onehot')

        with tf.name_scope('embed'):
            # inputs: 输入数据,这里是大小为 Nx1508 的Tensor张量数据
            # units: 隐藏层神经元个数, 预置为16
            # 激活函数为Relu,用Xavier方法初始化参数,使用L2范数作为正则化参数的惩罚项
            # [Nx1508] x [1508x16] = Nx16
            self.user_embed_GMF = tf.layers.dense(inputs = self.user_onehot,
                                                  units = self.embed_size,
                                                  activation = self.activation_func,
                                                  kernel_initializer=self.initializer,
                                                  kernel_regularizer=self.regularizer,
                                                  name='user_embed_GMF')

            # [Nx2071] x [2071x16]= Nx16
            self.item_embed_GMF = tf.layers.dense(inputs=self.item_onehot,
                                                  units=self.embed_size,
                                                  activation=self.activation_func,
                                                  kernel_initializer=self.initializer,
                                                  kernel_regularizer=self.regularizer,
                                                  name='item_embed_GMF')
            # [Nx1508] x [1508x16] = Nx16
            self.user_embed_MLP = tf.layers.dense(inputs=self.user_onehot,
                                                  units=self.embed_size,
                                                  activation=self.activation_func,
                                                  kernel_initializer=self.initializer,
                                                  kernel_regularizer=self.regularizer,
                                                  name='user_embed_MLP')
            # [Nx2071] x [2071x16]= Nx16
            self.item_embed_MLP = tf.layers.dense(inputs=self.item_onehot,
                                                  units=self.embed_size,
                                                  activation=self.activation_func,
                                                  kernel_initializer=self.initializer,
                                                  kernel_regularizer=self.regularizer,
                                                  name='item_embed_MLP')


        with tf.name_scope("GMF"):
            # [Nx16] x [Nx16] = [Nx16] 逐元素相加,输出一个等shape的矩阵
            self.GMF = tf.multiply(self.user_embed_GMF, self.item_embed_GMF,name='GMF')

        # 多层感知器网络
        with tf.name_scope("MLP"):
            # 按列拼接两个Tensor张量,[Nx16]与[Nx16]按列拼接等于[Nx32]
            self.interaction = tf.concat([self.user_embed_MLP, self.item_embed_MLP],
                                         axis=-1, name='interaction')
            print(self.interaction.shape)

            # [Nx32] x [32x32] = [Nx32]
            self.layer1_MLP = tf.layers.dense(inputs=self.interaction,
                                              units=self.embed_size * 2,
                                              activation=self.activation_func,
                                              kernel_initializer=self.initializer,
                                              kernel_regularizer=self.regularizer,
                                              name='layer1_MLP')
            # 使用dropout方法优化神经元的激活
            self.layer1_MLP = tf.layers.dropout(self.layer1_MLP, rate=self.dropout)
            print(self.layer1_MLP.shape)

            # [Nx32] x [32x16] = [Nx16]
            self.layer2_MLP = tf.layers.dense(inputs=self.layer1_MLP,
                                              units=self.embed_size,
                                              activation=self.activation_func,
                                              kernel_initializer=self.initializer,
                                              kernel_regularizer=self.regularizer,
                                              name='layer2_MLP')
            
            self.layer2_MLP = tf.layers.dropout(self.layer2_MLP, rate=self.dropout)
            print(self.layer2_MLP.shape)

            # [Nx16] x [16x8] = [Nx8]
            self.layer3_MLP = tf.layers.dense(inputs=self.layer2_MLP,
                                              units=self.embed_size // 2,
                                              activation=self.activation_func,
                                              kernel_initializer=self.initializer,
                                              kernel_regularizer=self.regularizer,
                                              name='layer3_MLP')
            self.layer3_MLP = tf.layers.dropout(self.layer3_MLP, rate=self.dropout)
            print(self.layer3_MLP.shape)
        #得到预测值
        with tf.name_scope('concatenation'):
            # [Nx16] 按列拼接 [Nx8] = [Nx24]
            self.concatenation = tf.concat([self.GMF,self.layer3_MLP],
                                           axis=-1,name='concatenation')

            # [Nx24] x [24x1] = [Nx1]
            self.logits = tf.layers.dense(inputs= self.concatenation,
                                          units = 1,
                                          activation=None,
                                          kernel_initializer=self.initializer,
                                          kernel_regularizer=self.regularizer,
                                          name='predict')
            print(self.logits.shape)

            # 转化[Nx1]矩阵为1D数组,为(N,)
            self.logits_dense = tf.reshape(self.logits,[-1])
            print(self.logits_dense.shape)

        with tf.name_scope("loss"):
            self.loss = tf.reduce_mean(self.loss_func(
                labels=self.label, logits=self.logits_dense, name='loss'))

        with tf.name_scope("optimzation"):
            self.optimzer = self.optim.minimize(self.loss)


    def eval(self):
        with tf.name_scope("evaluation"):
            self.item_replica = self.item
            _, self.indice = tf.nn.top_k(tf.sigmoid(self.logits_dense), self.topk)


    def summary(self):
        """ Create summaries to write on tensorboard. """
        self.writer = tf.summary.FileWriter('./graphs/NCF', tf.get_default_graph())
        with tf.name_scope("summaries"):
            tf.summary.scalar('loss', self.loss)
            tf.summary.histogram('histogram loss', self.loss)
            self.summary_op = tf.summary.merge_all()




    def build(self):
        self.get_data()
        self.inference()
        self.create_model()
        self.eval()
        self.summary()
        self.saver = tf.train.Saver(tf.global_variables())

    def step(self, session, step):
        """ Train the model step by step. """
        if self.is_training:
            loss, optim, summaries = session.run(
                [self.loss, self.optimzer, self.summary_op])
            self.writer.add_summary(summaries, global_step=step)
        else:
            indice, item = session.run([self.indice, self.item_replica])
            prediction = np.take(item, indice)
            return prediction, item