function Timer_mainFcn(~,~,handles)
global data HG sys


%%% basic setting
d2r = pi/180;

% set(handles.text_time,'string',num2str(data.t(data.i_sim)));
data.t(data.i_sim+1) = data.t(data.i_sim) + data.dt;

%%% vessel
data.ship.phi(data.i_sim+1) = data.ship.phi(1);
data.ship.theta(data.i_sim+1) = data.ship.theta(1);
data.ship.psi(data.i_sim+1) = data.ship.psi(1);
data.ship.V(data.i_sim+1) = data.ship.V(1);
% data.ship.V(data.i_sim+1)
data.ship.X(data.i_sim+1) = data.ship.V(data.i_sim+1)*cos(data.ship.psi(data.i_sim))*data.dt + data.ship.X(data.i_sim);
data.ship.Y(data.i_sim+1) = data.ship.V(data.i_sim+1)*sin(data.ship.psi(data.i_sim))*data.dt + data.ship.Y(data.i_sim);
data.ship.Z(data.i_sim+1) = data.ship.Z(1);

% if data.flag_deploy == 0
%     for i_missile = 1:data.C.missile(1).N
%         data.missile.flag_expl(data.i_sim+1,i_missile) = 0;
%     end
%     for i_decoy = 1:data.C.decoy(1).N
%         data.decoy.flag_expl(data.i_sim+1,i_decoy) = 0;
%     end
% else
%     for i_decoy = 1:data.C.decoy(1).N
%         for i_missile = 1:data.C.missile(1).N
%             R_decoy(i_missile,i_decoy) = sqrt( (data.missile.X(data.i_sim,i_missile)-data.decoy.X(data.i_sim,i_decoy))^2 + (data.missile.Y(data.i_sim,i_missile)-data.decoy.Y(data.i_sim,i_decoy))^2 );
%             if abs(R_decoy(i_missile,i_decoy)) < data.missile.D_expl(1,i_missile)
%                 data.missile.flag_expl(data.i_sim+1,i_missile) = 1;
%                 decoy_flag_expl(i_missile,i_decoy) = 1;
%             else
%                 data.missile.flag_expl(data.i_sim+1,i_missile) = 0;
%                 decoy_flag_expl(i_missile,i_decoy) = 0;
%             end
%         end
%         if max(decoy_flag_expl(:,i_decoy)) == 1
%             data.decoy.flag_expl(data.i_sim+1,i_decoy) = 1;
%         else
%             data.decoy.flag_expl(data.i_sim+1,i_decoy) = 0;
%         end
%     end
% end

