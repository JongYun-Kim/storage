function strc = name_list(str,lb,ub)
% This function returns a string cell containing a list of strings with consecutive numbers
% for example, it returns {'uav1','uav2', ... , 'uav10'}

strc = [];
count = 1;

% check string or not
if ~isstr(str)
    str = num2str(str);
end

% make the list
for i = lb:ub
    strc{count} = [str, num2str(i)];
    count = count + 1;
end