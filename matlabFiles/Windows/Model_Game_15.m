function Model_Game_15()
%% 使用遗传算法求解2018年研究生数学建模比赛F题
    clc, clear, close all;
    warning off; % 关掉警告信息
    % 导入需要处理的数据
    filename = 'Data\flights2gate.xlsx';
    [~,~,flights] = xlsread(filename, 'flights');
    [~,~,gate] = xlsread(filename, 'gate');
    [~,~,tickets] = xlsread(filename, 'tickets');
    [fs,~] = size(flights);
    [gs,~] = size(gate);
    [ts,~] = size(tickets);
    flights = flights(2:fs, :);
    gate = gate(2:gs, :);
    tickets = tickets(2:ts, :);
    
    testChrom = [63, 22, 63, 39, 69, 44, 62, 53, 59, 66, 42,  2, 16, 33, 51, 46, 36, 18, 57, 39, 64, 24, 35, 2,...
                 66, 24, 56, 69, 58, 47, 70, 36, 12, 66, 57, 62, 43, 43, 46, 31, 54, 37, 24, 31, 33, 19, 26, 23,...
                 16,  6, 49, 21, 48, 31, 56, 47, 44, 18, 69,  3,  2, 49, 47, 36, 37,  5, 50, 68, 22, 70, 62, 29,...
                 53, 18, 54, 66, 52, 28, 40, 31, 52, 48, 61, 27, 24, 17, 60, 70, 27, 63, 13, 11, 70, 60, 58, 8,...
                 35, 63, 68, 56, 66, 46, 61, 13, 36, 31,  9, 65, 48, 46, 15, 30, 56, 50, 12, 15, 27,  2, 31, 68,...
                 31, 61, 13, 33, 34, 57, 40, 48, 58,  7, 55, 52, 27, 67, 18, 60, 41, 56, 10, 22, 62, 65, 24, 8,...
                 41, 57, 12, 11, 50, 19, 62, 46, 40, 38, 23, 37, 37, 15, 52, 15,  1, 21, 63, 64, 13, 46, 15, 19,...
                 46, 21, 51, 46,  3, 64,  3,  1, 17, 46, 12, 44, 16, 31,  1, 38, 61, 46, 60, 34, 70, 66, 39, 12,...
                 31, 10,  3, 32, 56, 43, 23, 22,  4,  4, 31, 38, 31,  2, 18, 64, 59, 51, 40, 43, 36, 59, 67, 29,...
                 26,  1, 25, 32, 54, 20, 41, 13, 68, 51, 66, 43, 36, 42,  6,  5, 18,  6, 68, 46, 20, 37,  7, 60,...
                 41, 10, 20, 23, 64, 53, 23, 15, 51, 50, 63, 56, 45, 36, 37, 28, 32, 60, 11, 21, 47, 55, 57, 32,...
                 58, 39, 14, 64, 61, 32, 14,  3, 60, 14,  1,  8, 25, 22, 42, 24, 69,  9, 23, 37,  9, 67, 54,  6,...
                 6,  26, 26, 13, 33,  9,  7, 58, 40, 12, 18, 38, 34, 42, 49]; % 给定一条测试数据
    %fitChrom = reAllocate(testChrom, flights, gate);
    %[y,failPasser]=fitness_2(testChrom, flights, gate, tickets)
    genetic(flights, gate, tickets);
    
end

function y=fitness_1(code, fsize, gsize)
%% 适应度函数1，求解问题1
    gtsize = gsize + 1; % 临时机位
    [~,gcount] = fgAllocate(code, fsize, gtsize);
    y = 0;
    for i=1:gtsize
       % 统计被占用登机口的数量(包括临时机位)
       if gcount(i) > 0
           y = y + 1;
       end
    end
end

