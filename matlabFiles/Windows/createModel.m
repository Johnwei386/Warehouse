function createModel()
    clc,clear,close all;
    warning off;
%     filename='Data\TxData.xlsx';
%     [~,~,Oils] = xlsread(filename,'Oils');
%     [~,~,Coal] = xlsread(filename,'Coal');
%     [~,~,Gas] = xlsread(filename,'Gas');
%     [~,~,Nuclear] = xlsread(filename,'Nuclear');
%     [~,~,Electricy] = xlsread(filename,'Electricy');
%     [~,~,Renew] = xlsread(filename,'Renewable');
%     plot_AZ_Pie(Oils, Coal, Gas, Nuclear, Electricy, Renew);
%     plot_Pie(Oils, Coal, Gas, Nuclear, Electricy, Renew);
%     plot_Nm_Pie(Oils, Coal, Gas, Nuclear, Electricy, Renew)
%     compareData('Data\AZ_Renew_Energy.xlsx');
%     compareData('Data\CA_Renew_Energy.xlsx');
%     compareData('Data\NM_Renew_Energy.xlsx');
%     compareData('Data\TX_Renew_Energy.xlsx');
%     AZbcr = caculateEnergyFitness('Data\AZData2.xlsx');
%     CAbcr = caculateEnergyFitness('Data\CAData2.xlsx');
%     NMbcr = caculateEnergyFitness('Data\NMData2.xlsx');
%     TXbcr = caculateEnergyFitness('Data\TXData2.xlsx');
%     Bcr = [AZbcr';CAbcr';NMbcr';TXbcr'];
%     x=1960:2009;
%     plot(x, Bcr(1,:), 'b', x, Bcr(2,:), 'g', x, Bcr(3,:), 'r', x, Bcr(4,:), 'c');
%     legend('AZ','CA','NM','TX')
    TEC = getTETCP(); % TEC = [AZ; CA; NM; TX]
    populationAnalysis('Data\Population.xlsx',TEC);
end

function populationAnalysis(filename, TEC)
% 分析各州的人口信息,并与可再生与清洁能源的使用度进行数据拟合
    Range = 'D2:D51';
    AZp = achieveXlsData(filename, 'AZ', Range); % AZ州的常住人口
    AZp = cell2mat(AZp) * 1000; % 原数据单位为千人
    CAp = achieveXlsData(filename, 'CA', Range); % CA州的常住人口
    CAp = cell2mat(CAp) * 1000;
    NMp = achieveXlsData(filename, 'NM', Range); % NM州的常住人口
    NMp = cell2mat(NMp) * 1000;
    TXp = achieveXlsData(filename, 'TX', Range); % TX州的常住人口
    TXp = cell2mat(TXp) * 1000;
    % 绘制常住人口变动图
    x = 1960:2009;
%     figure(4);
%     plot(x, AZp, 'b', x, CAp, 'g', x, NMp, 'c', x, TXp, 'r');
%     legend('AZ','CA','NM','TX');
    % 绘制总能源消耗量变化趋势图
%     figure(5);
%     plot(x, TEC(1,:), 'b', x, TEC(2,:), 'g', x, TEC(3,:), 'c', x, TEC(4,:), 'r');
%     legend('AZ','CA','NM','TX');
    % 绘制AZ州的人口与总能源消费量的拟合图
%     figure(6);
%     plot(AZp, TEC(1,:),'ro');
%     xlabel('Population'),ylabel('Energy Consumption');

    figure(7);
    plot(AZp, TEC(1,:),'ro');
    xlabel('Population'),ylabel('Energy Consumption');
    
%     [s1, s2]=meshgrid(x,AZp); % 产生网格
%     Gdata = griddata(x,AZp,TEC(1,:), s1, s2, 'v4');
%     mesh(s1, s2, Gdata);
end

function TEC=getTETCP()
% 得到总的能源消费量
    Range = 'D2:D51';
    TEaz = achieveXlsData('Data\AZData2.xlsx', 'TE', Range);
    TEaz = cell2mat(TEaz);
    TEca = achieveXlsData('Data\CAData2.xlsx', 'TE', Range);
    TEca = cell2mat(TEca);
    TEnm = achieveXlsData('Data\NMData2.xlsx', 'TE', Range);
    TEnm = cell2mat(TEnm);
    TEtx = achieveXlsData('Data\TXData2.xlsx', 'TE', Range);
    TEtx = cell2mat(TEtx);
    TEC = [TEaz';TEca';TEnm';TEtx'];
end

