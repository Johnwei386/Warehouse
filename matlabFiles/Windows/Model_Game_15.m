function Model_Game_15()
%% ʹ���Ŵ��㷨���2018���о�����ѧ��ģ����F��
    clc, clear, close all;
    warning off; % �ص�������Ϣ
    % ������Ҫ���������
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
                 6,  26, 26, 13, 33,  9,  7, 58, 40, 12, 18, 38, 34, 42, 49]; % ����һ����������
    %fitChrom = reAllocate(testChrom, flights, gate);
    %[y,failPasser]=fitness_2(testChrom, flights, gate, tickets)
    genetic(flights, gate, tickets);
    
end

function y=fitness_1(code, fsize, gsize)
%% ��Ӧ�Ⱥ���1���������1
    gtsize = gsize + 1; % ��ʱ��λ
    [~,gcount] = fgAllocate(code, fsize, gtsize);
    y = 0;
    for i=1:gtsize
       % ͳ�Ʊ�ռ�õǻ��ڵ�����(������ʱ��λ)
       if gcount(i) > 0
           y = y + 1;
       end
    end
end

function [y,failPasser]=fitness_2(chrom, flights, gate, tickets)
%% ��Ӧ�Ⱥ���2�� �������2
    [fsize,~] = size(flights);
    [gsize,~] = size(gate);
    [tsize,~] = size(tickets);
    theta = calcuCost(chrom, flights, gate); % ���໻�˴��۾���
    gtsize = gsize + 1; % ��ʱ��λ
    failPasser = zeros(1,tsize);
    [~,gcount] = fgAllocate(chrom, fsize, gtsize);
    cost = 0; % ����С����ʱ�����
    y = 0;
    
    % ͳ�Ʊ�ռ�õǻ��ڵ�����(������ʱ��λ)
    for i=1:gtsize      
       if gcount(i) > 0
           y = y + 1;
       end
    end
    
    % ����ֵ����ֻ���ǿ�����ת���ÿ�
    findex = 1;
    for j=1:tsize
       numPeople = cell2mat(tickets(j, 3)); % �˿���
       ia = cell2mat(tickets(j, 4)); % ���ﺽ��
       id = cell2mat(tickets(j, 6)); % ��������
       if theta(ia, id) == inf
           % ��תʧ�ܵ��ÿͣ����������ֵ����
           failPasser(findex) = j;
           findex = findex + 1;
           continue;
       end
       cost = cost + numPeople * theta(ia, id);
    end    
    y = y + cost;
end

function genetic(flights, gate, tickets)
%% ʹ���Ŵ��㷨��⺽���������
% flights       input: ����ת������
% gate          input: �ǻ�������
    %% ������ʼ��
    popsize = 10; % ��Ⱥ��ģ
    [chromLen,~] = size(flights); % Ⱦɫ���С
    [gateSize,~]= size(gate); % �̶��ǻ�������
    pc = 0.9; % �������
    pm = 0.05; % �������
    maxgen = 1; % ��������
    
    %% ���ɳ�ʼ����Ⱥ
    geneMax = gateSize + 2; % ��������ȡֵ��������ʱ��λ(���70)������ȡ��
    bound = ones(chromLen, 2);
    bound(:,2) = bound(:,2) * geneMax;
    GApop = zeros(popsize, chromLen); % ��ʼ��Ⱥ
    fitness = zeros(1, popsize); % ��Ӧ�ȼ���
    for i=1:popsize
        % �������һ��Ⱦɫ��
        GApop(i,:) = code(chromLen, bound);
        % �������Ⱦɫ���Ӧ����Ӧ��ֵ
        % fitness(i) = fitness_1(GApop(i,:), chromLen, gateSize); % ����1��Ӧֵ
        [fitness(i),~] = fitness_2(GApop(i,:), flights, gate, tickets);
    end
    
    %% ����Ѱ��
    for i=1:maxgen
        % ����ѡ����Ⱥ����
        GApop = Select(GApop, fitness, popsize);
        % �������
        GApop = Cross(pc, chromLen, GApop, popsize, bound);
        % �������
        GApop = Mutation(pm, chromLen, GApop, popsize, [i maxgen], bound);

        for j=1:popsize
            % ������Ӧ��ֵ
            j
            if ~checkFeasible(GApop(j,:), flights, gate)
               % Ⱦɫ�岻���У�����Ⱦɫ��ʹ������Լ��
               [GApop(j,:), ~, ~] = reAllocate(GApop(j,:), flights, gate);
            end
            [fitness(j),~] = fitness_2(GApop(j,:), flights, gate, tickets);
        end
    end
    %% Ѱ����õ�Ⱦɫ��
    [bestfitness, bestindex] = min(fitness); % ���ؾ����е���Сֵ������Ӧ����λ��        
    [bestChrom, tempGFlist, temPlace] = reAllocate(GApop(bestindex,:), flights, gate);
    [~,failPasser] = fitness_2(bestChrom, flights, gate, tickets);
    plotFigure_1(failPasser, tickets);
    bestfitness
    tempGFlist(:,1:24)
    temPlace
    bestChrom