function [y,failPasser]=fitness_2(chrom, flights, gate, tickets)
%% 适应度函数2， 求解问题2
    [fsize,~] = size(flights);
    [gsize,~] = size(gate);
    [tsize,~] = size(tickets);
    theta = calcuCost(chrom, flights, gate); % 航班换乘代价矩阵
    gtsize = gsize + 1; % 临时机位
    failPasser = zeros(1,tsize);
    [~,gcount] = fgAllocate(chrom, fsize, gtsize);
    cost = 0; % 总最小流程时间代价
    y = 0;
    
    % 统计被占用登机口的数量(包括临时机位)
    for i=1:gtsize      
       if gcount(i) > 0
           y = y + 1;
       end
    end
    
    % 代价值计算只考虑可以中转的旅客
    findex = 1;
    for j=1:tsize
       numPeople = cell2mat(tickets(j, 3)); % 乘客数
       ia = cell2mat(tickets(j, 4)); % 到达航班
       id = cell2mat(tickets(j, 6)); % 出发航班
       if theta(ia, id) == inf
           % 中转失败的旅客，不计入代价值计算
           failPasser(findex) = j;
           findex = findex + 1;
           continue;
       end
       cost = cost + numPeople * theta(ia, id);
    end    
    y = y + cost;
end

function genetic(flights, gate, tickets)
%% 使用遗传算法求解航班分配问题
% flights       input: 航班转场数据
% gate          input: 登机口数据
    %% 参数初始化
    popsize = 10; % 种群规模
    [chromLen,~] = size(flights); % 染色体大小
    [gateSize,~]= size(gate); % 固定登机口数量
    pc = 0.9; % 交叉概率
    pm = 0.05; % 变异概率
    maxgen = 1; % 进化次数
    
    %% 生成初始化种群
    geneMax = gateSize + 2; % 基因的最大取值，考虑临时机位(编号70)和向下取整
    bound = ones(chromLen, 2);
    bound(:,2) = bound(:,2) * geneMax;
    GApop = zeros(popsize, chromLen); % 初始种群
    fitness = zeros(1, popsize); % 适应度集合
    for i=1:popsize
        % 随机产生一条染色体
        GApop(i,:) = code(chromLen, bound);
        % 计算该条染色体对应的适应度值
        % fitness(i) = fitness_1(GApop(i,:), chromLen, gateSize); % 问题1适应值
        [fitness(i),~] = fitness_2(GApop(i,:), flights, gate, tickets);
    end
    
    %% 迭代寻优
    for i=1:maxgen
        % 父代选择，种群更新
        GApop = Select(GApop, fitness, popsize);
        % 交叉操作
        GApop = Cross(pc, chromLen, GApop, popsize, bound);
        % 变异操作
        GApop = Mutation(pm, chromLen, GApop, popsize, [i maxgen], bound);

        for j=1:popsize
            % 更新适应度值
            j
            if ~checkFeasible(GApop(j,:), flights, gate)
               % 染色体不可行，更新染色体使其满足约束
               [GApop(j,:), ~, ~] = reAllocate(GApop(j,:), flights, gate);
            end
            [fitness(j),~] = fitness_2(GApop(j,:), flights, gate, tickets);
        end
    end
    %% 寻找最好的染色体
    [bestfitness, bestindex] = min(fitness); % 返回矩阵中的最小值及其相应索引位置        
    [bestChrom, tempGFlist, temPlace] = reAllocate(GApop(bestindex,:), flights, gate);
    [~,failPasser] = fitness_2(bestChrom, flights, gate, tickets);
    plotFigure_1(failPasser, tickets);
    bestfitness
    tempGFlist(:,1:24)
    temPlace
    bestChrom
end

function plotFigure_1(failPasser, tickets)
%% 画换乘失败的旅客数量和比率
    [tsize,~] = size(tickets);
    
    failCount = 0;
    for i=1:tsize
        if failPasser(i) ~= 0
            failCount = failCount + cell2mat(tickets(failPasser(i),3));
        else
            break;
        end
    end
    
    passerCount = 0;
    for j=1:tsize
       passerCount =  passerCount + cell2mat(tickets(j,3));
    end
    failCount
    passerCount
    %figure(1);
    %x = [failCount (passerCount - failCount)/passerCount];
    %explode = [0 1];
    %pie(x,explode);
end

