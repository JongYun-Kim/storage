%% Read Me
% This script implements Gao's method

% Note: the method uses the shortest paths (smoothed and prunned)

clear all; close all; 
rng('shuffle');


%% 시나리오 선택
sc_fire = true;    if sc_fire;  mission = 2;  end
sc_many = false;     if sc_many;  mission = 1;  end
sc_artf = false;
sc_tot = sc_fire + sc_many + sc_artf;

if sc_tot ~= 1
    error('You must choose only one scnario');
end


%% Settings
NumRelay = 1;   NumBase = 1;   NumClient = 1;
if sc_many
    BasePosition = [ 37.8, 25.9 ];  % PLZ check if it corresponds to the GP map unless noGP = true.
    ClientPosition = [ 14.4, 56.2 ];
elseif sc_fire
    BasePosition = [ 13.3, 62.5 ];  % PLZ check if it corresponds to the GP map unless noGP = true.
    ClientPosition = [ 14.7, 57.1 ];  % 방화문 시나리오2
end

pruning = false;   % 짧은 거리로 감(true)
    if pruning
        pathtype = 1;  % 직선경로
    else
        pathtype = 2;  % 꼬불꼬불 경로
    end
MaxIter = 100;
NumPath = 5;
result_GaoExt(NumPath).val = 0;
result_GaoExt(NumPath).val_hist = 0;
NumTrial = 10;

noGP = false;  % GP없이 전부 모델로 할 경우!

% WCC is used as the communication performance metric since the paper does.


%% 결과 변수 생성
DATA_GaoExt = struct();
for trial = 1:NumTrial
    DATA_GaoExt(trial).WCC = [];
    DATA_GaoExt(trial).relay = [];
    DATA_GaoExt(trial).signals = [];
    DATA_GaoExt(trial).path = [];
end


%% The Geometric Map
% get the map data
% 반드시 그릴때 뒤집어줘야 제대로 나옴~ : 이전 코드는 미리 뒤집은걸 수도 있으니 잘 보고 갖다쓰기 => 보니까 이전것도 같은 크기
if sc_fire      % 방화문 시나리오 로드
    load('./data/mapData8Fire.mat','unfreeMap','unfreeSpaceID','resolution');  % map8FSquared : 608x704 matrix (x,y) // surf(0:0.1:60.7, 0:0.1:70.3 , map8FSquared','LineStyle','none');
    ax_range = [8 25 43 64 0.01 1];
elseif sc_many  % 복잡 경로 시나리오 로드
    load('./data/mapData8F.mat','unfreeMap','unfreeSpaceID','resolution');  % map8FSquared : 608x704 matrix (x,y) // surf(0:0.1:60.7, 0:0.1:70.3 , map8FSquared','LineStyle','none');
    ax_range = [5 45 20 60 0.01 1];
elseif sc_artf  % 인조 시나리오 로드
    error('You must create the map of artf scnario');  % 맵 만들고 지울것 !!
    % 맵 만들고 에러문 지울것 !!    % 맵 만들고 에러문 지울것 !!    % 맵 만들고 에러문 지울것 !!
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
if sc_many     % base2
    load('./data/xb28_hyp.mat','mm'); gpGridMap(1).data = -mm; clear mm;  % 음수로 변환해서 실제 RSSI의 부호 동질화
elseif sc_fire % base 1
    load('./data/xb21_hyp.mat','mm'); gpGridMap(1).data = -mm; clear mm;  % gridMap로 반환해서 속도 빠르게
end
% load('./data/xb29_hyp.mat','mm'); gpGridMap(1).data = -mm; clear mm;  % 변수 받고 메모리 관리


%% The Communication Model
load('./data/Comm_Model.mat');
    % Comm. model params
    C = model_params.C;
    nu = model_params.nu;
    alpha = model_params.alpha_val;