end

function plotFigure_1(failPasser, tickets)
%% ������ʧ�ܵ��ÿ������ͱ���
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
%% ��������ʱ��Ĵ��۾���
    [fsize,~] = size(flights);
    [gsize,~] = size(gate);
    gtsize = gsize + 1; % ��ʱͣ��λ
    costMatrix = inf * ones(fsize, fsize);
    
    for i=1:fsize
       if chrom(i) == gtsize
           continue; % ͣ����ʱͣ��λ�ĺ��࣬��������
       end
       t1 = cell2mat(gate(chrom(i),2)); % �ն�������
       arrive = cell2mat(flights(i,6)); % ��������
       for j=1:fsize
           if chrom(j) == gtsize
               continue;
           end
           t2 = cell2mat(gate(chrom(j),2));
           depart = cell2mat(flights(j,6)); % ��������
           costMatrix(i,j) = score(arrive, depart, t1, t2);
       end
    end
end

function s=score(arrive, depart, termin1, termin2)
%% ����ת�������ת���۽��д�֣�������ʱ��
    % �������ʱ����۱�
    cost = [15, 20, 35, 40;
            20, 15, 40, 35;
            35, 40, 20, 30;
            40, 45, 30, 20];

    ir = 1; % ������    
    if arrive == 0
        % ���ڵ���
        if termin1 == 'T'
            % ��վ¥T
            ir = 1;
        end
        if termin1 == 'S'
            % ������S
            ir = 2;
        end
    else
       % ���ʵ���
       if termin1 == 'T'
           ir = 3;
       end
       if termin1 == 'S'
           ir = 4;
       end
    end
            
    ic = 1; % ������
    if depart == 0
        % ���ڳ���
        if termin2 == 'T'
            % ��վ¥T
            ic = 1;
        end
        if termin2 == 'S'
            % ������S
            ic = 2;
        end
    else
       % ���ʳ���
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
%% ���Ⱦɫ�����ķ��䷽���Ƿ����
    [fsize,~] = size(flights);
    [gsize,~] = size(gate);
    gtsize = gsize + 1; % ��ʱ����
    isAvil = isAvailable(chrom, flights, gate);
    [fglist,~] = fgAllocate(chrom, fsize, gtsize);
    isSpan = timeSpan(fglist, flights);
    isCheck = isAvil && isSpan;
end

function isViable=singleCheck(flights, gate, curFlight, numGate, priv, next)
%% �Է��䵽�ǻ��ڵĺ�������������
    % �Ժ���͵ǻ��ڽ��л�������ƥ��
    u = cell2mat(flights(priv, 7)); % ����ɻ��ͺ�
    v = cell2mat(gate(numGate, 3)); % �ǻ��ڷɻ��ͺ�
    e = cell2mat(flights(priv, 6)); % ���ൽ������
    o = cell2mat(gate(numGate, 4)); % �ǻ��ڵ�������
    p = cell2mat(flights(priv, 11)); % �����������
    q = cell2mat(gate(numGate, 5)); % �ǻ��ڳ�������
    isViable = indicator(0, u, v) && indicator(1, e, o) && indicator(1, p, q);
    
    if next ~= 0
        % ��ǰ����ĺ��಻�Ǹõǻ��ڵ����һ�ܺ���
        d1 = cell2mat(flights(priv, 9)); % ǰһ�ܷɻ������ʱ��
        a1 = cell2mat(flights(next, 4)); % ��һ�ܷɻ��ĵ���ʱ��
        isViable = isViable && ((a1-d1) >= 45);
    end

    if curFlight(numGate) ~= 0
        % �ڵ�ǰ����֮ǰ����һ�ܺ���
        d2 = cell2mat(flights(curFlight(numGate), 9)); % ǰһ�ܷɻ������ʱ��
        a2 = cell2mat(flights(priv, 4)); % ��ǰ�������ܷɻ��ĵ���ʱ�� 
        isViable = isViable && ((a2-d2) >= 45);
    end
end

