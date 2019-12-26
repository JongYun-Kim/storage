function [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_2(n_u)      %uav_list,ship_list,n_u,n_s,sigma)

%% Information Settings
    rng('shuffle') % random seed generator
    
    % Ship infomation
    ship_speed = 15; % 15 ;                    % speed of ships[m/s]
    ship_heading = pi;                          % heading angle of the swarm of ships ranged by [-pi +pi]
    ship_position = [4500,500; 4500,-500; 5500,500; 5500,-500] ; % 2 column vectrors [Xs,Ys] % position of the ships when they meet uavs [m]
    n_s = size(ship_position,1) ;     % the number of ships (targets)
    ship_attack_radi = repmat(750,1,n_s);        % row vector % radius of attack zones of ships [m]
    ship_energy = repmat(4,1,n_s);               % relative energies of ships
    K_P = repmat(0.1452,1,n_s);                        % row vector  % killing ability of a ship [uav/s]
%     K_P = ship_spd_model(ship_speed,K_P);
    
    % UAV infomation
    uav_position = cir([5000,0],5000,n_u); % 2 column vectors [Xs,Ys]
%     n_u = size(uav_position,1);
    % 각 UAV가 각 ship으로 갈 때 각각의 경우에 대해서 헤딩각이 다 달라짐
    dx = repmat(ship_position(:,1)',n_u,1) - repmat(uav_position(:,1),1,n_s);
    dy = repmat(ship_position(:,2)',n_u,1) - repmat(uav_position(:,2),1,n_s);   % n_u x n_s matrix : i행은 uav_i가 각 배와의 위치 차이
    uav_heading_ang = atan2(dy,dx);                                             % n_u x n_s matrix % the direction of uav with respect to x-axis, ranged by [-pi +pi]
    bomb = repmat(1.0,n_u,1);        % n_u column vector
    v = 36;                                           % UAV speed
    hit_eff = repmat(0.9,n_u,1);  % n_u column vector   % hit probability of the uav (even though a uav is still alive just around a ship, sometimes it can't hit the ship.)

    sigma = 0.05;
    
%% Search Space Generation
    % Search Space는 Gene expression으로 되어 있으며, UAV별로 배당된 Ship의 번호를 순서대로 쓴다.
    % 바꿔말하면, UAV에 할당된 Ship의 번호들이 variables in the S.S. 가 되고 S.S.의 크기(문제의 차원)는 UAV개수.
    % 가령, UAV1~3이 각각 Ship1,2 중 1,1,2으로 할당이 되었다면 genome(candidate solution)은 [1 1 2]가 된다.
    % 또한, 모두 ship 2로 할당이 된다면, genome = [2 2 2];
    % 각 차원(UAV)의 bound는 1~ship개수 이다.
    

%% Cost Formulation
    % cost_func으로 정의하여 사용한다.
    % [fitness, indiv] = cost_func(x,dam_sole,r,dt,n_u,n_s,L_cell)
    % 이 파트와 cost_func은 UAV-함정 combat model에 의존한다. (i.e. combat model이 바뀌면 이 파트와 cost_func이 바뀌어야함
    
    L_cell = getLeff_mat2(dx,dy,ship_attack_radi);                     % get effective length through which each uav passes
    spd_rel = getVrel_mat2(v,uav_heading_ang,ship_speed,ship_heading); % n_u x n_s matrix % get relative speed
    
    PL = zeros(n_u,n_s);  % n_u x n_s matrix  % 각 uav가 각 ship으로 할당 됐을때 교란&포화 효과가 없는 상태에서 PL값
    for i = 1:n_u
        PL(i,:) = (K_P * L_cell{i})';
    end
    
    dt = cell(n_u,1);
    for agent = 1:n_u
        D = zeros(n_s);
        for target = 1:n_s  % when a uav goes to each ship
            x_t = dx(agent,target);  % 무인기에서 타겟의 x성분 거리
            y_t = dy(agent,target);  % 무인기에서 타겟의 y성분 거리
            d_t = ( abs( y_t.*dx(agent,:) - x_t.*dy(agent,:) ) ) / ( sqrt( x_t^2 + y_t^2 ) ) ; % row vector % 각 배에서 무인기 경로까지의 수직거리
            D(target,:) = d_t;
        end
        dt{agent} = D;
    end
    clear x_t y_t d_t D;
    

%% Optimization Algorithm

    % SL-PSO implementation
    SL_PSO_navy2;
    [bestever, indiv] = cost_func2(bestp,ship_attack_radi,ship_energy,dt,n_u,n_s,L_cell,PL,spd_rel,bomb,hit_eff);

%% Solution Returns

    assignment = ceil(bestp);
    damage_tot = bestever;
    damage_each = indiv;
    clear indiv bestever;

%% Uncertatinty treatment

    % imposing uncertainty
    K_P_unc = K_P .* normrnd(1,sigma,[1,n_s]);
    ship_attack_radi_unc = ship_attack_radi .* normrnd(1,sigma,[1,n_s]);
    hit_eff_unc = hit_eff .* normrnd(1,sigma,[n_u,1]);
    % negative no. management
    mask01 = K_P_unc < 0;                 K_P_unc = K_P_unc.*(~mask01);
    mask02 = ship_attack_radi_unc < 0;    ship_attack_radi_unc = ship_attack_radi_unc.*(~mask02);
    mask03 = hit_eff_unc < 0;             hit_eff_unc = hit_eff_unc.*(~mask03);
    
    % set the parameters with uncertainty
    L_cell_unc = getLeff_mat2(dx,dy,ship_attack_radi_unc);
    PL_unc = zeros(n_u,n_s);  % n_u x n_s matrix  % 각 uav가 각 ship으로 할당 됐을때 교란&포화 효과가 없는 상태에서 PL값
    for i = 1:n_u
        PL_unc(i,:) = (K_P_unc * L_cell_unc{i})';
    end
    
    % get info. with uncertainty
    [dam_tot_unc, dam_each_unc] = cost_func2(bestp,ship_attack_radi_unc,ship_energy,dt,n_u,n_s,L_cell_unc,PL_unc,spd_rel,bomb,hit_eff_unc);

end