%%% missile
for i_missile = 1:data.C.missile(1).N
    %     if data.missile.flag_expl(data.i_sim+1,i_missile) == 1
    %         data.missile.X(data.i_sim+1,i_missile) = data.missile.X(data.i_sim,i_missile);
    %         data.missile.Y(data.i_sim+1,i_missile) = data.missile.Y(data.i_sim,i_missile);
    %         data.missile.Z(data.i_sim+1,i_missile) = data.missile.Z(data.i_sim,i_missile);
    %         data.missile.phi(data.i_sim+1,i_missile) = data.missile.phi(1,i_missile);
    %         data.missile.theta(data.i_sim+1,i_missile) = data.missile.theta(1,i_missile);
    %         data.missile.psi(data.i_sim+1,i_missile) = data.missile.psi(data.i_sim,i_missile);
    %     else
    %     data.missile.target.X(data.i_sim+1,i_missile) = data.ship.X(data.i_sim+1);
    %     data.missile.target.Y(data.i_sim+1,i_missile) = data.ship.Y(data.i_sim+1);
    %     data.missile.target.Z(data.i_sim+1,i_missile) = data.ship.Z(data.i_sim+1);
    % assumption
    data.missile.target.psi(data.i_sim,:) = data.ship.psi(data.i_sim)*ones(1,data.C.missile(1).N);
    data.missile.target.V(data.i_sim,:) = data.ship.V(data.i_sim)*ones(1,data.C.missile(1).N);
    
    R = sqrt( (data.missile.X(data.i_sim,i_missile)-data.missile.target.X(data.i_sim,i_missile))^2 + (data.missile.Y(data.i_sim,i_missile)-data.missile.target.Y(data.i_sim,i_missile))^2 );
    R_ship = sqrt( (data.missile.X(data.i_sim,i_missile)-data.ship.X(data.i_sim))^2 + (data.missile.Y(data.i_sim,i_missile)-data.ship.Y(data.i_sim))^2 );
    
    %     data.missile.flag_expl(data.i_sim,i_missile)
    del_y = ( data.missile.target.Y(data.i_sim,i_missile) - data.missile.Y(data.i_sim,i_missile) );
    del_x = ( data.missile.target.X(data.i_sim,i_missile) - data.missile.X(data.i_sim,i_missile) );
    lamb = atan2(del_y,del_x);
    
    del_y_ship = ( data.ship.Y(data.i_sim) - data.missile.Y(data.i_sim,i_missile) );
    del_x_ship = ( data.ship.X(data.i_sim) - data.missile.X(data.i_sim,i_missile) );
    data.missile.lamb_ship(data.i_sim+1,i_missile) = atan2(del_y_ship,del_x_ship);
    
    state_missile_kin = [data.missile.X(data.i_sim,i_missile),...
        data.missile.Y(data.i_sim,i_missile)...
        data.missile.psi(data.i_sim,i_missile),...
        data.missile.V(data.i_sim,i_missile),...
        data.missile.a_c(data.i_sim,i_missile),...
        lamb,...
        R,...
        data.missile.target.X(data.i_sim,i_missile),...
        data.missile.target.Y(data.i_sim,i_missile),...
        data.missile.target.psi(data.i_sim,i_missile),...
        data.missile.target.V(data.i_sim,i_missile)
        ];
    
    % Field of View
    FoV_lim = data.missile.FoV_lim(1,i_missile);
    
    FoV_check = lamb-data.missile.psi(data.i_sim,i_missile);
    if FoV_check > 1.5*pi
        FoV_check = 2*pi-FoV_check;
    elseif FoV_check < -1.5*pi
        FoV_check = 2*pi+FoV_check;
    end
    if abs(FoV_check) > FoV_lim
        data.missile.R_dot(data.i_sim,i_missile) = 0;
        data.missile.lamb_dot(data.i_sim,i_missile) = 0;
        data.missile.psi_dot(data.i_sim,i_missile) = 0;
        data.missile.flag_FoV(data.i_sim,i_missile) = 0;
        %             set(HG.target(i_missile),'visible','off');
        %             set(HG.target_ZI(i_missile),'visible','off');
    else
        [missile_kin_out]=model_missile_kin(state_missile_kin);
        data.missile.R_dot(data.i_sim,i_missile) = missile_kin_out(1);
        data.missile.lamb_dot(data.i_sim,i_missile) = missile_kin_out(2);
        data.missile.psi_dot(data.i_sim,i_missile) = missile_kin_out(3);
        data.missile.flag_FoV(data.i_sim,i_missile) = 1;
        %             set(HG.target(i_missile),'visible','on');
        %             set(HG.target_ZI(i_missile),'visible','on');
    end
    
    data.missile.a_c(data.i_sim+1,i_missile) = 4*data.missile.lamb_dot(data.i_sim,i_missile);
    %missile constraint
    if abs(data.missile.a_c(data.i_sim+1,i_missile)) > 30*d2r
        data.missile.a_c(data.i_sim+1,i_missile) = 30*d2r*sign(data.missile.a_c(data.i_sim+1,i_missile));
    end
    
    data.missile.R(data.i_sim+1,i_missile) = R;
    data.missile.R_ship(data.i_sim+1,i_missile) = R_ship;
    data.missile.lamb(data.i_sim+1,i_missile) = lamb;
    data.missile.psi(data.i_sim+1,i_missile) = data.missile.psi_dot(data.i_sim,i_missile)*data.dt + data.missile.psi(data.i_sim,i_missile);
    
    data.missile.V(data.i_sim+1,i_missile) = data.missile.V(1,i_missile); % constant
    data.missile.X(data.i_sim+1,i_missile) = data.missile.V(data.i_sim+1,i_missile)*cos(data.missile.psi(data.i_sim+1,i_missile))*data.dt + data.missile.X(data.i_sim,i_missile);
    data.missile.Y(data.i_sim+1,i_missile) = data.missile.V(data.i_sim+1,i_missile)*sin(data.missile.psi(data.i_sim+1,i_missile))*data.dt + data.missile.Y(data.i_sim,i_missile);
    data.missile.Z(data.i_sim+1,i_missile) = data.missile.Z(data.i_sim,i_missile);
    tau = 0.5;
    data.missile.Z(data.i_sim+1,i_missile) = LowPF([data.missile.Z(data.i_sim+1,i_missile),data.missile.Z(data.i_sim,i_missile),tau,data.dt]);
    data.missile.phi(data.i_sim+1,i_missile) = data.missile.phi(1,i_missile);
    data.missile.theta(data.i_sim+1,i_missile) = data.missile.theta(1,i_missile);
    %     end
end

