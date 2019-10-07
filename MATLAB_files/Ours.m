%% Read Me
% This script implements the proposed relay positioning algorithm in a
% simple relay chain for the sake of comparison with the conventional
% approaches since they are not able to be applied to multi-node cases.

clear all; close all; rng('shuffle');

%% �ó����� ����
sc_fier = false;
sc_many = true;
sc_artf = false;
sc_tot = sc_fier + sc_many + sc_artf;

if sc_tot ~= 1
    error('You must choose only one scnario');
end

%% User Controls and Preliminaries: define what you need and load what you want
% Definitions
NumRelay = 3; NumBase = 1; NumClient = 1;
% BasePosition = [ 13.3, 62.5 ];  % Base 1
BasePosition = [ 37.8, 25.9 ];  % Base 2 
% ClientPosition = [ 15.9, 57.7 ];  % ��ȭ�� ���
% ClientPosition = [ 14.7, 57.1 ];  % ��ȭ�� �ó�����2
ClientPosition = [ 14.4, 56.2 ];   % Ext���� ���̽�2��

% Communication performance evaluavtion metric
GMC  = false;
mGMC = false;   beta = 2;
WCC  = true;  %% in my opinion, WCC should be used for comparisions because Gao's method also uses it.
if (GMC + mGMC + WCC) ~= 1
    error('You must choose only one commmunication performance metric')
end

% PSO control
endCondition = 2;     % particle number and maxfe; normally 1 ~ 3  (avg 1.5)
maxfe_control = 0.5;  % maxfe * this; normally 0.3 ~ 1 (avg 0.5)
maxStagNum = 35;      % the number of the maximum iteration number without update (best particle stagnation)
% see_pso = false;      % true : shows the intermediates; otherwise, nothing shown
realRand = false;     % �� �������� ������ ��������(true) �ƴϸ� �� ���� ����ǥ ��������(false)
psoBound = [10,   22   ;  45,   60  ];  % ����
         % [ xmin ymin ;  xmax ymax ];


%% Build the Geometric Map
% get the map data
% �ݵ�� �׸��� ��������� ����� ����~ : ���� �ڵ�� �̸� �������� ���� ������ �� ���� ���پ��� => ���ϱ� �����͵� ���� ũ��
if sc_fier      % ��ȭ�� �ó����� �ε�
    load('./data/mapData8Fire.mat','unfreeMap','unfreeSpaceID','resolution');  % map8FSquared : 608x704 matrix (x,y) // surf(0:0.1:60.7, 0:0.1:70.3 , map8FSquared','LineStyle','none');
    ax_range = [8 25 43 64 0.01 1];
    psoBound = [8,   42   ;  25,   63  ];  % ��ȭ�� �ó�����
elseif sc_many  % ���� ��� �ó����� �ε�
    load('./data/mapData8F.mat','unfreeMap','unfreeSpaceID','resolution');  % map8FSquared : 608x704 matrix (x,y) // surf(0:0.1:60.7, 0:0.1:70.3 , map8FSquared','LineStyle','none');
    ax_range = [5 45 20 60 0.01 1];
    psoBound = [10,   22   ;  45,   60  ];
elseif sc_artf  % ���� �ó����� �ε�
    error('You must create the map of artf scnario');  % �� ����� ����� !!
    % �� ����� ������ ����� !!    % �� ����� ������ ����� !!    % �� ����� ������ ����� !!
    %load('./data/mapData8F.mat','unfreeMap','unfreeSpaceID','resolution');  % map8FSquared : 608x704 matrix (x,y) // surf(0:0.1:60.7, 0:0.1:70.3 , map8FSquared','LineStyle','none');
    ax_range = [0 60.7 0 70.3 0.01 1];
end
% % % load('./data/mapData8F.mat','unfreeMap','unfreeSpaceID','resolution');  % map8FSquared : 608x704 matrix (x,y) // surf(0:0.1:60.7, 0:0.1:70.3 , map8FSquared','LineStyle','none');


