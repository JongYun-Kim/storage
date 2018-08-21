function [out]=model_decoy_kin(in)
X = in(1);
Y = in(2);
Z = in(3);
Vx = in(4); % X_dot
Vy = in(5); % Y_dot
Vz = in(6); % Z_dot

Vx_in = in(7);
Vy_in = in(8);
Vz_in = in(9);
Vx_cmd = in(10);
Vy_cmd = in(11);
Vz_cmd = in(12);
Z_cmd = in(13);

dt = in(17);
sys.case = in(18);

if sys.case == 1
    Wx = 0;
    Wy = 0;
    Wz = 0;
else
    Wx = in(14);
    Wy = in(15);
    Wz = in(16);
end

K = 1;
K_pos = 0.3;
acc_lim = 3; % [m/s^2]
acc_alt_lim = 1; % [m/s^2]

% vel_lim = 30; % [m/s^2]
vel_lim = 30; % [m/s^2]
vel_alt_lim = 5; % [m/s^2]

if sys.case <= 2
    Ax = 0;
    Ay = 0;
    Az = 0;
elseif sys.case >= 3
    Ax = -K*(Vx - Vx_cmd);
    Ay = -K*(Vy - Vy_cmd);
    Az = -K*(Vz - Vz_cmd);
end
if abs(Ax) > acc_lim
    Ax = acc_lim*sign(Ax);
end
if abs(Ay) > acc_lim
    Ay = acc_lim*sign(Ay);
end
if abs(Az) > acc_alt_lim
    Az = acc_alt_lim*sign(Az);
end

Vx_in_new = Ax*dt + Vx_in;
Vy_in_new = Ay*dt + Vy_in;
Vz_in_new = Az*dt + Vz_in;
if abs(Vx_in_new) > vel_lim
    Vx_in_new = vel_lim*sign(Vx_in_new);
end
if abs(Vy_in_new) > vel_lim
    Vy_in_new = vel_lim*sign(Vy_in_new);
end
if abs(Vz_in_new) > vel_alt_lim
    Vz_in_new = vel_alt_lim*sign(Vz_in_new);
end

Vx_new = Vx_in_new - Wx;
Vy_new = Vy_in_new - Wy;
Vz_new = Vz_in_new - Wz;
Vz_cmd_new = -K_pos*(Z - Z_cmd);
X_new = Vx_new*dt + X;
Y_new = Vy_new*dt + Y;
Z_new = Vz_new*dt + Z;
out = [X_new;Y_new;Z_new;Vx_new;Vy_new;Vz_new;Vx_in_new;Vy_in_new;Vz_in_new;Vz_cmd_new];