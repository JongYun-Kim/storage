function K_P = ship_spd_model(ship_speed,K_P_org);
% returns kill probability in the speed envr.

    if ship_speed <= 5.144       % 10kts 이하
        K_P = K_P_org;
    elseif ship_speed <= 10.289  % 20kts 이하
        K_P = 0.95 * K_P_org;
    else                        % 그외
        K_P = 0.9 * K_P_org;
    end


end