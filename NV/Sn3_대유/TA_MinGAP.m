function [result] = TA_MinGAP(inst,setting)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Game-theoretical Local Search Algorithm for GAP
% Using Min. Knapsack Problem Algorithm as an individual function (MinKP.m), which is from {Guntzer2000a} providing 50% guarantee
% If an item is chosen by MinKP in a bin, it has its original value on that bin.
% By Inmo Jang, 5.Dec.2016
% Modified 22.Jul.2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following describes the name of variables; meanings;  and their matrix sizes
% Input :
%   in "inst"
%   - bin_rqmt;     Bin's minimum requirement;    m by 1 matrix (m = #bins)
%   - item_size;    Item size(value);          m by n matrix (n = #items)
%   - item_cost;    Item cost;                 m by n matrix (n = #items)
%   - Alloc_pre;    Previously Assigned Bin ID for Items;     n by 1 matrix
%   in "setting"
%   - learning_rate; learning rate;  the rate to increase an expelled task cost
%   - Flag_display; Flag for display the process;   
% Output :
%   - Alloc;        Assigned Bin ID for Items;   n by 1 matrix
%   - item_assigned_cost;       Resulted individual cost for each item; n by 1 matrix
%   - iteration;    Resulted number of iteration for convergence;   1 by 1   matrix
%   - cost_history;  History of iterative total cost values as the
%   algorithm runs; x by 2 matrix (if a value is recorded in the first
%   column, it means that the corresponding assignment satisfies the
%   minimum requirement (feasible). Otherwise, it means that the assignment
%   does not so. The value is the total cost at that iteration.)
%   - feasibility;  If the value is the same as m, then all the minimum
%   requirements are met. 

% Loading Input


item_size = inst.item_size;
item_cost = inst.item_cost;
bin_rqmt = inst.bin_rqmt;
Alloc = inst.Alloc_pre;


Learning_rate = setting.learning_rate;
Flag_display = setting.display_flag;

item_cost_original = item_cost;
item_cost_private_inc = item_cost*0;


n = size(item_size,2);
m = size(bin_rqmt,1);


% Total cost history
cost_history = zeros(1,2); % Col1: Value when feasible, Col2:Value when no feasible



sequence = 1;   % This is just for initialising the below while loop.
iteration = 0;  % Number of iteration
while sum(sequence)~=0
    
    % Check current individual utility of each agents
    current_value = zeros(n,1);
    for i=1:n
        current_bin = Alloc(i,1);
        if current_bin == 0 % if no task assigned to the i-th agent
            current_value(i) = inf;
        else
            % Check member agent ID in the selected task
            current_members = (Alloc == ones(n,1)*current_bin);
            % Obtain Current individual utility value
            item_cost = item_cost_original;
            item_cost(:,i) = item_cost(:,i) + item_cost_private_inc(:,i);
            current_value(i) = TA_get_item_cost_MinKP(current_bin, i, current_members, bin_rqmt, item_size, item_cost);
        end
    end
    
    %%%% broadcast along with changing myself (not others' statuses)
    
    for i=1:n
        if current_value(i) == inf || current_value(i) == 0
            current_value(i) = 0;
            % Debug
            if Alloc(i) ~= 0
                debug = 1;
            end
        end
    end
    
    
    
    
    % Test
    if iteration > 0
        
        
        [output] = TA_feasibility_test(item_size,bin_rqmt,Alloc,'Over_rqmt');
        
        
        if sum(output) == m % All feasible
            cost_history(iteration, 1) = sum(current_value);
        else
            cost_history(iteration, 2) = sum(current_value);
        end
        
    end
    
    
    
    
    % Randomize sequence to simulate distributed algorithm
    sequence = randperm(n);
    
    %%% Merge and split
    for i_=1:n
        i=sequence(i_);% Choose agent randomly, initially
        
        % For choosing unchecked agent
        % If the agent already was checked, choose next agent.
        j_=0;
        while (i==0)
            j_=j_+1;
            i=sequence(i_+j_);
        end
        % End For choosing unchecked agent
        
        
        current_bin = Alloc(i); % Current task of selected agent
        %%% End Selecting agent who will move
        
        
        
        %%% Merge-and-split
        % 1) Check the best alternative amongst other tasks
        
        % Initialize
        Candidate = ones(m,1)*(0);
        
        item_cost = item_cost_original;
        item_cost(:,i) = item_cost(:,i) + item_cost_private_inc(:,i);
        
        % Obtain possible utility when choosing other tasks
        for t=1:m
            % Check member agent ID in the selected task
            current_members = (Alloc == ones(n,1)*t);
            current_members(i) = 1; % including oneself
            
            % Obtain possible individual utility value
            Candidate(t) = TA_get_item_cost_MinKP(t, i, current_members, bin_rqmt, item_size, item_cost);
            
            
            

        end
        
        
        
        % Select Best alternative
        [Best_utility,Best_task] = min(Candidate);
        
        
        
        Alloc_prev = Alloc;
        if Best_utility == 0 || Best_utility == inf
            Alloc(i,1) = 0; % Go th the void
        else
            Alloc(i,1) = Best_task;
        end
        
        
        
        if current_bin == Alloc(i,1) % if this choice is the same as remaining
            [dummy,index]=max(sequence == i*ones(1,n));
            sequence(index) = 0;
        else
            
            if Learning_rate > 0
                if current_bin ~= 0
                    item_cost_private_inc(current_bin,i) = item_cost_private_inc(current_bin,i) + item_cost_original(current_bin,i)*(Learning_rate);
                end
            end
            
            iteration = iteration + 1;
            break;
        end
        
        
    end
    
    % Display
    if Flag_display == 1
        
        % Check the number of participants for each task-specific coalition
        Participants = zeros(m,1);
        for t=1:m
            dummy = ones(n,1)*t;
            Participants(t) = sum(dummy==Alloc);
        end
        disp(['New Allocation status = ',num2str(Participants'),': agent #',num2str(i),' joined from task #',num2str(current_bin),' to #',num2str(Alloc(i,1)),', #round = ',num2str(iteration)])
        
    end
    % End display
    
    
    
end


%% Last check
%%%%% Post processing
% Check current individual utility of each agents
item_cost = item_cost_original;
item_assigned_cost = zeros(n,1);
for i=1:n
    current_bin = Alloc(i,1);
    if current_bin == 0 % if no task assigned to the i-th agent
        item_assigned_cost(i) = 0;
    else
        % Check member agent ID in the selected task
        current_members = (Alloc == ones(n,1)*current_bin);
        % Obtain Current individual utility value
        
        item_assigned_cost(i) = TA_get_item_cost_MinKP(current_bin, i, current_members, bin_rqmt, item_size, item_cost);
        
        if item_assigned_cost(i) == inf
            item_assigned_cost(i) = 0;
            Alloc(i) = 0;
        end
        
    end
end



% Final feasiblity
[output] = TA_feasibility_test(item_size,bin_rqmt,Alloc,'Over_rqmt');


% Rearrange Output
result = struct('Alloc',Alloc,'item_assigned_cost',item_assigned_cost,'iteration',iteration,'cost_history',cost_history,'feasibility',sum(output));

end