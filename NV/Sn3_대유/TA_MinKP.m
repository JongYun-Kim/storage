function [sum_cost, Assign] = TA_MinKP(item_energy_,item_cost_,bin_rqmt_)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Greedy Algorithm for Knapsack-Problem-like problem for
% Minimising costs while satisfying requirement for a task
% By Inmo Jang, 5.Dec.2016
% {Guntzer2000a}: this algorithm provides 50% guarantee
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following describes the name of variables; meanings;  and their matrix sizes
% Input :
%   - item_energy_;    Energy contribution of items;      n by 1 matrix (n = #items)
%   - item_cost_;      Cost of items;                     n by 1 matrix (n = #items)
%   - bin_rqmt_;       Requirement of Bin;                1 by 1 matrix
% Output :
%   - sum_cost;          Sum of the cots of the selected items;    1 by 1   matrix
%   - Assign;          ID of selected items;                      n by 1 matrix


item_cost_input = item_cost_;
item_energy_input = item_energy_;



for i=1:length(item_energy_);
    if bin_rqmt_ >= item_energy_(i);
    else
%         disp('Some agent can meet Bin rqmt alone (MinKP.m)');
        item_cost_(i) = 0;
        item_energy_(i) = 100;
    end
end

%%%%%% Sorting by Efficient Ratio
Profit_ratio = item_cost_./item_energy_;
[Profit_ratio_sorted,ID_Profit_ratio_sorted] = sort(Profit_ratio, 'ascend');

item_cost_ = item_cost_(ID_Profit_ratio_sorted);
item_energy_ = item_energy_(ID_Profit_ratio_sorted);


% [Initialisation]
Assign = zeros(length(item_energy_),1);
Remaining_Bin_rqmt = bin_rqmt_;

%Line 2 (Current solution)
sum_cost = 0; sum_energy = 0; 

%Line 3 (Best solution so far)
sum_cost_so_far = sum(item_cost_); 
sum_energy_so_far = sum(item_energy_);

%Line 4 (Completion item)
k = 1;

%Line 5 (Set of unprocessed items)
S = ones(length(item_energy_),1);

while(sum(S)~=0 && sum_cost < sum_cost_so_far)
    % Line 7 (Insertion phase)
    while max(item_energy_(S==1)) < bin_rqmt_ - sum_energy
        j = min(find(S==1));
        sum_energy = sum_energy + item_energy_(j);
        sum_cost = sum_cost + item_cost_(j);
        S(j) = 0;
    end
    % Line 10 (Completion phase)
    while max(item_energy_(S==1)) >= bin_rqmt_ - sum_energy
        [max_energy,j]=max(item_energy_.*S);
        S(j) = 0;
        if sum_cost + item_cost_(j) < sum_cost_so_far
            sum_energy_so_far = sum_energy + item_energy_(j);
            sum_cost_so_far = sum_cost + item_cost_(j);
            k = j;
        end
        
    end

end

% Line 15 (Determine final solution)
Assign(k) = 1;
sum_energy = item_energy_(k);
for i=1:length(item_energy_)
    if i ~= k
        if sum_energy + item_energy_(i) <= sum_energy_so_far + 10e-10
            Assign(i) = 1;
            sum_energy = sum_energy + item_energy_(i);            
        end
    end
end

sum_cost = sum(item_cost_(Assign == 1));


Assign_true = zeros(length(item_energy_),1);
Assigned_ID = ID_Profit_ratio_sorted(Assign==1);
for i=1:length(Assigned_ID)
    Assign_true(Assigned_ID(i)) = 1;
end

Assign = Assign_true;
% %%%%% Test
% if (sum(item_energy_(Assign == 1)) > bin_rqmt_)
% else
%     disp('Feasibility Error');
% end


end