function costMatrix = calcuCost(chrom, flights, gate)
%% 计算流程时间的代价矩阵
    [fsize,~] = size(flights);
    [gsize,~] = size(gate);
    gtsize = gsize + 1; % 临时停机位
    costMatrix = inf * ones(fsize, fsize);
    
    for i=1:fsize
       if chrom(i) == gtsize
           continue; % 停在临时停机位的航班，代价无穷
       end
       t1 = cell2mat(gate(chrom(i),2)); % 终端厅类型
       arrive = cell2mat(flights(i,6)); % 到达类型
       for j=1:fsize
           if chrom(j) == gtsize
               continue;
           end
           t2 = cell2mat(gate(chrom(j),2));
           depart = cell2mat(flights(j,6)); % 出发类型
           costMatrix(i,j) = score(arrive, depart, t1, t2);
       end
    end
end

function s=score(arrive, depart, termin1, termin2)
%% 对中转航班的中转代价进行打分，即流程时间
    % 最短流程时间代价表
    cost = [15, 20, 35, 40;
            20, 15, 40, 35;
            35, 40, 20, 30;
            40, 45, 30, 20];

    ir = 1; % 行索引    
    if arrive == 0
        % 国内到达
        if termin1 == 'T'
            % 航站楼T
            ir = 1;
        end
        if termin1 == 'S'
            % 卫星厅S
            ir = 2;
        end
    else
       % 国际到达
       if termin1 == 'T'
           ir = 3;
       end
       if termin1 == 'S'
           ir = 4;
       end
    end
            
    ic = 1; % 列索引
    if depart == 0
        % 国内出发
        if termin2 == 'T'
            % 航站楼T
            ic = 1;
        end
        if termin2 == 'S'
            % 卫星厅S
            ic = 2;
        end
    else
       % 国际出发
       if termin2 == 'T'
           ic = 3;
       end
       if termin2 == 'S'
           ic = 4;
       end
    end
    s = cost(ir, ic);
end

function isCheck=checkFeasible(chrom, flights, gate)
%% 检查染色体代表的分配方案是否可行
    [fsize,~] = size(flights);
    [gsize,~] = size(gate);
    gtsize = gsize + 1; % 临时航班
    isAvil = isAvailable(chrom, flights, gate);
    [fglist,~] = fgAllocate(chrom, fsize, gtsize);
    isSpan = timeSpan(fglist, flights);
    isCheck = isAvil && isSpan;
end

function isViable=singleCheck(flights, gate, curFlight, numGate, priv, next)
%% 对分配到登机口的航班检验其可行性
    % 对航班和登机口进行基本类型匹配
    u = cell2mat(flights(priv, 7)); % 航班飞机型号
    v = cell2mat(gate(numGate, 3)); % 登机口飞机型号
    e = cell2mat(flights(priv, 6)); % 航班到达类型
    o = cell2mat(gate(numGate, 4)); % 登机口到达类型
    p = cell2mat(flights(priv, 11)); % 航班出发类型
    q = cell2mat(gate(numGate, 5)); % 登机口出发类型
    isViable = indicator(0, u, v) && indicator(1, e, o) && indicator(1, p, q);
    
    if next ~= 0
        % 当前处理的航班不是该登机口的最后一架航班
        d1 = cell2mat(flights(priv, 9)); % 前一架飞机的起飞时间
        a1 = cell2mat(flights(next, 4)); % 后一架飞机的到达时间
        isViable = isViable && ((a1-d1) >= 45);
    end

    if curFlight(numGate) ~= 0
        % 在当前航班之前还有一架航班
        d2 = cell2mat(flights(curFlight(numGate), 9)); % 前一架飞机的起飞时间
        a2 = cell2mat(flights(priv, 4)); % 当前处理的这架飞机的到达时间 
        isViable = isViable && ((a2-d2) >= 45);
    end
end

