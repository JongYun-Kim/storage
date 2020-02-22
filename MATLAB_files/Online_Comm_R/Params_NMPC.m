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
NumControl = 3;    % �� ���� ��Ʈ�ѷ� �ɰ���
NumSysControl = NumControl^NumRelay;  % ������ ���� �ϳ��� �ý������� �� �� ������ ��Ʈ���� ���� 
% idx_relay_to_system = linspace(1,NumSysControl,NumSysControl);
idx_relay_to_system = (1:NumSysControl)';
        % �� �����ʹ� ������ �����븦 �ϳ��� �ý������� ����
        % �� �ý����� ���� �� �ִ� ��� ������ ����� ���� ��Ÿ���� ��Ʈ������ �ε����� ��Ÿ���� ����.
        % ex) ������2�� ��Ʈ��3���� �̸� 
u_robot = getRobotControls(NumControl,maxAngRate);  % a set of control inputs [rad/s]: angular rate! not the heading

% NMPC
horizonLength = 2;
NumPossibleControl = (NumControl)^(NumRelay*horizonLength);
p_hr = 100.0;     % NMPC coefficient for communication
q_hr = 0.1;    % NMPC coefficient for GP variance
r_hr = 0;    % NMPC coefficient for dynamics
h_hr = 100;    % NMPC coefficient for potential field (��Ÿ��)
coeffNMPC = [ p_hr; q_hr; r_hr; h_hr ];

% Map setting
Xmin = -25;    Xmax =  25;
Ymin = -25;    Ymax =  25;
MapBound = [ Xmin, Xmax, Ymin, Ymax ];
Qdist = 2.0;  % ���ټ� �ʵ忡�� �װ� �����ݰ�

% Agent Positions
base_position   = randGenPos(NumBase,MapBound,500,25);  % random generation
client_position = randGenPos(NumClient,MapBound);       % random generation
temp_dist_bc = zeros(NumBase,NumClient);  % �� ���̽��� Ŭ���̾�Ʈ ������ �Ÿ�
for i = 1:NumBase
    for j = 1:NumClient
        temp_dist_bc(i,j) = sqrt(  (base_position(i,1)-client_position(j,1)).^2 + (base_position(i,2)-client_position(j,2)).^2   );
    end
end
% base_position   = [-18  0;
%                     18  0];
% client_position = [ 15  0];
disp(min(min(temp_dist_bc)));  % the minimum distance between a base and a client: �ʹ� ������ �ȵ�...
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
% STATE: x = [ x_pos; y_pos; heading ];  % �����̺��� �຤��
for i=1:NumRelay
    % randome generation of relay initial positions
    x0 = [ randGenPos(NumRelay,MapBound), 0*ones(NumRelay,1) ];
end
%         x0 = [-12, 4, -pi/2 ];  % �ӽ÷� ������ �� �� �϶� �׳� ���Ƿ� �ϴ°� ����
%             x0 = [  -21,   10,  -pi/2;
%                      21,   -10,  (pi/2)];
x = x0; % state initialization
    

% Measurment intialization
for i = 1:NumBase
    GP(i).D = [];  % GP �н� ������ ��ǲ   ��� [ ...; x(k) y(k); ... ];
    GP(i).Y = [];  % GP �н� ������ �ƿ�ǲ ���� [ ...; r(k); ... ];
    GP(i).n = 0 ;  % the number of input data
    GP(i).covfunc  = covfunc_hyp_opt;  % ó�� ������ �ϴ� insparse�� �սô� ������ ���� � ���ݾ�.
    GP(i).likfunc  = likfunc;
    GP(i).meanfunc = meanfunc;
    GP(i).inffunc  = inffunc_hyp_opt;  % ó�� ������ �ϴ� insparse�� �սô� ������ ���� � ���ݾ�.
end

% hyp_learned = minimize(hyp, @gp, -100, @infExact, [], covfunc, likfunc, x, Y);
% exp(hyp2.lik)
% [m s2] = gp(hyp_learned, @infExact, [], covfunc, likfunc, x, Y, z);

%% Inputvalidation
if NumBase ~= size(base_position,1)
    error('@@@ Base ���ڰ� �ȸ��ڳ� @@@');
elseif NumClient ~= size(client_position,1)
    error('@@@ Client ���ڰ� �ȸ��ڳ� @@@');
elseif NumRelay ~= size(x0,1)
    error('@@@ Relay ���ڰ� �ȸ��ڳ� @@@');
end