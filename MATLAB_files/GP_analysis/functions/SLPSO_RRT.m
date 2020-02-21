%% 외부 파라미터 세팅
%d: dimensionality
d = NumR;  % = NumR;
%maxfe: maximal number of fitness evaluations
maxfe = d*5000;

%% 피트니스 함수 정의
n = d;
        % lu: define the upper and lower bounds of the variables
% lu = [-100 * ones(1, n); 100 * ones(1, n)];
lu = repmat([0.5; size(path,1)+0.4999],1,NumR);  % 모든 파티클은 노드번호를 가진다 1~갯수까지

%% 내부 파라미터 세팅
%parameter initiliaztion
M = 100;
m = M + floor(d/2);  % M + floor(d/10);
c3 = d/M*0.01;
PL = zeros(m,1);

for i = 1 : m
    PL(i) = (1 - (i - 1)/m)^log(sqrt(ceil(d/M)));
end

%% 초기화
% initialization
XRRmin = repmat(lu(1, :), m, 1);
XRRmax = repmat(lu(2, :), m, 1);
rand('seed', sum(100 * clock));
p = XRRmin + (XRRmax - XRRmin) .* rand(m, d);
% fitness = fit_func_RRT(path,p,NumR,p_client,gpr,model_params,unfreeMap,resolution,unfreeSpaceID);
fitness = fit_func_RRT2(path,p,NumR,p_client,GPR_signal_BR,model_params,unfreeMap,resolution,unfreeSpaceID);
v = zeros(m,d);
bestever = 1e200;

FES = m;
gen = 0;

%% 메인 루프
tic;
% main loop
while(FES < maxfe)


    % population sorting
    [fitness, rank] = sort(fitness, 'descend');
    p = p(rank,:);
    v = v(rank,:);
    besty = fitness(m);
    bestp = p(m, :);
        if besty < bestever
            bestever = besty;
            best_p = bestp;
        end
%     bestever = min(besty, bestever);

    % center position
    center = ones(m,1)*mean(p);

    %random matrix 
    %rand('seed', sum(100 * clock));
    randco1 = rand(m, d);
    %rand('seed', sum(100 * clock));
    randco2 = rand(m, d);
    %rand('seed', sum(100 * clock));
    randco3 = rand(m, d);
    winidxmask = repmat((1:m)', [1 d]);
    winidx = winidxmask + ceil(rand(m, d).*(m - winidxmask));
    pwin = p;
    for j = 1:d
            pwin(:,j) = p(winidx(:,j),j);
    end

    % social learning
     lpmask = repmat(rand(m,1) < PL, [1 d]);
     lpmask(m,:) = 0;
     v1 =  1*(randco1.*v + randco2.*(pwin - p) + c3*randco3.*(center - p));
     p1 =  p + v1;   


     v = lpmask.*v1 + (~lpmask).*v;         
     p = lpmask.*p1 + (~lpmask).*p;

     % boundary control
    for i = 1:m - 1
        p(i,:) = max(p(i,:), lu(1,:));
        p(i,:) = min(p(i,:), lu(2,:));
    end


    % fitness evaluation
%     fitness(1:m - 1,:) = fit_func_RRT(path,p(1:m - 1,:),NumR,p_client,gpr,model_params,unfreeMap,resolution,unfreeSpaceID); % yao_func(p(1:m - 1,:), funcid);
    fitness(1:m - 1,:) = fit_func_RRT2(path,p(1:m - 1,:),NumR,p_client,GPR_signal_BR,model_params,unfreeMap,resolution,unfreeSpaceID);
%     fprintf('Best fitness: %e\n', bestever); 
    FES = FES + m - 1;

    gen = gen + 1;
end

%% 결과 도시
disp(['CPU time: ',num2str(toc)]);