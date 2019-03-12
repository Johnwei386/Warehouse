function TSPGenetic_origin()
%% 遗传算法求解TSP问题 
    clc, clear, close all;
    n=50;               % 城市的数量
    xy=10*rand(n,2);    % 城市的位置坐标
    popSize=60;         % 初始种群的大小，能被4整除
    numIter = 1e4;      % 遗传迭代的次数
    showProg = 1;
    showResult = 1;
    a = meshgrid(1:n);
    % 计算距离矩阵，距离测度为欧式距离
    dmat = reshape(sqrt(sum((xy(a, :)-xy(a', :)).^2, 2)), n, n);
    % optRoute 遗传算法得出的最优路径
    % minDist 最优路径下的成本值或距离值
    [optRoute, minDist] = tsp_ga(xy, dmat, popSize, numIter, showProg, showResult);
    
    figure(6)
    for i=1:n
        hold on
        plot(xy(:, 1), xy(:, 2), 'k.'); % 绘出初始城市的坐标点
        text(xy(i, 1), xy(i, 2)+0.08, num2str(i)); % 标记相应的点
    end
    for i=1:n-1
        % 城市间绘出路径
        plot([xy(optRoute(1, i),1), xy(optRoute(1, i+1),1)], [xy(optRoute(1, i), 2), xy(optRoute(1, i+1),2)])
        hold on
    end
    % 绘出从最后的那个城市到出发城市的路径
    plot([xy(optRoute(1, n), 1), xy(optRoute(1, 1), 1)], [xy(optRoute(1, n), 2), xy(optRoute(1, 1), 2)])
    hold on
end

function varargout = tsp_ga(xy, dmat, popSize, numIter, showProg, showResult)
% 使用遗传算法求解TSP问题
    % 缺失参数则使用默认参数值补齐
    nargs = 6;
    for k = nargin:nargs-1
        switch k
            case 0
                xy = 10*rand(50, 2);
            case 1
                N = size(xy, 1);
                a = meshgrid(1:N);
                dmat = reshape(sqrt(sum((xy(a, :)-xy(a', :)).^2, 2)), N, N);
            case 2
                popSize = 100;
            case 3
                numIter = 1e4;
            case 4
                showProg = 1;
            case 5
                showResult = 1;
            otherwise
        end
    end
    
    % 输入验证
    [N, dims] = size(xy); % dims表示维度，目前为二维
    [nr, nc] = size(dmat);
    if N ~= nr || N ~= nc
        error('Invalid XY or DMAT inputs!')
    end
    n = N; % n为城市数目
    
    % 完整性检查
    popSize = 4*ceil(popSize/4);
    numIter = max(1, round(real(numIter(1))));
    showProg = logical(showProg(1));
    showResult = logical(showResult(1));
    
    % 初始化种群
    pop = zeros(popSize, n);
    pop(1, :) = (1:n); % 第1条路径初始化为1,2,...,n
    for k = 2:popSize
        pop(k, :)=randperm(n); % 随机路径
    end
    
    % 遗传操作
    globalMin = Inf; % 全局路径距离最小值
    totalDist = zeros(1, popSize);
    distHistory = zeros(1, numIter);
    tmpPop = zeros(4, n);
    newPop = zeros(popSize, n);
    if showProg
        pfig = figure('Name', 'TSP_GA|Current Best Solution', 'Numbertitle', 'off');
    end
    for iter = 1:numIter    % 遗传迭代
        % 计算路径的距离总和，将路径作为适应度
        for p = 1:popSize
            d = dmat(pop(p, n), pop(p, 1)); % 每一条路径，终点与起点间的距离
            for k = 2:n
                d = d + dmat(pop(p, k-1), pop(p, k)); % 每条路径的距离总和，起点-终点-起点
            end
            totalDist(p)=d; % 保存每一条路径的距离总和
        end
        
        % 找到拥有最好适应度的染色体(即路径的总距离最小)及它们在种群中的位置
        [minDist, index] = min(totalDist);
        distHistory(iter) = minDist; % 保存当前迭代已知的最佳路径
        % 代替上一次进化中最好的染色体
        if minDist < globalMin
            globalMin = minDist; % 逐步更新全局最小值
            optRoute = pop(index, :); % 返回该路径
            if showProg
                figure(pfig);
                rte = optRoute([1:n 1]); % 从起点到终点在回到起点的路径
                if dims > 2 % 城市的位置分布不是一个平面
                    plot3(xy(rte, 1), xy(rte, 2), xy(rte, 3), 'r.-');
                else
                    plot(xy(rte, 1), xy(rte, 2), 'r.-'); % 按坐标绘点
                end
                title(sprintf('Total Distance = %1.4f, Iteration = %d', minDist, iter));
            end
        end
        
        % 交叉操作
        randomOrder = randperm(popSize); % 生成一个随机的种群选择空间
        for p = 4:4:popSize
            rtes = pop(randomOrder(p-3:p), :); % 每次选择4条不同路径
            dists = totalDist(randomOrder(p-3:p)); % 得到4条路径各自的距离
            [~, idx] = min(dists); % 选出距离最小的那条路径，返回其索引
            bestOf4Route = rtes(idx, :); % 在本次选择中距离(适应度)最小的那条路径
            routeInsertionPoints = sort(ceil(n*rand(1, 2))); % 随机选择交叉点
            I = routeInsertionPoints(1);
            J = routeInsertionPoints(2);
            for k = 1:4
                tmpPop(k, :) = bestOf4Route; % 每次以最好的那条路径为基准进行遗传操作
                switch k
                    case 2 % Flip
                        tmpPop(k, 1:J) = tmpPop(k, J:-1:1);
                    case 3 % Swap
                        tmpPop(k, [I J]) = tmpPop(k, [J I]);
                    case 4 % Slide
                        tmpPop(k, I:J) = tmpPop(k, [I+1:J I]);
                    otherwise
                end
            end
            newPop(p-3:p, :) = tmpPop;
        end
        pop = newPop; % 每次迭代直接替换旧的种群为新种群
    end
    
    % 绘图
    if showResult
        figure('Name', 'TSP_GA|Results', 'Numbertitle', 'off');
        figure(1);
        if dims > 2
            plot3(xy(:, 1), xy(:, 2), xy(:, 3), 'r.');
        else
            plot(xy(:, 1), xy(:, 2), 'r.');
        end
        title('城市位置');
        grid on
        figure(2)
        imagesc(dmat(optRoute, optRoute));
        title('距离矩阵-imagese');
        
        figure(3)
        rte = optRoute([1:n 1]);
        if dims>2
            plot3(xy(rte, 1), xy(rte, 2), xy(rte, 3), 'r.-');
        else
            plot(xy(rte, 1), xy(rte, 2), 'r.-');
        end
        title(sprintf('最短距离 = %1.4f', minDist));
        grid on
        
        figure(4);
        plot(distHistory, 'b', 'LineWidth', 2);
        title('最佳适应度曲线');
        grid on
        set(gca, 'XLim', [0 numIter+1], 'YLim', [0 1.1*max([1 distHistory])]);
    end
    
    % 返回结果
    if nargout
        varargout{1} = optRoute;
        varargout{2} = minDist;
    end
    
end