%%% detection flag
% to detect any missile for the deployment of decoys
%%% decoy
if data.C.decoy(1).N == 0
else
    if data.flag_deploy == 0
        if min(data.missile.R(data.i_sim,:)) < 12*10^3
            data.flag_deploy = 1;
            
            if data.C.decoy(1).N <= data.C.missile(1).N
                for i = 1:data.C.missile(1).N
                    R_time_ship(i) = data.missile.R_ship(data.i_sim+1,i)/data.missile.V(data.i_sim+1,i);
                end
                R_ship_sort = sort(R_time_ship);
                for i = 1:length(R_ship_sort)
                    for j = 1:length(R_time_ship)
                        if R_time_ship(j) == R_ship_sort(i)
                            data.decoy.assign(i) = j;
                        end
                    end
                end
            end
            
            if sys.flag_MC == 0
                for i_decoy = 1:data.C.decoy(1).N
                    set(HG.decoy(i_decoy),'visible','on');
                end
            end
            
            for i_decoy = 1:data.C.decoy(1).N
                data.decoy.X(data.i_sim+1,i_decoy) = data.ship.X(data.i_sim+1);
                data.decoy.Y(data.i_sim+1,i_decoy) = data.ship.Y(data.i_sim+1);
                data.decoy.Z(data.i_sim+1,i_decoy) = data.ship.Z(data.i_sim+1);
                data.decoy.phi(data.i_sim+1,i_decoy) = data.decoy.phi(1,i_decoy);
                data.decoy.theta(data.i_sim+1,i_decoy) = data.decoy.theta(1,i_decoy);
                data.decoy.psi(data.i_sim+1,i_decoy) = data.decoy.psi(1,i_decoy);
                data.decoy.V_X(data.i_sim+1,i_decoy) = 0;
                data.decoy.V_Y(data.i_sim+1,i_decoy) = 0;
                data.decoy.V_Z(data.i_sim+1,i_decoy) = 0;
                data.decoy.V_X_in(data.i_sim+1,i_decoy) = 0;
                data.decoy.V_Y_in(data.i_sim+1,i_decoy) = 0;
                data.decoy.V_Z_in(data.i_sim+1,i_decoy) = 0;
                
                if sys.case == 1
                    data.decoy.V_X_cmd(data.i_sim+1,i_decoy) = 0;
                    data.decoy.V_Y_cmd(data.i_sim+1,i_decoy) = 0;
                    data.decoy.V_Z_cmd(data.i_sim+1,i_decoy) = 0;
                    data.decoy.Z_cmd(data.i_sim+1,i_decoy) = data.decoy.Z(1,i_decoy);
                elseif sys.case == 2
                    data.decoy.V_X_cmd(data.i_sim+1,i_decoy) = 0;
                    data.decoy.V_Y_cmd(data.i_sim+1,i_decoy) = 0;
                    data.decoy.V_Z_cmd(data.i_sim+1,i_decoy) = 0;
                    data.decoy.Z_cmd(data.i_sim+1,i_decoy) = 30;
                elseif sys.case == 3
                    j_missile = data.decoy.assign(i_decoy);
                    if data.missile.lamb_ship(data.i_sim+1,j_missile) >= 0
                        data.decoy.V_X_cmd(data.i_sim+1,i_decoy) = data.decoy.V(1,i_decoy)*cos(data.missile.lamb_ship(data.i_sim+1,j_missile) + data.decoy.lau_psi(1,i_decoy));
                        data.decoy.V_Y_cmd(data.i_sim+1,i_decoy) = data.decoy.V(1,i_decoy)*sin(data.missile.lamb_ship(data.i_sim+1,j_missile) + data.decoy.lau_psi(1,i_decoy));
                    else
                        data.decoy.V_X_cmd(data.i_sim+1,i_decoy) = data.decoy.V(1,i_decoy)*cos(data.missile.lamb_ship(data.i_sim+1,j_missile) - data.decoy.lau_psi(1,i_decoy));
                        data.decoy.V_Y_cmd(data.i_sim+1,i_decoy) = data.decoy.V(1,i_decoy)*sin(data.missile.lamb_ship(data.i_sim+1,j_missile) - data.decoy.lau_psi(1,i_decoy));
                    end
                    data.decoy.V_Z_cmd(data.i_sim+1,i_decoy) = 0;
                    data.decoy.Z_cmd(data.i_sim+1,i_decoy) = 30;
                elseif sys.case == 4
                    data.decoy.X(data.i_sim+1,i_decoy) = data.ship.X(data.i_sim+1) + data.TA.r*cos(data.TA.theta(i_decoy));
                    data.decoy.Y(data.i_sim+1,i_decoy) = data.ship.Y(data.i_sim+1) + data.TA.r*sin(data.TA.theta(i_decoy));
                    data.decoy.Z(data.i_sim+1,i_decoy) = data.ship.Z(data.i_sim+1);
                    
                    data.decoy.V_Z_cmd(data.i_sim+1,i_decoy) = 0;
                    data.decoy.Z_cmd(data.i_sim+1,i_decoy) = 30;
                    
                    data.TA.a_location(i_decoy,1) = data.decoy.X(data.i_sim+1,i_decoy);
                    data.TA.a_location(i_decoy,2) = data.decoy.Y(data.i_sim+1,i_decoy);
                    
                    % task assignment
                    for i_missile = 1:data.C.missile(1).N
                        
                        TA_tri_A = sqrt((data.missile.X(data.i_sim+1,i_missile)-data.ship.X(data.i_sim+1))^2 + (data.missile.Y(data.i_sim+1,i_missile)-data.ship.Y(data.i_sim+1))^2);
                        TA_tri_C = (TA_tri_A / sin(data.decoy.lau_psi(1,i_decoy) - data.missile.FoV_lim(1,i_missile)/2)) * sin(data.missile.FoV_lim(1,i_missile)/2);
                        
                        if data.missile.lamb_ship(data.i_sim+1,i_missile) >= 0
                            TA_pos_x = [TA_tri_C*cos(data.missile.lamb_ship(data.i_sim+1,i_missile)+data.decoy.lau_psi(1,i_decoy))] + data.ship.X(data.i_sim+1);
                            TA_pos_y = [TA_tri_C*sin(data.missile.lamb_ship(data.i_sim+1,i_missile)+data.decoy.lau_psi(1,i_decoy))] + data.ship.Y(data.i_sim+1);
                        else
                            TA_pos_x = [TA_tri_C*cos(data.missile.lamb_ship(data.i_sim+1,i_missile)-data.decoy.lau_psi(1,i_decoy))] + data.ship.X(data.i_sim+1);
                            TA_pos_y = [TA_tri_C*sin(data.missile.lamb_ship(data.i_sim+1,i_missile)-data.decoy.lau_psi(1,i_decoy))] + data.ship.Y(data.i_sim+1);
                        end
                        
                        set(HG.TA_pos(i_missile),'xdata',TA_pos_x,'ydata',TA_pos_y,'zdata',data.missile.Z(data.i_sim+1,i_missile),'visible','on');
                        
                        data.TA.t_location(i_missile,1) = TA_pos_x;
                        data.TA.t_location(i_missile,2) = TA_pos_y;
                        data.TA.t_amount(i_missile,1) = (data.missile.R_ship(data.i_sim+1,i_missile)/data.missile.V(data.i_sim+1,i_missile))^-1;
                        
                        % TA_R = 100000;
                        
                        
                        % TA_1_x = [0, TA_R*cos(data.missile.lamb_ship(data.i_sim+1,i_missile)+data.missile.FoV_lim(1,i_missile)/2)] + data.missile.X(data.i_sim+1,i_missile);
                        % TA_1_y = [0, TA_R*sin(data.missile.lamb_ship(data.i_sim+1,i_missile)+data.missile.FoV_lim(1,i_missile)/2)] + data.missile.Y(data.i_sim+1,i_missile);
                        
                        % set(HG.TA_1(i_missile),'xdata',TA_1_x, 'ydata',TA_1_y, 'zdata',[0 0]+data.missile.Z(data.i_sim+1,i_missile),'visible','on');
                        % TA_2_x = [0, TA_R*cos(data.missile.lamb_ship(data.i_sim+1,i_missile)-data.missile.FoV_lim(1,i_missile)/2)] + data.missile.X(data.i_sim+1,i_missile);
                        % TA_2_y = [0, TA_R*sin(data.missile.lamb_ship(data.i_sim+1,i_missile)-data.missile.FoV_lim(1,i_missile)/2)] + data.missile.Y(data.i_sim+1,i_missile);
                        
                        % set(HG.TA_2(i_missile),'xdata',TA_2_x, 'ydata',TA_2_y, 'zdata',[0 0]+data.missile.Z(data.i_sim+1,i_missile),'visible','on');
                        
                        % TA_3_x = [data.missile.X(data.i_sim+1,i_missile), data.ship.X(data.i_sim+1)];
                        % TA_3_y = [data.missile.Y(data.i_sim+1,i_missile), data.ship.Y(data.i_sim+1)];
                        % set(HG.TA_3(i_missile),'xdata',TA_3_x, 'ydata',TA_3_y, 'zdata',[0 0]+data.missile.Z(data.i_sim+1,i_missile),'visible','on');
                        
                        % TA_tri_A = sqrt((data.missile.X(data.i_sim+1,i_missile)-data.ship.X(data.i_sim+1))^2 + (data.missile.Y(data.i_sim+1,i_missile)-data.ship.Y(data.i_sim+1))^2);
                        % TA_tri_C = (TA_tri_A / sin(data.decoy.lau_psi(1,i_decoy) - data.missile.FoV_lim(1,i_missile)/2)) * sin(data.missile.FoV_lim(1,i_missile)/2);
                        
                        % if data.missile.lamb_ship(data.i_sim+1,i_missile) >= 0
                            % TA_4_x = [0, TA_tri_C*cos(data.missile.lamb_ship(data.i_sim+1,i_missile)+data.decoy.lau_psi(1,i_decoy))] + data.ship.X(data.i_sim+1);
                            % TA_4_y = [0, TA_tri_C*sin(data.missile.lamb_ship(data.i_sim+1,i_missile)+data.decoy.lau_psi(1,i_decoy))] + data.ship.Y(data.i_sim+1);
                        % else
                            % TA_4_x = [0, TA_tri_C*cos(data.missile.lamb_ship(data.i_sim+1,i_missile)-data.decoy.lau_psi(1,i_decoy))] + data.ship.X(data.i_sim+1);
                            % TA_4_y = [0, TA_tri_C*sin(data.missile.lamb_ship(data.i_sim+1,i_missile)-data.decoy.lau_psi(1,i_decoy))] + data.ship.Y(data.i_sim+1);
                        % end
                        % set(HG.TA_4(i_missile),'xdata',TA_4_x, 'ydata',TA_4_y, 'zdata',[0 0]+data.missile.Z(data.i_sim+1,i_missile),'visible','on');
                        
                    end
                    if i_decoy == data.C.decoy(1).N
                        %% Obtain Cost for TA
                        for i_missile=1:data.C.missile(1).N
                            for j_decoy=1:data.C.decoy(1).N
                                %%%% 미사일 기만위치와 uav 간의 거리
                                agent(j_decoy).task(i_missile).cost = norm(data.TA.t_location(i_missile,:)-data.TA.a_location(j_decoy,:))^2;
                            end
                        end
                        %% Initialise task allocation
                        Flag_TA = 1;
                        %% Input for TA Module
