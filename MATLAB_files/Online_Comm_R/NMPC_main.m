global base_pos_meanfunc;

%% Main Loop
iter = 0; t = 0;
contCond = true;
oneTimeUse = true;
while(contCond)
    rng('shuffle');
    % Measurment & GP update
    
    for i = 1:NumBase
        z = getSignals(base_position(i,:),x(:,1:2),model_params_w_n);  % True 값을 정해서 노이즈 섞어 반환해줘야함; 시뮬레이션이니까; z = [ r(base1);, ... r(base#)] 열벡터
        GP(i).D = [ GP(i).D; x(:,1:2) ];
        GP(i).Y = [ GP(i).Y; z];
        GP(i).n = GP(i).n +1;
        base_pos_meanfunc = base_position(i,:);
        GP(i).hyp_learned = minimize(hyp, @gp, -100, inffunc_hyp_opt, GP(i).meanfunc, covfunc_hyp_opt, GP(i).likfunc, GP(i).D, GP(i).Y);
            % 파라미터 러닝할 때는 exact로 하는 것이 메뉴얼
%         GP(i).hyp_learned = minimize(hyp, @gp, -100, GP(i).inffunc, GP(i).meanfunc, GP(i).covfunc, GP(i).likfunc, GP(i).D, GP(i).Y);
            % 이것도 천천히 하고 싶긴한데 흠.. 이게 될지 파악해보자
        base_pos_meanfunc = [];
    end
    % Sparse or Exact GP?
    if GP(1).n > sparseSize          % sparsity가 요구될 때
        if oneTimeUse                % 한 번만 실행시키길
            isisSparse = true;       % sparsity 보여주고
            if isisSparse
                for i = 1:NumBase    % 베이스별 GP를 sparse setting으로 고치자
                    GP(i).covfunc  = covfuncSparse;
                    GP(i).inffunc  = inffuncSparse;
                end
            end
            oneTimeUse = false;      % 한 번 실행되면 더이상 실행 안됨
        end
    end
    
    % Communication map generation :: 그리드 상에서 관리하려고 만든 부분; gp호출이 많다아 느리다면 생성
    
    % Network configuration update :: 일단은 업데이트는 나중에 바로바로 해도될듯 어차피 horizon 내에서 계산할꺼 잖아;

    % Control input optimization
        % Defining search space: control input vector within the horizon
            % generation
            U_sys_pool = genCtrl(NumRelay,u_robot,true);
                % u_sys = 시스템컨트롤수NumSysControl x NumRelay :: 시스템의 컨트롤 풀
            U_idx_pool = genCtrl(horizonLength,idx_relay_to_system,true);
                % 가능한 모든 경우의 수 각각에 대하여 각 시간에서 시스템의 컨트롤 종류(인덱스)

            % obstacle avoidance

            % emergency backup
            
        % Static network computation for better use of memory on ur device
        NetOrg = getNetFull(base_position, client_position, GP, model_params_wo_n, []);

        % Cost computation
        cost = zeros(NumPossibleControl,5);  % 각 성분별 코스트를 남겨두기로함
        minCost = 1e99;  bestNet = [];
        for i = 1:NumPossibleControl
            u_idx_pool = U_idx_pool(i,:);  % horizon 전체에서 시스템의 컨트롤 번호들 == 이번 경우에 시스템의 컨트롤 인덱스들
            
            u_sys_over_horizon = (  U_sys_pool(u_idx_pool,:)  )';  % 이번 경우의 실제 쓰일 컨트롤 들
                % u_sys_over_horizon = (릴레이수) x (horizon길이):: 열벡터가 특정 시간에서 
                % 열벡터로 뽑으면 해당 시간대에서 릴레이들(시스템)의 컨트롤들

            [cost(i,:), mstNet] = costFunc(x,u_sys_over_horizon,sampleTime,relaySpd,maxAngRate,coeffNMPC,GP,model_params_wo_n,base_position,client_position,NetOrg,Xmin,Xmax,Ymin,Ymax,Qdist,isGMC);
            
            % optimal cost 찾기: 이전 모든 값중에 최소값이랑 비교해서 얼마나 작아지는지
            if cost(i,1) < minCost(1)  % 최소화 문제; Minimization!
                minCost = cost(i,:);
                u_opt_pool = u_sys_over_horizon;
                bestNet = mstNet;
            elseif cost(i,1) == minCost(1)
                % 같은거 중에 아무거나로
                if rand(1) < 0.5  % ~의 확률로 같을 때는 업데이트
                    minCost = cost(i,:);
                    u_opt_pool = u_sys_over_horizon;
                    bestNet = mstNet;
                end
            end
%             prevCost = cost(i,1);
        end

        % Optimal control
        u_opt = u_opt_pool(:,1);  % 첫번째만 실제로 작동하는 최적 컨트롤
        disp(u_opt_pool);
    
    % State update
    [del_x, del_y, del_ang] = posAngUpdate(x, u_opt, sampleTime, relaySpd);
    x = x + [ del_x, del_y, del_ang ];
    
    % Iteration update
    iter = iter +1;
    % Time update
    t = iter*sampleTime;
    
    % Terminal condition update
    if (iter >= MaxIter)
        contCond = false;
    elseif (true)
        contCond = true;
    else
        error('The endCond is not defined');
    end
    
    % Displaying info
    disp(iter)
    
    % HistData 저장
    data.x(:,iter)    = x(:,1);
    data.y(:,iter)    = x(:,2);
    data.psi(:,iter)  = x(:,3);
    data.t(:,iter)    = t;
    data.cost(:,iter) = minCost;
    data.u_opt(:,iter)= u_opt;
    data.NetFull{iter} = bestNet;
    
end

if isisSparse
    disp('The GP-SPARCITY has been made!');
end

