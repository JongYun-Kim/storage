%% Read Me
% This script implements Gao's method

% Note: the method uses the shortest paths (smoothed and prunned)

clear all; close all; rng('shuffle');

%% �ó����� ����
sc_fier = false;
sc_many = true;
sc_artf = false;
sc_tot = sc_fier + sc_many + sc_artf;

if sc_tot ~= 1
    error('You must choose only one scnario');
end


%% Settings
NumRelay = 1;   NumBase = 1;   NumClient = 1;
% BasePosition = [ 13.3, 62.5 ];  % PLZ check if it corresponds to the GP map unless noGP = true.
BasePosition = [ 37.8, 25.9 ];  % PLZ check if it corresponds to the GP map unless noGP = true.
% ClientPosition = [ 15.9, 57.7 ];  % ��ȭ�� �ó�����
% ClientPosition = [ 14.7, 57.1 ];  % ��ȭ�� �ó�����2
ClientPosition = [ 14.4, 56.2 ];
pruning = true;   % ª�� �Ÿ��� ��(true)// �̰� ��� pruning�� �ƴϰ� waypoint reduction��...
MaxIter = 100;
NumPath = 1;

noGP = false;  % GP���� ���� Model-based (--)�� �� ���!

% WCC is used as the communication performance metric since the paper does.


%% The Geometric Map
% get the map data
% �ݵ�� �׸��� ��������� ����� ����~ : ���� �ڵ�� �̸� �������� ���� ������ �� ���� ���پ��� => ���ϱ� �����͵� ���� ũ��
if sc_fier      % ��ȭ�� �ó����� �ε�
    load('./data/mapData8Fire.mat','unfreeMap','unfreeSpaceID','resolution');  % map8FSquared : 608x704 matrix (x,y) // surf(0:0.1:60.7, 0:0.1:70.3 , map8FSquared','LineStyle','none');
    ax_range = [8 25 43 64 0.01 1];
elseif sc_many  % ���� ��� �ó����� �ε�
    load('./data/mapData8F.mat','unfreeMap','unfreeSpaceID','resolution');  % map8FSquared : 608x704 matrix (x,y) // surf(0:0.1:60.7, 0:0.1:70.3 , map8FSquared','LineStyle','none');
    ax_range = [0 60.7 0 70.3 0.01 1];
elseif sc_artf  % ���� �ó����� �ε�
    error('You must create the map of artf scnario');  % �� ����� ����� !!
    % �� ����� ������ ����� !!    % �� ����� ������ ����� !!    % �� ����� ������ ����� !!
    %load('./data/mapData8F.mat','unfreeMap','unfreeSpaceID','resolution');  % map8FSquared : 608x704 matrix (x,y) // surf(0:0.1:60.7, 0:0.1:70.3 , map8FSquared','LineStyle','none');
    ax_range = [0 60.7 0 70.3 0.01 1];
end
% % % load('./data/mapData8F.mat','unfreeMap','unfreeSpaceID','resolution');  % map8FSquared : 608x704 matrix (x,y) // surf(0:0.1:60.7, 0:0.1:70.3 , map8FSquared','LineStyle','none');
    % Map params
    mapSizeRowGridX = size(unfreeMap,1);  % 608
    % % % mapSizeColGridY = size(unfreeMap,2);  % 704


%% The Communication Map
%  getGPfunction;
gpGridMap(1:NumBase) = struct;
% load('./data/xb21_hyp.mat','mm'); gpGridMap(1).data = -mm; clear mm;  % gridMap�� ��ȯ�ؼ� �ӵ� ������
load('./data/xb28_hyp.mat','mm'); gpGridMap(1).data = -mm; clear mm;  % ������ ��ȯ�ؼ� ���� RSSI�� ��ȣ ����ȭ
% load('./data/xb29_hyp.mat','mm'); gpGridMap(1).data = -mm; clear mm;  % ���� �ް� �޸� ����


%% The Communication Model
load('./data/Comm_Model.mat');
    % Comm. model params
    C = model_params.C;
    nu = model_params.nu;
    alpha = model_params.alpha_val;

    
%% RRT-path
tic;
pre_path = GetRRTStar(BasePosition,ClientPosition,pruning,unfreeMap,resolution,unfreeSpaceID);  % ��Ÿ�� �ƴ϶�� ���� ����
disp(['RRT CPU time: ',num2str(toc)]);
%inter_node_distance = pre_path(:,4);  % �� ��� ������ ���� �Ÿ� (LOSȮ����; pruning�ѰŶ󼭵�)
%pre_path = pre_path(:,1:2);  % x, y ��ǥ �� ���� ���� �÷�

path = GetNewPath(pre_path(:,1:2));  % path�� ������ �߶� ����ȭ��: ���� ��尣 �Ÿ��� 0.1���� �ణŭ ���� 2% �̳�

% % % % % % ����� ���� ����� ���
% % % % % % load('tempPath_sn01_r3.mat');
% % % % % load('AllPath.mat','Mission');


%% Cost Computation
path_length = size(path,1);  % ����� ��� ����
%relay_node = zeros(NumRelay,2);   % �������� ��ġ ����
relay_idx  = randperm((path_length-2),NumRelay)'+1;  % ������ �ʱ� ��ġ�� ���� RRT���� �ε��� (�� �ڴ� ��
    relay_idx  = sort(relay_idx);   % ������� ��ġ (���� ���ص� �Ǳ���..)
relay_idx_hist = [relay_idx, zeros(NumRelay,MaxIter)];

relay_node = path(relay_idx,:);  % ������ �ʱ� ��ġ ����: path���� �������� ��ġ

Sall = -100*ones(NumRelay+1, 1);  %�ñ׳� ����Ƽ ���� ���� �Ҵ�
Sall_hist = [ Sall, -100*ones(NumRelay+1, MaxIter)];  % MatIter ���� 1 ũ�� ����-- �ʱⰪ ������

val = -100;
val_hist  = [val; -100*ones(MaxIter,1)];  % MatIter ���� 1 ũ�� ����-- �ʱⰪ ������

best_idx = relay_idx;
best_Sall = Sall;
best_val = val;
best_val_hist = [];

% Main Loop
for iter = 1:MaxIter
    % Cost update if not prematurely terminated
    val = min(Sall);
    val_hist(iter) = val;
    % Sall�� ��� ����� ���غ��� ������Ʈ �ȵ�:: ���߿� �ڿ��� ������Ʈ
    
    % Best update
    if best_val < val
        best_idx  = relay_idx;
        best_Sall = Sall; 
        best_val  = val;
    end
    
    % GP-based channel prediction: Base to R1 x m times(particles)
    if noGP   % �𵨸� ���� ���
        [d1, d2] = sepDistance(BasePosition(1,1),BasePosition(1,2),relay_node(1,1),relay_node(1,2),unfreeMap,resolution,unfreeSpaceID);
        Sall(1) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % ������ ������ �ݿ�
    else      % GP�� ���� ���
        R1_position = relay_node(1,:);    % �� �࿡  �� relay1�� (x,y) position����
        R1_position_gridID = gridID2(R1_position, resolution);
        R1_position_gridID_short = R1_position_gridID(:,1) + ( (mapSizeRowGridX).*(R1_position_gridID(:,2)-1)) ;
        Sall(1) = gpGridMap.data(R1_position_gridID_short);
    end
    
    % Model-based channel prediction
    for j = 2:NumRelay
        [d1, d2] = sepDistance(relay_node(j-1,1),relay_node(j-1,2),relay_node(j,1),relay_node(j,2),unfreeMap,resolution,unfreeSpaceID);
        Sall(j) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % ������ ������ �ݿ�
    end
    j = NumRelay+1;  % ������ �������� Ŭ���̾�Ʈ�� ���
    [d1, d2] = sepDistance(relay_node(j-1,1),relay_node(j-1,2),ClientPosition(1,1),ClientPosition(1,2),unfreeMap,resolution,unfreeSpaceID);
    Sall(j) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % ������ ������ �ݿ�
    Sall_hist(:,iter) = Sall;
    
    % Relay migration: relay_node(idx of path) update
    Sdiff = ceil( Sall(1:end-1) - Sall(2:end) );  % �ñ׳� ���̰�
    relay_idx = relay_idx + Sdiff;  % relay �ε��� ������Ʈ
    relay_idx(relay_idx>=path_length) = path_length-1;
    relay_idx(relay_idx<=1) = 2;
    if ~issorted(relay_idx)  % ������ ���̸� �˷��ּ���!!
        warning('The relays are placed in an unsorted order: current_iter = %d',iter);
    end
    JB_flag = false;  % �ߺ� �÷���
    for now_idx = 1:NumRelay-1
        for rmd_idx = now_idx+1:NumRelay
            if relay_idx(now_idx) == relay_idx(rmd_idx)   % ���� ���� �ִٸ�--
                relay_idx(rmd_idx) = relay_idx(rmd_idx)+1;  % 1�� ������
                JB_flag = true;
            else
                break;  % ������ ���� ���̶� �ٸ� ���� ������ ū���� �����Ű� �� �ʿ� ����
            end
        end
    end
    if JB_flag  % �ߺ��� Ž���Ǹ� ���׿���
        warning('�����̰� ���ƽ��ϴ�. ����?')
    end
    relay_node = path(relay_idx,:);  % ������ ��ġ ������Ʈ
    relay_idx_hist(:,iter+1) = relay_idx;
    
    % Terminal condictions : % ��ü ������ ���� �ʰ� �ϴ� �ܼ� 1ȸ ���� ���� ã��
    if isequal(relay_idx,relay_idx_hist(:,iter))         % ���� ���ܿ� ���� ���� ����
        fprintf('Converged earlier than it is meant to be at %d \n',iter-1);
        val_hist = val_hist(1:iter+1);  % cost histroy ��� ����
        break;
    elseif iter>1
        if isequal(relay_idx,relay_idx_hist(:,iter-1))  % ���� ���ܿ� ���� ���� ����: ����(�ֱ�2)
            warning('The relays are oscillating with the period number 2 and first oscl completed at %d',iter-1);
            val_hist = val_hist(1:iter+1);                % cost history ����
            break;
        end
    end
    
    