function [fitChrom,tempGFlist,temPlace] = reAllocate(chrom, flights, gate)
%% �ط��亯��������Ⱦɫ��ʹ������Լ������
    [fsize,~] = size(flights);
    [gsize,~] = size(gate);
    gtsize = gsize + 1; % �ܵĵǻ�����Ŀ(������ʱ��λ)
    [fglist,~] = fgAllocate(chrom, fsize, gtsize);
    temPlace = zeros(1, fsize); % �ݴ�ռ䣬�����ʱ���õĺ���
    tempGFlist = zeros(gsize, fsize); % ���������ĵǻ���-�������    
    curFlight = zeros(1, gsize);
    fitChrom = zeros(1,fsize);
    
    parkIndex = 1; % ��ʱ��λ���������һ�ܷɻ�֮��Ŀ��л�λ����
    for i=1:(fsize-1)
       % �����ִ���֪����ʱ��λ�ϵķɻ�
       temPlace(i) = fglist(gtsize, i);
       if fglist(gtsize, i) == 0
          % ��ʼȾɫ��δ����ɻ�����ʱ��λ,��һλ���ǿ���λ
          break;
       end
       if fglist(gtsize,i+1) == 0
          % ��ǰ��ʱ��λͣ�Ŷ��е����һ�ܷɻ���ĵ�һ������λ��
          parkIndex = i+1;
          break;
       end
    end
    
    % �ƶ������еĺ��ൽ��ʱ��λ
    for i=1:gsize
        for j=1:(fsize - 1)
           if fglist(i,j) == 0
               continue;
           end          
           % i�ǻ��ڵ�j�ź����Ƿ����
           isViable = singleCheck(flights, gate, curFlight, i, fglist(i,j), fglist(i,j+1));
           if isViable
               % ����i�ŵǻ���������֤������Լ���ĺ���
               curFlight(i) = fglist(i,j);
           else
              % ��j�����ƶ�����ʱ��λ 
              temPlace(parkIndex) = fglist(i,j);
              fglist(i,j) = 0; % �����ǰ�ǻ��ڵĲ����к���
              parkIndex = parkIndex + 1; % ָ����һ�����л�λ
           end
        end
    end
    %curFlight
    %temPlace
    %fglist(:,1:20)
    % �����ѻ�õĿ��еĵǻ���-�������
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
    % ����ʱ��λ���亽�ൽ�ǻ��ڣ��õ�һ�����еķ��䷽��
    for i=1:(parkIndex - 1)
       flag1 = false;
       for g=1:gsize
           for k=1:fsize
               if k == 1
                   % �ǻ��ڵĵ�һ�ܺ��࣬��Ҫ���⴦��
                   if tempGFlist(g,k) == 0
                       % �ǻ��ڻ�δ��ʹ��
                       isViable = singleCheck(flights, gate, zeros(1, gsize), g, temPlace(i), 0);
                       if isViable
                           tempGFlist(g,k) = temPlace(i);                 
                           curFlight(g) = temPlace(i);
                           temPlace(i) = 0;
                           flag1 = true; % �ú����ѱ����䣬�����ٷ֣��е���һ����Ҫ����ĺ���
                       end
                       break; % ���Բ�ƥ�䣬�õǻ��ڲ������ڴ˺���
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

    % ���ɸ��º��Ⱦɫ�壬����д��̶��ǻ��ڸ��º�ĺ������
    for i=1:gsize
        for j=1:fsize
            if tempGFlist(i,j) ~= 0
                fitChrom(tempGFlist(i,j)) =  i;
            end
        end
    end
    
    % ��ʱ��λ�ĸ��º�ķ���
    for i=1:fsize
        if temPlace(i) ~= 0
            fitChrom(temPlace(i)) = gtsize; % �̶��ǻ��ڵ��±�����
        end
    end
end

function ret=Select(individuals, fitness, sizepop)
%% ����ѡ��,��ÿһ����Ⱥ�е�Ⱦɫ�����ѡ��,�Խ��к���Ľ���ͱ���
% individuals   input: ��Ⱥ��Ϣ
% fitness       input: ��Ӧ��
% sizepop       input: ��Ⱥ��ģ
% ret           return: ����ѡ������Ⱥ   
    fitness = 1./(fitness); % ��ԭ������Ӧֵȡ����
    sumfitness = sum(fitness); % ���µõ���������Ӧֵ���
    sumf = fitness./sumfitness; % �����Ӧֵ��������Ӧֵ����ռ�ı���ֵ
    index = [];
    for i=1:sizepop
        % ��ת���㷨��ת��Ⱥ��������ת��
        pick = rand; % ��ȡһ�������
        while pick == 0
            pick = rand;
        end
        for j=1:sizepop
            % ����һ�����������Ӧֵ��ת�̵ı����Ĳ�����ѡ����
            pick = pick - sumf(j);
            if pick < 0
                index = [index j];
                break; % ƥ�䵽һ��j���˳���ѭ��
            end
        end
    end
    individuals = individuals(index,:);
    ret = floor(individuals);