%% 몬테 카를로!
load('./data/path_data/AllPath.mat','Mission2');  Mission = Mission2; clear Mission2;
for trial = 1:NumTrial
    
    WCC_best = -100;  % 매 트라이얼 마다 최고인걸 구분 (NumPath의 갯수 중에 최고만을 가져감)
    clear resul_GaoExt;  % 매 트라이얼 마다 반복되니 그냥 지워버리자
    result_GaoExt(NumPath).val = 0;
    result_GaoExt(NumPath).val_hist = 0;
    
    %% RRT-path
%     tic;
    for i = 1:NumPath
%         pre_path = GetRRTStar(BasePosition,ClientPosition,pruning,unfreeMap,resolution,unfreeSpaceID);  % 스타가 아니라는 말도 있음
%         result_GaoExt(i).path = GetNewPath(pre_path(:,1:2));  % path를 적당히 잘라 세분화함: 인접 노드간 거리가 0.1보다 약간큼 보통 2% 이내
        if sc_fire
            path_idx = NumPath*(trial-1)+i;  % 앞에 50개는 버리고~
        elseif sc_many
            path_idx = 50 + NumPath*(trial-1)+i;  % 앞에 50개는 버리고~
        else
            error('omg')
        end
        result_GaoExt(i).path = Mission(mission).pathtype(pathtype).cases(path_idx).data;  % 경로는 미션과 경로타입별로 잘 선택하자
    end
%     disp(['RRT CPU time: ',num2str(toc)]);
    %inter_node_distance = pre_path(:,4);  % 각 노드 사이의 직선 거리 (LOS확보됨; pruning한거라서도)
    %pre_path = pre_path(:,1:2);  % x, y 좌표 각 얻음 벡터 컬럼


    %% Cost Computation
    for path_num = 1:NumPath
        path = result_GaoExt(path_num).path;
        path_length = size(path,1);  % 경로의 노드 개수
        %relay_node = zeros(NumRelay,2);   % 릴레이의 위치 정보
        relay_idx  = randperm((path_length-2),NumRelay)'+1;  % 릴레이 초기 위치를 위한 RRT위의 인덱스 (앞 뒤는 뺌
            relay_idx  = sort(relay_idx);   % 순서대로 배치 (원래 안해도 되긴함..)
        relay_idx_hist = [relay_idx, zeros(NumRelay,MaxIter)];

        relay_node = path(relay_idx,:);  % 릴레이 초기 위치 지정: path위에 랜덤으로 위치

        Sall = -100*ones(NumRelay+1, 1);  %시그널 퀄리티 벡터 사전 할당
        Sall_hist = [ Sall, -100*ones(NumRelay+1, MaxIter)];  % MatIter 보다 1 크게 저장-- 초기값 때문에

        val = -100;
        val_hist  = [val; -100*ones(MaxIter,1)];  % MatIter 보다 1 크게 저장-- 초기값 때문에

        best_idx = relay_idx;
        best_Sall = Sall;
        best_val = val;
        best_val_hist = [];

        % Main Loop
        for iter = 1:MaxIter
            % Cost update if not prematurely terminated
            val = min(Sall);
            val_hist(iter) = val;
            % Sall의 경우 계산을 안해봐서 업데이트 안됨:: 나중에 뒤에서 업데이트

            % Best update
            if best_val < val
                best_idx  = relay_idx;
                best_Sall = Sall; 
                best_val  = val;
            end

            % GP-based channel prediction: Base to R1 x m times(particles)
            if noGP   % 모델만 쓰는 경우
                [d1, d2] = sepDistance(BasePosition(1,1),BasePosition(1,2),relay_node(1,1),relay_node(1,2),unfreeMap,resolution,unfreeSpaceID);
                Sall(1) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % 음수의 실제값 반영
            else      % GP도 쓰는 경우
                R1_position = relay_node(1,:);    % 각 행에 particle 별로 각 relay1의 (x,y) position있음
                R1_position_gridID = gridID2(R1_position, resolution);
                R1_position_gridID_short = R1_position_gridID(:,1) + ( (mapSizeRowGridX).*(R1_position_gridID(:,2)-1)) ;
                Sall(1) = gpGridMap.data(R1_position_gridID_short);
            end

            % Model-based channel prediction
            for j = 2:NumRelay
                [d1, d2] = sepDistance(relay_node(j-1,1),relay_node(j-1,2),relay_node(j,1),relay_node(j,2),unfreeMap,resolution,unfreeSpaceID);
                Sall(j) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % 음수의 실제값 반영
            end
            j = NumRelay+1;  % 릴레이 마지막과 클라이언트의 경우
            [d1, d2] = sepDistance(relay_node(j-1,1),relay_node(j-1,2),ClientPosition(1,1),ClientPosition(1,2),unfreeMap,resolution,unfreeSpaceID);
            Sall(j) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % 음수의 실제값 반영
            Sall_hist(:,iter) = Sall;

            % Relay migration: relay_node(idx of path) update
            Sdiff = ceil( Sall(1:end-1) - Sall(2:end) );  % 시그널 차이값
            relay_idx = relay_idx + Sdiff;  % relay 인덱스 업데이트
