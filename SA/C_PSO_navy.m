%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SL-PSO��ſ� Classical PSO �� ������ ��ũ��Ʈ �Դϴ�.
%% ���� ���� �κ� �뿡�� PSO�� �Լ��� �ƴ϶� �׳� ��ũ��Ʈ ������� ���ư��׿� ����
%% �����Ƽ� �Ѱ� �� ������ ���� ���� ��ƴ�..
%% 2019�� 12�췯������
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Classic/ conventional particle swarm optimization by JYK

%% Settings
maxfe = n_u*5000;                                  % max fitness evaluation control!! BE FAIR!
m = 50;
w = 1.0;
c1 = 2.0;
c2 = 2.0;

%% Initialization
lu = [eps^10 * ones(1, n_u); n_s * ones(1, n_u)];  % lu: define the upper and lower bounds of the variables
XRRmin = repmat(lu(1, :), m, 1);
XRRmax = repmat(lu(2, :), m, 1);

p = XRRmin + (XRRmax - XRRmin) .* rand(m, n_u);
p_best_pos = p;                 % p-best�� �����ϴ� ��ġ������ ������ �־��

fitness = zeros(m,1);
p_best_val  = 1e200*ones(m,1);  % ó���� p-best�� ũ�� ����
for k = 1:m
    fitness(k) = -1 * cost_func2(p(k,:)',ship_attack_radi,ship_energy,dt,n_u,n_s,L_cell,PL,spd_rel,bomb,hit_eff);
end
vel = zeros(m,n_u);
bestever = 1e200;               % ó���� g-best�� ũ�� ����; ������ �۾����״ϱ�.

FES = m;
gen = 0;


%% Main Loop
tic;
while(FES < maxfe)
    % random settings
    rng('shuffle');
    r1 = rand(m,n_u);
    r2 = rand(m,n_u);
    
    % best updates
    idx_pbest_update = fitness < p_best_val;                   % ������  p-best ������ ������ p-best �ε����� ������!
    p_best_val(idx_pbest_update) = fitness(idx_pbest_update);  % p-best ����    ������Ʈ �ϰ�
    p_best_pos(idx_pbest_update,:) = p(idx_pbest_update,:);      % p-best ��ġ��  ������Ʈ �ϱ�
    
    [candi_g, idx_g] = min(fitness);
    if bestever > candi_g  % ���ο� �ĺ��� �� ������ (������) ?
        bestever = candi_g;   % g_best_val�� ��¿ �� ���� �̷��� ��..
        bestp = p(idx_g,:);   % g_best_position�� bestp��� ��.. �ƽ��Ե� ���� �ڵ�� ȣȯ���� ���ؼ����... �Լ��� �ƴ϶� ��
    end
    
    %
    
    % particle update
    vel = w*vel + c1*r1.*(p_best_pos-p) + c2*r2.*(repmat(bestp,m,1)-p);
    p   = p + vel;
    
    % boundary control
    for i = 1:m
        p(i,:) = max(p(i,:), lu(1,:));
        p(i,:) = min(p(i,:), lu(2,:));
    end
    
    % fitness evaluation
    for k = 1:m
        fitness(k) = -1 * cost_func2(p(k,:)',ship_attack_radi,ship_energy,dt,n_u,n_s,L_cell,PL,spd_rel,bomb,hit_eff);
    end
    FES = FES + m;  % fitness update
    
    % generation control
    gen = gen + 1;
    
end  % END: MAIN LOOP


%% Displaying
% check the duration
disp(['CPU time: ',num2str(toc),' C_PSO']);
% manage your memory
clear vel XRRmax XRRmin idx_pbest_update candi_g idx_g m w c1 c2 maxfe;