%% Build the Communication Map: (Channel prediction b/w the base and others)
%  getGPfunction;
gpGridMap(1:NumBase) = struct;
% load('./data/xb21_hyp.mat','mm'); gpGridMap(1).data = -mm; clear mm;  % gridMap�� ��ȯ�ؼ� �ӵ� ������
load('./data/xb28_hyp.mat','mm'); gpGridMap(1).data = -mm; clear mm;  % ������ ��ȯ�ؼ� ���� RSSI�� ��ȣ ����ȭ
% load('./data/xb29_hyp.mat','mm'); gpGridMap(1).data = -mm; clear mm;  % ���� �ް� �޸� ����


%% Communication Model (Channel prediction b/w mobile nodes)
load('./data/Comm_Model.mat');


%% Main Section: optimization for optimial positions of the nodes
% Run SL-PSO

% �ܺ� �Ķ���� ����
%d: dimensionality
d = 2*NumRelay;
%maxfe: maximal number of fitness evaluations
maxfe = d*5000*endCondition*maxfe_control;   % �ڵ� ���� �ð��� �ٲٷ��� �̰� ���������� �ٲٸ��. 5000d�� ���� �򰡿�; ������� ����� ������ ����

% lu: defines the upper and lower bounds of the variables = [lower(row) ,  upper(row)];
% lu = [ zeros(1, d);  repmat([mapMaxX, mapMaxY],1,NumRelay) ];
lu = repmat(psoBound,1,NumRelay);


% ���� �Ķ���� ����
%parameter initiliaztion
M = 100*endCondition;   m = M + floor(d/2);  % M + floor(d/10);  % ��ƼŬ ����
c3 = d/(M/endCondition)*0.01;
PL = zeros(m,1);  % �����ͷ� ũ�� ���� (�����Ҵ�)
for i = 1 : m
    PL(i) = (1 - (i - 1)/m)^(0.5*log(sqrt(ceil((40*d)/(M/endCondition)))));
end

% initialization
XRRmin = repmat(lu(1, :), m, 1);
XRRmax = repmat(lu(2, :), m, 1);
if realRand;  rng('shuffle');  end  % rand('seed', sum(100 * clock));
p = XRRmin + (XRRmax - XRRmin) .* rand(m, d);
fitness = fitEval4aLink(p,d,WCC,ClientPosition,gpGridMap,resolution,unfreeMap,unfreeSpaceID,model_params);
v = zeros(m,d);
bestever = 1e200;

FES = m;
gen = 0;

