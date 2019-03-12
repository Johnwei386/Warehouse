function AHPmethod()
% 层次分析法应用实例，用层次分析法为大学生就业决策出最优方案
% 假设一就业生经双方面谈，已有三家单位表示愿意录用该生，该生根据已有
% 信息建立了一个层次结构模型：
% 目标层 A            工作满意程度
% 准则层 B    B1   B2   B3   B4   B5   B6
%             研   发   待   同   地   单
%             究   展        事   理   位
%             课   前        情   位   名
%             题   途   遇   况   置   气
% 方案层 C          C1      C2      C3
%                 工作1    工作2   工作3
    clc,clear,close all;
    %% 计算准则层B对目标层A权值
    % 定义准则层B对目标层A的相互因子正互反矩阵
    A = [1,1,1,4,1,1/2
         1,1,2,4,1,1/2
         1,1/2,1,5,3,1/2
         1/4,1/4,1/5,1,1/3,1/3
         1,1,1/3,3,1,1
         2,2,2,3,3,1];
    [X,Y] = eig(A); % X由A的所有特征向量按列拼成，Y为由A的所有特征值组成的对角矩阵
    eigenvalue = diag(Y); % 提取Y矩阵的对角值
    lamda = eigenvalue(1); % 第1个非0最大的特征值在矩阵的第1号位置
    Ci1 = (lamda - 6)/5; % 计算一致性指标Ci
    % 计算一致性比例Cr，Cr=Ci/Ri,当Cr<0.10时，认为该判断矩阵的一致性是可接受的
    % 即不会出现太大的偏差(非一致性)，否则应对判断矩阵做适当修正
    % Ri的值可查表，6个因素的平均随机一致性指标为1.24
    Cr1 = Ci1/1.24; 
    W1 = X(:,1)/sum(X(:,1)) % 计算准则层最终的权值
    
    %% 方案层C对准则层B1的权值计算，B1:研究课题
    B1 = [1  1/4  1/2;4  1  3;2  1/3  1];
    [X,Y] = eig(B1);
    eigenvalue = diag(Y);
    lamda=eigenvalue(1);
    Ci21 = (lamda - 3)/2;
    Cr21 = Ci21/0.58; % Ri21在3个因素时的值，查表为0.58
    W21 = X(:,1)/sum(X(:,1)) % 取特征值为真且最大的那个特征向量来计算最终权值
    
    %% B2:发展前途
    B2 = [1  1/4  1/5;4  1  1/2;5  2  1];
    [X,Y] = eig(B2);
    eigenvalue = diag(Y);
    lamda=eigenvalue(1);
    Ci22 = (lamda - 3)/2;
    Cr22 = Ci22/0.58;
    W22 = X(:,1)/sum(X(:,1))
    
    %% B3:待遇
    B3 = [1  3  1/3;1/3  1  1/7;3  7  1];
    [X,Y] = eig(B3);
    eigenvalue = diag(Y);
    lamda=eigenvalue(1);
    Ci23 = (lamda - 3)/2;
    Cr23 = Ci23/0.58;
    W23 = X(:,1)/sum(X(:,1))
    
    %% B4:同事情况
    B4 = [1  1/3  5;3  1  7;1/5  1/7  1];
    [X,Y] = eig(B4);
    eigenvalue = diag(Y);
    lamda=eigenvalue(1);
    Ci24 = (lamda - 3)/2;
    Cr24 = Ci24/0.58;
    W24 = X(:,1)/sum(X(:,1))
    
    %% B5:地理位置
    B5 = [1  1  7;1  1  7;1/7  1/7  1];
    [X,Y] = eig(B5);
    eigenvalue = diag(Y);
    lamda=eigenvalue(1);
    Ci25 = (lamda - 3)/2;
    Cr25 = Ci25/0.58;
    W25 = X(:,1)/sum(X(:,1))
    
    %% B6:单位名气
    B6 = [1  7  9;1/7  1  1;1/9  1  1];
    [X,Y] = eig(B6);
    eigenvalue = diag(Y);
    lamda=eigenvalue(1);
    Ci26 = (lamda - 3)/2;
    Cr26 = Ci26/0.58;
    W26 = X(:,1)/sum(X(:,1))
    
    %% 总排序得到最终的权值
    W_sum = [W21,W22,W23,W24,W25,W26]*W1
    Ci = [Ci21,Ci22,Ci23,Ci24,Ci25,Ci26]
    Cr = Ci*W1/sum(0.58*W1) % 计算总的一致性比例
end