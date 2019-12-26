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
    % �� UAV�� �� ship���� �� �� ������ ��쿡 ���ؼ� ������� �� �޶���
    dx = repmat(ship_position(:,1)',n_u,1) - repmat(uav_position(:,1),1,n_s);
    dy = repmat(ship_position(:,2)',n_u,1) - repmat(uav_position(:,2),1,n_s);   % n_u x n_s matrix : i���� uav_i�� �� ����� ��ġ ����
    uav_heading_ang = atan2(dy,dx);                                             % n_u x n_s matrix % the direction of uav with respect to x-axis, ranged by [-pi +pi]
    bomb = repmat(1.0,n_u,1);        % n_u column vector
    v = 36;                                           % UAV speed
    hit_eff = repmat(0.9,n_u,1);  % n_u column vector   % hit probability of the uav (even though a uav is still alive just around a ship, sometimes it can't hit the ship.)

    sigma = 0.05;
    
%% Search Space Generation
    % Search Space�� Gene expression���� �Ǿ� ������, UAV���� ���� Ship�� ��ȣ�� ������� ����.
    % �ٲ㸻�ϸ�, UAV�� �Ҵ�� Ship�� ��ȣ���� variables in the S.S. �� �ǰ� S.S.�� ũ��(������ ����)�� UAV����.
    % ����, UAV1~3�� ���� Ship1,2 �� 1,1,2���� �Ҵ��� �Ǿ��ٸ� genome(candidate solution)�� [1 1 2]�� �ȴ�.
    % ����, ��� ship 2�� �Ҵ��� �ȴٸ�, genome = [2 2 2];
    % �� ����(UAV)�� bound�� 1~ship���� �̴�.
    

%% Cost Formulation
    % cost_func���� �����Ͽ� ����Ѵ�.
    % [fitness, indiv] = cost_func(x,dam_sole,r,dt,n_u,n_s,L_cell)
    % �� ��Ʈ�� cost_func�� UAV-���� combat model�� �����Ѵ�. (i.e. combat model�� �ٲ�� �� ��Ʈ�� cost_func�� �ٲ�����
    
    L_cell = getLeff_mat2(dx,dy,ship_attack_radi);                     % get effective length through which each uav passes
    spd_rel = getVrel_mat2(v,uav_heading_ang,ship_speed,ship_heading); % n_u x n_s matrix % get relative speed
    
    PL = zeros(n_u,n_s);  % n_u x n_s matrix  % �� uav�� �� ship���� �Ҵ� ������ ����&��ȭ ȿ���� ���� ���¿��� PL��
    for i = 1:n_u
        PL(i,:) = (K_P * L_cell{i})';
    end
    
    dt = cell(n_u,1);
    for agent = 1:n_u
        D = zeros(n_s);
        for target = 1:n_s  % when a uav goes to each ship
            x_t = dx(agent,target);  % ���α⿡�� Ÿ���� x���� �Ÿ�
            y_t = dy(agent,target);  % ���α⿡�� Ÿ���� y���� �Ÿ�
            d_t = ( abs( y_t.*dx(agent,:) - x_t.*dy(agent,:) ) ) / ( sqrt( x_t^2 + y_t^2 ) ) ; % row vector % �� �迡�� ���α� ��α����� �����Ÿ�
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
    PL_unc = zeros(n_u,n_s);  % n_u x n_s matrix  % �� uav�� �� ship���� �Ҵ� ������ ����&��ȭ ȿ���� ���� ���¿��� PL��
    for i = 1:n_u
        PL_unc(i,:) = (K_P_unc * L_cell_unc{i})';
    end
    
    % get info. with uncertainty
    [dam_tot_unc, dam_each_unc] = cost_func2(bestp,ship_attack_radi_unc,ship_energy,dt,n_u,n_s,L_cell_unc,PL_unc,spd_rel,bomb,hit_eff_unc);

end