function populations()
    clc, clear, close all;
    global E F B K 
    %displayGraph_1(10, 10)
    %displayGraph_2()
    whaleCompete()
end

% 绘制当r1=1, r2=1, n1=100, n2=100, s1=0.5, s2=0.5时的函数图像
function displayGraph_1(x0, y0)
   % ode45用于常微分方程的数值求解，原理就是差分法，用指定步长离散化求解区域
   % ode45常用来解带时间分量的微分方程，即时间t(或x)的变化对应的方程的解为多少
   % 在给定方程下，将t(或x,一维变化)离散为一组点的集合，然后对这组离散点求方程的解
   % 方程的解向量Y可包含多列，每一列的定义由dy(n)在解方程函数中定义，n为列数
   % 但Y的行数与时间t的离散点集的数量一致
   % T返回一个时间点，Y返回该时间点下对应的值，T与Y皆为解向量
   % ode45(函数句柄， 参数t的初始值，参数y的初始值)
   [T, Y]=ode45(@zhongqun, [0 50], [x0 y0]);
   grid on % 打开网格
   axis equal % 同比例因子绘图，x和y是同比例变化的
   plot(T, Y(:,1), 'b-', T, Y(:,2), 'r-')
   title('r1=1, r2=1, n1=100, n2=100, s1=0.5, s2=0.5, x0=10, y0=10')
   legend('x(t)', 'y(t)', 'NorthWest');
end

% 绘制曲线向量解曲线，描绘y(t)关于x(t)的变化情况
function displayGraph_2()
    syms r1 r2 s1 s2 n1 n2
    r1=1;r2=1;s1=0.5;s2=2;n1=100;n2=100;
    Xmin=0;
    Xmax=140;
    Ymin=0;
    Ymax=100;
    n=50;
    % 计算切线矢量，linspace用来创建一个含n个元素的一维空间矢量
    [X Y]=meshgrid(linspace(Xmin, Xmax, n), linspace(Ymin, Ymax, n));
    Fx=r1.*X.*(1-X./n1-s1.*Y./n2);
    Fy=r2.*Y.*(1-s2.*X./n1-Y./n2);
    Fx=Fx./(sqrt(Fx.^2+Fy.^2+1));
    Fy=Fy./(sqrt(Fx.^2+Fy.^2+1));
    % 求解微分方程
    [T1 Y1]=ode45(@zhongqun, [0 50], [10 10]);
    % 绘制斜率场
    hold on
    grid on
    box on % 左边和下边加上边框
    axis([Xmin, Xmax, Ymin, Ymax]) % 设置坐标轴的范围
    quiver(X, Y, Fx, Fy, 0.5); % 绘制二维向量场, 0.5为向量的比例因子
    % 绘制解曲线
    plot(Y1(:, 1), Y1(:, 2), 'g', 'LineWidth', 2)
    xlabel('x(t)'), ylabel('y(t)')
    title('解曲线')
end

% 种群竞争微分方程模型求解
% 自定义种群函数
function dy=zhongqun(t, y)
    syms r1 r2 s1 s2 n1;
    % r,n赋予不同的参数时，有不同的解
    % 在此函数中通过改变r1,r2,n1,n2,s1,s2的值来达到相关要求
    r1=1;r2=1;
    n1=100;n2=100;
    s1=0.5;s2=2;
    dy=zeros(2, 1);
    dy(1)=r1*y(1)*(1-y(1)/n1-s1*y(2)/n2);
    dy(2)=r2*y(2)*(1-s2*y(1)/n1-y(2)/n2);
end

% 同一海域蓝鲸和长须鲸竞争生存求解
function dy=zhongqun_4(t, y)
    global E F B K % 声明全局变量，若要在函数中使用全局变量需声明
    dy=zeros(2, 1); % 定义返回值矩阵为一个列向量
    dy(1)=0.05*y(1)*(1-y(1)/150000-E(B)*y(2)/400000); % 蓝鲸在竞争状态下的数量变化程度
    dy(2)=0.08*y(2)*(1-F(K)*y(1)/150000-y(2)/400000); % 长须鲸在竞争状态下的数量变化程度
end

function whaleCompete()
    % ode45()的解向量Y最后一行的值，表示最后的时刻t得到的解
    % 它可表示得到的最终的变化的稳态值
    global E F B K
    E=0:0.1:2;
    E=E';
    F=0:0.1:2;
    F=F';
    S=zeros(140, 2); % 记录当蓝鲸和长须鲸的最后稳定状态都不为0时s1,s2的值
    H=zeros(250, 2); % 记录蓝鲸具有优势，最后稳态值为x=150000,y=0时s1,s2的值
    U=zeros(250, 2); % 记录长须鲸具有优势，最后稳态值为x=0,y=400000时s1,s2的值
    Num=zeros(441, 4); % 记录蓝鲸和长须鲸的最后稳态值
    B=1;K=1;a=1;b=1;c=1;d=1;
    while B<22
        % 穷列举法，将s1,s2在0:2上按0.1步长取点算值，得到蓝鲸和长须鲸的数量变化关系的网格近似
        K=1;
        while K<22
            [~, Y]=ode45(@zhongqun_4, [0 2000], [5000 70000]);
            [m, ~]=size(Y);
            Num(a, 1)=Y(m, 1); % 第a行第1列保存得到的蓝鲸数量变化的最终稳态值
            if Num(a, 1)<1
                Num(a, 1)=0; % 如果得到的蓝鲸数量变化的最终稳态值小于1，则置为0
            end
            Num(a, 2)=Y(m, 2); % 第a行第2列保存得到的长须鲸数量最终稳态值
            if Num(a, 2)<1
                Num(a, 2)=0; % 如果得到的长须鲸数量变化的最终稳态值小于1，则置为0
            end
            Num(a, 3)=E(B); % 第a行第3列保存当前状态下的s1值
            Num(a, 4)=F(K); % 第a行第4列保存当前状态下的s2值
            if ((Y(1)-1>0)&(Y(2)-1>0))==1
                % 蓝鲸和长须鲸的最后稳定状态都不为0
                S(b, 1)=E(B); % 第1列为s1值
                S(b, 2)=F(K); % 第2列为s2值
                b=b+1;
            end
            if (Y(2)-1)<0
                % 长须鲸的最终稳定状态为0，蓝鲸达到最大数量
                H(c, 1)=E(B);
                H(c, 2)=F(K);
                c=c+1;
            end
            if (Y(1)-1)<0
                % 蓝鲸的最终稳定状态为0，长须鲸达到最大数量
                U(d, 1)=E(B);
                U(d, 2)=F(K);
                d=d+1;
            end
            a=a+1;
            K=K+1;
        end
        B=B+1;
    end
    [s1, s2]=meshgrid(Num(:,3), Num(:,4)); % 产生网格
    LANJING=griddata(Num(:,3), Num(:,4), Num(:,1), s1, s2, 'v4'); % 拟合蓝鲸的数量变化函数
    CHANGXUJING=griddata(Num(:,3), Num(:,4), Num(:,2), s1, s2, 'v4'); % 拟合长须鲸的数量变化函数
    figure(1);
    mesh(s1, s2, LANJING);
    title('s1和s2改变时，蓝鲸的数量变化图像');
    figure(2);
    mesh(s1, s2, CHANGXUJING);
    title('s1和s2改变时，长须鲸的数量变化图像');
end