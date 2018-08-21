function [handles]=PARAInit(handles)
global data HG sys i_itr
% initial set for simulation
sys.flag_sim = 0;
data.t(1) = 0;
data.dt = 0.1;
data.i_sim = 1;
d2r = pi/180;

% wind
data.wind.V(1) = 0;
data.wind.psi(1) = 45*d2r;
data.wind.V_X(1) = data.wind.V(1) * cos(data.wind.psi(1));
data.wind.V_Y(1) = data.wind.V(1) * sin(data.wind.psi(1));
data.wind.V_Z(1) = 0;

% ship
ship_alpha = 0.8;
if sys.flag_MC == 0
    if isempty(HG.ship) == 1
    else
        delete(HG.ship);
        delete(HG.ship_kill);
    end
end

for i = 1:data.C.ship(1).N
    data.ship.V(1,i) = data.C.ship(i).V; % [m/s]
    data.ship.psi(1,i) = data.C.ship(i).psi; % [rad]
    data.ship.RCS(1,i) = data.C.ship(i).RCS; % [m^2]
    data.ship.X(1,i) = 0;
    data.ship.Y(1,i) = 0;
    data.ship.Z(1,i) = 5;
    data.ship.phi(1,i) = 0*d2r;
    data.ship.theta(1,i) = 0*d2r;
    data.ship.D_kill(1,i) = data.C.ship(i).D_kill;
    if sys.flag_MC == 0
        [HG.ship(i)] = ICON_vessel(handles.axes_disp,ship_alpha,sys.SF_icon);
        HG.ship_kill(i) = line('parent',handles.axes_plot1,...
            'xdata',[-10000], 'ydata',[-10000],...
            'linestyle','-','linewidth',2,'color',[0 0 0]);
        
        ship_trans = makehgtform('translate',[data.ship.X(1,i), data.ship.Y(1,i), data.ship.Z(1,i)*sys.SF]);
        ship_rot = makehgtform('xrotate',data.ship.phi(1,i),'yrotate',data.ship.theta(1,i),'zrotate',data.ship.psi(1,i));
        set(HG.ship(i),'Matrix',ship_trans*ship_rot);
    end
end

% decoy
data.N_decoy = 0;
data.flag_deploy = 0;
data.flag_decoy_ini = zeros(1,data.C.decoy(1).N);
data.i_sim_deploy = ones(1,data.C.decoy(1).N);
data.flag_deploy_delay = zeros(1,data.C.decoy(1).N);

if sys.flag_MC == 0
    if isempty(HG.decoy) == 1
    else
        delete(HG.decoy);
    end
end
for i = 1:data.C.decoy(1).N
    data.decoy.V(1,i) = data.C.decoy(i).V;
    data.decoy.lau_psi(1,i) = data.C.decoy(i).lau_psi;
    data.decoy.V_X(1,i) = 0;
    data.decoy.V_Y(1,i) = 0;
    data.decoy.V_Z(1,i) = 0;
    data.decoy.V_X_in(1,i) = 0;
    data.decoy.V_Y_in(1,i) = 0;
    data.decoy.V_Z_in(1,i) = 0;
    data.decoy.X(1,i) = data.ship.X(1,1);
    data.decoy.Y(1,i) = data.ship.Y(1,1);
    data.decoy.Z(1,i) = data.ship.Z(1,1);
    data.decoy.phi(1,i) = 0;
    data.decoy.theta(1,i) = 0;
    data.decoy.psi(1,i) = 0;
    data.decoy.flag_expl(1,i) = 0;
    data.decoy.assign(i) = 0;
    
    data.decoy.P_jt(1,i) = data.C.decoy(i).P_jt; % [mW]
    data.decoy.G_jt(1,i) = data.C.decoy(i).G_jt; % [dB]
    data.decoy.G_rr(1,i) = data.C.decoy(i).G_rr; % [dB]
    data.decoy.F(1,i) = data.C.decoy(i).F; % [GHz]
    
    data.decoy.RCS(1,i) = data.C.decoy(i).RCS;
    if sys.flag_MC == 0
        if sys.case == 1
            data.buoy.R(1,i) = 10;
            [HG.decoy(i)] = ICON_Buoy(handles.axes_disp,sys.SF_icon,[0.9 0.9 0.9],[0 0 0],4,data.buoy.R(1,i),1);
        elseif sys.case == 2
            [HG.decoy(i)] = ICON_balloon(handles.axes_disp,1,sys.SF_icon);
        elseif sys.case >= 3
            [HG.decoy(i)] = ICON_Duct(handles.axes_disp,1,sys.SF_icon*50);
        else
            
        end
        decoy_trans = makehgtform('translate',[data.decoy.X(1,i), data.decoy.Y(1,i), data.decoy.Z(1,i)*sys.SF]);
        decoy_rot = makehgtform('xrotate',data.decoy.phi(1,i),'yrotate',data.decoy.theta(1,i),'zrotate',data.decoy.psi(1,i));
        set(HG.decoy(i),'Matrix',decoy_trans*decoy_rot,'visible','off');
    end
