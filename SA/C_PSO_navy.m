%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SL-PSO대신에 Classical PSO 를 돌리는 스크립트 입니다.
%% 원래 메인 부분 쯤에서 PSO는 함수가 아니라 그냥 스크립트 기반으로 돌아가네여 ㄷㄷ
%% 귀찮아서 한게 더 귀찮아 지는 군요 흐아니..
%% 2019년 12우러러러럴
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
p_best_pos = p;                 % p-best가 존재하는 위치정보도 가지고 있어보자

fitness = zeros(m,1);
p_best_val  = 1e200*ones(m,1);  % 처음에 p-best는 크게 정의
for k = 1:m
    fitness(k) = -1 * cost_func2(p(k,:)',ship_attack_radi,ship_energy,dt,n_u,n_s,L_cell,PL,spd_rel,bomb,hit_eff);
end
vel = zeros(m,n_u);
bestever = 1e200;               % 처음에 g-best도 크게 정의; 어차피 작아질테니까.

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
    idx_pbest_update = fitness < p_best_val;                   % 이전의  p-best 값보다 작으면 p-best 인덱스를 따놓기!
    p_best_val(idx_pbest_update) = fitness(idx_pbest_update);  % p-best 값을    업데이트 하고
    p_best_pos(idx_pbest_update,:) = p(idx_pbest_update,:);      % p-best 위치도  업데이트 하기
    
    [candi_g, idx_g] = min(fitness);
    if bestever > candi_g  % 새로운 후보가 더 작은지 (좋은지) ?
        bestever = candi_g;   % g_best_val도 어쩔 수 없이 이렇게 씀..
        bestp = p(idx_g,:);   % g_best_position을 bestp라고 씀.. 아쉽게도 기존 코드와 호환성을 위해서라면... 함수가 아니라서 ㅠ
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

