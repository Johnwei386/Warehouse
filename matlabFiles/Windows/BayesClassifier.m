function BayesClassifier()
% 贝叶斯分类器的原理是基于贝叶斯理论，设有c个不同分类w1,w2,...,wc
% x为待分类的目标，x可看作结果,wi为x发生的原因,i属于(1,c)，由贝叶斯概率
% P(wi|x)=(P(x|wi)P(wi))/P(x), P(x)=\sum\limits_{i=1}^{c}P(x|wi)P(wi)
% 对分类x到一个具体的wi而言，就是是P(wi|x)最大的那个分类wi
% 将上式转化得到: P(wi|x)P(x)=P(x|wi)P(wi),由P(x)为概率，概率永远为正，且在
% 分类固定时，对某个具体的x而言，它可视为一个常量，所以求分类概率最大转变为求
% 概率P(x|wi)P(wi)最大的一个优化类问题。
% 在实际操作中，P(x|wi)可视为服从高斯概率分布因子为(x-m)的概率函数，其中，
% m为wi这个分类的期望矢量，P(wi)可视为等概率的，则此时可将贝叶斯分类器等效为欧式距离分类器
% 使用欧氏距离分类器来实际给x进行分类操作
    clc,clear,close all;
    warning off;
    feature jit off; % 加速代码执行
    % Gauss_test_1();
    % Gauss_test_2();
    % Classifier_example_1();
    Gauss_test_3();
end

function Gauss_test_1()
% 给出高斯概率分布函数N(m,S),计算关于x1,x2的概率值
    m=[0.0 0.1]';
    S=[1,0;1,1];
    x1=[0.12 0.012]';
    x2=[0.2 -0.3]';
    pg1 = comp_gauss_dens_val(m,S,x1) % 高斯概率密度分布函数计算
    pg2 = comp_gauss_dens_val(m,S,x2)
end

function Gauss_test_2()
% 基于高斯概率分布的简单贝叶斯分类器实例
% 数据隶属w1和w2两个类别，分别满足概率密度分布N(m1,S1)和N(m2,S2)
% 设P(w1)=P(w2)=0.5,求待分类的x属于w1还是w2类
    P1=0.5; P2=0.5;
    m1=[0.1 1.1]';
    m2=[1.3 0.2]';
    S=eye(2); % 生成二阶单位阵
    x=[1.5 1.5]';
    p1=P1*comp_gauss_dens_val(m1,S,x)
    p2=P2*comp_gauss_dens_val(m2,S,x)
end

function Gauss_test_3()
% 在许多实际问题中，往往不知道数据服从什么统计分布，此时需要采用最大似然估计法
% 进行参数估计，假设概率密度函数已知，通常设其服从高斯概率密度分布，此时由此出发
% 来估计均值和协方差矩阵。
   m = [1 -1];
   S = [1.1 0.740630;0.740630 0.87];
   rng; % 随机产生数据集
   % 随机产生100个服从高斯分布N(m,S)的2维特征向量作为样本
   X = mvnrnd(m,S,100)';
   % 最大似然估计，进行均值和协方差估计
   [m_hat, S_hat]=Gaussian_ML_estimate(X)
end

function Classifier_example_1()
% 一个三维空间，分类数为2，分别为w1和w2，均服从高斯分布
% 对应的期望向量为m1和m2，协方差矩阵为S，需将x识别到具体的分类
% 分别使用欧式距离分类器和马氏距离分类器实现之
    % 初始化数据
    x = [0.34 0.25 0.34]';
    m1 = [0 0 0]';
    m2 = [1.2 1.2 1.2]';
    m = [m1 m2];
    % 欧式距离分类器
    z1 = Euclidean_classifier(m,x)
    S = [1.1 0.063 0.063;
         0.063 0.74 0.063;
         0.063 0.063 0.74]; % 初始化协方差矩阵
     % 马氏距离分类器
     z2 = Mahalanobis_classifier(m,S,x) 
end

function z=Euclidean_classifier(m,X)
% 实现欧式距离分类器
% 输入：
%    m: 列向量，均值向量，每一列表示待分类数据的均值向量
%    X: 每一列表示待分类的数据
% 输出：
%    z: 输出属于哪一类的标签
    [~,c] = size(m);
    [~,N] = size(X);
    for i=1:N
        for j=1:c
            de(j) = sqrt((X(:,i)-m(:,j))'*(X(:,i)-m(:,j))); % 计算欧式距离
        end
        [num,z(i)]=min(de);
    end
end

function z=Mahalanobis_classifier(m,S,X)
% 实现马氏距离分类器
% 输入：
%    m: 列向量，均值向量，每一列表示待分类数据的均值向量
%    S: 方差，协方差矩阵
%    X: 每一列表示待分类的数据
% 输出：
%    z: 输出属于哪一类的标签
    [~,c] = size(m);
    [~,N] = size(X);
    for i=1;N
        for j=1:c
            dm(j)=sqrt((X(:,i)-m(:,j))'*inv(S)*(X(:,i)-m(:,j))); % 马氏距离计算
        end
        [num, z(i)]=min(dm); % 返回最小距离
    end
end

function z=comp_gauss_dens_val(m,S,x)
% m: 期望向量
% S: 协方差矩阵
% x: 需要求解的列向量
% 返回 z: 在特定点x位置处的高斯概率密度估计值
    [L,~]=size(m); % m为列向量，则L就是m的元素个数
    % 多维度高斯概率密度分布函数
    z = (1/((2*pi)^(L/2)*det(S)^0.5))*exp(-0.5*(x-m)'*inv(S)*(x-m));
end

function [m_hat, S_hat]=Gaussian_ML_estimate(X)
% 实现服从正态分布的一组数据相关参数的最大似然估计
% 输入：
%    X: 列向量
% 输出：
%    m_hat: 均值估计，样本均值估计真实的期望
%    S_hat: 协方差估计，估计真实的方差
    [L,N]=size(X);
    m_hat = (1/N)*sum(X')';
    S_hat = zeros(L);
    for k=1:N
        S_hat=S_hat+(X(:,k)-m_hat)*(X(:,k)-m_hat)';
    end
    S_hat = (1/N)*S_hat;
end