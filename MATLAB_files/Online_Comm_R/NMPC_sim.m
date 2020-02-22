%%% This is a script for NMPC-based online comm. relay simulations
%%% Communication relays generate communication maps and search for relay position

%%% 변화율에도 제한조건이 있어야하나 빼먹음.. 일단은 해보고 horizon길어지고 할때 pso로 constraint 넣어버리자...  
%%% 근데 없어도 일단은 괜찮음 그렇게 안한 사람들도 있으니
clear; close all; 


%% Ramdom Seed
rng('default');
rng('shuffle');

%% Settings
Params_NMPC;

%% Main Loop
NMPC_main;

%% Plots
NMPC_plots;

% % % hgexport(figure(1), sprintf('./images/h3i600_3'), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % hgexport(figure(2), sprintf('./images/h3i600_3_GP1mean'), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % hgexport(figure(3), sprintf('./images/h3i600_3_GP1var'), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % hgexport(figure(4), sprintf('./images/h3i600_3_GP2mean'), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % hgexport(figure(5), sprintf('./images/h3i600_3_GP2var'), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % save('200130_2032_data.mat','data','base_position','coeffNMPC','x0','client_position','GP');