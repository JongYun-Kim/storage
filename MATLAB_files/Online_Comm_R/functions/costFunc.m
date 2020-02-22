function [cost, NetFull_next] = costFunc(current_state,u,dt,spd,maxAngRate,coeffNMPC,GP,model_params,base_position,client_position,NetOrg,Xmin,Xmax,Ymin,Ymax,Qdist,isGMC)
% returns the cost
% INPUT current_state = [ x, y, psi ]:: (NumRelay) x (3)
%       u = (NumRelay) x (horizonLength)
%       dt = sampling time
% OUTPUT cost = [ total, comm, GPvar, dynamics ]
    
    global base_pos_meanfunc

    [NumRelay, horizonLength] = size(u);
    NumBase = size(GP,2);
    NumClient = size(client_position,1);
    NumNodes = NumBase + NumClient +NumRelay;
    x = current_state;
    cost = [   0,      0,     0,      0,        0       ];  % cost intialization
%            total   Comm   GPvar  dynamics   potential
    
    [del_x, del_y, del_ang] = posAngUpdate(current_state, u, dt, spd);
    
    % 시간별 위치계산
    x_temp_tot = zeros(NumRelay*horizonLength,3);
    for t = 1:horizonLength
        % state 업데이트
% % %         for i = 1:NumRelay
% % %             idx = (i-1)*horizonLength + t;
% % %             x_temp_tot(idx,:) = x + [ del_x(i,t), del_y(i,t), del_ang(i,t) ];
% % %         end
        x_temp = x + [ del_x(:,t), del_y(:,t), del_ang(:,t) ];
        x_temp_tot( (NumRelay*(t-1)+1):NumRelay*t, : ) = x_temp;  % 시스템을 시간순으로 배열
        
        % comm cost computation: GMC
        if t == 1
            [temp, NetFull_next]   = commCostFunc(base_position, client_position, x_temp(:,1:2), GP, model_params, NetOrg,isGMC);
        
        else
            [temp]   = commCostFunc(base_position, client_position, x_temp(:,1:2), GP, model_params, NetOrg,isGMC);
        end
        cost(2) = cost(2) - temp;
                % GMC를 구한거라서 minimization 문제에 넣으려면 -1을 곱해야 더 좋은 네트워크 선택 가능
    end
    if isGMC
        cost(2) = cost(2) / (horizonLength*(NumNodes-1));  % 시간길이당 링크당 평균 코스트(GMC)
    else
        cost(2) = cost(2) / (horizonLength);  % 시간길이당 평균 코스트(WCC)
    end
    
    % GPvar cost computation
    for i = 1:NumBase  % 각 베이스 별로 GP가 있으니까
        z = x_temp_tot(:,1:2);  % 애들의 모든 좌표들을 모아냄
        base_pos_meanfunc = base_position(i,:);
        [~, s2] = gp(GP(i).hyp_learned, GP(i).inffunc, GP(i).meanfunc, GP(i).covfunc, GP(i).likfunc, GP(i).D, GP(i).Y, z);
        cost(3) = cost(3) + sum(s2);  % 분산의 합을 구함
    end
    base_pos_meanfunc = [];
    cost(3) = cost(3) / (NumBase*NumRelay*horizonLength*(-1));  % 평균적인 값을 얻기 위해: 릴레이하나가 특정 GP에서 한 스탭당 얻을 수 잇는 양
                % 분산값의 합이라서 양수인데 큰것을 찾아다니기 위해 minimization 문제를 풀어야하니까 (-1)을 곱해야함
    
    % dynamics cost computation
    cost(4) = sum(sum( u.^2 ))/(horizonLength*NumRelay*(maxAngRate^2));  % 릴레이와 시간으로 나눠줌 >> coefficient 통일
    
    % potential field penalty computation
    cost(5) = costPF(z,Xmin,Xmax,Ymin,Ymax,Qdist)/(NumRelay*horizonLength);
    
    % cost with coefficient
    cost(1) = cost(2:5) * coeffNMPC;  % 행렬 곱인데 스칼라로 잘 나오는지, 적절하게 곱해지는지 확인해야 할 듯
    

end