%                 relay_idx = relay_idx + (repmat(randperm(19,1),NumRelay,1)-9);  % 랜덤항목 추가
            relay_idx(relay_idx>=path_length) = path_length-1;
            relay_idx(relay_idx<=1) = 2;
            if ~issorted(relay_idx)  % 순서가 꼬이면 알려주세요!!
                warning('The relays are placed in an unsorted order: current_iter = %d',iter);
            end
            JB_flag = false;  % 중복 플래그
            for now_idx = 1:NumRelay-1
                for rmd_idx = now_idx+1:NumRelay
                    if relay_idx(now_idx) == relay_idx(rmd_idx)   % 같은 값이 있다면--
                        relay_idx(rmd_idx) = relay_idx(rmd_idx)+1;  % 1씩 더해줌
                        JB_flag = true;
                    else
                        break;  % 어차피 정렬 순이라서 다른 값이 나오면 큰값만 남은거고 볼 필요 없음
                    end
                end
            end
            if JB_flag  % 중복이 탐지되면 워닝워닝
                warning('릴레이가 겹쳤습니다. 왜죠?')
            end
            relay_node = path(relay_idx,:);  % 릴레이 위치 업데이트
            relay_idx_hist(:,iter+1) = relay_idx;

            % Terminal condictions : % 전체 진동은 잡지 않고 일단 단순 1회 진동 으로 찾음
            if isequal(relay_idx,relay_idx_hist(:,iter))         % 직전 스텝에 같은 값이 나옴
                warning('Converged earlier than it is meant to be at %d',iter-1);
                val_hist = val_hist(1:iter+1);  % cost histroy 끊어서 저장
                break;
            elseif iter>1
                if isequal(relay_idx,relay_idx_hist(:,iter-1))  % 전전 스텝에 같은 값이 나옴: 진동(주기2)
                    warning('The relays are oscillating with the period number 2 and first oscl completed at %d',iter-1);
                    val_hist = val_hist(1:iter+1);                % cost history 저장
                    break;
                end
            end


        end

        % GP-based channel prediction: Base to R1 x m times(particles)
        if noGP   % 모델만 쓰는 경우
            [d1, d2] = sepDistance(BasePosition(1,1),BasePosition(1,2),relay_node(1,1),relay_node(1,2),unfreeMap,resolution,unfreeSpaceID);
            Sall(1) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % 음수의 실제값 반영
        else      % GP도 쓰는 경우
            R1_position = relay_node(1,:);    % 각 행에 particle 별로 각 relay1의 (x,y) position있음
            R1_position_gridID = gridID2(R1_position, resolution);
            R1_position_gridID_short = R1_position_gridID(:,1) + ( (mapSizeRowGridX).*(R1_position_gridID(:,2)-1)) ;
            Sall(1) = gpGridMap.data(R1_position_gridID_short);
        end

        % Model-based channel prediction
        for j = 2:NumRelay
            [d1, d2] = sepDistance(relay_node(j-1,1),relay_node(j-1,2),relay_node(j,1),relay_node(j,2),unfreeMap,resolution,unfreeSpaceID);
            Sall(j) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % 음수의 실제값 반영
        end
        j = NumRelay+1;  % 릴레이 마지막과 클라이언트의 경우
        [d1, d2] = sepDistance(relay_node(j-1,1),relay_node(j-1,2),ClientPosition(1,1),ClientPosition(1,2),unfreeMap,resolution,unfreeSpaceID);
        Sall(j) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % 음수의 실제값 반영
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
        best_val_hist = [best_val_hist, best_val];

    %% Results
    % disp(val);
    % disp(Sall);
    %disp(best_idx);
    %disp(best_val);
        result_GaoExt(path_num).val_hist = val_hist;
        result_GaoExt(path_num).relay_idx_hist = relay_idx_hist;
        result_GaoExt(path_num).best_val = best_val;
        result_GaoExt(path_num).best_idx = best_idx;
        result_GaoExt(path_num).best_Sall = best_Sall;
        result_GaoExt(path_num).best_relay = path(best_idx,:);
        
        if WCC_best < best_val
            % 결과 저장
            DATA_GaoExt(trial).WCC = best_val;
            DATA_GaoExt(trial).relay = path(best_idx,:);
            DATA_GaoExt(trial).signals = best_Sall;
            DATA_GaoExt(trial).path = path;
        end

    end
    
    
