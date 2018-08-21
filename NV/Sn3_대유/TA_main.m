function [Alloc, a_cost_assigned, iteration, Pre_Alloc,Pre_a_cost_assigned] = TA_main(inst, Flag_TA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task Allocation Module for CNU Project
% By Inmo Jang, 2.Apr.2016 (GRAPE mode for homogeneous agents)
%%%%%%%%%%%% Modification by Inmo Jang, 26. Jul. 2017 (D-GAP mode) %%%%%%%%
% - The D-GAP module allows heterogeneous agents, but needs tabu learning
% heuristics. The details of this module is submitted as a RED-UAS paper
% - "a_energy", the remaining energy of each agent, is newly included. 
% - All the inputs are defined as a struct "inst" and "setting". "inst"
% is the struct that includes information regarding the given problem
% instance such as a_location, t_location, etc. Whereas, "setting" is one
% consising of setting-related parameters such as "Flag_display", etc.
% Likewise, results (e.g., iteration, Alloc) are also output in a struct "output". 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following describes the name of variables; meanings;  and their matrix sizes
% Input (inst):
%   - t_location;   Radar Position(x,y);             m by 2 matrix (m = #tasks)
%   - t_amount;     Radar Jamming burn-through value;m by 1 matrix
%   - a_location;   Agent Posision(x,y);             n by 2 matrix (n = #agents)
%   - a_energy;     Agent Remaining Energy;          n by 1 matrix (n = #agents)
%   - Alloc_pre;    Previously Assigned Task ID for Agents;     n by 1 matrix
% Input (setting):
%   - Flag_TA;      Flag for starting T/A;          1 by 1 matrix
%   - Flag_display; Flag for display the process;   1 by 1 matrix
% Output (output):
%   - Alloc;        Assigned Task ID for Agents;   n by 1 matrix
%   - a_cost_assigned;    Resulted individual cost for each agent; n by 1 matrix
%   - iteration;    Resulted number of iteration for convergence;   1 by 1   matrix
%   - Pre_Alloc;    Allocation just before all the agents are assigned
%   - Pre_a_cost_assigned;    Resulted cost before all the agents are assigned


if Flag_TA == 1
%% Setting Algorirhm
    n = length(inst.a_energy);
    m = length(inst.t_amount);
    
    % Read input parameters (setting-related)
    setting.learning_rate = 0.5;
    setting.display_flag = 0; % display the iterative process in the screen? (Yes 1 / No 0)
    
    
    % Additional setting for "Iterative Mode"
    redundancy_increasing_gap = 0.1; % 5% of the original task min rqmt will be increased at each iteration.
    
    % Generate agents costs w.r.t. tasks
    a_cost = zeros(m,n);
    for i=1:n
        for t=1:m
            a_cost(t,i) = inst.agent(i).task(t).cost;
        end
    end
    
    % If we go to 
    %a_effective_energy = inst.a_energy - a_cost;
    

    inst_TA.item_size = ones(m,1)*inst.a_energy';
    inst_TA.item_cost = a_cost;
    inst_TA.bin_rqmt = inst.t_amount;
    inst_TA.Alloc_pre = inst.Alloc_pre;
    
    %% Basic mode: Just once execution
%     [result] = TA_MinGAP(inst_TA,setting); 
%     Alloc = result.Alloc;
%     
%     
%     a_cost_assigned = result.item_assigned_cost;
%     iteration = result.iteration;

    %% Iterative mode: Until all agents are assigned
    process = 1;
    final_redundancy = 1;
    total_iteration = 0;
    while(process == 1)
        [result] = TA_MinGAP(inst_TA,setting);
        if length(find(result.Alloc)) == n
            % result.feasibility == m % If Yes, the current min rqmts are met
            % length(find(result.Alloc)) == n; % If Yes, all agents are assigned
            process = 0; % this process will be terminiated
        elseif result.feasibility < m 
            process = 0; % this process will be terminiated
        else
            inst_TA.bin_rqmt =  inst_TA.bin_rqmt + redundancy_increasing_gap*inst.t_amount;
            final_redundancy = final_redundancy + redundancy_increasing_gap;
            pre_result = result;            
        end
        total_iteration = total_iteration + result.iteration;
    end

    %%%%% Output
    Alloc = result.Alloc;
    a_cost_assigned = result.item_assigned_cost;
    iteration = total_iteration;    
    
    if total_iteration == result.iteration
        % If one-time process is enough to assign all the agents
        Pre_Alloc = Alloc;
        Pre_a_cost_assigned = a_cost_assigned;
    else
        Pre_Alloc = pre_result.Alloc;
        Pre_a_cost_assigned = pre_result.item_assigned_cost;
    end

    
    
    
end
end