#!/usr/bin/env python
# -*- coding:utf8 -*-

import re
import matplotlib.pyplot as plt

''' 使用文本注解绘制决策树形图, Matplotlib提供了一个注解工具annotations,可以在数据图形上添加文本注释 '''

def getNumLeafs(myTree):
    ''' 获取叶子节点的数目 '''
    numLeafs = 0
    firstStr = list(myTree.keys())[0]
    secondDict = myTree[firstStr]
    for key in secondDict.keys():
        if type(secondDict[key]).__name__ == 'dict':
            numLeafs += getNumLeafs(secondDict[key])
        else:
            numLeafs += 1
    return numLeafs

def getTreeDepth(myTree):
    ''' 获取树的层数 '''
    maxDepth = 0
    firstStr = list(myTree.keys())[0]
    secondDict = myTree[firstStr]
    for key in secondDict.keys():
        if type(secondDict[key]).__name__ == 'dict':
            thisDepth = 1 + getTreeDepth(secondDict[key])
        else:
            thisDepth = 1
        if thisDepth > maxDepth:
            maxDepth = thisDepth
    return maxDepth

def retrieveTree(i):
    ''' 返回测试案例 '''
    listOfTrees = [{'no surfacing': {0: 'no', 1: {'flippers': {0: 'no', 1: 'yes'}}}},
                   {'a_no \n surfacing': {0: 'b_no', 1: {'a_flippers': {0:{'b_head': {0:'c_no', 1: 'c_yes'}}, 1:'b_no'}}}}
                  ]
    return listOfTrees[i]

# 设置显示样式: boxstyle为文本框的类型, sawtooth是锯齿形, square是矩形, round4是圆角矩形, fc是边框背景颜色, ec是边框线的颜色(b蓝色,k黑色,r红色)
#             arrowstyle是箭头样式
decisionNode = dict(boxstyle="sawtooth", fc="w", ec='k')
leafNode = dict(boxstyle="round4", fc="w")
aNodeStyle = dict(boxstyle="square", fc="w", ec='k') # a系统机构树
bNodeStyle = dict(boxstyle="square", fc="w", ec='b') # b系统机构树
diffNodeStyle = dict(boxstyle="square", fc="w", ec='r') # a和b系统存在交集的节点,机构编号相同或机构名称相似
arrow_args = dict(arrowstyle="<-", relpos=(0,0))

def plotNode(nodeTxt, centerPt, parentPt, nodeType):
    ''' 绘制节点  
        input:
            nodeTxt:  节点文本
            centerPt: 子节点
            parentPt: 父节点
            nodeType: 节点样式
    '''
    createPlot.ax1.annotate(nodeTxt, xy=parentPt,  xycoords='axes fraction',  
                            xytext=centerPt, textcoords='axes fraction',
                            va="center", ha="center", bbox=nodeType, arrowprops=arrow_args)
        
def plotMidText(cntrPt, parentPt, txtString):
    ''' 使用plotMidText函数,计算父节点和子节点的中间位置,并在此处添加简单的文本标签信息,即绘制中间的箭头线中间的数字编号 '''
    xMid = (parentPt[0]-cntrPt[0])/2.0 + cntrPt[0]  # 计算标注位置
    yMid = (parentPt[1]-cntrPt[1])/2.0 + cntrPt[1]
    createPlot.ax1.text(xMid, yMid, txtString, va="center", ha="center", rotation=30, color='r')

def calculateNodeStyle(nodeText):
    ''' 计算节点的显示样式 '''
    p = re.compile(r'^([abc])_(.*)', flags=re.S)
    m = p.match(nodeText)
    if m:
        s = m.group(1)
        text = m.group(2)
        # print(text)
        if s=='a':
            return text,aNodeStyle
        elif s=='b':
            return text,bNodeStyle
        elif s=='c':
            return text,diffNodeStyle
    return nodeText,leafNode # 默认返回叶子节点的样式
    

def plotTree(myTree, parentPt, nodeTxt):
    ''' 绘制决策树 '''
    numLeafs = getNumLeafs(myTree)
    depth = getTreeDepth(myTree)
    firstStr = list(myTree.keys())[0]                                                      # 找到第一个元素，根节点
    cntrPt = (plotTree.xOff + (1.0 + float(numLeafs))/2.0/plotTree.totalW, plotTree.yOff)  # 节点位置
    
    # plotMidText(cntrPt, parentPt, nodeTxt)                       # 标记子节点属性值
    showText1,style1 = calculateNodeStyle(firstStr)
    # plotNode(firstStr, cntrPt, parentPt, decisionNode)
    plotNode(showText1, cntrPt, parentPt, style1)
    secondDict = myTree[firstStr]                                  # 获取节点下的内容
    plotTree.yOff = plotTree.yOff - 1.0/plotTree.totalD            # 减少 y 偏移，树是自顶向下画的
    for key in secondDict.keys():                                  # 键值：0、1
        if type(secondDict[key]).__name__ == 'dict':               # 判断是 dict 还是 value
            plotTree(secondDict[key], cntrPt, str(key))            # 递归调用
        else:
            plotTree.xOff = plotTree.xOff + 1.0/plotTree.totalW    # 更新 x 值
            showText2,style2 = calculateNodeStyle(secondDict[key])
            plotNode(showText2, (plotTree.xOff, plotTree.yOff), cntrPt, style2)
            # plotNode(secondDict[key], (plotTree.xOff, plotTree.yOff), cntrPt, leafNode)
            # plotMidText((plotTree.xOff, plotTree.yOff), cntrPt, str(key))
    plotTree.yOff = plotTree.yOff + 1.0/plotTree.totalD

def createPlot(inTree):
    fig = plt.figure(1, facecolor='white') # 绘制背景图,背景颜色为白色,1为图像的编号
    fig.clf() # 清除所有轴
    axprps = dict(xticks=[], yticks=[])
    createPlot.ax1 = plt.subplot(111, frameon=False, **axprps)  # 定义绘图区,全局为一张图
    plotTree.totalW = float(getNumLeafs(inTree))                # 存储树的宽度
    plotTree.totalD = float(getTreeDepth(inTree))               # 存储树的深度
    # 使用了这两个全局变量追踪已经绘制的节点位置，以及放置下一个节点的恰当位置
    plotTree.xOff = -0.5/plotTree.totalW
    plotTree.yOff = 1.0
    plotTree(inTree, (0.5,1.0), ' ')
    plt.show()


if __name__ == '__main__':
    pass
    myTree = retrieveTree(1)
    createPlot(myTree)
    # plt.annotate('test \n abc', xy=(0.5,0.5),  xycoords='axes fraction',  
    #                         xytext=(0.5,0.5), textcoords='axes fraction',
    #                         va="center", ha="center",bbox=leafNode, arrowprops=arrow_args)
    # plt.show()


    