clc, clear, close all;
%peaks返回一组(x,y,z)点矩阵，服从二元高斯分布的概率密度函数
[X, Y, Z]=peaks(16);
% gradient(Z, .5, .5)表示以Z为初始矩阵，求Z的梯度分布
% DX为水平梯度，为初始矩阵列差值，0.5表示原来除数因子从2变为0.5
% DY为垂直梯度变化，为初始矩阵行差值
[DX, DY]=gradient(Z, .5, .5);
contour(X, Y, Z, 10) % 绘制等位线图，线条数目控制在10条
hold on
quiver(X, Y, DX, DY) % 绘制场图，在(X, Y)处绘制向量，向量用箭头表示, DX为水平分量，DY为垂直分量
hold off