%% 몬테 끗
end


%% Plots
% map plot
af = figure(2);
plot_map = surf(0:0.1:60.7,0:0.1:70.3,unfreeMap','LineStyle','None');
hold on; grid off;
legend_str = cell((1+1+1+(NumTrial)+(NumTrial*NumRelay)),1);
legend_str{1} = 'Map';

% base plot
for i = 1:NumBase
    plot3(BasePosition(i,1),BasePosition(i,2),1,'o','Color','g','MarkerSize',6,'LineWidth',6)
    legend_str{1+i} = ['Base',num2str(i)];
end

% clietn plot
for i = 1:NumClient
%     plot3(initial_position_client(i,1),initial_position_client(i,2),1,'v','Color','b','MarkerSize',4,'LineWidth',4)
    plot3(ClientPosition(i,1),ClientPosition(i,2),1,'v','MarkerSize',6,'LineWidth',5)
    legend_str{1+1+i} = ['Client',num2str(i)];
end

% path plot
for trial = 1:NumTrial
    path = Mission(mission).pathtype(pathtype).cases(trial).data;
    path_length = size(path,1);
    plot3(path(:,1),path(:,2),ones(path_length,1),'LineWidth',1.4);
    legend_str{1+1+1+trial} = ['Path',num2str(trial)];
end

% relay plot
for trial = 1:NumTrial
    for i = 1:NumRelay
        rx = DATA_GaoExt(trial).relay(i,1);
        ry = DATA_GaoExt(trial).relay(i,2);
        plot3(rx,ry,1,'p','MarkerSize',5,'LineWidth',4);
        legend_str{1+1+1+(NumTrial)+((trial-1)*NumRelay+i)} = ['Relay',num2str(trial),num2str(i)];
    end
end
% axis([0 60.7 0 70.3 0.01 1])
axis(ax_range);


% plot setting
% colorbar;
colormap('gray');
ax = gca; ax.CLim = [0, 1.67];  ax.View = [0, 90];
ax.FontSize = 13;  ax.FontWeight = 'bold';
legend(legend_str); xlabel('x [m]'); ylabel('y [m]');
af.Position = [ 300, 250, 770, 730 ];

yy = [];
for i = 1:NumTrial
yy(i,1) = DATA_GaoExt(i).WCC;
end
fprintf('mean = %f , std = %f \n', mean(yy), std(yy));
disp(yy);