end

    % GP-based channel prediction: Base to R1 x m times(particles)
    if noGP   % �𵨸� ���� ���
        [d1, d2] = sepDistance(BasePosition(1,1),BasePosition(1,2),relay_node(1,1),relay_node(1,2),unfreeMap,resolution,unfreeSpaceID);
        Sall(1) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % ������ ������ �ݿ�
    else      % GP�� ���� ���
        R1_position = relay_node(1,:);    % �� �࿡ particle ���� �� relay1�� (x,y) position����
        R1_position_gridID = gridID2(R1_position, resolution);
        R1_position_gridID_short = R1_position_gridID(:,1) + ( (mapSizeRowGridX).*(R1_position_gridID(:,2)-1)) ;
        Sall(1) = gpGridMap.data(R1_position_gridID_short);
    end
    
    % Model-based channel prediction
    for j = 2:NumRelay
        [d1, d2] = sepDistance(relay_node(j-1,1),relay_node(j-1,2),relay_node(j,1),relay_node(j,2),unfreeMap,resolution,unfreeSpaceID);
        Sall(j) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % ������ ������ �ݿ�
    end
    j = NumRelay+1;  % ������ �������� Ŭ���̾�Ʈ�� ���
    [d1, d2] = sepDistance(relay_node(j-1,1),relay_node(j-1,2),ClientPosition(1,1),ClientPosition(1,2),unfreeMap,resolution,unfreeSpaceID);
    Sall(j) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % ������ ������ �ݿ�
    Sall_hist(:,iter+1) = Sall;
    
    % Cost update if not prematurely terminated
    val = min(Sall);
    val_hist(iter+1) = val;

    % Best update
    if best_val < val
        best_idx  = relay_idx;
        best_Sall = Sall; 
        best_val  = val;
    end

%% Results
% disp(val);
% disp(Sall);
disp(best_idx);
disp(best_val);

%% Plots
% map plot
af = figure(2);
plot_map = surf(0:0.1:60.7,0:0.1:70.3,unfreeMap','LineStyle','None');
hold on; grid off;
legend_str = cell((NumRelay+NumBase+NumClient+1+NumPath),1);
legend_str{1} = 'Map';

% path plot
for i = 1:NumPath
    plot3(path(:,1),path(:,2),ones(path_length,1),'LineWidth',2.5);
    legend_str{1+i} = ['Path',num2str(i)];
end

% relay plot
for i = 1:NumRelay
    plot_relay(i) = plot3(path(best_idx(i),1),path(best_idx(i),2),1,'p','MarkerSize',6,'LineWidth',4);
    legend_str{1+NumPath+i} = ['Relay',num2str(i)];
end
% axis([0 60.7 0 70.3 0.01 1])
axis(ax_range);

% base plot
for i = 1:NumBase
    plot3(BasePosition(i,1),BasePosition(i,2),1,'o','Color','g','MarkerSize',6,'LineWidth',6)
    legend_str{1+NumPath+NumRelay+i} = ['Base',num2str(i)];
end

% clietn plot
for i = 1:NumClient
%     plot3(initial_position_client(i,1),initial_position_client(i,2),1,'v','Color','b','MarkerSize',4,'LineWidth',4)
    plot3(ClientPosition(i,1),ClientPosition(i,2),1,'v','MarkerSize',6,'LineWidth',5)
    legend_str{1+NumPath+NumRelay+NumBase+i} = ['Client',num2str(i)];
end

% plot setting
% colorbar;
colormap('gray');
ax = gca; ax.CLim = [0, 1.67];  ax.View = [0, 90];
ax.FontSize = 13;  ax.FontWeight = 'bold';
legend(legend_str); xlabel('x [m]'); ylabel('y [m]');
af.Position = [ 300, 250, 770, 730 ];