function [fitChrom,tempGFlist,temPlace] = reAllocate(chrom, flights, gate)
%% 重分配函数，更新染色体使其满足约束限制
    [fsize,~] = size(flights);
    [gsize,~] = size(gate);
    gtsize = gsize + 1; % 总的登机口数目(包括临时机位)
    [fglist,~] = fgAllocate(chrom, fsize, gtsize);
    temPlace = zeros(1, fsize); % 暂存空间，存放临时放置的航班
    tempGFlist = zeros(gsize, fsize); % 保存重组后的登机口-航班队列    
    curFlight = zeros(1, gsize);
    fitChrom = zeros(1,fsize);
    
    parkIndex = 1; % 临时机位队列中最后一架飞机之后的空闲机位索引
    for i=1:(fsize-1)
       % 保存现存已知的临时机位上的飞机
       temPlace(i) = fglist(gtsize, i);
       if fglist(gtsize, i) == 0
          % 初始染色体未分配飞机给临时机位,第一位就是空闲位
          break;
       end
       if fglist(gtsize,i+1) == 0
          % 当前临时机位停放队列的最后一架飞机后的第一个空闲位置
          parkIndex = i+1;
          break;
       end
    end
    
    % 移动不可行的航班到临时机位
    for i=1:gsize
        for j=1:(fsize - 1)
           if fglist(i,j) == 0
               continue;
           end          
           % i登机口的j号航班是否可用
           isViable = singleCheck(flights, gate, curFlight, i, fglist(i,j), fglist(i,j+1));
           if isViable
               % 保存i号登机口最新验证的满足约束的航班
               curFlight(i) = fglist(i,j);
           else
              % 将j航班移动到临时机位 
              temPlace(parkIndex) = fglist(i,j);
              fglist(i,j) = 0; % 清除当前登机口的不可行航班
              parkIndex = parkIndex + 1; % 指向下一个空闲机位
           end
        end
    end
    %curFlight
    %temPlace
    %fglist(:,1:20)
    % 重组已获得的可行的登机口-航班队列
    for i=1:gsize
        index = 1;
        for j=1:fsize
            if fglist(i,j) ~= 0
                tempGFlist(i,index) = fglist(i,j);
                index = index + 1;
            end
        end
    end
    %parkIndex
    %tempGFlist(:, 1:20)
    
    %temPlace(1:20)
    % 从临时机位分配航班到登机口，得到一个可行的分配方案
    for i=1:(parkIndex - 1)
       flag1 = false;
       for g=1:gsize
           for k=1:fsize
               if k == 1
                   % 登机口的第一架航班，需要特殊处理
                   if tempGFlist(g,k) == 0
                       % 登机口还未被使用
                       isViable = singleCheck(flights, gate, zeros(1, gsize), g, temPlace(i), 0);
                       if isViable
                           tempGFlist(g,k) = temPlace(i);                 
                           curFlight(g) = temPlace(i);
                           temPlace(i) = 0;
                           flag1 = true; % 该航班已被分配，不用再分，切到下一个需要分配的航班
                       end
                       break; % 属性不匹配，该登机口不可用于此航班
                   end
               else
                   if tempGFlist(g,k) == 0
                       isViable = singleCheck(flights, gate, curFlight, g, temPlace(i), 0);
                       if isViable
                           tempGFlist(g,k) = temPlace(i);
                           curFlight(g) = temPlace(i);
                           temPlace(i) = 0;
                           flag1 = true;
                       end
                       break;
                   end
               end              
           end
           if flag1
               break;
           end
       end
    end   
    %tempGFlist(:, 1:20)
    %temPlace

    % 生成更新后的染色体，这里写入固定登机口更新后的航班分配
    for i=1:gsize
        for j=1:fsize
            if tempGFlist(i,j) ~= 0
                fitChrom(tempGFlist(i,j)) =  i;
            end
        end
    end
    
    % 临时机位的更新后的分配
    for i=1:fsize
        if temPlace(i) ~= 0
            fitChrom(temPlace(i)) = gtsize; % 固定登机口的下标索引
        end
    end
end

function ret=Select(individuals, fitness, sizepop)
%% 父代选择,对每一代种群中的染色体进行选择,以进行后面的交叉和变异
% individuals   input: 种群信息
% fitness       input: 适应度
% sizepop       input: 种群规模
% ret           return: 经过选择后的种群   
    fitness = 1./(fitness); % 将原来的适应值取倒数
    sumfitness = sum(fitness); % 对新得到的所有适应值求和
    sumf = fitness./sumfitness; % 求得适应值在所有适应值中所占的比重值
    index = [];
    for i=1:sizepop
        % 类转盘算法，转种群的总数次转盘
        pick = rand; % 获取一个随机数
        while pick == 0
            pick = rand;
        end
        for j=1:sizepop
            % 基于一个随机数和适应值在转盘的比例的差来挑选父代
            pick = pick - sumf(j);
            if pick < 0
                index = [index j];
                break; % 匹配到一个j即退出该循环
            end
        end
    end
    individuals = individuals(index,:);
    ret = floor(individuals);
