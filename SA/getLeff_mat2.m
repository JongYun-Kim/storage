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
            x_t = dx(agent,target);  % ���α⿡�� Ÿ���� x���� �Ÿ�
            y_t = dy(agent,target);  % ���α⿡�� Ÿ���� y���� �Ÿ�
            d_t = ( abs( y_t.*dx(agent,:) - x_t.*dy(agent,:) ) ) / ( sqrt( x_t^2 + y_t^2 ) ) ; % row vector % �� �迡�� ���α� ��α����� �����Ÿ�

            mask_touch = d_t <= r;                                                 % T/F : �ٸ� �谡 ���α� ��ο� �����ϴ���
            mask_Oside = ( y_t*(dy(agent,:)-y_t) + x_t*(dx(agent,:)-x_t) ) <= 0;   % � �谡 ���α� ����� ������
            mask_Tin = ((x_t - dx(agent,:)).^2 + (y_t - dy(agent,:)).^2) >= r.^2;  % � ���� ���� �ۿ� Ÿ���� �ִ��� / � �谡 Ÿ�ٿ��� �ָ������� True
            index_rd = ((-1).^(mask_Oside+1)) .* (mask_Tin) ;                      % Ÿ�ټ� �ָ��ִ� �� �� ���α����� + �ݴ�� -
            index_st = ((-1).^(mask_Oside+1)) .* (1-mask_Tin) ;                    % Ÿ�ٿ��� ����� �� �� ���α����� + �ݴ�� -

            Li(1:n) = mask_touch.*( sqrt(r.^2-d_t.^2) + index_rd.*sqrt(r.^2-d_t.^2) + index_st.*sqrt(( (x_t - dx(agent,:)).^2 + (y_t - dy(agent,:)).^2 )-d_t.^2) );
            L_eff = [ L_eff, Li' ]; % i ��° ���� uav�� i�迡 ���� �� �迡 �������� ���� (Li)
        end
        
        L_cell{agent} = L_eff;
    end

end