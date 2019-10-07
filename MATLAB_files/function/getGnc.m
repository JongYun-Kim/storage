function [Gnr, val, tree] = getGnr(model_based_node,NumModel,GMC,mGMC,WCC,beta,Gn,gpGridNode,resolution,unfreeMap,unfreeSpaceID,model_params)
% fitness val을 반환함; GPR_p실험에 맞게 되어 있음.

% model_based_node : model-based estimation nodes (NumModel x 2) matrix
% NumModel : the number of the agents who use model-based RSSI prediction
% GMC, mGMC, WMC : communication performance metrics
% Gn : Adj matrix b/w grounds
% gpGridNode(1:Numnodes).data : gp grid data for fast computation instead of the gp functions

%% Parameter settting
NumNodes = size(Gn,1);
m = 1;  % the swarm size
C = model_params.C;
nu = model_params.nu;
alpha = model_params.alpha_val;
mapSizeRowGridX = size(unfreeMap,1);  % 608
% % % mapSizeColGridY = size(unfreeMap,2);  % 704
see_warning = false;

% output 크기 사전할당
val = -1*ones(m,1);    % 음수 있으면 디버깅 걸린거 니까 체크
tree(m).Gnr2 = [];
% tree(m).PVnr = [];

too_close = -25;



for particle = 1:m  % 각 particle에 대해서,
    
%% Get Gnr matrix
%     model_based_node = reshape(model_based_node(particle,:),2,NumModel)';  % 각 행에 각 릴레이의 (x,y) position있음
    model_position_gridID = gridID2(model_based_node,resolution);
    model_position_gridID_short = model_position_gridID(:,1) + ( (mapSizeRowGridX).*(model_position_gridID(:,2)-1)) ;
    map_out_num = sum(unfreeMap(model_position_gridID_short));  % 몇 대의 릴레이가 맵 밖으로 나가있는지
    if map_out_num  % 만약에 맵 밖에 한 대 이상 있다면.
        if GMC
            val(particle,1) = 100*(NumNodes+NumModel);       % 로봇 갯수 만큼 최대 val으로 집어 넣기
            tree(particle).Gnr2 = zeros(NumNodes+NumModel);  % dummy tree 만듬 : 나중에 이거 맵 밖으로 나간 릴레이 있다고 알아서 생각하셈
        elseif mGMC
            val(particle,1) = 100*map_out_num*beta;          % 나간 릴레이만큼 안좋음. 적게 나가면 배울수는 있게 합시다.
            tree(particle).Gnr2 = zeros(NumNodes+NumModel);  % dummy tree
        elseif WCC
            val(particle,1) = 100;                           % 제일 작은 connection만 신경쓰니 그냥 100
            tree(particle).Gnr2 = zeros(NumNodes+NumModel);  % dummy tree
        else
            error('Check... why...!')
        end
        warning('there is a poor client somewhere');
%         continue;  % 일단 나쁜 애들이 있으면 평가 가치가 없음.
    end

    
    % Gnr의 GPR데이터에서 얻을 수 있는 부분 먼저 계산
    Gnr_ground_to_relay = -1*ones(NumNodes,NumModel);    % GPR데이터로 구할 수 있는 부분 (Gnr의 오른쪽 부분(아래 빼고))