end

function ret=Cross(pcross, lenchrom, chrom, sizepop, bound)
%% 本函数完成交叉操作
% pcross    input: 交叉概率
% lenchrom  input: 染色体的长度
% chrom     input: 染色体群
% sizepop   input: 种群规模
% ret       return: 交叉后的染色体
    for i=1:sizepop
        % 随机选择两个染色体进行交叉
        pick = rand(1,2);
        while prod(pick) == 0
            % prod()产生一行元素，若输入的是多行元素，则它处理每一列，然后产生一行元素
            % 这里将产生一个值，在输入的两个随机值的基础上
            % 一行元素数目的多少由输入矩阵的列数决定
            pick = rand(1,2);
        end
        index = ceil(pick .* sizepop); % ceil向上取整
        % 交叉概率决定是否进行交叉操作
        pick = rand;
        while pick == 0
            pick = rand;
        end
        if pick > pcross
            % 本次循环不进行交叉操作
            continue;
        end
        flag = 0;
        while flag == 0
           % 随机选择交叉位置
           pick = rand;
           while pick == 0
               pick = rand;
           end
           % 随机选择进行交叉的位置，即选择第几个变量进行交叉
           % 两个染色体交叉的位置相同
           pos = ceil(pick .* sum(lenchrom));
           pick = rand; % 交叉开始
           v1 = chrom(index(1),pos);
           v2 = chrom(index(2),pos);
           chrom(index(1),pos) = pick*v2 + (1-pick)*v1;
           chrom(index(2),pos) = pick*v1+(1-pick)*v2; % 交叉结束
           flag1 = testFeasible(bound,chrom(index(1),:)); % 检验染色体1的可行性
           flag2 = testFeasible(bound,chrom(index(2),:)); % 检验染色体2的可行性
           if (flag1 * flag2) == 0
               flag=0; % 两个染色体有一个不可行时，再次进行交叉操作
           else
               flag=1; % 交叉是可行的，结束交叉操作
           end
        end
    end
    ret = floor(chrom); % 返回交叉后的染色体
end

function ret=Mutation(pmutation, lenchrom, chrom, sizepop, pop, bound)
%% 本函数完成变异操作
% pmutation     input: 变异概率
% lenchrom      input: 染色体长度
% chrom         input: 染色体群
% sizepop       input: 种群规模
% pop           input: 当前种群的进化代数和最大的进化代数信息
% ret           return: 变异后的染色体
    for i=1:sizepop
       % 随机选择一个染色体进行变异
       pick = rand;
       while pick == 0
           pick = rand;
       end
       index = ceil(pick * sizepop);
       % 变异概率决定该轮循环是否进行变异
       pick = rand;
       if pick > pmutation
           continue;
       end
       flag = 0;
       while flag == 0
          % 变异位置
          pick = rand;
          while pick == 0
              pick = rand;
          end
          pos = ceil(pick * sum(lenchrom)); % 随机选择了染色体变异的位置，即选择了第pos个变量进行变异
          v = chrom(i,pos);
          v1 = v - bound(pos,1);
          v2 = bound(pos,2) - v;
          pick = rand; % 变异开始
          if pick > 0.5
              delta = v2 * (1-pick^((1-pop(1)/pop(2))^2));
              chrom(i,pos) = v + delta;
          else
              delta = v1 * (1-pick^((1-pop(1)/pop(2))^2));
              chrom(i, pos) = v - delta;
          end % 变异结束
          flag = testFeasible(bound, chrom(i,:)); % 检验染色体的可行性，可行退出变异循环
       end
    end
    ret = floor(chrom);
end

