function geneticAlgorithms()
%% �����Ŵ��㷨����Լ�����������Է�������ֵѰ�ż��� 
    genetic();
end

% ��Ӧ�Ⱥ���
function y=fun(x)
    % ʹ���Ŵ��㷨����Լ�������Է����������Сֵ���Ż���������Լ��������ʹ�亯��ֵ��С������ȡֵ����Сֵ
    % �����ڸ������У���Ӧֵ������Ϊ�����Ľ⣬��y��ֵ����������ʹ����Ӧֵ����ȥ�����Сֵ
    y=0.072*x(1)+0.063*x(2)+0.057*x(3)+0.05*x(4)+0.032*x(5)+0.0442*x(6)+0.0675*x(7);
end

function genetic()
%% ����GA�㷨ʵ�ֺ�����Ѱ�ż���
    clc, clear, close all;
    warning off; % �ص�������Ϣ
    
    %% ������ʼ��
    popsize=100; % ��Ⱥ��ģ
    lenchrom=7; % �����ִ�����
    % ���ý�����ʣ������н�������Ƕ�ֵ���������ñ仯�Ľ������
    % ���ñ��ʽ��ʾ������дһ��������ʺ�����������������ѵ��
    % �õ���ֵ��Ϊ�������
    pc=0.7; 
    pm=0.3; % ���ñ�����ʣ�ͬ��Ҳ������Ϊ�仯��
    maxgen=100; % ��������
    
    %% ������Ⱥ
    popmax=50;
    popmin=0;
    bound=[popmin popmax;
           popmin popmax;
           popmin popmax;
           popmin popmax;
           popmin popmax;
           popmin popmax;
           popmin popmax]; % ������Χ
    % ������Ⱥ����Ⱥ��СΪpopsize
    for i=1:popsize
        % �������һ��Ⱦɫ��
        GApop(i,:)=Code(lenchrom, bound);
        % ������Ӧ��,�õ�Ⱦɫ�����Ӧ��
        % ����Ӧ�Ⱦ���������Ⱦɫ��ĸ�ֵ��������õ��ĺ���ֵ
        fitness(i)=fun(GApop(i,:));
    end
    
    %% Ѱ����õ�Ⱦɫ��
    [bestfitness, bestindex]=min(fitness); % ���ؾ����е���Сֵ������Ӧ����λ��
    zbest=GApop(bestindex,:); % ȫ�����,����������֪��С����Ӧֵ��Ⱦɫ��
    gbest=GApop; % �������,������Ⱥ,���������Ⱥ��
    fitnessgbest=fitness; % ���������Ӧ��ֵ,������Ӧֵ,�����ʼ�õ�����Ӧ��ʸ��
    fitnesszbest=bestfitness; % ȫ�������Ӧ��ֵ,�õ���֪��С����Ӧֵ
    
    %% ����Ѱ��
    for i=1:maxgen
        % ��Ⱥ���� ����ѡ��
        GApop=Select(GApop, fitness, popsize);
        % �������
        GApop=Cross(pc, lenchrom, GApop, popsize, bound);
        % �������
        GApop=Mutation(pm, lenchrom, GApop, popsize, [i maxgen], bound);
        pop=GApop;
        for j=1:popsize
            % ������Ӧ��ֵ
            if 0.072*pop(j,1)+0.063*pop(j,2)+0.057*pop(j,3)+0.05*pop(j,4)
                +0.032*pop(j,5)+0.0442*pop(j,6)+0.0675*pop(j,7)<=264.4
               if 128*pop(j,1)+78.1*pop(j,2)+64.1*pop(j,3)+43*pop(j,4)
                   +58.1*pop(j,5)+36.9*pop(j,6)+50.5*pop(j,7)<=69719
                   % ����Լ��������Ⱦɫ������������Ӧֵ
                        fitness(j)=fun(pop(j,:));
               end
            end
            % �������Ÿ���
            if fitness(j) < fitnessgbest(j)
                % �µõ�����Ӧֵ��ԭ������Ӧֵʸ����Ԫ��ֵ���жԱ�
                gbest(j,:)=pop(j,:); % ���¸�����Ⱥ����
                fitnessgbest(j)=fitness(j); % ���¸�����Ӧֵ����
            end
            % Ⱥ�����Ÿ���
            if fitness(j)<fitnesszbest
                % ����Ӧֵ�����仯��,�ٴ�Ѱ����С��Ӧֵ��Ⱦɫ�����ֵ
                zbest = pop(j,:); % �����µ�ȡ����Сֵ��Ⱦɫ��
                fitnesszbest=fitness(j); % �����»�õ���Сֵ
            end 
        end
        yy(i)=fitnesszbest; % ����ÿ�ε������õ���Сֵ���Ա����ɵõ��Ż�ֵ���������֮��Ĺ�ϵ
    end
    
    %% ���
    disp '**********************best patical number****************************'
    zbest
    %% ��ͼ
    plot(yy, 'linewidth', 2);
    title(['��Ӧ�Ⱥ���' '��ֹ����=' num2str(maxgen)]);
    xlabel('��������'); ylabel('��Ӧ��');
    grid on
end