%                         data.TA.t_location
%                         data.TA.t_amount
%                         data.TA.a_location
                        inst.t_location = data.TA.t_location; % It and a_location will transform to agents' costs
                        inst.t_amount = data.TA.t_amount; % Minimum requirements
                        inst.a_location = data.TA.a_location;
                        inst.a_energy = data.TA.a_energy; % Agent work capacities (remaining energies)
                        inst.Alloc_pre = data.TA.Alloc;
                        inst.agent = agent; % result from cost
                        %% TA main code
                        [data.TA.Alloc, data.TA.a_cost_assigned, data.TA.iteration, Pre_Alloc, Pre_a_cost_assigned] = ...
                            TA_main(inst,Flag_TA);
%                         data.TA.Alloc
                        for k_decoy = 1:data.C.decoy(1).N
                            if data.missile.lamb_ship(data.i_sim+1,data.TA.Alloc(k_decoy)) >= 0
                                data.decoy.V_X_cmd(data.i_sim+1,k_decoy) = data.decoy.V(1,k_decoy)*cos(data.missile.lamb_ship(data.i_sim+1,data.TA.Alloc(k_decoy)) + data.decoy.lau_psi(1,k_decoy));
                                data.decoy.V_Y_cmd(data.i_sim+1,k_decoy) = data.decoy.V(1,k_decoy)*sin(data.missile.lamb_ship(data.i_sim+1,data.TA.Alloc(k_decoy)) + data.decoy.lau_psi(1,k_decoy));
                            else
                                data.decoy.V_X_cmd(data.i_sim+1,k_decoy) = data.decoy.V(1,k_decoy)*cos(data.missile.lamb_ship(data.i_sim+1,data.TA.Alloc(k_decoy)) - data.decoy.lau_psi(1,k_decoy));
                                data.decoy.V_Y_cmd(data.i_sim+1,k_decoy) = data.decoy.V(1,k_decoy)*sin(data.missile.lamb_ship(data.i_sim+1,data.TA.Alloc(k_decoy)) - data.decoy.lau_psi(1,k_decoy));
                            end
                        end
                    end
                end
            end
            
            if (sys.scen == 2) && (sys.case == 4)
                for i_missile = 1:data.C.missile(1).N % i_task
                    j_decoy = 1;
                    for i_decoy = 1:data.C.decoy(1).N
                        if data.TA.Alloc(i_decoy) == i_missile
                            data.decoy.RCS_pos_flag{1}(i_missile,i_decoy)=i_decoy;
