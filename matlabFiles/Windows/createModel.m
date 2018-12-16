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
% �������ݵ��˿���Ϣ,����������������Դ��ʹ�öȽ����������
    Range = 'D2:D51';
    AZp = achieveXlsData(filename, 'AZ', Range); % AZ�ݵĳ�ס�˿�
    AZp = cell2mat(AZp) * 1000; % ԭ���ݵ�λΪǧ��
    CAp = achieveXlsData(filename, 'CA', Range); % CA�ݵĳ�ס�˿�
    CAp = cell2mat(CAp) * 1000;
    NMp = achieveXlsData(filename, 'NM', Range); % NM�ݵĳ�ס�˿�
    NMp = cell2mat(NMp) * 1000;
    TXp = achieveXlsData(filename, 'TX', Range); % TX�ݵĳ�ס�˿�
    TXp = cell2mat(TXp) * 1000;
    % ���Ƴ�ס�˿ڱ䶯ͼ
    x = 1960:2009;
%     figure(4);
%     plot(x, AZp, 'b', x, CAp, 'g', x, NMp, 'c', x, TXp, 'r');
%     legend('AZ','CA','NM','TX');
    % ��������Դ�������仯����ͼ
%     figure(5);
%     plot(x, TEC(1,:), 'b', x, TEC(2,:), 'g', x, TEC(3,:), 'c', x, TEC(4,:), 'r');
%     legend('AZ','CA','NM','TX');
    % ����AZ�ݵ��˿�������Դ�����������ͼ
%     figure(6);
%     plot(AZp, TEC(1,:),'ro');
%     xlabel('Population'),ylabel('Energy Consumption');

    figure(7);
    plot(AZp, TEC(1,:),'ro');
    xlabel('Population'),ylabel('Energy Consumption');
    
%     [s1, s2]=meshgrid(x,AZp); % ��������
%     Gdata = griddata(x,AZp,TEC(1,:), s1, s2, 'v4');
%     mesh(s1, s2, Gdata);
end

function TEC=getTETCP()
% �õ��ܵ���Դ������
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
% ����ĳ���ݵ���Դʹ�ö�
    Range = 'D2:D51';
    TE = achieveXlsData(filename, 'TE', Range);
    TE = cell2mat(TE); % ĳ��������Դ������ֵ
    NU = achieveXlsData(filename, 'NU', Range);
    NU = cell2mat(NU); % ����
    NG = achieveXlsData(filename, 'NG', Range);
    NG = cell2mat(NG); % ��Ȼ��
    EM = achieveXlsData(filename, 'EM', Range);
    EM = cell2mat(EM); % ȼ���Ҵ�
    GE = achieveXlsData(filename, 'GE', Range);
    GE = cell2mat(GE); % ������
    HY = achieveXlsData(filename, 'HY', Range);
    HY = cell2mat(HY); % ˮ��
    SO = achieveXlsData(filename, 'SO', Range);
    SO = cell2mat(SO); % ̫����
    WY = achieveXlsData(filename, 'WY', Range);
    WY = cell2mat(WY); % ����
    WW = achieveXlsData(filename, 'WW', Range);
    WW = cell2mat(WW); % ������
    % �����������Դ������ֵ
    Pr = EM + GE + HY + SO + WY + WW;
    % ����������������Դ������ֵ
    Pc = Pr + NU + NG;
    Bu = NU ./ TE; % �������Ѷ�
    Bg = NG ./ TE; % ���������Ѷ�
    Br = Pr ./ TE; % ��������Դ���Ѷ�
    %Bcr = Pc ./ TE;
    % �����������Ӻ����������ʹ�ö�
    % Bcr = 0.1 * Bu + 0.1 * Bg + 0.8 * Br;
    Bcr = Br; % ���ؿ�������Դ�����Ѷ�
    % ���Bcrͼ
%     x = 1960:2009;
%     figure(1);
%     plot(x, Bcr);
%     % ������ܡ���Ȼ���Ϳ�������Դʹ�ö�ͼ
%     figure(2);
%     plot(x, Bu, 'b', x, Bg, 'g', x, Br, 'r');
%     legend('NU','NG','RE');
%     % ��������������Դ�ķ�չ����
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
% �ȽϿ������벻��������Դ������   
    Rdata = achieveXlsData(filename, 'Renewable', 'B1:B50'); % ��������Դ
    Udata = achieveXlsData(filename, 'UnRenewable', 'B1:B50'); % ����������Դ
    Rdata = cell2mat(Rdata);
    Udata = cell2mat(Udata);
    % ��ԭ����ȡ����
    Rdata = log(Rdata);
    Udata = log(Udata);
    % �����仯����ͼ
    x = 1960:2009;
    plot(x, Rdata, 'b', x, Udata, 'r');
    legend('Renewable Energy','Non-renewable energy');
    % ����һ��Ĳ�ֵ,�������ʵı仯���
