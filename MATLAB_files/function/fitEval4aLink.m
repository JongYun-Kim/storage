function [val, Sall] = fitEval4aLink(p,d,WCC,ClientPosition,gpGridMap,resolution,unfreeMap,unfreeSpaceID,model_params)
% fitness val을 반환함; 단일 링크에 대해서 작동함. GMC를 쓰거나 하려면 조금은 손봐야함 마지막에

% p : particles - (m x p) matrix
% d : dimension; d=2*NumRelays
% GMC, mGMC, WMC : communication performance metrics
%%%%% gpGridMap(1:Numnodes).data : gp grid data for fast computation instead of the gp functions
if ~WCC
    error('the WCC is only considered as the other methods can be implemented only in single link networks')
end
if ~~mod(d,2)
    error('the variable d must be an even number, Plz check it')
end


%% Parameter Settting
%NumNodes = size(p,1)+2;
NumRelay = d/2;
m = size(p,1);  % the swarm size
% C = repmat(model_params.C,m,1);
C = model_params.C;
nu = model_params.nu;
% nu = repmat(model_params.nu,m,1);
alpha = model_params.alpha_val;
mapSizeRowGridX = size(unfreeMap,1);  % 608
% % % mapSizeColGridY = size(unfreeMap,2);  % 704
see_warning = false;

% output 크기 사전할당
%val = -1*ones(m,1);    % 음수 있으면 디버깅 걸린거 니까 체크

too_close = -25;


%% Get the Signals
pall = [p, repmat(ClientPosition,m,1)];  % 릴레이랑 클라이언트 포지션 ( m by (d+2) 행렬 )
Sall = -1*ones(m,NumRelay+1);  % m by (NumRelay+2) 크기 행렬: 각 connection의 통신강도를 나타냄
    % 베이스의 경우에는 어차피 GP자체를 만들때 위치가 implicitly 고려되었기 때문에 생각하지 않아도 될듯

% GP-based Channel Prediction: Base to R1 x m times(particles)
R1_position = p(:,1:2);    % 각 행에 particle 별로 각 relay1의 (x,y) position있음
R1_position_gridID = gridID2(R1_position, resolution);
R1_position_gridID_short = R1_position_gridID(:,1) + ( (mapSizeRowGridX).*(R1_position_gridID(:,2)-1)) ;
% % % for i = 1:m
% % %     Sall(i,1) = gpGridMap.data(R1_position_gridID_short);  % 
% % % end
        Sall(:,1) = gpGridMap.data(R1_position_gridID_short);  % 

% Model-based Channel Prediction: Inter-relay and relay-client
for ptc = 1:m
    for i = 1:NumRelay
        [d1, d2] = sepDistance(pall(ptc,2*i-1),pall(ptc,2*i),pall(ptc,2*i+1),pall(ptc,2*i+2),unfreeMap,resolution,unfreeSpaceID);
        Sall(ptc,i+1) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % 음수의 실제값 반영
    end
end

%% Cost Computation

% if GMC
%     val = sum(Sall,2);
% elseif WCC
%     val = min(Sall,[],2);
% elseif mGMC
%     dd
% else
%     error('You must choose a specific comm perf metric')
% end

% WCC metric cost
val = -min(Sall,[],2);

% 랩으로 안들어가게 하려고 함 ㅠㅠ
if d==2
    sum_indt = p(:,1)+p(:,2);
    lab_idx = sum_indt>=79.0;
    val(lab_idx) = 100;
end


end % function end; do not care
