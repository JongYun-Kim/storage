function Timer_visFcn(~,~,handles)
global HG data sys

if sys.flag_sim == 1
    set(handles.uitable_1,'data',sys.data_table)
    
    ship_trans = makehgtform('translate',[data.ship.X(data.i_sim), data.ship.Y(data.i_sim), data.ship.Z(data.i_sim)*sys.SF]);
    ship_rot = makehgtform('xrotate',data.ship.phi(data.i_sim),'yrotate',data.ship.theta(data.i_sim),'zrotate',data.ship.psi(data.i_sim));
    set(HG.ship,'Matrix',ship_trans*ship_rot);
    for i = 1:data.C.missile(1).N
%         if data.missile.flag_expl(data.i_sim,i) == 1
%             set(HG.missile(i),'visible','off');
%         end
        missile_trans = makehgtform('translate',[data.missile.X(data.i_sim,i), data.missile.Y(data.i_sim,i), data.missile.Z(data.i_sim,i)*sys.SF]);
        missile_rot = makehgtform('xrotate',data.missile.phi(data.i_sim,i),'yrotate',data.missile.theta(data.i_sim,i),'zrotate',data.missile.psi(data.i_sim,i));
        set(HG.missile(i),'Matrix',missile_trans*missile_rot);
        set(HG.missile_tracking(i),'xdata',data.missile.X(:,i),'ydata',data.missile.Y(:,i),'zdata',data.missile.Z(:,i)*sys.SF);
%         set(HG.target(i),'xdata',data.missile.target.X(data.i_sim,i),...
%             'ydata',data.missile.target.Y(data.i_sim,i),...
%             'zdata',data.missile.target.Z(data.i_sim,i));
        set(HG.missile_RD(i),'xdata',data.t,'ydata',data.missile.R_ship(:,i));
        set(HG.ship_kill(1),'xdata',data.t,'ydata',data.ship.D_kill(1,1)*ones(size(data.t)));
        set(HG.missile_line_S(i),'xdata',data.t(1:end-1),'ydata',data.missile.S(:,i));
        set(HG.missile_line_J(i),'xdata',data.t(1:end-1),'ydata',data.missile.J_max(:,i));
    end
    for i_decoy = 1:data.C.decoy(1).N
        if data.flag_deploy == 1
%             if data.decoy.flag_expl(data.i_sim,i_decoy) == 1
%                 set(HG.decoy(i_decoy),'visible','off');
%             end
            decoy_trans = makehgtform('translate',[data.decoy.X(data.i_sim,i_decoy), data.decoy.Y(data.i_sim,i_decoy), data.decoy.Z(data.i_sim,i_decoy)]);
            decoy_rot = makehgtform('xrotate',data.decoy.phi(data.i_sim,i_decoy),'yrotate',data.decoy.theta(data.i_sim,i_decoy),'zrotate',data.decoy.psi(data.i_sim,i_decoy));
        else
            decoy_trans = ship_trans;
            decoy_rot = ship_rot;
        end
        set(HG.decoy(i_decoy),'Matrix',decoy_trans*decoy_rot);
    end
    
    if data.t(end) > data.flag_sim_end
        sys.flag_stop = 2;
    end
    if sys.flag_stop == 2
        stop(handles.Timer_main)
        sys.flag_sim = 0;
        sys.flag_start = 0;
        sys.flag_ready = 1;
        time = clock;
        yyyy = num2str(time(1));
        if time(2) < 10
            mm = strcat('0',num2str(time(2)));
        else
            mm = num2str(time(2));
        end
        if time(3) < 10
            dd = strcat('0',num2str(time(3)));
        else
            dd = num2str(time(3));
        end
        if time(4) < 10
            hour = strcat('0',num2str(time(4)));
        else
            hour = num2str(time(4));
        end
        if time(5) < 10
            min = strcat('0',num2str(time(5)));
        else
            min = num2str(time(5));
        end
        file_name = strcat('data_',yyyy,mm,dd,hour,min,'.mat');
        cd data
        save(file_name,'data');
        cd ..
        data.t = [];
        data.ship = [];
        data.missile = [];
        data.decoy = [];
        data.TA = [];
        sys.data_table = cell(14,2);
        sys.flag_ready = 1;
        sys.flag_start = 0;
    end
else
end
if sys.flag_para == 1
    for i = 1:data.C.missile(1).N
        missile_trans = makehgtform('translate',[data.C.missile(i).X, data.C.missile(i).Y, data.C.missile(i).Z*sys.SF]);
        missile_rot = makehgtform('xrotate',0,'yrotate',0,'zrotate',data.C.missile(i).psi);
        set(HG.missile(i),'Matrix',missile_trans*missile_rot);
    end
end

if sys.flag_ready == 0
    set(handles.pushbutton_ready,'enable','off','backgroundcolor',[1 0 0]);
elseif sys.flag_ready == 1
    set(handles.pushbutton_ready,'enable','on','backgroundcolor',[0 1 1]);
elseif sys.flag_ready == 2
    set(handles.pushbutton_ready,'enable','inactive','backgroundcolor',[0 1 0]);
end

if sys.flag_start == 0
    set(handles.pushbutton_start,'enable','off','backgroundcolor',[1 0 0]);
elseif sys.flag_start == 1
    set(handles.pushbutton_start,'enable','on','backgroundcolor',[0 1 1]);
elseif sys.flag_start == 2
    set(handles.pushbutton_start,'enable','inactive','backgroundcolor',[0 1 0]);
end

if sys.flag_stop == 0
    set(handles.pushbutton_stop,'enable','off','backgroundcolor',[1 0 0]);
elseif sys.flag_stop == 1
    set(handles.pushbutton_stop,'enable','on','backgroundcolor',[0 1 1]);
elseif sys.flag_stop == 2
    set(handles.pushbutton_stop,'enable','inactive','backgroundcolor',[0 1 0]);
end

