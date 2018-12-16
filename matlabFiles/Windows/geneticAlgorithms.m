function geneticAlgorithms()
%% 基于遗传算法的有约束条件的线性方程最优值寻优计算 
    genetic();
end

% 适应度函数
function y=fun(x)
    % 使用遗传算法求解带约束的线性方程问题的最小值，优化就是求在约束条件下使其函数值最小的那组取值和最小值
    % 所以在该问题中，适应值被定义为函数的解，即y的值，这样才能使用适应值函数去求解最小值
    y=0.072*x(1)+0.063*x(2)+0.057*x(3)+0.05*x(4)+0.032*x(5)+0.0442*x(6)+0.0675*x(7);
end

function genetic()
%% 采用GA算法实现函数的寻优计算
    clc, clear, close all;
    warning off; % 关掉警告信息
    
    %% 参数初始化
    popsize=100; % 种群规模
    lenchrom=7; % 变量字串长度
    % 设置交叉概率，本例中交叉概率是定值，若想设置变化的交叉概率
    % 可用表达式表示，或重写一个交叉概率函数，例如用神经网络训练
    % 得到的值作为交叉概率
    pc=0.7; 
    pm=0.3; % 设置变异概率，同理也可设置为变化的
    maxgen=100; % 进化次数
    
    %% 生成种群
    popmax=50;
    popmin=0;
    bound=[popmin popmax;
           popmin popmax;
           popmin popmax;
           popmin popmax;
           popmin popmax;
           popmin popmax;
           popmin popmax]; % 变量范围
    % 产生种群，种群大小为popsize
    for i=1:popsize
        % 随机产生一条染色体
        GApop(i,:)=Code(lenchrom, bound);
        % 计算适应度,得到染色体的适应度
        % 该适应度就是在这条染色体的赋值情况下所得到的函数值
        fitness(i)=fun(GApop(i,:));
    end
    
    %% 寻找最好的染色体
    [bestfitness, bestindex]=min(fitness); % 返回矩阵中的最小值及其相应索引位置
    zbest=GApop(bestindex,:); % 全局最佳,保存现在已知最小的适应值的染色体
    gbest=GApop; % 个体最佳,辅助种群,保存最初的群体
    fitnessgbest=fitness; % 个体最佳适应度值,辅助适应值,保存最开始得到的适应度矢量
    fitnesszbest=bestfitness; % 全局最佳适应度值,得到已知最小的适应值
    
    %% 迭代寻优
    for i=1:maxgen
        % 种群更新 父代选择
        GApop=Select(GApop, fitness, popsize);
        % 交叉操作
        GApop=Cross(pc, lenchrom, GApop, popsize, bound);
        % 变异操作
        GApop=Mutation(pm, lenchrom, GApop, popsize, [i maxgen], bound);
        pop=GApop;
        for j=1:popsize
            % 更新适应度值
            if 0.072*pop(j,1)+0.063*pop(j,2)+0.057*pop(j,3)+0.05*pop(j,4)
                +0.032*pop(j,5)+0.0442*pop(j,6)+0.0675*pop(j,7)<=264.4
               if 128*pop(j,1)+78.1*pop(j,2)+64.1*pop(j,3)+43*pop(j,4)
                   +58.1*pop(j,5)+36.9*pop(j,6)+50.5*pop(j,7)<=69719
                   % 满足约束条件的染色体立即更新适应值
                        fitness(j)=fun(pop(j,:));
               end
            end
            % 个体最优更新
            if fitness(j) < fitnessgbest(j)
                % 新得到的适应值与原来的适应值矢量的元素值进行对比
                gbest(j,:)=pop(j,:); % 更新辅助种群集合
                fitnessgbest(j)=fitness(j); % 更新辅助适应值集合
            end
            % 群体最优更新
            if fitness(j)<fitnesszbest
                % 在适应值发生变化后,再次寻找最小适应值的染色体和其值
                zbest = pop(j,:); % 保存新的取得最小值的染色体
                fitnesszbest=fitness(j); % 保存新获得的最小值
            end 
        end
        yy(i)=fitnesszbest; % 保存每次迭代后获得的最小值，以便生成得到优化值与迭代次数之间的关系
    end
    
    %% 结果
    disp '**********************best patical number****************************'
    zbest
    %% 画图
    plot(yy, 'linewidth', 2);
    title(['适应度函数' '终止代数=' num2str(maxgen)]);
    xlabel('进化代数'); ylabel('适应度');
    grid on
end