%                             data.decoy.RCS_pos_X{1}(i_missile,i_decoy)=data.decoy.X(data.i_sim+1,i_decoy);
%                             data.decoy.RCS_pos_Y{1}(i_missile,i_decoy)=data.decoy.Y(data.i_sim+1,i_decoy);
                            data.decoy.RCS_pos_flag{1}(i_missile,data.C.decoy(1).N + 1)=j_decoy;
                            j_decoy = j_decoy + 1;
                        else
                            data.decoy.RCS_pos_flag{1}(i_missile,i_decoy)=NaN;
%                             data.decoy.RCS_pos_X{1}(i_missile,i_decoy)=NaN;
%                             data.decoy.RCS_pos_Y{1}(i_missile,i_decoy)=NaN;
                        end
                    end
                end
                for i_missile = 1:data.C.missile(1).N
                    data.decoy.RCS_pos_flag{1+i_missile} = data.decoy.RCS_pos_flag{1};
%                     data.decoy.RCS_new_X(i_missile) = mean(data.decoy.RCS_pos_X(i_missile,:),'omitnan');
%                     data.decoy.RCS_new_Y(i_missile) = mean(data.decoy.RCS_pos_Y(i_missile,:),'omitnan');
                end
%                 data.decoy.RCS_new_X
%                 data.decoy.RCS_new_Y
            end
            
        end
    else
        for i_decoy = 1:data.C.decoy(1).N
            %             if data.decoy.flag_expl(data.i_sim+1,i_decoy) == 1
            %                 data.decoy.X(data.i_sim+1,i_decoy) = data.decoy.X(data.i_sim,i_decoy);
            %                 data.decoy.Y(data.i_sim+1,i_decoy) = data.decoy.Y(data.i_sim,i_decoy);
            %                 data.decoy.Z(data.i_sim+1,i_decoy) = data.decoy.Z(data.i_sim,i_decoy);
            %                 data.decoy.phi(data.i_sim+1,i_decoy) = data.decoy.phi(1,i_decoy);
            %                 data.decoy.theta(data.i_sim+1,i_decoy) = data.decoy.theta(1,i_decoy);
            %                 data.decoy.psi(data.i_sim+1,i_decoy) = data.decoy.psi(1,i_decoy);
            %             else
            in = [data.decoy.X(data.i_sim,i_decoy),data.decoy.Y(data.i_sim,i_decoy),data.decoy.Z(data.i_sim,i_decoy),...
                data.decoy.V_X(data.i_sim,i_decoy),data.decoy.V_Y(data.i_sim,i_decoy),data.decoy.V_Z(data.i_sim,i_decoy),...
                data.decoy.V_X_in(data.i_sim,i_decoy), data.decoy.V_Y_in(data.i_sim,i_decoy), data.decoy.V_Z_in(data.i_sim,i_decoy),...
                data.decoy.V_X_cmd(data.i_sim,i_decoy),data.decoy.V_Y_cmd(data.i_sim,i_decoy),data.decoy.V_Z_cmd(data.i_sim,i_decoy),...
                data.decoy.Z_cmd(data.i_sim,i_decoy),...
                data.wind.V_X(1),data.wind.V_Y(1),data.wind.V_Z(1),...
                data.dt,sys.case];
            [out] = model_decoy_kin(in);
            data.decoy.X(data.i_sim+1,i_decoy) = out(1);
            data.decoy.Y(data.i_sim+1,i_decoy) = out(2);
            data.decoy.Z(data.i_sim+1,i_decoy) = out(3);
            data.decoy.V_X(data.i_sim+1,i_decoy) = out(4);
            data.decoy.V_Y(data.i_sim+1,i_decoy) = out(5);
            data.decoy.V_Z(data.i_sim+1,i_decoy) = out(6);
            data.decoy.V_X_in(data.i_sim+1,i_decoy) = out(7);
            data.decoy.V_Y_in(data.i_sim+1,i_decoy) = out(8);
            data.decoy.V_Z_in(data.i_sim+1,i_decoy) = out(9);
            data.decoy.V_Z_cmd(data.i_sim+1,i_decoy) = out(10);
            
            data.decoy.phi(data.i_sim+1,i_decoy) = data.decoy.phi(1,i_decoy);
            data.decoy.theta(data.i_sim+1,i_decoy) = data.decoy.theta(1,i_decoy);
            data.decoy.psi(data.i_sim+1,i_decoy) = data.decoy.psi(1,i_decoy);
            
            data.decoy.V_X_cmd(data.i_sim+1,i_decoy) = data.decoy.V_X_cmd(data.i_sim,i_decoy);
            data.decoy.V_Y_cmd(data.i_sim+1,i_decoy) = data.decoy.V_Y_cmd(data.i_sim,i_decoy);
            data.decoy.Z_cmd(data.i_sim+1,i_decoy) = data.decoy.Z_cmd(data.i_sim,i_decoy);
            %             end
        end
    end
