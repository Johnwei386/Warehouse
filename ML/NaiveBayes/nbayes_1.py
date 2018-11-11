# _*_ coding:utf8 _*_

import numpy as np

# 项目案例1: 屏蔽社区留言板的侮辱性言论
def loadDataSet():
    """
    创建数据集
    :return: 单词列表postingList, 所属类别classVec
    """
    postingList = [['my', 'dog', 'has', 'flea', 'problems', 'help', 'please'],
                   ['maybe', 'not', 'take', 'him', 'to', 'dog', 'park', 'stupid'],
                   ['my', 'dalmation', 'is', 'so', 'cute', 'I', 'love', 'him'],
                   ['stop', 'posting', 'stupid', 'worthless', 'garbage'],
                   ['mr', 'licks', 'ate', 'my', 'steak', 'how', 'to', 'stop', 'him'],
                   ['quit', 'buying', 'worthless', 'dog', 'food', 'stupid']]
    classVec = [0, 1, 0, 1, 0, 1]  # 1 is abusive, 0 not
    return postingList, classVec


def createVocabList(dataSet):
    """
    获取所有单词的集合
    :param dataSet: 数据集
    :return: 所有单词的集合(即不含重复元素的单词列表)
    """
    vocabSet = set([])  # create empty set
    for document in dataSet:
        # 用于求两个集合的并集
        vocabSet = vocabSet | set(document)  # union of the two sets
    return list(vocabSet)


def setOfWords2Vec(vocabList, inputSet):
    """
    遍历查看该单词是否出现，出现该单词则将该单词置1
    :param vocabList: 所有单词集合列表
    :param inputSet: 输入数据集
    :return: 匹配列表[0,1,0,1...]，其中 1与0 表示词汇表中的单词是否出现在输入的数据集中
    """
    # 创建一个和词汇表等长的向量
    returnVec = np.zeros(len(vocabList))
    # 遍历文档中的所有单词，如果出现了词汇表中的单词，则将输出的文档向量中的对应值设为1
    # 不考虑词汇在文本中出现次数的影响,无论出现几次,都看作1次
    for word in inputSet:
        if word in vocabList:
            returnVec[vocabList.index(word)] = 1
    return returnVec


def trainNB_0(trainMatrix, trainCategory):
    """
    训练数据,不对概率分布值做log处理
    :param trainMatrix: 文件单词矩阵 [[1,0,1,1,1....],[...],...]
    :param trainCategory: 文件对应的类别[0,1,1,0....]，列表长度等于单词矩阵数，其中的1代表对应的文件是侮辱性文件，0代表不是侮辱性矩阵
    :return:
    """
    # 文件数
    numTrainDocs = len(trainMatrix)
    # 词库大小
    numWords = len(trainMatrix[0])
    # 侮辱文件出现的概率
    pAbusive = sum(trainCategory) / float(numTrainDocs)

    # 初始化正负词频向量
    p0Num = np.zeros(numWords)
    p1Num = np.zeros(numWords)

    # 正负词汇计数
    p0Denom = 0.0
    p1Denom = 0.0
    for i in range(numTrainDocs):
        if trainCategory[i] == 0:
            # 非侮辱性文件，正类
            # 累加当前文档的词汇计数到正词频向量
            p0Num += trainMatrix[i]
            # 累加当前文档词汇总量到正词汇计数总量
            p0Denom += sum(trainMatrix[i])
        else:
            # 侮辱性文件,负类
            # 累加当前文档到负词频向量
            p1Num += trainMatrix[i]
            # 累加当前文档词汇总量到负词汇计数总量
            p1Denom += sum(trainMatrix[i])

    # 正类概率分布矢量,按词汇在所有正类样本文档中出现的概率
    p0Vect = p0Num / p0Denom
    # 负类概率分布矢量
    p1Vect = p1Num / p1Denom

    return p0Vect, p1Vect, pAbusive