end
data.decoy.RCS_pos_flag{1} = zeros(data.C.missile(1).N,data.C.decoy(1).N);
data.decoy.RCS_pos_X{1} = zeros(data.C.missile(1).N,data.C.decoy(1).N);
data.decoy.RCS_pos_Y{1} = zeros(data.C.missile(1).N,data.C.decoy(1).N);
data.decoy.RCS_pos = zeros(data.C.missile(1).N,2);
data.decoy.RCS_new_X{1} = zeros(data.C.missile(1).N,1);
data.decoy.RCS_new_Y{1} = zeros(data.C.missile(1).N,1);
data.decoy.RCS_inc_rate = 0.25;

% missile
missile_alpha = 0.8;
if sys.flag_MC == 0
    if isempty(HG.missile) == 1
    else
        delete(HG.missile);
        delete(HG.target);
        delete(HG.missile_tracking);
        delete(HG.missile_RD);
        delete(HG.TA_1)
        delete(HG.TA_2)
        delete(HG.TA_3)
        delete(HG.TA_4)
        delete(HG.TA_pos)
        delete(HG.missile_line_S)
        delete(HG.missile_line_J)
    end
end
for i = 1:data.C.missile(1).N
    data.missile.flag_FoV(1,i) = 0;
    if sys.flag_MC == 0
        data.missile.X(1,i) = data.C.missile(i).X;
        data.missile.Y(1,i) = data.C.missile(i).Y;
        data.missile.psi(1,i) = data.C.missile(i).psi;
    else
        iter_theta = data.iter.theta(i_itr) + (i-2)*data.iter.dtheta2;
        [data.missile.X(1,i), data.missile.Y(1,i)] = pol2cart(iter_theta,data.iter.R);
        data.missile.X(1,i) = data.missile.X(1,i) + data.ship.X(1,1);
        data.missile.Y(1,i) = data.missile.Y(1,i) + data.ship.Y(1,1);
        data.missile.psi(1,i) = iter_theta + pi;
        if data.missile.psi(1,i) > 2*pi
            data.missile.psi(1,i) = data.missile.psi(1,i) - 2*pi;
        elseif data.missile.psi(1,i) < 0
            data.missile.psi(1,i) = data.missile.psi(1,i) + 2*pi;
        end
    end
    data.missile.Z(1,i) = data.C.missile(i).Z;
    data.missile.phi(1,i) = 0;
    data.missile.theta(1,i) = 0;
    data.missile.V(1,i) = data.C.missile(i).V;
    data.missile.D_expl(1,i) = data.C.missile(i).D_expl;
    data.missile.flag_expl(1,i) = 0;
    data.missile.FoV_lim(1,i) = data.C.missile(i).FoV_lim;
    
    data.missile.sedu(:,i) = rand(data.C.decoy(1).N+1,1); % seduction index
    data.missile.sedu(data.C.decoy(1).N+1,i) = 0;
    data.missile.sedu_rate(1,i) = 90/100; % seduction rate
    
    data.missile.P_rt(1,i) = data.C.missile(i).P_rt; % [mW]
    data.missile.G_rt(1,i) = data.C.missile(i).G_rt; % [dB]
    data.missile.G_rr(1,i) = data.C.missile(i).G_rr; % [dB]
    data.missile.F(1,i) = data.C.missile(i).F; % [GHz]
    
    if sys.flag_MC == 0
        HG.missile(i) = ICON_scud(handles.axes_disp,missile_alpha,sys.SF_icon*10);
        missile_trans = makehgtform('translate',[data.missile.X(1,i), data.missile.Y(1,i), data.missile.Z(1,i)]);
        missile_rot = makehgtform('xrotate',data.missile.phi(1,i),'yrotate',data.missile.theta(1,i),'zrotate',data.missile.psi(1,i));
        set(HG.missile(i),'Matrix',missile_trans*missile_rot);
        HG.missile_tracking(i) = line('parent',handles.axes_disp,...
            'xdata',[-10000], 'ydata',[-10000],...
            'linestyle','--','linewidth',2,'color',[1 0 0]);

        
        set(handles.axes_plot1,'xlim',[0 10]);
        set(handles.axes_plot2,'xlim',[0 10]);

        HG.missile_RD(1) = line('parent',handles.axes_plot1,...
            'xdata',[-10000], 'ydata',[-10000],...
            'linestyle','-','linewidth',2,'color',[1 0 0]);
        HG.missile_RD(2) = line('parent',handles.axes_plot1,...
            'xdata',[-10000], 'ydata',[-10000],...
            'linestyle','-','linewidth',2,'color',[0 0 1]);
        HG.missile_RD(3) = line('parent',handles.axes_plot1,...
            'xdata',[-10000], 'ydata',[-10000],...
            'linestyle','-','linewidth',2,'color',[1 0 1]);
        
        HG.missile_line_S(1) = line('parent',handles.axes_plot2,...
            'xdata',[-10000], 'ydata',[-10000],...
            'linestyle','-','linewidth',2,'color',[1 0 0]);
        HG.missile_line_J(1) = line('parent',handles.axes_plot2,...
            'xdata',[-10000], 'ydata',[-10000],...
            'linestyle','-','linewidth',2,'color',[0 0 1]);
        
        HG.missile_line_S(2) = line('parent',handles.axes_plot2,...
            'xdata',[-10000], 'ydata',[-10000],...
            'linestyle','-','linewidth',2,'color',[1 0 0]);
        HG.missile_line_J(2) = line('parent',handles.axes_plot2,...
            'xdata',[-10000], 'ydata',[-10000],...
            'linestyle','-','linewidth',2,'color',[0 0 1]);
        
        HG.missile_line_S(3) = line('parent',handles.axes_plot2,...
            'xdata',[-10000], 'ydata',[-10000],...
            'linestyle','-','linewidth',2,'color',[1 0 0]);
        HG.missile_line_J(3) = line('parent',handles.axes_plot2,...
            'xdata',[-10000], 'ydata',[-10000],...
            'linestyle','-','linewidth',2,'color',[0 0 1]);
    end
    
    data.missile.target.X(1,i) = data.ship.X(1,1);
    data.missile.target.Y(1,i) = data.ship.Y(1,1);
    data.missile.target.Z(1,i) = data.ship.Z(1,1);
    data.missile.target.psi(1,i) = data.ship.psi(1,1);
    data.missile.target.V(1,i) = data.ship.V(1,1);
    
    if sys.flag_MC == 0
        HG.target(i) = line('parent',handles.axes_disp,...
            'xdata',data.missile.target.X(1,i),'ydata',data.missile.target.Y(1,i),'zdata',data.missile.target.Z(1,i),...
            'marker','*','markersize',20,'linewidth',4,'visible','off',...
            'linestyle','none','color',[1 0 0]);
    end
    
    data.missile.R(1,i) = sqrt( (data.missile.X(1,i)-data.missile.target.X(1,i))^2 + (data.missile.Y(1,i)-data.missile.target.Y(1,i))^2 );
    data.missile.R_ship(1,i) = sqrt( (data.missile.X(1,i)-data.ship.X(1))^2 + (data.missile.Y(1,i)-data.ship.Y(1))^2 );
    
    expected_t(i) = data.missile.R_ship(1,i) / data.missile.V(1,i);
    
    del_y = ( data.missile.target.Y(1,i) - data.missile.Y(1,i) );
    del_x = ( data.missile.target.X(1,i) - data.missile.X(1,i) );
    lamb = atan2(del_y,del_x);
    
    del_y_ship = ( data.ship.Y(1) - data.missile.Y(1,i) );
    del_x_ship = ( data.ship.X(1) - data.missile.X(1,i) );
    data.missile.lamb_ship(1,i) = atan2(del_y_ship,del_x_ship);
    
    TA_R = 100000;
     
     TA_1_x = [0, TA_R*cos(data.missile.lamb_ship(1,i)+data.missile.FoV_lim(1,i)/2)] + data.missile.X(1,i);
    TA_1_y = [0, TA_R*sin(data.missile.lamb_ship(1,i)+data.missile.FoV_lim(1,i)/2)] + data.missile.Y(1,i);
