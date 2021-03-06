function GrayMethod()
%% 灰色关联分析实例
	clc, clear, close all;
	% Data_plot();
    gray_connect();
end

function Data_plot()
% 绘制基本数据图形
% 绘制城市居民消费价格指数CPI和城市食品零售价格随时间变化的曲线
	y = [102.4 102.8 103.1 102.9 103.3 103.5 103.6 104.4 105.1 104.6 104.9 104.9 105.4; % CPI数据
	     105.2 105.9 106.1 105.7 106.8 107.5 108.0 110.1 117.1 109.6 110.3 111.0 111.7]; % 食品数据
	figure(gcf);
	plot(1:13,y');
	grid on
	axis([0,14,90,120])
	legend('居民消费价格指数(以上年同期价格为100)','城市食品零售价格指数(上年同月=100)')
	gtext('资料来源：中国国家统计局网站')
end

function gray_connect()
    % CPI体系价格指数
    y = [102.4 102.8 103.1 102.9 103.3 103.5 103.6 104.4 105.1 104.6 104.9 104.9 105.4; % CPI
	     105.2 105.9 106.1 105.7 106.8 107.5 108.0 110.1 117.1 109.6 110.3 111.0 111.7; % 食品
         101.7 101.7 101.7 101.7 101.6 101.5 101.4 101.5 101.6 101.8 101.8 101.9 102.1; % 烟酒
         98.9 98.7 98.8 99.0 99.2 98.8 98.5 98.7 99.3 100.1 99.8 100.4 100.8; % 衣着
         99.3 99.5 99.7 100.0 100.2 100.4 100.4 100.5 100.7 101.2 101.4 101.4 101.9; % 家庭设备
         102.5 102.8 103.2 103.2 103.3 103.3 103.4 103.7 104.0 104.0 103.2 103.0 103.2; % 医疗保健
         100.0 100.0 100.1 99.7 99.3 99.4 99.3 99.5 99.3 99.3 99.9 99.7 100.1; % 交通通信
         100.3 100.4 100.6 100.9 101.1 101.2 101.2 100.9 100.6 100.7 101.0 100.3 100.5; % 娱乐教育
         100.3 104.5 105.0 105.0 104.8 104.4 104.3 104.9 105.8 106.0 106.8 106.1 106.6 % 居住
         ]; 
     y1 = mean(y'); % 求每个影响因子的均值
     y1 = y1';
     % 求均值像矩阵
     for i=1:9
         for j=1:13
             y2(i,j)=y(i,j)/y1(i); % 设该值为原矩阵值的均分值
         end
     end
     
     % 求差序列，被影响因子的均分值为被减数，需分析对该因子有关联影响的因子为减数
     % 故求出来是8个列的影响因子值
     for i=2:9
         for j=1:13
             y3(i-1,j)=abs(y2(i,j)-y2((i-1),j));
         end
     end
     
     % 求得差序列中的最大值b和最小值a
     a=1;b=0;
     for i=1:8
         for j=1:13
             if y3(i,j) <= a
                 a = y3(i,j);
             elseif y3(i,j) >= b
                 b = y3(i,j);
             end
         end
     end
     
     % 计算关联系数，其中分辨系数p取0.5，其作用在于提高关联系数间的差异显著性
     % 若p越小，则关联系数间差异越大，区分能力越强
     for i=1:8
         for j=1:13
             y4(i,j)=(a+0.5*b)/(y3(i,j)+0.5*b);
         end
     end
     
     % 计算灰色关联度
     y5 = sum(y4')/12
end