end

%%% target
if data.flag_deploy == 1
    for i_missile = 1:data.C.missile(1).N
        for i_decoy = 1:data.C.decoy(1).N
            if data.TA.Alloc(i_decoy) == i_missile
                data.decoy.RCS_pos_X{1}(i_missile,i_decoy)=data.decoy.X(data.i_sim+1,i_decoy);
                data.decoy.RCS_pos_Y{1}(i_missile,i_decoy)=data.decoy.Y(data.i_sim+1,i_decoy);
            else
                data.decoy.RCS_pos_X{1}(i_missile,i_decoy)=0;
                data.decoy.RCS_pos_Y{1}(i_missile,i_decoy)=0;
            end
        end
    end
    for i_missile = 1:data.C.missile(1).N
        data.decoy.RCS_pos_X{1+i_missile} = data.decoy.RCS_pos_X{1};
        data.decoy.RCS_pos_Y{1+i_missile} = data.decoy.RCS_pos_Y{1};
    end
    for i_missile = 1:data.C.missile(1).N
            for i_decoy_wV = 1:(data.C.decoy(1).N + 1) % also considers the ship which can also be a decoy
                if i_decoy_wV < data.C.decoy(1).N + 1
                    dist_bwMD(i_decoy_wV,i_missile) = sqrt((data.missile.X(data.i_sim+1,i_missile) - data.decoy.X(data.i_sim+1,i_decoy_wV))^2 ...
                        + (data.missile.Y(data.i_sim+1,i_missile) - data.decoy.Y(data.i_sim+1,i_decoy_wV))^2*10^-3 ...
                        ); % + (data.missile.Z(data.i_sim+1,i_missile) - data.decoy.Z(data.i_sim+1,i_decoy_wV))^2)*10^-3;
                    % 레이더에서 수신할 경우 재밍 신호의 세기( Jamming Power )
                    if sys.scen == 1 % 1: RF / 2: RCS
                        data.missile.J{i_missile}(data.i_sim,i_decoy_wV) = 10*log10(data.decoy.P_jt(1,i_decoy_wV)) + data.decoy.G_jt(1,i_decoy_wV) + data.decoy.G_rr(1,i_decoy_wV) - 20*log10(dist_bwMD(i_decoy_wV,i_missile)) - 20*log10(data.decoy.F(1,i_decoy_wV)) - 92.45; % 기만 신호 세기[dBm]
                    else
                        data.missile.J{i_missile}(data.i_sim,i_decoy_wV) = 10*log10(data.missile.P_rt(1,i_missile)) + data.missile.G_rt(1,i_missile) + data.missile.G_rr(1,i_missile) - 40*log10(dist_bwMD(i_decoy_wV,i_missile)) + 10*log10(data.decoy.RCS(1,i_decoy_wV)) - 163.4 - 20*log10(data.missile.F(1,i_missile));  % 자함 신호 세기 [dBm]
                    end
                else
                    dist_bwMD(data.C.decoy(1).N+1,i_missile) = sqrt((data.missile.X(data.i_sim+1,i_missile) - data.ship.X(data.i_sim+1))^2 ...
                        + (data.missile.Y(data.i_sim+1,i_missile) - data.ship.Y(data.i_sim+1))^2*10^-3 ...
                        );
                    % 타겟으로부터 반사되어 수신한 신호 세기 (S)
                    data.missile.S(data.i_sim,i_missile) = 10*log10(data.missile.P_rt(1,i_missile)) + data.missile.G_rt(1,i_missile) + data.missile.G_rr(1,i_missile) - 40*log10(dist_bwMD(data.C.decoy(1).N+1,i_missile)) + 10*log10(data.ship.RCS(1,1)) - 163.4 - 20*log10(data.missile.F(1,i_missile));  % 자함 신호 세기 [dBm]
                    data.missile.J{i_missile}(data.i_sim,data.C.decoy(1).N+1) = data.missile.S(data.i_sim,i_missile);
                end
            end

            data.missile.J_max(data.i_sim,i_missile) = max(data.missile.J{i_missile}(data.i_sim,:));
            
            %         if data.missile.flag_FoV(data.i_sim,i_missile) == 1;
            for i_decoy_wV = 1:data.C.decoy(1).N + 1
                if data.missile.sedu(i_decoy_wV,i_missile) <= data.missile.sedu_rate(1,1) % check seduction
                    flag_J(i_missile,i_decoy_wV) = data.missile.J{i_missile}(data.i_sim,i_decoy_wV);
                else
                    flag_J(i_missile,i_decoy_wV) = nan;
                    if (sys.scen == 2) && (sys.case == 4)
                        for j_missile = 1:data.C.missile(1).N
                            if i_decoy_wV ~= data.C.decoy(1).N + 1
                                if isnan(data.decoy.RCS_pos_flag{1+i_missile}(j_missile,i_decoy_wV)) == 0
                                    data.decoy.RCS_pos_flag{1+i_missile}(j_missile,i_decoy_wV) = nan;
                                    data.decoy.RCS_pos_X{1+i_missile}(j_missile,i_decoy_wV) = 0;
                                    data.decoy.RCS_pos_Y{1+i_missile}(j_missile,i_decoy_wV) = 0;
                                    data.decoy.RCS_pos_flag{1+i_missile}(j_missile,end) = data.decoy.RCS_pos_flag{1+i_missile}(j_missile,end) - 1;
                                end
                            end
                        end
                    end
                end
            end

            if (sys.scen == 2) && (sys.case == 4)
                for i_decoy_wV = 1:data.C.missile(1).N + 1 % decoy grouping
