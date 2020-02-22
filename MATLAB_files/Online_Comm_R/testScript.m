% % % % clear all; close all;
% % % % 
% % % % %% Settings
% % % % 
% % % % % Agent numbers
% % % % NumRelay  = 4;
% % % % 
% % % % % Relay dynamics
% % % % angMaxRate = 1.0;  % relay maximum angular rate [rad/s]
% % % % NumControl = 2;    % �� ���� ��Ʈ�ѷ� �ɰ���
% % % % NumSysControl = NumControl^NumRelay;  % ������ ���� �ϳ��� �ý������� �� �� ������ ��Ʈ���� ���� 
% % % % % idx_relay_to_system = linspace(1,NumSysControl,NumSysControl);
% % % % idx_relay_to_system = [1:NumSysControl]';
% % % %         % �� �����ʹ� ������ �����븦 �ϳ��� �ý������� ����
% % % %         % �� �ý����� ���� �� �ִ� ��� ������ ����� ���� ��Ÿ���� ��Ʈ������ �ε����� ��Ÿ���� ����.
% % % %         % ex) ������2�� ��Ʈ��3���� �̸� 
% % % % u_robot = getRobotControls(NumControl,angMaxRate);  % a set of control inputs [rad/s]: angular rate! not the heading
% % % % 
% % % % % NMPC
% % % % horizonLength = 3;
% % % % NumPossibleControl = (NumControl)^(NumRelay*horizonLength);
% % % % 
% % % % %%
% % % % 
% % % % % Control input optimization
% % % %         % Defining search space: control input vector within the horizon
% % % %             % generation
% % % %             U_sys_pool = genCtrl(NumRelay,u_robot,true);
% % % %                 % u_sys = �ý�����Ʈ�Ѽ�NumSysControl x NumRelay :: �ý����� ��Ʈ�� Ǯ
% % % %             U_idx_pool = genCtrl(horizonLength,idx_relay_to_system,true);
% % % %                 % ������ ��� ����� �� ������ ���Ͽ� �� �ð����� �ý����� ��Ʈ�� ����(�ε���)
% % % % 
% % % % clear NumRelay angMaxRate NumControl NumSysControl idx_relay_to_system horizonLength
% % % %                 
% % % %         % Cost computation
% % % %         for i = 1:NumPossibleControl
% % % %             u_idx_pool = ( U_idx_pool(i,:) );  % horizon ��ü���� �ý����� ��Ʈ�� ��ȣ�� == �̹� ��쿡 �ý����� ��Ʈ�� �ε�����
% % % %               +
% �຤�Ϳ����� �����ͷ� �ٲپ����� �����϶�
% % % %             u_sys_over_horizon = (  U_sys_pool(u_idx_pool,:)  )';  % �̹� ����� ���� ���� ��Ʈ�� ��
% % % %                 % u_sys_over_horizon = (�����̼�) x (horizon����):: �����Ͱ� Ư�� �ð����� 
% % % %         end


