function L_cell = getLeff_mat2(dx,dy,ship_attack_radius)
% Calculating effective length through which uavs pass
% there might be some freaky things. those make the calculation easier, never mind
    
    m = size(dx,1);  % the no. of uavs
    n = size(dy,2);  % the no. of ships
    r = ship_attack_radius;
    
    L_cell = cell(m,1);  %[];
    for agent = 1:m
        
        L_eff = [];
        for target = 1:n  % when a uav goes to each ship
            x_t = dx(agent,target);  % 무인기에서 타겟의 x성분 거리
            y_t = dy(agent,target);  % 무인기에서 타겟의 y성분 거리
            d_t = ( abs( y_t.*dx(agent,:) - x_t.*dy(agent,:) ) ) / ( sqrt( x_t^2 + y_t^2 ) ) ; % row vector % 각 배에서 무인기 경로까지의 수직거리

            mask_touch = d_t <= r;                                                 % T/F : 다른 배가 무인기 경로에 접촉하는지
            mask_Oside = ( y_t*(dy(agent,:)-y_t) + x_t*(dx(agent,:)-x_t) ) <= 0;   % 어떤 배가 무인기 출발점 쪽인지
            mask_Tin = ((x_t - dx(agent,:)).^2 + (y_t - dy(agent,:)).^2) >= r.^2;  % 어떤 배의 범위 밖에 타겟이 있는지 / 어떤 배가 타겟에서 멀리있으면 True
            index_rd = ((-1).^(mask_Oside+1)) .* (mask_Tin) ;                      % 타겟서 멀리있는 배 중 무인기쪽은 + 반대는 -
            index_st = ((-1).^(mask_Oside+1)) .* (1-mask_Tin) ;                    % 타겟에서 가까운 배 중 무인기쪽은 + 반대는 -

            Li(1:n) = mask_touch.*( sqrt(r.^2-d_t.^2) + index_rd.*sqrt(r.^2-d_t.^2) + index_st.*sqrt(( (x_t - dx(agent,:)).^2 + (y_t - dy(agent,:)).^2 )-d_t.^2) );
            L_eff = [ L_eff, Li' ]; % i 번째 열은 uav가 i배에 갈때 각 배에 지나가는 길이 (Li)
        end
        
        L_cell{agent} = L_eff;
    end

end