%     for i=2:50
%         RiseR(i-1) = Rdata(i) - Rdata(i-1);
%         RiseU(i-1) = Udata(i) - Udata(i-1);
%     end
%     x = 1:49
%     plot(x, RiseR, 'b', x, RiseU, 'r');
end

function Data=achieveXlsData(filename, sheet, range)
% ��xls�ĵ��з�����������
    [~,~,Data] = xlsread(filename, sheet, range);
end

function plot_AZ_Pie(Oils, Coal, Gas, Nuclear, Electricy, Renew)
    OC = getEnegySum(Oils);
    CC = getEnegySum(Coal);
    GC = getEnegySum(Gas);
    NC = getEnegySum(Nuclear);
    EC = getEnegySum(Electricy);
    RC = getEnegySum(Renew);
    Omean = mean(convert2matrix(Oils)); % �õ���ʯ��Դ��50���ֵ
    Cmean = mean(convert2matrix(Coal));
    Gmean = convert2matrix(Gas);
    Nmean = mean(convert2matrix(Nuclear));
    Emean = mean(convert2matrix(Electricy));
    Rmean = mean(convert2matrix(Renew));
    y = [Emean;Omean;Cmean;Gmean;Nmean;Rmean];
    Egray = getGrayValue(y) % �������Ӱ�������������Դ���ܹ�����
    % ��Ϊ������Դ���ڶ�����Դ����������Դװ������
    Eper = 1-round(Egray,2); % ������Դ������Դ������Ӧ��ռ�еı���
    % ������Դռ��ͼ
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
    Omean = mean(convert2matrix(Oils)); % �õ���ʯ��Դ��50���ֵ
    Cmean = mean(convert2matrix(Coal));
    Gmean = mean(convert2matrix(Gas));
    Nmean = mean(convert2matrix(Nuclear));
    Emean = mean(convert2matrix(Electricy));
    Rmean = mean(convert2matrix(Renew));
    y = [Emean;Omean;Cmean;Gmean;Nmean;Rmean];
    Egray = getGrayValue(y) % �������Ӱ�������������Դ���ܹ�����
    % ��Ϊ������Դ���ڶ�����Դ����������Դװ������
    Eper = 1-round(Egray,2); % ������Դ������Դ������Ӧ��ռ�еı���
    % ������Դռ��ͼ
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
    Omean = mean(convert2matrix(Oils)); % �õ���ʯ��Դ��50���ֵ
    Cmean = mean(convert2matrix(Coal));
    Gmean = mean(convert2matrix(Gas));
    Nmean = mean(convert2matrix(Nuclear));
    Emean = mean(convert2matrix(Electricy));
    Rmean = mean(convert2matrix(Renew));
    y = [Emean;Omean;Cmean;Gmean;Nmean;Rmean];
    Egray = 0.6329; % ����NM�ݵĺ�������Ϊ0,�ɺ���,ֱ�Ӽ�����Ҷ�ֵ
    % ��Ϊ������Դ���ڶ�����Դ����������Դװ������
    Eper = 1-round(Egray,2); % ������Դ������Դ������Ӧ��ռ�еı���
    % ������Դռ��ͼ
    T = [OC CC GC Eper*EC RC];
    pie3(T,[0,1,1,1,1]);
    legend('Petroleum','Coal','Natural gas','Electricity','Renewable energy');
end

function S=getEnegySum(ndata)
    % ����1960-2009��50����Դ����������
    [m,n] = size(ndata);
    S = 0;
    for i=2:m
        S = S + cell2mat(ndata(i,n));
    end
end

function M=convert2matrix(ndata)
% ����ʼ��Դ����ת������50��Ϊ�����ľ���
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
% �������Դ���������صĻ�ɫ������
     y1 = mean(y'); % ��ÿ��Ӱ�����ӵľ�ֵ
     % ��ԭʼ������Ը������ӵľ�ֵ�����ִ���
     for i=1:6
         for j=1:50
             y2(i,j)=y(i,j)/y1(i); % ���ֵΪԭ����ֵ�ľ���ֵ
         end
     end
     
     % ������У��Ե�����ԴΪ�����Ƚ���
     for i=1:6
         for j=1:50
             y3(i,j)=abs(y2(i,j)-y2(1,j));
         end
     end
     
     % ��ò������е����ֵb����Сֵa
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
     
     % �������ϵ��,�ֱ�ϵ��pȡ0.5
     for i=1:6
         for j=1:50
             y4(i,j)=(a+0.5*b)/(y3(i,j)+0.5*b);
         end
     end
     
     % �����ɫ������
     G = sum(y4')/50
     G = mean(G(2:6));
end