function Bcr=caculateEnergyFitness(filename)
% 计算某个州的能源使用度
    Range = 'D2:D51';
    TE = achieveXlsData(filename, 'TE', Range);
    TE = cell2mat(TE); % 某年所有能源的消耗值
    NU = achieveXlsData(filename, 'NU', Range);
    NU = cell2mat(NU); % 核能
    NG = achieveXlsData(filename, 'NG', Range);
    NG = cell2mat(NG); % 天然气
    EM = achieveXlsData(filename, 'EM', Range);
    EM = cell2mat(EM); % 燃料乙醇
    GE = achieveXlsData(filename, 'GE', Range);
    GE = cell2mat(GE); % 地热能
    HY = achieveXlsData(filename, 'HY', Range);
    HY = cell2mat(HY); % 水力
    SO = achieveXlsData(filename, 'SO', Range);
    SO = cell2mat(SO); % 太阳能
    WY = achieveXlsData(filename, 'WY', Range);
    WY = cell2mat(WY); % 风能
    WW = achieveXlsData(filename, 'WW', Range);
    WW = cell2mat(WW); % 生物能
    % 计算可再生能源的消耗值
    Pr = EM + GE + HY + SO + WY + WW;
    % 计算可再生与清洁能源的消耗值
    Pc = Pr + NU + NG;
    Bu = NU ./ TE; % 核能消费度
    Bg = NG ./ TE; % 天热气消费度
    Br = Pr ./ TE; % 可再生能源消费度
    %Bcr = Pc ./ TE;
    % 加入折算因子后计算后的消费使用度
    % Bcr = 0.1 * Bu + 0.1 * Bg + 0.8 * Br;
    Bcr = Br; % 返回可再生能源的消费度
    % 绘出Bcr图
%     x = 1960:2009;
%     figure(1);
%     plot(x, Bcr);
%     % 绘出核能、天然气和可再生能源使用度图
%     figure(2);
%     plot(x, Bu, 'b', x, Bg, 'g', x, Br, 'r');
%     legend('NU','NG','RE');
%     % 绘出六类可再生能源的发展趋势
%     figure(3);
%     Bem = EM ./ Pr;
%     Bge = GE ./ Pr;
%     Bhy = HY ./ Pr;
%     Bso = SO ./ Pr;
%     Bwy = WY ./ Pr;
%     Bww = WW ./ Pr;
%     plot(x, Bem, 'b', x, Bge, 'g', x, Bhy, 'r', x, Bso, 'm', x, Bwy, 'y', x, Bww, 'b:');
%     legend('EM','GE','HY','SO','WY','WW');
end

function compareData(filename)
% 比较可再生与不可再生资源的数据   
    Rdata = achieveXlsData(filename, 'Renewable', 'B1:B50'); % 可再生能源
    Udata = achieveXlsData(filename, 'UnRenewable', 'B1:B50'); % 不可再生能源
    Rdata = cell2mat(Rdata);
    Udata = cell2mat(Udata);
    % 对原数据取对数
    Rdata = log(Rdata);
    Udata = log(Udata);
    % 作出变化趋势图
    x = 1960:2009;
    plot(x, Rdata, 'b', x, Udata, 'r');
    legend('Renewable Energy','Non-renewable energy');
    % 与上一年的差值,看增长率的变化情况
%     for i=2:50
%         RiseR(i-1) = Rdata(i) - Rdata(i-1);
%         RiseU(i-1) = Udata(i) - Udata(i-1);
%     end
%     x = 1:49
%     plot(x, RiseR, 'b', x, RiseU, 'r');
end

function Data=achieveXlsData(filename, sheet, range)
% 从xls文档中返回所需数据
    [~,~,Data] = xlsread(filename, sheet, range);
end

function plot_AZ_Pie(Oils, Coal, Gas, Nuclear, Electricy, Renew)
    OC = getEnegySum(Oils);
    CC = getEnegySum(Coal);
    GC = getEnegySum(Gas);
    NC = getEnegySum(Nuclear);
    EC = getEnegySum(Electricy);
    RC = getEnegySum(Renew);
    Omean = mean(convert2matrix(Oils)); % 得到化石能源的50年均值
    Cmean = mean(convert2matrix(Coal));
    Gmean = convert2matrix(Gas);
    Nmean = mean(convert2matrix(Nuclear));
    Emean = mean(convert2matrix(Electricy));
    Rmean = mean(convert2matrix(Renew));
    y = [Emean;Omean;Cmean;Gmean;Nmean;Rmean];
    Egray = getGrayValue(y) % 求得其它影响因素与电力能源的总关联度
    % 因为电力能源属于二次能源，由其它能源装换而来
    Eper = 1-round(Egray,2); % 电力能源在总能源消耗中应该占有的比重
    % 绘制能源占比图
    T = [OC CC GC NC Eper*EC RC];
    pie3(T,[0,1,1,1,1,1]);
    legend('Petroleum','Coal','Natural gas','Nuclear power','Electricity','Renewable energy');
