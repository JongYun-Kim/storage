clear all; close all; clc
%% Instance Settings
% Agents
n_a = 10; % the number of agents

% Tasks
n_t = 3; % the number of tasks
%% =================
%% Task Allocation
%% =================
%   - t_location;   Missle�� ���� decoying Position (x,y);   m by 2 matrix (m = #missiles)
%   - t_amount;     Missle�� �����ϱ���� �ɸ��� �ð�;          m by 1 matrix
%   - a_location;   ���� ���α� Position(x,y);                n by 2 matrix (n = #UAVs)
%   - a_energy;     ���� ���α� �����ܷ�                       n by 1 matrix (n = #UAVs)
%   - Alloc_pre;    Previously Assigned Task ID for Agents;     n by 1 matrix
%% Initilise task location / task amount / agent location
t_location = zeros(n_t,2);    % task location - 2D
t_amount = zeros(n_t,1);      % task rewards
a_location = zeros(n_a,2);    % agent location - 2D: -> This will be generated at Path planning parameter generation
a_energy = zeros(n_a,1);      % agent remaining energy
%% ���α� �⸸�� ���� ���� ��ġ
t_location = [ 
    100 50
    -100 100
    100 -50
    ];
%% �������� �̻����� ���� ����ð�
t_amount = 1e0*[ 
    1/10 % 10 sec 
    1/5 % 5 sec
    1/20 % 12 sec
    ];
%% ���α� ��ġ (��� ������ġ)
r = 30; % radius
theta = 0:2*pi/n_a:(2*pi-2*pi/n_a);
a_location = [ 
    r*cos(theta)' r*sin(theta)'
    ];
%% ���α��� �ܿ�����
a_energy = ones(n_a,1);      
%% Obtain Cost for TA
cost = zeros(n_a,n_t);
for t_i=1:n_t    
    for j=1:n_a
        %%%% �̻��� �⸸��ġ�� uav ���� �Ÿ�
        agent(j).task(t_i).cost = norm(t_location(t_i,:)-a_location(j,:))^2;
    end
end
%% Initialise task allocation
Alloc = zeros(n_a,1);
Flag_TA = 1;
%% Input for TA Module
inst.t_location = t_location; % It and a_location will transform to agents' costs
inst.t_amount = t_amount; % Minimum requirements
inst.a_location = a_location;
inst.a_energy = a_energy; % Agent work capacities (remaining energies)

inst.Alloc_pre = Alloc;
inst.agent = agent; % result from cost
%% TA main code
[Alloc, a_cost_assigned, iteration, Pre_Alloc, Pre_a_cost_assigned] = ...
    TA_main(inst,Flag_TA);
Alloc
iteration
%% plot the TA result
plot(t_location(:,1),t_location(:,2),'*'); hold on;
plot(a_location(:,1),a_location(:,2),'o'); legend('missiles','UAVs'); grid
text(t_location(:,1)+3,t_location(:,2)-3,num2str([1:n_t]'))
text(a_location(:,1)+3,a_location(:,2)+3,num2str(Alloc))
axis([-120 120 -80 120])