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
    
    spd_rel = sqrt(vx.^2+vy.^2);  % n_u x n_s matrix : spd_rel(i,j) = ���α�i�� ��j�� �Ҵ�� �� � ����� ���ӵ�
                                  % ���� �ӵ��� ��� �����Ƿ� �ϳ��� �迡 ���αⰡ �����Ǹ� ���α�� ���
                                  % ���� ���ӷ��� ����
%     ang_rel = atan2(y,x);
    
end