%                     flag_J(i_missile,:)
%                     data.decoy.RCS_pos_flag{1}
%                     data.decoy.RCS_pos_flag{1+i_missile}
                    
                    if i_decoy_wV < data.C.missile(1).N + 1
                        if data.decoy.RCS_pos_flag{1+i_missile}(i_decoy_wV,data.C.decoy(1).N + 1) > 1
                            J_RCS_K = data.decoy.RCS_pos_flag{1+i_missile}(i_decoy_wV,data.C.decoy(1).N + 1) * data.decoy.RCS_inc_rate + 1;
                        else
                            J_RCS_K = 1;
                        end
%                         J_RCS_K
%                         data.decoy.RCS_new_X{i_missile}(i_decoy_wV) = mean(data.decoy.RCS_pos_X{1+i_missile}(i_decoy_wV,:),'omitnan');
                        data.decoy.RCS_new_X{i_missile}(i_decoy_wV) = sum(data.decoy.RCS_pos_X{1+i_missile}(i_decoy_wV,:))/data.decoy.RCS_pos_flag{1+i_missile}(i_decoy_wV,end);
                        data.decoy.RCS_new_Y{i_missile}(i_decoy_wV) = sum(data.decoy.RCS_pos_Y{1+i_missile}(i_decoy_wV,:))/data.decoy.RCS_pos_flag{1+i_missile}(i_decoy_wV,end);
                        data.decoy.RCS_new_Z{i_missile}(i_decoy_wV) = mean(data.decoy.Z(data.i_sim+1,:));
                        dist_bwMD(i_decoy_wV,i_missile) = sqrt((data.missile.X(data.i_sim+1,i_missile) - data.decoy.RCS_new_X{i_missile}(i_decoy_wV))^2 ...
                            + (data.missile.Y(data.i_sim+1,i_missile) - data.decoy.RCS_new_Y{i_missile}(i_decoy_wV))^2*10^-3 ...
                            );
                        % 레이더에서 수신할 경우 재밍 신호의 세기( Jamming Power )
                        flag_J_RCS(i_missile, i_decoy_wV) = 10*log10(data.missile.P_rt(1,i_missile)) + data.missile.G_rt(1,i_missile) + data.missile.G_rr(1,i_missile) - 40*log10(dist_bwMD(i_decoy_wV,i_missile)) + 10*log10(data.decoy.RCS(1,i_decoy_wV)*J_RCS_K) - 163.4 - 20*log10(data.missile.F(1,i_missile));  % 자함 신호 세기 [dBm]
                    else
                        flag_J_RCS(i_missile, i_decoy_wV) = data.missile.S(data.i_sim,i_missile);
                        
                    end
                    if flag_J_RCS(i_missile,i_decoy_wV) == max(flag_J_RCS(i_missile,:))
                        for i_table = 1:data.C.missile(1).N
                            if i_table == i_missile
                                if i_decoy_wV == data.C.decoy(1).N + 1
                                    sys.data_table{i_table,1} = strcat('Ship');
                                    sys.data_table{i_table,2} = strcat('X');
                                else
                                    sys.data_table{i_table,1} = strcat('Decoy ',num2str(i_decoy_wV));
                                    sys.data_table{i_table,2} = strcat('O');
                                end
                            end
                        end
                        
                        if i_decoy_wV < data.C.decoy(1).N + 1
                            % strcat('mssile:',num2str(i_missile),'target: decoy',num2str(i_decoy_wV))
                            data.missile.target.X(data.i_sim+1,i_missile) = data.decoy.RCS_new_X{i_missile}(i_decoy_wV);
                            data.missile.target.Y(data.i_sim+1,i_missile) = data.decoy.RCS_new_Y{i_missile}(i_decoy_wV);
                            data.missile.target.Z(data.i_sim+1,i_missile) = data.decoy.RCS_new_Z{i_missile}(i_decoy_wV);
                        else
                            % strcat('mssile:',num2str(i_missile),'target: ship',num2str(i_decoy_wV))
                            data.missile.target.X(data.i_sim+1,i_missile) = data.ship.X(data.i_sim+1);
                            data.missile.target.Y(data.i_sim+1,i_missile) = data.ship.Y(data.i_sim+1);
                            data.missile.target.Z(data.i_sim+1,i_missile) = data.ship.Z(data.i_sim+1);
                        end
                        break
                    end
                    
                end
            else
                for i_decoy_wV = 1:data.C.decoy(1).N + 1
                    if flag_J(i_missile,i_decoy_wV) == max(flag_J(i_missile,:))
                        %                 strcat('mssile:',num2str(i_missile),'decoy',num2str(i_decoy_wV))
                        
                        for i_table = 1:data.C.missile(1).N
                            if i_table == i_missile
                                if i_decoy_wV == data.C.decoy(1).N + 1
                                    sys.data_table{i_table,1} = strcat('Ship');
                                    sys.data_table{i_table,2} = strcat('X');
                                else
                                    sys.data_table{i_table,1} = strcat('Decoy ',num2str(i_decoy_wV));
                                    sys.data_table{i_table,2} = strcat('O');
                                end
                            end
                        end
                        
                        if i_decoy_wV < data.C.decoy(1).N + 1
                            % strcat('mssile:',num2str(i_missile),'target: decoy',num2str(i_decoy_wV))
                            data.missile.target.X(data.i_sim+1,i_missile) = data.decoy.X(data.i_sim+1,i_decoy_wV);
                            data.missile.target.Y(data.i_sim+1,i_missile) = data.decoy.Y(data.i_sim+1,i_decoy_wV);
                            data.missile.target.Z(data.i_sim+1,i_missile) = data.decoy.Z(data.i_sim+1,i_decoy_wV);
                        else
                            % strcat('mssile:',num2str(i_missile),'target: ship',num2str(i_decoy_wV))
                            data.missile.target.X(data.i_sim+1,i_missile) = data.ship.X(data.i_sim+1);
                            data.missile.target.Y(data.i_sim+1,i_missile) = data.ship.Y(data.i_sim+1);
                            data.missile.target.Z(data.i_sim+1,i_missile) = data.ship.Z(data.i_sim+1);
                        end
                        break
                    end
                    
                end
        end
    end