%     TA_1_x = [0, TA_R*cos(data.missile.psi(1,i)+data.missile.FoV_lim(1,i)/2)] + data.missile.X(1,i);
%     TA_1_y = [0, TA_R*sin(data.missile.psi(1,i)+data.missile.FoV_lim(1,i)/2)] + data.missile.Y(1,i);
    HG.TA_1(i) = line('parent',handles.axes_disp,...
        'xdata',[TA_1_x], 'ydata',[TA_1_y],...
        'linestyle','-','linewidth',2,'color',[0 1 0],'visible','off');
TA_2_x = [0, TA_R*cos(data.missile.lamb_ship(1,i)-data.missile.FoV_lim(1,i)/2)] + data.missile.X(1,i);
    TA_2_y = [0, TA_R*sin(data.missile.lamb_ship(1,i)-data.missile.FoV_lim(1,i)/2)] + data.missile.Y(1,i);    
%     TA_2_x = [0, TA_R*cos(data.missile.psi(1,i)-data.missile.FoV_lim(1,i)/2)] + data.missile.X(1,i);
%     TA_2_y = [0, TA_R*sin(data.missile.psi(1,i)-data.missile.FoV_lim(1,i)/2)] + data.missile.Y(1,i);
    HG.TA_2(i) = line('parent',handles.axes_disp,...
        'xdata',[TA_2_x], 'ydata',[TA_2_y],...
        'linestyle','-','linewidth',2,'color',[0 1 0],'visible','off');
    
    TA_3_x = [data.missile.X(1,i), data.ship.X(1,1)];
    TA_3_y = [data.missile.Y(1,i), data.ship.Y(1,1)];
    HG.TA_3(i) = line('parent',handles.axes_disp,...
        'xdata',[TA_3_x], 'ydata',[TA_3_y],...
        'linestyle','-','linewidth',2,'color',[0 1 0],'visible','off');
    
    TA_tri_A = sqrt((data.missile.X(1,i)-data.ship.X(1,1))^2 + (data.missile.Y(1,i)-data.ship.Y(1,1))^2);
    TA_tri_C = (TA_tri_A / sin(data.decoy.lau_psi(1,1) - data.missile.FoV_lim(1,i)/2)) * sin(data.missile.FoV_lim(1,i)/2);
    
    if data.missile.lamb_ship(1,i) >= 0
        TA_4_x = [0, TA_tri_C*cos(data.missile.lamb_ship(1,i) + data.decoy.lau_psi(1,1))] + data.ship.X(1,1);
        TA_4_y = [0, TA_tri_C*sin(data.missile.lamb_ship(1,i) + data.decoy.lau_psi(1,1))] + data.ship.Y(1,1);
    else
        TA_4_x = [0, TA_tri_C*cos(data.missile.lamb_ship(1,i)- data.decoy.lau_psi(1,1))] + data.ship.X(1,1);
        TA_4_y = [0, TA_tri_C*sin(data.missile.lamb_ship(1,i)- data.decoy.lau_psi(1,1))] + data.ship.Y(1,1);
    end
    HG.TA_4(i) = line('parent',handles.axes_disp,...
        'xdata',[TA_4_x], 'ydata',[TA_4_y],...
        'linestyle','-','linewidth',2,'color',[1 0 0],'visible','off');
    
    HG.TA_pos(i) = line('parent',handles.axes_disp,...
        'xdata',[-100000], 'ydata',[-100000],...
        'linestyle','none','linewidth',2,'color',[1 1 0],...
        'marker','+','markersize',10,'visible','off');
    
    data.missile.lamb(1,i) = lamb;
    data.missile.a_c(1,i) = 0;
end

% task allocation
data.TA.r = 300; % radius
data.TA.theta = 0:2*pi/data.C.decoy(1).N:(2*pi-2*pi/data.C.decoy(1).N);
data.TA.a_location = [data.TA.r*cos(data.TA.theta)' data.TA.r*sin(data.TA.theta)'];
data.TA.t_location = zeros(data.C.missile(1).N,2);
data.TA.t_amount = zeros(data.C.missile(1).N,1);
data.TA.a_energy = ones(data.C.decoy(1).N,1)/data.C.decoy(1).N;
data.TA.cost = zeros(data.C.decoy(1).N,data.C.missile(1).N);
data.TA.Alloc = zeros(data.C.decoy(1).N,1);
data.TA.a_cost_assigned = zeros(data.C.decoy(1).N,1);
data.TA.iteration = 0;
% data.missile.X(1,:)
% data.missile.Y(1,:)
% data.missile.psi(1,:)
% data.missile.psi(1,:)*180/pi
data.flag_sim_end = max(expected_t)*1.3;