% % % % % % % % %%
% % % % % % % % clear; close all;
% % % % % % % % 
% % % % % % % % for horizonLength = 1:2:5  % 1, 3, 5
% % % % % % % %     for Numplots_in_sim = 1:8
% % % % % % % %         clearvars -except Numplots_in_sim horizonLength;
% % % % % % % %         close all;
% % % % % % % %         rng('shuffle');
% % % % % % % %         
% % % % % % % %         Params_NMPC;
% % % % % % % %         NMPC_main;
% % % % % % % %         NMPC_plots;
% % % % % % % % 
% % % % % % % %         name1 = ['./images/SetParams_B2R2H',num2str(horizonLength),'_',num2str(Numplots_in_sim)];
% % % % % % % %         name2 = [name1, '_GP1'];
% % % % % % % %         name3 = [name1, '_GP2'];
% % % % % % % % 
% % % % % % % %         hgexport(figure(1), sprintf(name1), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % % % % % %         hgexport(figure(2), sprintf(name2), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % % % % % %         hgexport(figure(3), sprintf(name3), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % % % % % %     end
% % % % % % % % end
% % % % % % % % 
% % % % % % % % horizonLength = 6;
% % % % % % % %     for Numplots_in_sim = 1:8
% % % % % % % %         clearvars -except Numplots_in_sim horizonLength;
% % % % % % % %         close all;
% % % % % % % %         rng('shuffle');
% % % % % % % %         
% % % % % % % %         Params_NMPC;
% % % % % % % %         NMPC_main;
% % % % % % % %         NMPC_plots;
% % % % % % % % 
% % % % % % % %         name1 = ['./images/SetParams_B2R2H',num2str(horizonLength),'_',num2str(Numplots_in_sim)];
% % % % % % % %         name2 = [name1, '_GP1'];
% % % % % % % %         name3 = [name1, '_GP2'];
% % % % % % % % 
% % % % % % % %         hgexport(figure(1), sprintf(name1), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % % % % % %         hgexport(figure(2), sprintf(name2), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % % % % % %         hgexport(figure(3), sprintf(name3), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % % % % % %     end


%% ���ƴ�
global base_pos_meanfunc;
MaxIter = 185;

% Main Loop
% iter = 0; t = 0;
contCond = true;
% oneTimeUse = true;
while(contCond)
    rng('shuffle');
    % Measurment & GP update
    
    for i = 1:NumBase
        z = getSignals(base_position(i,:),x(:,1:2),model_params_w_n);  % True ���� ���ؼ� ������ ���� ��ȯ�������; �ùķ��̼��̴ϱ�; z = [ r(base1);, ... r(base#)] ������
        GP(i).D = [ GP(i).D; x(:,1:2) ];
        GP(i).Y = [ GP(i).Y; z];
        GP(i).n = GP(i).n +1;
        base_pos_meanfunc = base_position(i,:);
        GP(i).hyp_learned = minimize(hyp, @gp, -100, inffunc_hyp_opt, GP(i).meanfunc, covfunc_hyp_opt, GP(i).likfunc, GP(i).D, GP(i).Y);
            % �Ķ���� ������ ���� exact�� �ϴ� ���� �޴���
%         GP(i).hyp_learned = minimize(hyp, @gp, -100, GP(i).inffunc, GP(i).meanfunc, GP(i).covfunc, GP(i).likfunc, GP(i).D, GP(i).Y);
            % �̰͵� õõ�� �ϰ� �ͱ��ѵ� ��.. �̰� ���� �ľ��غ���
        base_pos_meanfunc = [];
    end
% % %     % Sparse or Exact GP?
% % %     if GP(1).n > sparseSize          % sparsity�� �䱸�� ��
% % %         if oneTimeUse                % �� ���� �����Ű��
% % %             isisSparse = true;       % sparsity �����ְ�
% % %             if isisSparse
% % %                 for i = 1:NumBase    % ���̽��� GP�� sparse setting���� ��ġ��
% % %                     GP(i).covfunc  = covfuncSparse;
% % %                     GP(i).inffunc  = inffuncSparse;
% % %                 end
% % %             end
% % %             oneTimeUse = false;      % �� �� ����Ǹ� ���̻� ���� �ȵ�
% % %         end
% % %     end
% % %     
    % Communication map generation :: �׸��� �󿡼� �����Ϸ��� ���� �κ�; gpȣ���� ���ٸ� ����
    
    % Network configuration update :: �ϴ��� ������Ʈ�� ���߿� �ٷιٷ� �ص��ɵ� ������ horizon ������ ����Ҳ� �ݾ�;

    % Control input optimization
        % Defining search space: control input vector within the horizon
            % generation
            U_sys_pool = genCtrl(NumRelay,u_robot,true);
                % u_sys = �ý�����Ʈ�Ѽ�NumSysControl x NumRelay :: �ý����� ��Ʈ�� Ǯ
            U_idx_pool = genCtrl(horizonLength,idx_relay_to_system,true);
                % ������ ��� ����� �� ������ ���Ͽ� �� �ð����� �ý����� ��Ʈ�� ����(�ε���)

            % obstacle avoidance

            % emergency backup
            
        % Static network computation for better use of memory on ur device
        NetOrg = getNetFull(base_position, client_position, GP, model_params_wo_n, []);

        % Cost computation
        cost = zeros(NumPossibleControl,5);  % �� ���к� �ڽ�Ʈ�� ���ܵα����
        minCost = 1e99;  bestNet = [];
        for i = 1:NumPossibleControl
            u_idx_pool = U_idx_pool(i,:);  % horizon ��ü���� �ý����� ��Ʈ�� ��ȣ�� == �̹� ��쿡 �ý����� ��Ʈ�� �ε�����
            
            u_sys_over_horizon = (  U_sys_pool(u_idx_pool,:)  )';  % �̹� ����� ���� ���� ��Ʈ�� ��
                % u_sys_over_horizon = (�����̼�) x (horizon����):: �����Ͱ� Ư�� �ð����� 
                % �����ͷ� ������ �ش� �ð��뿡�� �����̵�(�ý���)�� ��Ʈ�ѵ�

            [cost(i,:), mstNet] = costFunc(x,u_sys_over_horizon,sampleTime,relaySpd,maxAngRate,coeffNMPC,GP,model_params_wo_n,base_position,client_position,NetOrg,Xmin,Xmax,Ymin,Ymax,Qdist,isGMC);
            
            % optimal cost ã��: ���� ��� ���߿� �ּҰ��̶� ���ؼ� �󸶳� �۾�������
            if cost(i,1) < minCost(1)  % �ּ�ȭ ����; Minimization!
                minCost = cost(i,:);
                u_opt_pool = u_sys_over_horizon;
                bestNet = mstNet;
            elseif cost(i,1) == minCost(1)
                % ������ �߿� �ƹ��ų���
                if rand(1) < 0.5  % ~�� Ȯ���� ���� ���� ������Ʈ
                    minCost = cost(i,:);
                    u_opt_pool = u_sys_over_horizon;
                    bestNet = mstNet;
                end
            end
%             prevCost = cost(i,1);
        end

        % Optimal control
        u_opt = u_opt_pool(:,1);  % ù��°�� ������ �۵��ϴ� ���� ��Ʈ��
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
    disp('asdf')
    
    % HistData ����
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