else
    % without decoy
    for i_missile = 1:data.C.missile(1).N
        %         if data.missile.flag_expl(data.i_sim+1,i_missile) == 1
        %             data.missile.target.X(data.i_sim+1,i_missile) = data.missile.target.X(data.i_sim,i_missile);
        %             data.missile.target.Y(data.i_sim+1,i_missile) = data.missile.target.Y(data.i_sim,i_missile);
        %             data.missile.target.Z(data.i_sim+1,i_missile) = data.missile.target.Z(data.i_sim,i_missile);
        %         else
        %         if data.missile.flag_FoV(data.i_sim,i_missile) == 1;
        data.missile.target.X(data.i_sim+1,i_missile) = data.ship.X(data.i_sim+1);
        data.missile.target.Y(data.i_sim+1,i_missile) = data.ship.Y(data.i_sim+1);
        data.missile.target.Z(data.i_sim+1,i_missile) = data.ship.Z(data.i_sim+1);
        %         else
        %
        %             data.missile.target.X(data.i_sim+1,i_missile) = -99999999;
        %             data.missile.target.Y(data.i_sim+1,i_missile) = -99999999;
        %             data.missile.target.Z(data.i_sim+1,i_missile) = data.missile.target.Z(1,i_missile);
        %         end
        dist_bwMD = sqrt((data.missile.X(data.i_sim+1,i_missile) - data.ship.X(data.i_sim+1))^2 ...
            + (data.missile.Y(data.i_sim+1,i_missile) - data.ship.Y(data.i_sim+1))^2 ...
            + (data.missile.Z(data.i_sim+1,i_missile) - data.ship.Z(data.i_sim+1))^2);
        data.missile.S(data.i_sim,i_missile) = 10*log10(data.missile.P_rt(1,i_missile)) + data.missile.G_rt(1,i_missile) + data.missile.G_rr(1,i_missile) - 40*log10(dist_bwMD) + 10*log10(data.ship.RCS(1,1)) - 163.4 - 20*log10(data.missile.F(1,i_missile));  % 자함 신호 세기 [dBm]
        data.missile.J_max(data.i_sim,i_missile) = data.missile.S(data.i_sim,i_missile);
        %         end
    end
end

if sys.flag_MC == 0
    if data.t(end) > 8
        set(handles.axes_plot1,'xlim',[-8 2]+data.t(end))
        set(handles.axes_plot2,'xlim',[-8 2]+data.t(end))
    end
end
data.iter.D_miss = min(min(data.missile.R_ship));


% '============================='
% data.missile.lamb_ship(data.i_sim+1,1)*180/pi
% data.missile.lamb(data.i_sim+1,2)*180/pi
% data.missile.lamb(data.i_sim+1,3)*180/pi
% data.missile.psi(data.i_sim+1,1)*180/pi
% data.missile.psi(data.i_sim+1,2)*180/pi
% data.missile.psi(data.i_sim+1,3)*180/pi
% data.ship.psi(data.i_sim+1)*180/pi

data.i_sim = data.i_sim + 1;