function chrom=code(chromLen, bound)
%% 将变量编码成染色体，用于随机初始化一个种群
% lenchrom      input: 染色体长度
% bound         input: 基因的取值范围
% chrom           return: 染色体的编码值   
    flag=0;
    while flag == 0
        pick = rand(1, chromLen); % 生成随机数
        chrom = bound(:,1)'+(bound(:,2)-bound(:,1))' .* pick;
        chrom = floor(chrom); % 向下取整
        flag = testFeasible(bound, chrom); % 检验染色体的可行性
    end
end

function flag = testFeasible(bound, chrom)
%% 检验染色体的可行性
% bound         input: 基因的取值范围
% chrom          return: 染色体的编码值    
    flag = 1;
    [n,~] = size(chrom);
    for i = 1:n
        % 判断新得到的染色体每个元素值是否超过了边界
        if (chrom(i) < bound(i,1)) || (chrom(i) > bound(i,2))
            flag = 0; % 该染色体不可用，重新获取新的染色体值
        end
    end
end

function flag=indicator(type, a, b)
%% 指示函数
% type        input: 需要处理的指示函数的类型
% a           input: 需要匹配的航班类型
% b           input: 需要匹配的登机口类型
% flag        return: 类型匹配返回1
    if type == 1
       % 匹配航班与登机口的到达和出发类型
       if b == 2
           % 登机口可起飞所有类型
           flag = true;
       elseif a == b
           % 登机口起飞类型与航班相同
           flag = true;
       else
           flag = false;
       end
    else
        % 匹配航班和登机口的机型
        if a == b
            flag = true;
        else
            flag = false;
        end
    end
end

function isAvil=isAvailable(chrom, flights, gate)
%% 该分配方案是否可行
    [fsize,~] = size(flights);
    flag = true;
    for i=1:fsize
        if chrom(i) == 70
            % 分配到临时机位的飞机必定符合类型要求
            continue
        end
        u = cell2mat(flights(i, 7)); % 航班飞机型号
        v = cell2mat(gate(chrom(i), 3)); % 登机口飞机型号
        e = cell2mat(flights(i, 6)); % 航班到达类型
        o = cell2mat(gate(chrom(i), 4)); % 登机口到达类型
        p = cell2mat(flights(i, 11)); % 航班出发类型
        q = cell2mat(gate(chrom(i), 5)); % 登机口出发类型
        flag = (indicator(0, u, v) && indicator(1, e, o) && indicator(1, p, q)) && flag;
    end
    isAvil = flag;
end

function isSpan=timeSpan(fglist, flights)
%% 登机口航班时间间隔是否满足要求
% fglist      input:登机口和临时机位班次信息
% flights     input:航班转场数据
% isSpan      return:某个分配方案的时间间隔是否满足要求
    [gtsize, fsize] = size(fglist);
    isSpan = true;
    flag1 = false; % 设置跳出循环标志位
    gsize = gtsize - 1; % 不考虑临时机位
    for i=1:gsize
        for j=1:(fsize - 1)
            if (fglist(i,j+1) == 0) || (fglist(i,j) == 0)
                % 空闲登机口和最后一架航班不考虑时间间隔
                continue;
            end
            d = cell2mat(flights(fglist(i,j), 9)); % 前一架飞机的起飞时间
            a = cell2mat(flights(fglist(i,j+1), 4)); % 后一架飞机的到达时间
            if (a-d) < 45
                % 该分配方案不满足间隔约束
                flag1 = true;
                isSpan = false;
                break;
            end
        end      
        if flag1
           % 分配方案不满足约束
           break;
        end
    end
end

function [fglist, fgcount]=fgAllocate(code, fsize, gtsize)
%% 将染色体按登机口统计某个登机口的航班数量和班次
% code         input: 染色体表示一次航班分配的方案
% fsize        input: 航班总数
% gtsize       input: 登机口和临时机位总数
% fglist       return: 按登机口分配航班(包括临时机位)
% fgcount      return: 登机口和临时机位航班总数
    fgcount = zeros(1, gtsize); 
    fglist = zeros(gtsize, fsize);
    index = ones(1,gtsize); % 实时索引分配给登机口的航班班次
    for i=1:fsize
        fglist(code(i),index(code(i))) = i;
        fgcount(code(i)) = fgcount(code(i)) + 1;
        index(code(i)) = index(code(i)) + 1;
    end        
end