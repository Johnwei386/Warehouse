# _*_ coding:utf8 _*_

import numpy as np
import tensorflow as tf
from ncfmain import *

data = np.load('data/test_data.npy').item()
print(data['user'][:10])
dataset = tf.data.Dataset.from_tensor_slices(data)
dataset = dataset.shuffle(10000).batch(100)
user = tf.ones(name='user',shape=[None,],dtype=tf.int32)
item = tf.placeholder(name='item',shape=[None,],dtype=tf.int32)
iterator = tf.data.Iterator.from_structure(dataset.output_types,
                                           dataset.output_shapes,
                                           shared_name='user')

def getBatch():
    sample = iterator.get_next()
    print(sample)
    user = sample['user']
    item = sample['item']

    return user,item


iterator.get_next()
usersum = tf.reduce_mean(user,axis=-1)
itemsum = tf.reduce_mean(item,axis=-1)

with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())

    for i in range(2):
        sess.run(iterator.make_initializer(dataset))
        try:
            while True:
                print(sess.run([usersum,itemsum]))
        except tf.errors.OutOfRangeError:
            print("outOfRange")


def testShuffle():
    dataset = tf.data.Dataset.from_tensor_slices(
    {
        'a': np.array([1.0, 2.0, 3.0, 4.0, 5.0]),
        'b': np.random.uniform(size=(5, 2))
    })
 
    dataset = dataset.shuffle(100) # 洗牌多少次
    iterator = dataset.make_one_shot_iterator()
    one_element = iterator.get_next()
    with tf.Session() as sess:
        try:
            while True:
                print(sess.run(one_element))
        except tf.errors.OutOfRangeError:
            print("end!")

def testBatch():
    dataset = tf.data.Dataset.from_tensor_slices(
    {
        'item' : np.array([8, 6, 7, 9, 3]),
        'user' : np.array([1, 2, 3, 4, 5]),
        'label': np.array([1, 0, 1, 0, 0])
    })
 
    dataset = dataset.batch(2)# 将多个元素组合成batch
    iterator = dataset.make_one_shot_iterator()
    one_element = iterator.get_next()
    with tf.Session() as sess:
        try:
            while True:
                print(sess.run(one_element))
        except tf.errors.OutOfRangeError:
            print("end!")

# testBatch()
# testShuffle()
main()
