% Loop control
MaxIter = 40;  % Check it as to whether validity

% Agent numbers
NumRelay  = 2;
NumBase   = 2;
NumClient = 0;

% Network performance metric
% isGMC = true;
isGMC = false;

% Relay dynamics
sampleTime = 0.5;  % sampleing time [s]
relaySpd   = 1.0;  % relay speed [m/s]
maxAngRate = 1.0;  % relay maximum angular rate [rad/s]
NumControl = 3;    % 몇 개의 컨트롤로 쪼갤지
NumSysControl = NumControl^NumRelay;  % 릴레이 셋을 하나의 시스템으로 볼 때 가능한 컨트롤의 갯수 
% idx_relay_to_system = linspace(1,NumSysControl,NumSysControl);
idx_relay_to_system = (1:NumSysControl)';
        % 이 열벡터는 릴레이 여러대를 하나의 시스템으로 보고
        % 그 시스템이 택할 수 있는 모든 움직임 경우의 수를 나타내는 매트릭스의 인덱스를 나타내고 있음.
        % ex) 릴레이2대 컨트롤3가지 이면 
u_robot = getRobotControls(NumControl,maxAngRate);  % a set of control inputs [rad/s]: angular rate! not the heading

% NMPC
horizonLength = 2;
NumPossibleControl = (NumControl)^(NumRelay*horizonLength);
p_hr = 100.0;     % NMPC coefficient for communication
q_hr = 0.1;    % NMPC coefficient for GP variance
r_hr = 0;    % NMPC coefficient for dynamics
h_hr = 100;    % NMPC coefficient for potential field (에타요)
coeffNMPC = [ p_hr; q_hr; r_hr; h_hr ];

% Map setting
Xmin = -25;    Xmax =  25;
Ymin = -25;    Ymax =  25;
MapBound = [ Xmin, Xmax, Ymin, Ymax ];
Qdist = 2.0;  % 포텐셜 필드에서 그거 안전반경

% Agent Positions
base_position   = randGenPos(NumBase,MapBound,500,25);  % random generation
client_position = randGenPos(NumClient,MapBound);       % random generation
temp_dist_bc = zeros(NumBase,NumClient);  % 각 베이스와 클라이언트 사이의 거리
for i = 1:NumBase
    for j = 1:NumClient
        temp_dist_bc(i,j) = sqrt(  (base_position(i,1)-client_position(j,1)).^2 + (base_position(i,2)-client_position(j,2)).^2   );
    end
end
% base_position   = [-18  0;
%                     18  0];
% client_position = [ 15  0];
disp(min(min(temp_dist_bc)));  % the minimum distance between a base and a client: 너무 가까우면 안됨...
    clear temp_dist_bc;
disp(MapBound);

% GP meanfunction (PathLoss model)
% global base_pos_meanfunc

% Data hist
data.x    = zeros(NumRelay,MaxIter);
data.y    = zeros(NumRelay,MaxIter);
data.psi  = zeros(NumRelay,MaxIter);
data.t    = zeros(1,MaxIter);
data.cost = zeros(5,MaxIter);
data.u_opt= zeros(NumRelay,MaxIter);
data.NetFull = cell(MaxIter,1);

% GP map params
    % sparsity
    sparseDensity = 1.8;
    isisSparse = false;

    % covariance function
%     covfunc_hyp_opt = {@covSEiso};   sf = 2; ell = 1.0; hyp.cov = log([ell;sf]);
    covfunc_hyp_opt = {@covSEiso};   sf = 2; ell = 1.0; hyp.cov = log([ell;sf]);
    xu = genIndPoints(MapBound,sparseDensity,Qdist);  sparseSize = size(xu,1);  % inducing inputs
    covfuncSparse =  {'apxSparse',covfunc_hyp_opt,xu};

    % likelihood function
    likfunc = {@likGauss};   sn = 0.6;   hyp.lik = log(sn);
    
    % inference function
    inffunc_hyp_opt = @infGaussLik;
    inffuncSparse = @(varargin) inffunc_hyp_opt(varargin{:},struct('s',1.0));           % FITC, opt.s = 1

    % mean function
    meanfunc = @meanPathloss;          hyp.mean = [2.0; -27.0];
%     meanfunc = @meanConst;  c = -75;  hyp.mean = c;  % const mean
%     meanfunc = []; % zero  mean


%% Environments
% Communication model
load('./data/Comm_Model.mat');


%% Initialization
% State initialization
% STATE: x = [ x_pos; y_pos; heading ];  % 릴레이별로 행벡터
for i=1:NumRelay
    % randome generation of relay initial positions
    x0 = [ randGenPos(NumRelay,MapBound), 0*ones(NumRelay,1) ];
end
%         x0 = [-12, 4, -pi/2 ];  % 임시로 릴레이 한 대 일때 그냥 임의로 하는거 ㅋㅋ
%             x0 = [  -21,   10,  -pi/2;
%                      21,   -10,  (pi/2)];
x = x0; % state initialization
    

% Measurment intialization
for i = 1:NumBase
    GP(i).D = [];  % GP 학습 데이터 인풋   행렬 [ ...; x(k) y(k); ... ];
    GP(i).Y = [];  % GP 학습 데이터 아웃풋 벡터 [ ...; r(k); ... ];
    GP(i).n = 0 ;  % the number of input data
    GP(i).covfunc  = covfunc_hyp_opt;  % 처음 시작은 일단 insparse로 합시다 어차피 갯수 몇개 없잖아.
    GP(i).likfunc  = likfunc;
    GP(i).meanfunc = meanfunc;
    GP(i).inffunc  = inffunc_hyp_opt;  % 처음 시작은 일단 insparse로 합시다 어차피 갯수 몇개 없잖아.
end

% hyp_learned = minimize(hyp, @gp, -100, @infExact, [], covfunc, likfunc, x, Y);
% exp(hyp2.lik)
% [m s2] = gp(hyp_learned, @infExact, [], covfunc, likfunc, x, Y, z);

%% Inputvalidation
if NumBase ~= size(base_position,1)
    error('@@@ Base 숫자가 안맞자너 @@@');
elseif NumClient ~= size(client_position,1)
    error('@@@ Client 숫자가 안맞자너 @@@');
elseif NumRelay ~= size(x0,1)
    error('@@@ Relay 숫자가 안맞자너 @@@');
end