function flag=test(lenchrom, bound, code)
%% ����Ⱦɫ��Ŀ�����
% lenchrom      input: Ⱦɫ�峤��
% bound         input: ������ȡֵ��Χ
% code          return: Ⱦɫ��ı���ֵ    
    % ��ʼ������
    flag=1; % ��0ֵʹ�ڼ��֮�󣬸�Ⱦɫ�����ã����˳��������Ⱦɫ��Ĺ���
    [n,~]=size(code);
    for i=1:n
        % �ж��µõ���Ⱦɫ��ÿ��Ԫ��ֵ�Ƿ񳬹��˱߽�
        if code(i)<bound(i,1) || code(i)>bound(i,2)
            flag=0; % ��Ⱦɫ�岻���ã����»�ȡ�µ�Ⱦɫ��ֵ
        end
    end
end

function ret=Code(lenchrom, bound)
%% �����������Ⱦɫ�壬���������ʼ��һ����Ⱥ
% lenchrom      input: Ⱦɫ�峤��
% bound         input: ������ȡֵ��Χ
% ret           return: Ⱦɫ��ı���ֵ   
    flag=0;
    while flag==0
        pick=rand(1, lenchrom); % ����һ���������Ԫ�����������
        ret=bound(:,1)'+(bound(:,2)-bound(:,1))'.*pick; % ���Բ�ֵ,50*�����,����7��ֵ
        flag=test(lenchrom, bound, ret); % ����Ⱦɫ��Ŀ�����
    end
end

function ret=Select(individuals, fitness, sizepop)
%% ����ѡ��,��ÿһ����Ⱥ�е�Ⱦɫ�����ѡ��,�Խ��к���Ľ���ͱ���
% individuals   input: ��Ⱥ��Ϣ
% fitness       input: ��Ӧ��
% sizepop       input: ��Ⱥ��ģ
% ret           return: ����ѡ������Ⱥ   
    fitness=1./(fitness); % ��ԭ������Ӧֵȡ����
    sumfitness=sum(fitness); % ���µõ���������Ӧֵ���
    sumf=fitness./sumfitness; % �����Ӧֵ��������Ӧֵ����ռ�ı���ֵ
    index=[];
    for i=1:sizepop
        % ��ת���㷨��ת��Ⱥ��������ת��
        pick=rand; % ��ȡһ�������
        while pick==0
            pick=rand;
        end
        for j=1:sizepop
            % ����һ�����������Ӧֵ��ת�̵ı����Ĳ�����ѡ����
            % �п��ܻ��ظ�ѡ��ĳЩȾɫ�壬��ι���ظ�ѡ��
            pick=pick-sumf(j);
            if pick<0
                index=[index j];
                break; % ƥ�䵽һ��j���˳���ѭ��
            end
        end
    end
    individuals=individuals(index,:);
    fitness=fitness(index);
    ret=individuals;
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
        pick=rand(1,2);
        while prod(pick)==0
            % prod()����һ��Ԫ�أ���������Ƕ���Ԫ�أ���������ÿһ�У�Ȼ�����һ��Ԫ��
            % ���ｫ����һ��ֵ����������������ֵ�Ļ�����
            % һ��Ԫ����Ŀ�Ķ���������������������
            pick=rand(1,2);
        end
        index=ceil(pick.*sizepop); % ceil����ȡ��
        % ������ʾ����Ƿ���н������
        pick=rand;
        while pick==0
            pick=rand;
        end
        if pick>pcross
            % ����ѭ�������н������
            continue;
        end
        flag=0;
        while flag==0
           % ���ѡ�񽻲�λ��
           pick=rand;
           while pick==0
               pick=rand;
           end
           % ���ѡ����н����λ�ã���ѡ��ڼ����������н���
           % ����Ⱦɫ�彻���λ����ͬ
           pos=ceil(pick.*sum(lenchrom));
           pick=rand; % ���濪ʼ
           v1=chrom(index(1),pos);
           v2=chrom(index(2),pos);
           chrom(index(1),pos)=pick*v2+(1-pick)*v1;
           chrom(index(2),pos)=pick*v1+(1-pick)*v2; % �������
           flag1=test(lenchrom,bound,chrom(index(1),:)); % ����Ⱦɫ��1�Ŀ�����
           flag2=test(lenchrom,bound,chrom(index(2),:)); % ����Ⱦɫ��2�Ŀ�����
           if flag1*flag2==0
               flag=0; % ����Ⱦɫ����һ��������ʱ���ٴν��н������
           else
               flag=1; % �����ǿ��еģ������������
           end
        end
    end
    ret=chrom; % ���ؽ�����Ⱦɫ��
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
       pick=rand;
       while pick==0
           pick=rand;
       end
       index=ceil(pick*sizepop);
       % ������ʾ�������ѭ���Ƿ���б���
       pick=rand;
       if pick>pmutation
           continue;
       end
       flag=0;
       while flag==0
          % ����λ��
          pick=rand;
          while pick==0
              pick=rand;
          end
          pos=ceil(pick*sum(lenchrom)); % ���ѡ����Ⱦɫ������λ�ã���ѡ���˵�pos���������б���
          v=chrom(i,pos);
          v1=v-bound(pos,1);
          v2=bound(pos,2)-v;
          pick=rand; % ���쿪ʼ
          if pick>0.5
              delta=v2*(1-pick^((1-pop(1)/pop(2))^2));
              chrom(i,pos)=v+delta;
          else
              delta=v1*(1-pick^((1-pop(1)/pop(2))^2));
              chrom(i, pos)=v-delta;
          end % �������
          flag=test(lenchrom, bound, chrom(i,:)); % ����Ⱦɫ��Ŀ����ԣ������˳�����ѭ��
       end
    end
    ret=chrom;
end