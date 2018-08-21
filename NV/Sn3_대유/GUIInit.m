function [handles]=GUIInit(handles)
global sys data HG
% initial setting for simulation
sys.flag_ready = 0; % 0 off, 1 ready, 2 on
sys.flag_start = 0; % 0 off, 1 ready, 2 on
sys.flag_stop = 0; % 0 off, 1 ready, 2 on
sys.flag_para = 0;
sys.flag_sim = 0;
sys.data_table = cell(14,2);
sys.t = 0;
sys.SF = 40;
sys.SF_icon = 60;

sys.flag_MC = 0;
sys.scen = 1; % 1: RF / 2: RCS
sys.case = 0;
HG.missile = [];
HG.decoy = [];
HG.ship = [];

% initial setting for GUI
set(handles.main,'MenuBar','figure','renderer','opengl');
set(handles.uipanel_case1,'position',[810 380 780 450]);
set(handles.pushbutton_case1,'enable','on');
set(handles.pushbutton_case2,'enable','on');
set(handles.pushbutton_case3,'enable','on');
set(handles.pushbutton_case4,'enable','on');

set(handles.axes_plot1_pre,'xlim',[0 10],'ylim',[0 5000],'visible','off');
set(handles.axes_plot2_pre,'xlim',[0 10],'ylim',[-500 50],'visible','off');
set(handles.axes_plot3_pre,'xlim',[0 10],'ylim',[-500 50],'visible','off');
set(handles.axes_plot4_pre,'xlim',[0 10],'ylim',[-500 50],'visible','off');

handles.axes_polar = axes('parent',handles.main,...
    'units','pixels');
set(handles.axes_polar,'position',get(handles.axes_plot4_pre,'position'));
handles.axes_plot1=axes('parent',handles.main,'xlim',[0 10],'ylim',[0 5000],...
    'units','pixels');
set(handles.axes_plot1, 'position',get(handles.axes_plot1_pre,'position'));
handles.axes_plot2=axes('parent',handles.main,'xlim',[0 10],'ylim',[-500 50],...
    'units','pixels');
set(handles.axes_plot2, 'position',get(handles.axes_plot2_pre,'position'));
% handles.axes_plot3=axes('parent',handles.main,'xlim',[0 10],'ylim',[-500 50],...
%     'units','pixels');
% set(handles.axes_plot3, 'position',get(handles.axes_plot3_pre,'position'));


% sea
SF_map = 550*sys.SF;
SF_sea = 20;
[x,y] = meshgrid(-SF_map:2*SF_map/SF_sea:SF_map,-SF_map:2*SF_map/SF_sea:SF_map); 
sea_surf = peaks(SF_sea) + repmat(peaks(SF_sea/2),2,2) + repmat(peaks(SF_sea/4),4,4); 

sea_surf(:,SF_sea+1) = 0; 
sea_surf(SF_sea+1,:) = 0; 
sea_surf = 0.7/sys.SF*sea_surf; 

surf(x,y,sea_surf,... 
'parent',handles.axes_disp,'FaceColor',[.2 .4 .9],'EdgeColor',[.9 .9 .9],'FaceAlpha',1,'EdgeAlpha',.2);

set(handles.axes_disp,'parent',handles.main,'dataaspectratio',[1 1 1],...
    'xlim',[-1 1]*SF_map,'ylim',[-1 1]*SF_map,'zlim',[0 0.1]*SF_map,...
    'xtick',[-1:0.5:1]*SF_map,'ytick',[-1:0.5:1]*SF_map,...
    'xgrid','on','ygrid','on','zgrid','on',...
    'fontsize',15,'FontAngle','normal','fontweight','normal',...
    'cameraposition',[50 50 50]*SF_map,...
    'YDir','normal','ZDir','normal');


scenario_case(handles,sys,data);