def trainNB_1(trainMatrix, trainCategory):
    """
    朴素贝叶斯: P(F|C) = P(F1|C)xP(F2|C,F1)xP(F3|C,F1,F2) -> P(F1|C)xP(F2|C)xP(F3|C)
    朴素贝叶斯的思想核心就是忽略复杂的关联性分析,将每个随机变量皆看做独立的.
    从文本中出现的所有词出发,词和它周围的词的关系被忽略,只关注每个词在每个文本是否出现,
    多少个文本出现了这个词,与所有文本词的总数相除,转化为一个概率分布,一个统计量.
    训练数据优化版本，加了一个平滑处理，拉普拉斯平滑
    :param trainMatrix: 文件单词矩阵
    :param trainCategory: 文件对应的类别
    :return:
    """
    # 文件数
    numTrainDocs = len(trainMatrix)
    # 词库大小
    numWords = len(trainMatrix[0])
    # 侮辱性文件的出现概率
    pAbusive = sum(trainCategory) / float(numTrainDocs)

    # 初始化正负词频向量,不初始化为0,拉氏平滑
    p0Num = np.ones(numWords)
    p1Num = np.ones(numWords)
    p0Denom = 2.0
    p1Denom = 2.0
    for i in range(numTrainDocs):
        if trainCategory[i] == 0:
            p0Num += trainMatrix[i]
            p0Denom += sum(trainMatrix[i])

        else:
            p1Num += trainMatrix[i]
            p1Denom += sum(trainMatrix[i])

    # 对原始分布概率值,取log值
    p0Vect = np.log(p0Num / p0Denom)
    p1Vect = np.log(p1Num / p1Denom)
    return p0Vect, p1Vect, pAbusive


def classifyNB(vec2Classify, p0Vec, p1Vec, pClass1):
    """
        log(P(C|F) = log(P(F|C) x P(C)/P(F))) = log(P(F|C)) + log(P(C)) - log(P(F))
    :param vec2Classify: 待测新文本的词向量,[0,1,1,1,1,...]
    :param p0Vec: 正类的词分布概率
    :param p1Vec: 负类的词分布概率
    :param pClass1: 侮辱性文件的出现概率
    :return: 类别: 0 or 1
    """
    # 预测正类概率,P(C|F) = log(P(F|C)) + log(P(C))
    p0 = sum(vec2Classify * p0Vec) + np.log(1.0 - pClass1)
    p1 = sum(vec2Classify * p1Vec) + np.log(pClass1)
    if p1 > p0:
        return 1
    else:
        return 0


def bagOfWords2VecMN(vocabList, inputSet):
    # 统计单词出现的次数
    returnVec = [0] * len(vocabList)
    for word in inputSet:
        if word in vocabList:
            returnVec[vocabList.index(word)] += 1
    return returnVec


def testingNB():
    """
    测试朴素贝叶斯算法
    """
    # 1. 加载数据集
    listOPosts, listClasses = loadDataSet()
    # 2. 获取所有单词的集合,创建词库
    myVocabList = createVocabList(listOPosts)
    # 3. 创建词向量,并拼成训练用数据向量集合
    trainMat = []
    for postinDoc in listOPosts:
        # 遍历文档集合
        # 将转换后的向量添加到训练数据集合
        trainMat.append(setOfWords2Vec(myVocabList, postinDoc))
    # 4. 训练数据
    p0V, p1V, pAb = trainNB_1(np.array(trainMat), np.array(listClasses))
    # 5. 测试数据
    testEntry = ['love', 'my', 'dalmation']
    thisDoc = np.array(setOfWords2Vec(myVocabList, testEntry))
    print testEntry, 'classified as: ', classifyNB(thisDoc, p0V, p1V, pAb)
    testEntry = ['stupid', 'garbage']
    thisDoc = np.array(setOfWords2Vec(myVocabList, testEntry))
    print testEntry, 'classified as: ', classifyNB(thisDoc, p0V, p1V, pAb)

if __name__ == "__main__":
    testingNB()
