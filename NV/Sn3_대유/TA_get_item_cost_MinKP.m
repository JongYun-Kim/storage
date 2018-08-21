function [individual_utility_value] = TA_get_item_cost_MinKP(bin_id, item_id, current_members, bin_rqmt, item_size, item_cost)
% If an item is allocated to an bin (according to a TA_MinKP algorithm), then the item get its value. 
% Modified 22.Jul.2016: Dual Greedy Algorithm is used
%%%%%%%%%%%%%%%%%%%
% Input : 
% - bin_id: ID of the bin to be checked; 1x1
% - item_id: ID of current agent(item); 1x1
% - current_members: binary matrix to indicate members of coalition; nx1
% - bin_rqmt: all bin size info; mx1
% - item_size: all item size info; mxn
% - item_cost: all item value info; mxn
%% Utility Function for Testing GAP

% Extract current considered bin
bin_rqmt_ = bin_rqmt(bin_id);
item_size_ = item_size(bin_id,:);
item_cost_ = item_cost(bin_id,:);

%%%%%% Sorting by Efficient Ratio
Profit_ratio = item_cost_./item_size_;
[Profit_ratio_sorted,ID_Profit_ratio_sorted] = sort(Profit_ratio, 'ascend');
item_cost_ = item_cost_(ID_Profit_ratio_sorted);
item_size_ = item_size_(ID_Profit_ratio_sorted);
current_members_ = current_members(ID_Profit_ratio_sorted);

if bin_rqmt_ <= sum(item_size_(current_members_)); % Feasibility check
    
    
    [sum_cost, Assign] = TA_MinKP(item_size_(current_members_)',item_cost_(current_members_)',bin_rqmt_);
    
    
    sorted_ID = ID_Profit_ratio_sorted(current_members_);
    
    individual_utility_value = inf;
    for ii = 1:length(Assign)
        if Assign(ii) == 1
            if item_id == sorted_ID(ii)      
                
                individual_utility_value = item_cost(bin_id,item_id);  
                
            end
        end
    end    

else
    individual_utility_value = item_cost(bin_id,item_id); 
end


end
