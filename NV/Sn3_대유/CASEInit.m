function [data]=CASEInit(handles,data,sys)
clear('data');
% Class define
data.C.decoy = c_decoy;
data.C.ship = c_ship;
data.C.missile = c_missile;

d2r = pi/180;

% iterative simulation
data.iter.N = 30;
data.iter.R = 15*10^3;
data.iter.dtheta1 = 10*d2r;
data.iter.dtheta2 = 10*d2r;
data.iter.theta = 0*pi:data.iter.dtheta1:2*pi;
data.iter.D_miss = 0;
data.iter.D_miss_table = 0;
data.iter.S_rate = 0;

% missile
C_mV = 1;
m_Z = 30;
data.C.missile(1).N = 3;
data.C.missile(1).X = 20000; % [m]
data.C.missile(1).Y = 20000; % [m]
data.C.missile(1).Z = m_Z; % [m]
data.C.missile(1).V = 300*C_mV; % [m/s]
data.C.missile(1).psi = 230*d2r; % [rad]
data.C.missile(1).P_rt = 200*10^-6; % [mW]
data.C.missile(1).G_rt = 35; % [dB]
data.C.missile(1).G_rr = 35; % [dB]
data.C.missile(1).F = (3.0*10^8/0.003)*10^-9; % [GHz]
data.C.missile(1).FoV_lim = 30*d2r; % [rad]
data.C.missile(1).D_expl = 10; % [m]
    % missile(2)
data.C.missile(2).X = 5000; % [m]
data.C.missile(2).Y = 20000; % [m]
data.C.missile(2).Z = m_Z; % [m]
data.C.missile(2).V = 300*C_mV; % [m/s]
data.C.missile(2).psi = 270*d2r; % [rad]
data.C.missile(2).P_rt = 200*10^-6; % [mW]
data.C.missile(2).G_rt = 35; % [dB]
data.C.missile(2).G_rr = 35; % [dB]
data.C.missile(2).F = (3.0*10^8/0.003)*10^-9; % [GHz]
data.C.missile(2).FoV_lim = 30*d2r; % [rad]
data.C.missile(2).D_expl = 10; % [m]
    % missile(3)
data.C.missile(3).X = -10000; % [m]
data.C.missile(3).Y = 20000; % [m]
data.C.missile(3).Z = m_Z; % [m]
data.C.missile(3).V = 300*C_mV; % [m/s]
data.C.missile(3).psi = 280*d2r; % [rad]
data.C.missile(3).P_rt = 200*10^-6; % [mW]
data.C.missile(3).G_rt = 35; % [dB]
data.C.missile(3).G_rr = 35; % [dB]
data.C.missile(3).F = (3.0*10^8/0.003)*10^-9; % [GHz]
data.C.missile(3).FoV_lim = 30*d2r; % [rad]
data.C.missile(3).D_expl = 10; % [m]

% decoy
if sys.case == 1
    data.C.decoy(1).N = 1;
elseif sys.case == 2
    data.C.decoy(1).N = 1;
elseif sys.case == 3
    data.C.decoy(1).N = 1;
elseif sys.case == 4
    data.C.decoy(1).N = 20;
end
for i = 1:data.C.decoy(1).N
    if sys.case == 1
        data.C.decoy(i).V = 0; % [m/s]
        data.C.decoy(i).lau_psi = pi/2; % [rad]
    elseif sys.case == 2
        data.C.decoy(i).V = 0; % [m/s]
        data.C.decoy(i).lau_psi = pi/2; % [rad]
    elseif sys.case == 3
        data.C.decoy(i).V = 15; % [m/s]
        data.C.decoy(i).lau_psi = pi/2; % [rad]
    elseif sys.case == 4
        data.C.decoy(i).V = 15; % [m/s]
        data.C.decoy(i).lau_psi = pi/2; % [rad]
    end
    data.C.decoy(i).Z = 30; % [m]
    data.C.decoy(i).P_jt = 1*10^-6; % [mW]
    data.C.decoy(i).G_jt = 35; % [dB]
    data.C.decoy(i).G_rr = 35; % [dB]
    data.C.decoy(i).F = (3.0*10^8/0.003)*10^-9; % [GHz]
    data.C.decoy(i).RCS = 40;
end

% ship
data.C.ship(1).N = 1;
for i = 1:data.C.ship(1).N
    data.C.ship(i).V = 15; % [m/s]
    data.C.ship(i).psi = 0; % [rad]
    data.C.ship(i).RCS = 50; % [m^2]
    data.C.ship(i).D_kill = 138.1; % [m]
end

scenario_case(handles,sys,data);