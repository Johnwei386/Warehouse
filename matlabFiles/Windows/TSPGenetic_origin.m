function TSPGenetic_origin()
%% �Ŵ��㷨���TSP���� 
    clc, clear, close all;
    n=50;               % ���е�����
    xy=10*rand(n,2);    % ���е�λ������
    popSize=60;         % ��ʼ��Ⱥ�Ĵ�С���ܱ�4����
    numIter = 1e4;      % �Ŵ������Ĵ���
    showProg = 1;
    showResult = 1;
    a = meshgrid(1:n);
    % ���������󣬾�����Ϊŷʽ����
    dmat = reshape(sqrt(sum((xy(a, :)-xy(a', :)).^2, 2)), n, n);
    % optRoute �Ŵ��㷨�ó�������·��
    % minDist ����·���µĳɱ�ֵ�����ֵ
    [optRoute, minDist] = tsp_ga(xy, dmat, popSize, numIter, showProg, showResult);
    
    figure(6)
    for i=1:n
        hold on
        plot(xy(:, 1), xy(:, 2), 'k.'); % �����ʼ���е������
        text(xy(i, 1), xy(i, 2)+0.08, num2str(i)); % �����Ӧ�ĵ�
    end
    for i=1:n-1
        % ���м���·��
        plot([xy(optRoute(1, i),1), xy(optRoute(1, i+1),1)], [xy(optRoute(1, i), 2), xy(optRoute(1, i+1),2)])
        hold on
    end
    % ����������Ǹ����е��������е�·��
    plot([xy(optRoute(1, n), 1), xy(optRoute(1, 1), 1)], [xy(optRoute(1, n), 2), xy(optRoute(1, 1), 2)])
    hold on
end

function varargout = tsp_ga(xy, dmat, popSize, numIter, showProg, showResult)
% ʹ���Ŵ��㷨���TSP����
    % ȱʧ������ʹ��Ĭ�ϲ���ֵ����
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
    
    % ������֤
    [N, dims] = size(xy); % dims��ʾά�ȣ�ĿǰΪ��ά
    [nr, nc] = size(dmat);
    if N ~= nr || N ~= nc
        error('Invalid XY or DMAT inputs!')
    end
    n = N; % nΪ������Ŀ
    
    % �����Լ��
    popSize = 4*ceil(popSize/4);
    numIter = max(1, round(real(numIter(1))));
    showProg = logical(showProg(1));
    showResult = logical(showResult(1));
    
    % ��ʼ����Ⱥ
    pop = zeros(popSize, n);
    pop(1, :) = (1:n); % ��1��·����ʼ��Ϊ1,2,...,n
    for k = 2:popSize
        pop(k, :)=randperm(n); % ���·��
    end
    
    % �Ŵ�����
    globalMin = Inf; % ȫ��·��������Сֵ
    totalDist = zeros(1, popSize);
    distHistory = zeros(1, numIter);
    tmpPop = zeros(4, n);
    newPop = zeros(popSize, n);
    if showProg
        pfig = figure('Name', 'TSP_GA|Current Best Solution', 'Numbertitle', 'off');
    end
    for iter = 1:numIter    % �Ŵ�����
        % ����·���ľ����ܺͣ���·����Ϊ��Ӧ��
        for p = 1:popSize
            d = dmat(pop(p, n), pop(p, 1)); % ÿһ��·�����յ�������ľ���
            for k = 2:n
                d = d + dmat(pop(p, k-1), pop(p, k)); % ÿ��·���ľ����ܺͣ����-�յ�-���
            end
            totalDist(p)=d; % ����ÿһ��·���ľ����ܺ�
        end
        
        % �ҵ�ӵ�������Ӧ�ȵ�Ⱦɫ��(��·�����ܾ�����С)����������Ⱥ�е�λ��
        [minDist, index] = min(totalDist);
        distHistory(iter) = minDist; % ���浱ǰ������֪�����·��
        % ������һ�ν�������õ�Ⱦɫ��
        if minDist < globalMin
            globalMin = minDist; % �𲽸���ȫ����Сֵ
            optRoute = pop(index, :); % ���ظ�·��
            if showProg
                figure(pfig);
                rte = optRoute([1:n 1]); % ����㵽�յ��ڻص�����·��
                if dims > 2 % ���е�λ�÷ֲ�����һ��ƽ��
                    plot3(xy(rte, 1), xy(rte, 2), xy(rte, 3), 'r.-');
                else
                    plot(xy(rte, 1), xy(rte, 2), 'r.-'); % ��������
                end
                title(sprintf('Total Distance = %1.4f, Iteration = %d', minDist, iter));
            end
        end
        
        % �������
        randomOrder = randperm(popSize); % ����һ���������Ⱥѡ��ռ�
        for p = 4:4:popSize
            rtes = pop(randomOrder(p-3:p), :); % ÿ��ѡ��4����ͬ·��
            dists = totalDist(randomOrder(p-3:p)); % �õ�4��·�����Եľ���
            [~, idx] = min(dists); % ѡ��������С������·��������������
            bestOf4Route = rtes(idx, :); % �ڱ���ѡ���о���(��Ӧ��)��С������·��
            routeInsertionPoints = sort(ceil(n*rand(1, 2))); % ���ѡ�񽻲��
            I = routeInsertionPoints(1);
            J = routeInsertionPoints(2);
            for k = 1:4
                tmpPop(k, :) = bestOf4Route; % ÿ������õ�����·��Ϊ��׼�����Ŵ�����
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
        pop = newPop; % ÿ�ε���ֱ���滻�ɵ���ȺΪ����Ⱥ
    end
    
    % ��ͼ
    if showResult
        figure('Name', 'TSP_GA|Results', 'Numbertitle', 'off');
        figure(1);
        if dims > 2
            plot3(xy(:, 1), xy(:, 2), xy(:, 3), 'r.');
        else
            plot(xy(:, 1), xy(:, 2), 'r.');
        end
        title('����λ��');
        grid on
        figure(2)
        imagesc(dmat(optRoute, optRoute));
        title('�������-imagese');
        
        figure(3)
        rte = optRoute([1:n 1]);
        if dims>2
            plot3(xy(rte, 1), xy(rte, 2), xy(rte, 3), 'r.-');
        else
            plot(xy(rte, 1), xy(rte, 2), 'r.-');
        end
        title(sprintf('��̾��� = %1.4f', minDist));
        grid on
        
        figure(4);
        plot(distHistory, 'b', 'LineWidth', 2);
        title('�����Ӧ������');
        grid on
        set(gca, 'XLim', [0 numIter+1], 'YLim', [0 1.1*max([1 distHistory])]);
    end
    
    % ���ؽ��
    if nargout
        varargout{1} = optRoute;
        varargout{2} = minDist;
    end
    
end
