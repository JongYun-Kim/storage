function pathNew = GetNewPath(path)
% Returns a new path with dense 
    
    n = size(path,1);
    
    p_pri = [path(1,1:2); path(:,1:2)];
    p_pri(end,:) =[];
    p_post = path(:,1:2);
    
    l = sqrt(((p_post(:,1))-(p_pri(:,1))).^2+((p_post(:,2))-(p_pri(:,2))).^2);
    ll = ceil(10*l);
    
    pathNew = path(1,1:2);
    for i = 1:(n-1)
        x = linspace(path(i,1),path(i+1,1),ll(i+1))';
        y = linspace(path(i,2),path(i+1,2),ll(i+1))';
        pathNew = [pathNew; x(2:end), y(2:end)];
    end
    
end