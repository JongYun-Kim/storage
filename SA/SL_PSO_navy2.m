% This is just a script, not a function
% SL-PSO

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Implementation of a social learning PSO (SL-PSO) for scalable optimization
%%
%%  See the details of SL-PSO in the following paper
%%  R. Cheng and Y. Jin, A Social Learning Particle Swarm Optimization Algorithm for Scalable Pptimization,
%%  Information Sicences, 2014
%%
%%  The source code SL-PSO is implemented by Ran Cheng 
%%
%%  If you have any questions about the code, please contact: 
%%  Ran Cheng at r.cheng@surrey.ac.uk 
%%  Prof. Yaochu Jin at yaochu.jin@surrey.ac.uk
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    maxfe = n_u*5000;               %maxfe: maximal number of fitness evaluations
    lu = [eps^20 * ones(1, n_u); n_s * ones(1, n_u)];  % lu: define the upper and lower bounds of the variables

    %parameter initiliaztion
    M = 100;
    m = M + floor(n_u/10);
    c3 = n_u/M*0.01;
    P_L = zeros(m,1);

    for i = 1 : m
        P_L(i) = (1 - (i - 1)/m)^log(sqrt(ceil(n_u/M)));
    end

    % initialization
    XRRmin = repmat(lu(1, :), m, 1);
    XRRmax = repmat(lu(2, :), m, 1);
%     rand('seed', sum(100 * clock));
    p = XRRmin + (XRRmax - XRRmin) .* rand(m, n_u);
    fitness = zeros(m,1);
    for k = 1:m
        fitness(k) = -1 * cost_func2(p(k,:)',ship_attack_radi,ship_energy,dt,n_u,n_s,L_cell,PL,spd_rel,bomb,hit_eff);
%         fitness(k) = cost_func(p(k,:)',dam_sole,ship_attack_radi,ship_energy,dt,n_u,n_s,L_cell);
    end
    vel = zeros(m,n_u);
    bestever = 1e200;
    
    FES = m;
    gen = 0;

    tic;
    % main loop
    while(FES < maxfe)

        % population sorting
        [fitness, rank] = sort(fitness, 'descend');
        p = p(rank,:);
        vel = vel(rank,:);
        besty = fitness(m);
        bestp = p(m, :);
        bestever = min(besty, bestever);
        
        % center position
        center = ones(m,1)*mean(p);
        
        %random matrix 
        %rand('seed', sum(100 * clock));
        randco1 = rand(m, n_u);
        %rand('seed', sum(100 * clock));
        randco2 = rand(m, n_u);
        %rand('seed', sum(100 * clock));
        randco3 = rand(m, n_u);
        winidxmask = repmat((1:m)', [1 n_u]);
        winidx = winidxmask + ceil(rand(m, n_u).*(m - winidxmask));
        pwin = p;
        for j = 1:n_u
                pwin(:,j) = p(winidx(:,j),j);
        end
        
        % social learning
         lpmask = repmat(rand(m,1) < P_L, [1 n_u]);
         lpmask(m,:) = 0;
         v1 =  1*(randco1.*vel + randco2.*(pwin - p) + c3*randco3.*(center - p));
         p1 =  p + v1;
         
         vel = lpmask.*v1 + (~lpmask).*vel;         
         p = lpmask.*p1 + (~lpmask).*p;
         
         % boundary control
        for i = 1:(m-1)
            p(i,:) = max(p(i,:), lu(1,:));
            p(i,:) = min(p(i,:), lu(2,:));
        end
        
        % fitness evaluation
        for k = 1:(m-1)
            fitness(k) = (-1) * (cost_func2(p(k,:)',ship_attack_radi,ship_energy,dt,n_u,n_s,L_cell,PL,spd_rel,bomb,hit_eff));
%             fitness(k) = (cost_func(p(k,:)',dam_sole,ship_attack_radi,ship_energy,dt,n_u,n_s,L_cell));
        end
        FES = FES + m - 1;

        gen = gen + 1;
    end

    
    disp(['CPU time: ',num2str(toc)]);
    
    clear lpmask P_L pwin randco1 randco2 randco3 vel v1 winidx winidxmask XRRmax XRRmin
    