tic; pso_update = false; stag_count = 0;
% main loop
while(FES < maxfe)

    % population sorting
    [fitness, rank] = sort(fitness, 'descend');
    p = p(rank,:);
    v = v(rank,:);
    besty = fitness(m);
    bestp = p(m, :);
        if besty < bestever
            bestever = besty;
            best_p = bestp;
            pso_update = true;
            stag_count = 0;
        else
            pso_update = false;
            stag_count = stag_count + 1;
            if stag_count >= maxStagNum
                fprintf('The stagnation has occurred at the gen # = %d !!\n',gen)
                break;
            end
        end

    % center position
    center = ones(m,1)*mean(p);

    %random matrix 
    %rand('seed', sum(100 * clock));
    randco1 = rand(m, d);
    %rand('seed', sum(100 * clock));
    randco2 = rand(m, d);
    %rand('seed', sum(100 * clock));
    randco3 = rand(m, d);
    winidxmask = repmat((1:m)', [1 d]);
    winidx = winidxmask + ceil(rand(m, d).*(m - winidxmask));
    pwin = p;
    for j = 1:d
            pwin(:,j) = p(winidx(:,j),j);
    end

    % social learning
     lpmask = repmat(rand(m,1) < PL, [1 d]);
     lpmask(m,:) = 0;
     v1 =  1*(randco1.*v + randco2.*(pwin - p) + c3*randco3.*(center - p));
     p1 =  p + v1;   


     v = lpmask.*v1 + (~lpmask).*v;         
     p = lpmask.*p1 + (~lpmask).*p;

     % boundary control
    for i = 1:m - 1
        p(i,:) = max(p(i,:), lu(1,:));
        p(i,:) = min(p(i,:), lu(2,:));
    end


    % fitness evaluation  / removing tree calcuation may speed it up
    fitness(1:m-1, :)   = fitEval4aLink(p(1:m-1,:),d,WCC,ClientPosition,gpGridMap,resolution,unfreeMap,unfreeSpaceID,model_params);
    FES = FES + m - 1;
    
    gen = gen + 1;
    
    % asdf
    bestever_history(gen) = bestever;
    iteration(gen) = gen;
    
end  % PSO main loop ends

disp(['CPU time: ',num2str(toc)]);

% ���� ���! FEN�Ҹ� ����
% [fitness, post_connections] = fitEval4aLink(p,d,WCC,ClientPosition,gpGridMap,resolution,unfreeMap,unfreeSpaceID,model_params);
[fitness, rank] = sort(fitness, 'descend');    p = p(rank,:);
besty = fitness(m);   bestp = p(m, :);
if besty < bestever
    bestever = besty;
    best_p = bestp;
end

%% On Screen Results

% % % % [fitness, rank] = sort(fitness, 'descend');
% % % % p = p(rank,:);
% % % % v = v(rank,:);
% % % % besty = fitness(m);
% % % % bestp = p(m, :);
% % % % if besty < bestever
% % % %     bestever = besty;
% % % %     best_p = bestp;
% % % % end
% % % % [fitness, tree] = fitEval([repmat(reshape(initial_position_client',1,NumClient*2),m,1),p],(d+(2*NumClient)),GMC,mGMC,WCC,beta,Gn,gpGridNode,resolution,unfreeMap,unfreeSpaceID,model_params);

% Plot or save the results
% % % % if GMC
% % % %     disp('GMC')
% % % % elseif mGMC
% % % %     fprintf('mGMC,  beta = %d \n',beta);
% % % % else
% % % %     disp('WMC')
% % % % end
% % % % disp('best_p');        disp(best_p);
% % % % disp('bestever');      disp(bestever);
% % % % disp(tree(end).Gnr2);  disp('MST network w/o relays');
% % % % disp(-Gnc.*mst_tree_n);




%% Plots for the Results
% map plot
af = figure(2);
plot_map = surf(0:0.1:60.7,0:0.1:70.3,unfreeMap','LineStyle','None');
hold on; grid off;
legend_str = cell((NumRelay+NumBase+NumClient+1),1);
legend_str{1} = 'Map';

% relay plot
for i = 1:NumRelay
%     plot_relay(i) = plot3(best_p((2*i-1)),best_p((2*i)),1,'p','Color','r','MarkerSize',4,'LineWidth',4);
    plot_relay(i) = plot3(best_p((2*i-1)),best_p((2*i)),1,'p','MarkerSize',6,'LineWidth',4);
    legend_str{i+1} = ['Relay',num2str(i)];
end
% axis([0 60.7 0 70.3 0.01 1])
axis(ax_range);

% base plot
for i = 1:NumBase
    plot3(BasePosition(i,1),BasePosition(i,2),1,'o','Color','g','MarkerSize',6,'LineWidth',6)
    legend_str{i+1+NumRelay} = ['Base',num2str(i)];
end

% clietn plot
for i = 1:NumClient
%     plot3(initial_position_client(i,1),initial_position_client(i,2),1,'v','Color','b','MarkerSize',4,'LineWidth',4)
    plot3(ClientPosition(i,1),ClientPosition(i,2),1,'v','MarkerSize',6,'LineWidth',5)
    legend_str{i+1+NumRelay+NumBase} = ['Client',num2str(i)];
end

% plot setting
% colorbar;
colormap('gray');
ax = gca; ax.CLim = [0, 1.67];  ax.View = [0, 90];
ax.FontSize = 13;  ax.FontWeight = 'bold';
legend(legend_str); xlabel('x [m]'); ylabel('y [m]');
af.Position = [ 300, 250, 770, 730 ];


%% Save what you may be supposed to represent on the paper
