function spd_rel = getVrel_mat2(uav_speed, uav_ang, ship_speed, ship_heading)
% Calculating effective(relative) speed
    n_u = size(uav_ang,1);
    n_s = size(uav_ang,2);
    u = uav_speed;
    s = ship_speed;
    au = uav_ang;
    as = repmat(ship_heading,n_u,n_s);
    
    vx = u*cos(au) - s*cos(as);
    vy = u*sin(au) - s*sin(as);
    
    spd_rel = sqrt(vx.^2+vy.^2);  % n_u x n_s matrix : spd_rel(i,j) = 무인기i가 배j에 할당될 때 어떤 배와의 상대속도
                                  % 배의 속도는 모두 같으므로 하나의 배에 무인기가 배정되면 무인기와 모든
                                  % 배의 상대속력이 같다
%     ang_rel = atan2(y,x);
    
end