end

function ret=Cross(pcross, lenchrom, chrom, sizepop, bound)
%% ��������ɽ������
% pcross    input: �������
% lenchrom  input: Ⱦɫ��ĳ���
% chrom     input: Ⱦɫ��Ⱥ
% sizepop   input: ��Ⱥ��ģ
% ret       return: ������Ⱦɫ��
    for i=1:sizepop
        % ���ѡ������Ⱦɫ����н���
        pick = rand(1,2);
        while prod(pick) == 0
            % prod()����һ��Ԫ�أ���������Ƕ���Ԫ�أ���������ÿһ�У�Ȼ�����һ��Ԫ��
            % ���ｫ����һ��ֵ����������������ֵ�Ļ�����
            % һ��Ԫ����Ŀ�Ķ���������������������
            pick = rand(1,2);
        end
        index = ceil(pick .* sizepop); % ceil����ȡ��
        % ������ʾ����Ƿ���н������
        pick = rand;
        while pick == 0
            pick = rand;
        end
        if pick > pcross
            % ����ѭ�������н������
            continue;
        end
        flag = 0;
        while flag == 0
           % ���ѡ�񽻲�λ��
           pick = rand;
           while pick == 0
               pick = rand;
           end
           % ���ѡ����н����λ�ã���ѡ��ڼ����������н���
           % ����Ⱦɫ�彻���λ����ͬ
           pos = ceil(pick .* sum(lenchrom));
           pick = rand; % ���濪ʼ
           v1 = chrom(index(1),pos);
           v2 = chrom(index(2),pos);
           chrom(index(1),pos) = pick*v2 + (1-pick)*v1;
           chrom(index(2),pos) = pick*v1+(1-pick)*v2; % �������
           flag1 = testFeasible(bound,chrom(index(1),:)); % ����Ⱦɫ��1�Ŀ�����
           flag2 = testFeasible(bound,chrom(index(2),:)); % ����Ⱦɫ��2�Ŀ�����
           if (flag1 * flag2) == 0
               flag=0; % ����Ⱦɫ����һ��������ʱ���ٴν��н������
           else
               flag=1; % �����ǿ��еģ������������
           end
        end
    end
    ret = floor(chrom); % ���ؽ�����Ⱦɫ��
end

function ret=Mutation(pmutation, lenchrom, chrom, sizepop, pop, bound)
%% ��������ɱ������
% pmutation     input: �������
% lenchrom      input: Ⱦɫ�峤��
% chrom         input: Ⱦɫ��Ⱥ
% sizepop       input: ��Ⱥ��ģ
% pop           input: ��ǰ��Ⱥ�Ľ������������Ľ���������Ϣ
% ret           return: ������Ⱦɫ��
    for i=1:sizepop
       % ���ѡ��һ��Ⱦɫ����б���
       pick = rand;
       while pick == 0
           pick = rand;
       end
       index = ceil(pick * sizepop);
       % ������ʾ�������ѭ���Ƿ���б���
       pick = rand;
       if pick > pmutation
           continue;
       end
       flag = 0;
       while flag == 0
          % ����λ��
          pick = rand;
          while pick == 0
              pick = rand;
          end
          pos = ceil(pick * sum(lenchrom)); % ���ѡ����Ⱦɫ������λ�ã���ѡ���˵�pos���������б���
          v = chrom(i,pos);
          v1 = v - bound(pos,1);
          v2 = bound(pos,2) - v;
          pick = rand; % ���쿪ʼ
          if pick > 0.5
              delta = v2 * (1-pick^((1-pop(1)/pop(2))^2));
              chrom(i,pos) = v + delta;
          else
              delta = v1 * (1-pick^((1-pop(1)/pop(2))^2));
              chrom(i, pos) = v - delta;
          end % �������
          flag = testFeasible(bound, chrom(i,:)); % ����Ⱦɫ��Ŀ����ԣ������˳�����ѭ��
       end
    end
    ret = floor(chrom);
end

function chrom=code(chromLen, bound)
%% �����������Ⱦɫ�壬���������ʼ��һ����Ⱥ
% lenchrom      input: Ⱦɫ�峤��
% bound         input: �����ȡֵ��Χ
% chrom           return: Ⱦɫ��ı���ֵ   
    flag=0;
    while flag == 0
        pick = rand(1, chromLen); % ���������
        chrom = bound(:,1)'+(bound(:,2)-bound(:,1))' .* pick;
        chrom = floor(chrom); % ����ȡ��
        flag = testFeasible(bound, chrom); % ����Ⱦɫ��Ŀ�����
    end