end

function plot_Pie(Oils, Coal, Gas, Nuclear, Electricy, Renew)
    OC = getEnegySum(Oils);
    CC = getEnegySum(Coal);
    GC = getEnegySum(Gas);
    NC = getEnegySum(Nuclear);
    EC = getEnegySum(Electricy);
    RC = getEnegySum(Renew);
    Omean = mean(convert2matrix(Oils)); % 得到化石能源的50年均值
    Cmean = mean(convert2matrix(Coal));
    Gmean = mean(convert2matrix(Gas));
    Nmean = mean(convert2matrix(Nuclear));
    Emean = mean(convert2matrix(Electricy));
    Rmean = mean(convert2matrix(Renew));
    y = [Emean;Omean;Cmean;Gmean;Nmean;Rmean];
    Egray = getGrayValue(y) % 求得其它影响因素与电力能源的总关联度
    % 因为电力能源属于二次能源，由其它能源装换而来
    Eper = 1-round(Egray,2); % 电力能源在总能源消耗中应该占有的比重
    % 绘制能源占比图
    T = [OC CC GC NC Eper*EC RC];
    pie3(T,[0,1,1,1,1,1]);
    legend('Petroleum','Coal','Natural gas','Nuclear power','Electricity','Renewable energy');
end

function plot_Nm_Pie(Oils, Coal, Gas, Nuclear, Electricy, Renew)
    OC = getEnegySum(Oils);
    CC = getEnegySum(Coal);
    GC = getEnegySum(Gas);
    NC = getEnegySum(Nuclear);
    EC = getEnegySum(Electricy);
    RC = getEnegySum(Renew);
    Omean = mean(convert2matrix(Oils)); % 得到化石能源的50年均值
    Cmean = mean(convert2matrix(Coal));
    Gmean = mean(convert2matrix(Gas));
    Nmean = mean(convert2matrix(Nuclear));
    Emean = mean(convert2matrix(Electricy));
    Rmean = mean(convert2matrix(Renew));
    y = [Emean;Omean;Cmean;Gmean;Nmean;Rmean];
    Egray = 0.6329; % 由于NM州的核能利用为0,可忽略,直接计算其灰度值
    % 因为电力能源属于二次能源，由其它能源装换而来
    Eper = 1-round(Egray,2); % 电力能源在总能源消耗中应该占有的比重
    % 绘制能源占比图
    T = [OC CC GC Eper*EC RC];
    pie3(T,[0,1,1,1,1]);
    legend('Petroleum','Coal','Natural gas','Electricity','Renewable energy');
end

function S=getEnegySum(ndata)
    % 计算1960-2009年50年能源的总消耗量
    [m,n] = size(ndata);
    S = 0;
    for i=2:m
        S = S + cell2mat(ndata(i,n));
    end
end

function M=convert2matrix(ndata)
% 将初始能源数据转换成以50年为列数的矩阵
    [m,n] = size(ndata);
    j=1;k=1;
    for i=2:m
        if k < 50
            M(j,k) =  cell2mat(ndata(i,n));
            k = k+1;
        else
            M(j,50) =  cell2mat(ndata(i,n));
            j = j+1;
            k = 1;
        end 
    end
end

function G=getGrayValue(y)
% 求电力能源对其它因素的灰色关联度
     y1 = mean(y'); % 求每个影响因子的均值
     % 对原始矩阵除以各个因子的均值作均分处理
     for i=1:6
         for j=1:50
             y2(i,j)=y(i,j)/y1(i); % 设该值为原矩阵值的均分值
         end
     end
     
     % 求差序列，以电力能源为减数比较列
     for i=1:6
         for j=1:50
             y3(i,j)=abs(y2(i,j)-y2(1,j));
         end
     end
     
     % 求得差序列中的最大值b和最小值a
     a=1;b=0;
     for i=1:6
         for j=1:50
             if y3(i,j) <= a
                 a = y3(i,j);
             elseif y3(i,j) >= b
                 b = y3(i,j);
             end
         end
     end
     
     % 计算关联系数,分辨系数p取0.5
     for i=1:6
         for j=1:50
             y4(i,j)=(a+0.5*b)/(y3(i,j)+0.5*b);
         end
     end
     
     % 计算灰色关联度
     G = sum(y4')/50
     G = mean(G(2:6));
end