% % %     for ground = 1:NumNodes
% % %         for relay = 1:NumRelay
% % %             Gnr_ground_to_relay(ground,relay) = gpGridNode(ground).data(relay_position_gridID(relay,1),relay_position_gridID(relay,2));            
% % %         end
% % %     end

    for ground = 1:NumNodes
        Gnr_ground_to_relay(ground,:) = gpGridNode(ground).data(model_position_gridID_short);
    end

    
    % Gnr의 모델으로 구해야하는 (릴레이간) 것에 대해서 계산
    Gnr_bw_relay = -1*ones(NumModel);   % Gnr의 우하단 정사각 행렬; 릴레이 간의 통신 adj 행렬 (음수행렬)
    for relay1 = 1: NumModel
        for relay2 = 1:NumModel
            if relay1==relay2
                Gnr_bw_relay(relay1,relay2) = 0;
            else
                [d1, d2] = sepDistance(model_based_node(relay1,1),model_based_node(relay1,2),model_based_node(relay2,1),model_based_node(relay2,2),unfreeMap,resolution,unfreeSpaceID);
                Gnr_bw_relay(relay1,relay2) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % 음수의 실제값 반영
                if Gnr_bw_relay(relay1,relay2) > too_close
                    if see_warning
                        warning('Relay %d와 Relay %d 사이의 거리가 너무 가깝습니다.\n      PSO 알고리즘이 제대로 돌아가는지 확인해야할 수 도 있습니다.',relay1,relay2);
                    end
                    Gnr_bw_relay(relay1,relay2) = too_close;  % 너무 가까우면 적당히 좋은값주고 말음 : 플러스로 가면 안좋아짐..
                end                    
            end
        end
    end
    
    Gnr = [Gn, Gnr_ground_to_relay; Gnr_ground_to_relay', Gnr_bw_relay];
    
%% Compute PV matrix
    % weight vectors
    weight_nr = Gnr(Gnr~=0); % weights of adj mat (vector form)

    % idx vectors => 2열로 바뀌어야함
    idx_nr = find(Gnr~=0);   % indicies of the non-zero adj mat, Gnr (vector form)

    % index vector to actual indices
    jnr = ceil(idx_nr/(NumNodes+NumModel));        % the column indicies of non-zero elements in Gnr
    inr = idx_nr - ((jnr-1)*(NumNodes+NumModel));  % the row    indicies of non-zero elements in Gnr

    % define PV mats
    PVnr = [inr, jnr, -weight_nr];  % PV mat, the input form of the MST algorithm

%% Get a MST set
    % run a MST algorithm
    [mst_w_nr, mst_tree_nr] = kruskal(PVnr);  % weight의 합을 최소화 해줌.
    
%% Compute Cost: cost저장은 어쨌든 양수로 해야 됨. minimization 문제 푸는거라서 일단..

    if GMC        % GMC metric 일 때 cost계산
        val(particle,1) = mst_w_nr;  % 전체 네트워크 다가 fitness :: 양수인지 꼭 확인하자
        tree(particle).Gnr2 = -Gnr.*mst_tree_nr;
    elseif mGMC   % mGMC metric 일 때 cost계산
        Gnr2 = -Gnr.*mst_tree_nr;              % 트리에 있는 값만 남기고 양수로 바꿈
        tree(particle).Gnr2 = Gnr2;
        MST_tree_weight = Gnr2(Gnr2>0);        % 0을 제거하고 벡터 형태로 바꿈
        mGMC_val = sort(MST_tree_weight(:),'descend');   % 그걸 정렬함
        val(particle,1) = sum(  mGMC_val(2:2:(2*beta))  );  % 그 중에 beta개수 만큼 남김
        %%%%%%%%%%%%%%%%%%%%%%%%%% mGMC_val 값이 실제로 어떻게 나오는지 좀 봐야함. 대칭인거 지워질수도있음!!!
        
    elseif WCC    % WMC metric 일 때 cost계산
        Gnr2 = -Gnr.*mst_tree_nr;              % 트리에 있는 값만 남기고 양수로 바꿈
        tree(particle).Gnr2 = Gnr2;
        MST_tree_weight = Gnr2(Gnr2>0);        % 0을 제거하고 벡터 형태로 바꿈
        mGMC_val = sort(MST_tree_weight(:),'descend');   % 그걸 정렬함
        val(particle,1) = sum(  mGMC_val(2)  );  % 그 중에 beta개수 만큼 남김
        %%%%%%%%%%%%%%%%%%%%%%%%%% mGMC_val 값이 실제로 어떻게 나오는지 좀 봐야함. 대칭인거 지워질수도있음!!!
    else
        error('you must put a certain comm perf metric')
    end
    
    
    
end % end particle for



end % function end; do not care