end

function flag = testFeasible(bound, chrom)
%% ����Ⱦɫ��Ŀ�����
% bound         input: �����ȡֵ��Χ
% chrom          return: Ⱦɫ��ı���ֵ    
    flag = 1;
    [n,~] = size(chrom);
    for i = 1:n
        % �ж��µõ���Ⱦɫ��ÿ��Ԫ��ֵ�Ƿ񳬹��˱߽�
        if (chrom(i) < bound(i,1)) || (chrom(i) > bound(i,2))
            flag = 0; % ��Ⱦɫ�岻���ã����»�ȡ�µ�Ⱦɫ��ֵ
        end
    end
end

function flag=indicator(type, a, b)
%% ָʾ����
% type        input: ��Ҫ�����ָʾ����������
% a           input: ��Ҫƥ��ĺ�������
% b           input: ��Ҫƥ��ĵǻ�������
% flag        return: ����ƥ�䷵��1
    if type == 1
       % ƥ�亽����ǻ��ڵĵ���ͳ�������
       if b == 2
           % �ǻ��ڿ������������
           flag = true;
       elseif a == b
           % �ǻ�����������뺽����ͬ
           flag = true;
       else
           flag = false;
       end
    else
        % ƥ�亽��͵ǻ��ڵĻ���
        if a == b
            flag = true;
        else
            flag = false;
        end
    end
end

function isAvil=isAvailable(chrom, flights, gate)
%% �÷��䷽���Ƿ����
    [fsize,~] = size(flights);
    flag = true;
    for i=1:fsize
        if chrom(i) == 70
            % ���䵽��ʱ��λ�ķɻ��ض���������Ҫ��
            continue
        end
        u = cell2mat(flights(i, 7)); % ����ɻ��ͺ�
        v = cell2mat(gate(chrom(i), 3)); % �ǻ��ڷɻ��ͺ�
        e = cell2mat(flights(i, 6)); % ���ൽ������
        o = cell2mat(gate(chrom(i), 4)); % �ǻ��ڵ�������
        p = cell2mat(flights(i, 11)); % �����������
        q = cell2mat(gate(chrom(i), 5)); % �ǻ��ڳ�������
        flag = (indicator(0, u, v) && indicator(1, e, o) && indicator(1, p, q)) && flag;
    end
    isAvil = flag;
end

function isSpan=timeSpan(fglist, flights)
%% �ǻ��ں���ʱ�����Ƿ�����Ҫ��
% fglist      input:�ǻ��ں���ʱ��λ�����Ϣ
% flights     input:����ת������
% isSpan      return:ĳ�����䷽����ʱ�����Ƿ�����Ҫ��
    [gtsize, fsize] = size(fglist);
    isSpan = true;
    flag1 = false; % ��������ѭ����־λ
    gsize = gtsize - 1; % ��������ʱ��λ
    for i=1:gsize
        for j=1:(fsize - 1)
            if (fglist(i,j+1) == 0) || (fglist(i,j) == 0)
                % ���еǻ��ں����һ�ܺ��಻����ʱ����
                continue;
            end
            d = cell2mat(flights(fglist(i,j), 9)); % ǰһ�ܷɻ������ʱ��
            a = cell2mat(flights(fglist(i,j+1), 4)); % ��һ�ܷɻ��ĵ���ʱ��
            if (a-d) < 45
                % �÷��䷽����������Լ��
                flag1 = true;
                isSpan = false;
                break;
            end
        end      
        if flag1
           % ���䷽��������Լ��
           break;
        end
    end
end

function [fglist, fgcount]=fgAllocate(code, fsize, gtsize)
%% ��Ⱦɫ�尴�ǻ���ͳ��ĳ���ǻ��ڵĺ��������Ͱ��
% code         input: Ⱦɫ���ʾһ�κ������ķ���
% fsize        input: ��������
% gtsize       input: �ǻ��ں���ʱ��λ����
% fglist       return: ���ǻ��ڷ��亽��(������ʱ��λ)
% fgcount      return: �ǻ��ں���ʱ��λ��������
    fgcount = zeros(1, gtsize); 
    fglist = zeros(gtsize, fsize);
    index = ones(1,gtsize); % ʵʱ����������ǻ��ڵĺ�����
    for i=1:fsize
        fglist(code(i),index(code(i))) = i;
        fgcount(code(i)) = fgcount(code(i)) + 1;
        index(code(i)) = index(code(i)) + 1;
    end        
end