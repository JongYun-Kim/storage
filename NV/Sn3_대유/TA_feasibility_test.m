function [feasibility] = TA_feasibility_test(item_size,bin_rqmt,Alloc,mode)
% feasibility() = 1: Feasible, 0: Non-feasible


m = size(bin_rqmt,1);

feasibility = zeros(m,1);

for t=1:m
    switch mode
        case 'Under_budget'
            if bin_rqmt(t) >= sum(item_size(t,Alloc == t));
                feasibility(t) = 1;
            end
             
        case 'Over_rqmt'
            if bin_rqmt(t) <= sum(item_size(t,Alloc == t));
                feasibility(t) = 1;
            end            
    end
end

end