function flag=test(lenchrom, bound, code)
%% 检验染色体的可行性
% lenchrom      input: 染色体长度
% bound         input: 变量的取值范围
% code          return: 染色体的编码值    
    % 初始化变量
    flag=1; % 非0值使在检测之后，该染色体能用，则退出随机生成染色体的过程
    [n,~]=size(code);
    for i=1:n
        % 判断新得到的染色体每个元素值是否超过了边界
        if code(i)<bound(i,1) || code(i)>bound(i,2)
            flag=0; % 该染色体不能用，重新获取新的染色体值
        end
    end
end

function ret=Code(lenchrom, bound)
%% 将变量编码成染色体，用于随机初始化一个种群
% lenchrom      input: 染色体长度
% bound         input: 变量的取值范围
% ret           return: 染色体的编码值   
    flag=0;
    while flag==0
        pick=rand(1, lenchrom); % 生成一个随机数作元素项的行向量
        ret=bound(:,1)'+(bound(:,2)-bound(:,1))'.*pick; % 线性插值,50*随机数,返回7个值
        flag=test(lenchrom, bound, ret); % 检验染色体的可行性
    end
end

function ret=Select(individuals, fitness, sizepop)
%% 父代选择,对每一代种群中的染色体进行选择,以进行后面的交叉和变异
% individuals   input: 种群信息
% fitness       input: 适应度
% sizepop       input: 种群规模
% ret           return: 经过选择后的种群   
    fitness=1./(fitness); % 将原来的适应值取倒数
    sumfitness=sum(fitness); % 对新得到的所有适应值求和
    sumf=fitness./sumfitness; % 求得适应值在所有适应值中所占的比重值
    index=[];
    for i=1:sizepop
        % 类转盘算法，转种群的总数次转盘
        pick=rand; % 获取一个随机数
        while pick==0
            pick=rand;
        end
        for j=1:sizepop
            % 基于一个随机数和适应值在转盘的比例的差来挑选父代
            % 有可能会重复选择某些染色体，如何规避重复选择？
            pick=pick-sumf(j);
            if pick<0
                index=[index j];
                break; % 匹配到一个j即退出该循环
            end
        end
    end
    individuals=individuals(index,:);
    fitness=fitness(index);
    ret=individuals;
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
        pick=rand(1,2);
        while prod(pick)==0
            % prod()产生一行元素，若输入的是多行元素，则它处理每一列，然后产生一行元素
            % 这里将产生一个值，在输入的两个随机值的基础上
            % 一行元素数目的多少由输入矩阵的列数决定
            pick=rand(1,2);
        end
        index=ceil(pick.*sizepop); % ceil向上取整
        % 交叉概率决定是否进行交叉操作
        pick=rand;
        while pick==0
            pick=rand;
        end
        if pick>pcross
            % 本次循环不进行交叉操作
            continue;
        end
        flag=0;
        while flag==0
           % 随机选择交叉位置
           pick=rand;
           while pick==0
               pick=rand;
           end
           % 随机选择进行交叉的位置，即选择第几个变量进行交叉
           % 两个染色体交叉的位置相同
           pos=ceil(pick.*sum(lenchrom));
           pick=rand; % 交叉开始
           v1=chrom(index(1),pos);
           v2=chrom(index(2),pos);
           chrom(index(1),pos)=pick*v2+(1-pick)*v1;
           chrom(index(2),pos)=pick*v1+(1-pick)*v2; % 交叉结束
           flag1=test(lenchrom,bound,chrom(index(1),:)); % 检验染色体1的可行性
           flag2=test(lenchrom,bound,chrom(index(2),:)); % 检验染色体2的可行性
           if flag1*flag2==0
               flag=0; % 两个染色体有一个不可行时，再次进行交叉操作
           else
               flag=1; % 交叉是可行的，结束交叉操作
           end
        end
    end
    ret=chrom; % 返回交叉后的染色体
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
       pick=rand;
       while pick==0
           pick=rand;
       end
       index=ceil(pick*sizepop);
       % 变异概率决定该轮循环是否进行变异
       pick=rand;
       if pick>pmutation
           continue;
       end
       flag=0;
       while flag==0
          % 变异位置
          pick=rand;
          while pick==0
              pick=rand;
          end
          pos=ceil(pick*sum(lenchrom)); % 随机选择了染色体变异的位置，即选择了第pos个变量进行变异
          v=chrom(i,pos);
          v1=v-bound(pos,1);
          v2=bound(pos,2)-v;
          pick=rand; % 变异开始
          if pick>0.5
              delta=v2*(1-pick^((1-pop(1)/pop(2))^2));
              chrom(i,pos)=v+delta;
          else
              delta=v1*(1-pick^((1-pop(1)/pop(2))^2));
              chrom(i, pos)=v-delta;
          end % 变异结束
          flag=test(lenchrom, bound, chrom(i,:)); % 检验染色体的可行性，可行退出变异循环
       end
    end
    ret=chrom;
end