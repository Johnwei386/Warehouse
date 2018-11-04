# _*_ coding:utf8 _*_
import numpy as np
import pandas as pd
import tensorflow as tf
import os

DATA_DIR = 'data/ratings.txt'
DATA_PATH = 'cache/'
COLUMN_NAMES = ['user','item']

# 将item的id从0开始排，作为itemmap新的index
def re_index(s):
    i = 0
    s_map = {}
    for key in s:
        s_map[key] = i
        i += 1
    return s_map

def load_data():
    full_data = pd.read_csv(DATA_DIR,
                            sep=' ',
                            header=None,
                            names=COLUMN_NAMES,
                            usecols=[0,1],
                            dtype={0:np.int32,1:np.int32},
                            engine='python')
   
    full_data.user = full_data['user'] - 1
    # 排序加去重
    user_set = set(full_data['user'].unique())
    item_set = set(full_data['item'].unique())

    user_size = len(user_set) # 1508
    item_size = len(item_set) # 2071

    # item变为字典映射,便于索引
    item_map = re_index(item_set)

    item_list = []

    full_data['item'] = full_data['item'].map(lambda x:item_map[x])

    item_set = set(full_data.item.unique()) # item项-1

    # 用户已购买的items
    user_bought = {}
    for i in range(len(full_data)):
        u = full_data['user'][i]
        t = full_data['item'][i]
        if u not in user_bought:
            user_bought[u] = []
        user_bought[u].append(t)

    # 用户未购买的items
    user_negative = {}
    for key in user_bought:
        user_negative[key] = list(item_set - set(user_bought[key]))

    # 每个用户购买的item项目数量
    user_length = full_data.groupby('user').size().tolist()

    split_train_test = []

    # 每个用户购买的item前面的用于训练,最后一个用来测试验证
    # 只有一个item的用户,其item只用于测试,每个用户只有一个item用于验证
    # 因此,测试验证集只有1508条数据,即总的用户数条数据
    for i in range(len(user_set)):
        for _ in range(user_length[i] - 1):
            split_train_test.append('train')
        split_train_test.append('test')

    full_data['split'] = split_train_test

    # reset_index 重置data_frame的索引,将切分后的数据集重新整序标号
    train_data = full_data[full_data['split'] == 'train'].reset_index(drop=True)
    test_data = full_data[full_data['split'] == 'test'].reset_index(drop=True)
    # 删除用于切分数据的辅助列
    del train_data['split']
    del test_data['split']

    # 为何要将训练集的label全部设为1,而测试集则全部为item的编号？
    labels  = np.ones(len(train_data),dtype=np.int32)
    train_features = train_data
    train_labels = labels.tolist()
    test_features = test_data
    test_labels = test_data['item'].tolist()

    return ((train_features, train_labels),
            (test_features, test_labels),
            (user_size, item_size),
            (user_bought, user_negative))


def add_negative(features,user_negative,labels,numbers,is_training):
    feature_user,feature_item,labels_add,feature_dict = [],[],[],{}

    for i in range(len(features)):
        user = features['user'][i]
        item = features['item'][i]
        label = labels[i]
        feature_user.append(user)
        feature_item.append(item)
        labels_add.append(label)
        # 在用户user的每条正样本的后面追加负样本
        # 随机采样4个负样本,负样本即不属于该用户的item
        neg_samples = np.random.choice(user_negative[user],
                                       size=numbers,
                                       replace=False).tolist()
        if is_training:
            # 训练集将负样本添加到用户的样本集合里,并将label设为0
            for k in neg_samples:
                feature_user.append(user)
                feature_item.append(k)
                labels_add.append(0)

        else:
            # 测试集将负样本的label设为item的编号
            for k in neg_samples:
                feature_user.append(user)
                feature_item.append(k)
                labels_add.append(k)


    feature_dict['user'] = feature_user
    feature_dict['item'] = feature_item

    return feature_dict,labels_add



def dump_data(features,labels,user_negative,num_neg,is_training):
    if not os.path.exists(DATA_PATH):
        os.makedirs(DATA_PATH)

    features,labels = add_negative(features,user_negative,labels,num_neg,is_training)

    # 字典在创建时,会将所有key先进行排序,然后保存,索引时也是按这个排好序的key索引的
    # data_dict[keys]=(item, user, label), Aascii码首字有序.
    data_dict = dict([('user', features['user']),
                      ('item', features['item']), 
                      ('label', labels)])

    # 打印每个项的前12条数据
    for k in data_dict.keys():
        print(k)
        for i in range(12):
            print(data_dict[k][i]),
        print('\n')
    
    if is_training:
        # 二进制格式保存格式数据
        np.save(os.path.join(DATA_PATH, 'train_data.npy'), data_dict)
    else:
        np.save(os.path.join(DATA_PATH, 'test_data.npy'), data_dict)



def train_input_fn(features,labels,batch_size,user_negative,num_neg):
    """
        features: 训练特征数据集
        label: 对应训练集的正确分类标签,1维数组
        batch_size: 切分数据集用于训练的批次大小
        user_negative: 用户的负分类集合
        num_neg: 负分类集合的大小
    """
    data_path = os.path.join(DATA_PATH, 'train_data.npy')
    if not os.path.exists(data_path):
        # npy数据不存在即从源数据集创建
        dump_data(features, labels, user_negative, num_neg, True)

    # item()将ndarray数组数据转化为dict标量数据,格式转换
    data = np.load(data_path).item()
    # 打印每个项前12条数据
    for k in data.keys():
        print(k)
        for i in range(12):
            print(data[k][i]),
        print('\n')
    print("Loading training data finished!")
    # 转化data为tensorflow数据集Dataset,每条数据格式为 item:user:label
    # Dataset API同时支持从内存和硬盘的读取数据,通过生成迭代器逐个处理每条数据
    dataset = tf.data.Dataset.from_tensor_slices(data)
    # shuffle(n)洗牌n次,batch()将多个元素组合为一个batch
    # 分批次训练, SGD随机梯度下降使用批次数据不断迭代更新参数
    dataset = dataset.shuffle(100000).batch(batch_size)

    return dataset


def eval_input_fn(features, labels, user_negative, test_neg):
    """ Construct testing dataset. """
    data_path = os.path.join(DATA_PATH, 'test_data.npy')
    if not os.path.exists(data_path):
        dump_data(features, labels, user_negative, test_neg, False)

    data = np.load(data_path).item()
    print("Loading testing data finished!")
    dataset = tf.data.Dataset.from_tensor_slices(data)
    dataset = dataset.batch(test_neg + 1)

    return dataset

