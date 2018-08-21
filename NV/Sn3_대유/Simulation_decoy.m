function varargout = Simulation_decoy(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Simulation_decoy_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Simulation_decoy_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 08-Nov-2017 13:34:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Simulation_decoy_OpeningFcn, ...
                   'gui_OutputFcn',  @Simulation_decoy_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before main is made visible.
function Simulation_decoy_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)
clc
% Choose default command line output for main
handles.output = hObject;
[handles] = GUIInit(handles);
[handles] = TimerSetting(handles);

% Update handles structure
guidata(hObject, handles);
start(handles.Timer_vis);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.main);


% --- Outputs from this function are returned to the command line.
function varargout = Simulation_decoy_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function radiobutton_single_Callback(hObject, eventdata, handles)
global sys data
sys.flag_MC = 0;
set(handles.text_missile_title_X,'enable','on')
set(handles.edit_missile_X,'enable','on')
set(handles.text_missile_unit_X,'enable','on')
set(handles.text_missile_title_Y,'enable','on')
set(handles.edit_missile_Y,'enable','on')
set(handles.text_missile_unit_Y,'enable','on')
set(handles.text_missile_title_Z,'enable','on')
set(handles.edit_missile_Z,'enable','on')
set(handles.text_missile_unit_Z,'enable','on')

set(handles.text_missile_title_itN,'enable','off')
set(handles.edit_missile_itN,'enable','off')
set(handles.text_missile_unit_itN,'enable','off')
set(handles.text_missile_title_R,'enable','off')
set(handles.edit_missile_R,'enable','off')
set(handles.text_missile_unit_R,'enable','off')
set(handles.text_missile_title_theta,'enable','off')
set(handles.edit_missile_theta,'enable','off')
set(handles.text_missile_unit_theta,'enable','off')
set(handles.text_missile_title_dtheta1,'enable','off')
set(handles.edit_missile_dtheta1,'enable','off')
set(handles.text_missile_unit_dtheta1,'enable','off')
set(handles.text_missile_title_dtheta2,'enable','off')
set(handles.edit_missile_dtheta2,'enable','off')
set(handles.text_missile_unit_dtheta2,'enable','off')
[data]=CASEInit(handles,data,sys);


function radiobutton_MC_Callback(hObject, eventdata, handles)
global sys data
sys.flag_MC = 1;
set(handles.text_missile_title_X,'enable','off')
set(handles.edit_missile_X,'enable','off')
set(handles.text_missile_unit_X,'enable','off')
set(handles.text_missile_title_Y,'enable','off')
set(handles.edit_missile_Y,'enable','off')
set(handles.text_missile_unit_Y,'enable','off')
set(handles.text_missile_title_Z,'enable','off')
set(handles.edit_missile_Z,'enable','off')
set(handles.text_missile_unit_Z,'enable','off')

set(handles.text_missile_title_itN,'enable','on')
set(handles.edit_missile_itN,'enable','on')
set(handles.text_missile_unit_itN,'enable','on')
set(handles.text_missile_title_R,'enable','on')
set(handles.edit_missile_R,'enable','on')
set(handles.text_missile_unit_R,'enable','on')
set(handles.text_missile_title_theta,'enable','on')
set(handles.edit_missile_theta,'enable','inactive')
set(handles.text_missile_unit_theta,'enable','on')
set(handles.text_missile_title_dtheta1,'enable','on')
set(handles.edit_missile_dtheta1,'enable','on')
set(handles.text_missile_unit_dtheta1,'enable','on')
set(handles.text_missile_title_dtheta2,'enable','on')
set(handles.edit_missile_dtheta2,'enable','on')
set(handles.text_missile_unit_dtheta2,'enable','on')
[data]=CASEInit(handles,data,sys);


function radiobutton_RF_Callback(hObject, eventdata, handles)
global sys
sys.scen = 1;
set(handles.text_decoy_title_RCS,'enable','off');
set(handles.edit_decoy_RCS,'enable','off');
set(handles.text_decoy_unit_RCS,'enable','off');
function radiobutton_RCS_Callback(hObject, eventdata, handles)
global sys
sys.scen = 2;
set(handles.text_decoy_title_RCS,'enable','on');
set(handles.edit_decoy_RCS,'enable','on');
set(handles.text_decoy_unit_RCS,'enable','on');

function pushbutton_case1_Callback(hObject, eventdata, handles)
set(handles.pushbutton_case1,'enable','inactive','foregroundcolor',[0 0 1]);
set(handles.pushbutton_case2,'enable','on','foregroundcolor',[0 0 0]);
set(handles.pushbutton_case3,'enable','on','foregroundcolor',[0 0 0]);
set(handles.pushbutton_case4,'enable','on','foregroundcolor',[0 0 0]);
global sys data
sys.flag_ready = 1;
sys.flag_para = 0;
sys.flag_start = 0;
sys.case = 1;
[data]=CASEInit(handles,data,sys);

function pushbutton_case2_Callback(hObject, eventdata, handles)
set(handles.pushbutton_case1,'enable','on','foregroundcolor',[0 0 0]);
set(handles.pushbutton_case2,'enable','inactive','foregroundcolor',[0 0 1]);
set(handles.pushbutton_case3,'enable','on','foregroundcolor',[0 0 0]);
set(handles.pushbutton_case4,'enable','on','foregroundcolor',[0 0 0]);
global sys data
sys.flag_ready = 1;
sys.flag_para = 0;
sys.flag_start = 0;
sys.case = 2;
[data]=CASEInit(handles,data,sys);

function pushbutton_case3_Callback(hObject, eventdata, handles)
set(handles.pushbutton_case1,'enable','on','foregroundcolor',[0 0 0]);
set(handles.pushbutton_case2,'enable','on','foregroundcolor',[0 0 0]);
set(handles.pushbutton_case3,'enable','inactive','foregroundcolor',[0 0 1]);
set(handles.pushbutton_case4,'enable','on','foregroundcolor',[0 0 0]);
global sys data
sys.flag_ready = 1;
sys.flag_para = 0;
sys.flag_start = 0;
sys.case = 3;
[data]=CASEInit(handles,data,sys);

function pushbutton_case4_Callback(hObject, eventdata, handles)
set(handles.pushbutton_case1,'enable','on','foregroundcolor',[0 0 0]);
set(handles.pushbutton_case2,'enable','on','foregroundcolor',[0 0 0]);
set(handles.pushbutton_case3,'enable','on','foregroundcolor',[0 0 0]);
set(handles.pushbutton_case4,'enable','inactive','foregroundcolor',[0 0 1]);
global sys data
sys.flag_ready = 1;
sys.flag_para = 0;
sys.flag_start = 0;
sys.case = 4;
[data]=CASEInit(handles,data,sys);

% control panel
function pushbutton_ready_Callback(hObject, eventdata, handles)
global sys data
if sys.flag_ready == 1
    sys.flag_ready = 2;
    sys.flag_stop = 0;
    if sys.flag_MC == 0
        [handles] = PARAInit(handles);
        sys.flag_para = 1;
    end
    sys.flag_start = 1;
end

function pushbutton_start_Callback(hObject, eventdata, handles)
global sys data i_itr
sys.flag_start = 2;
sys.flag_para = 0;
if sys.flag_MC == 0
    sys.flag_stop = 1;
    start(handles.Timer_main)
    sys.flag_sim = 1;
else
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
    file_name_ini = strcat('data_iter_',yyyy,mm,dd,hour,min);
    for i_itr= 1:length(data.iter.theta)
        for i_MC= 1:data.iter.N
            [handles] = PARAInit(handles);
            for i = 0:data.flag_sim_end/data.dt
                Timer_mainFcn
            end
            disp(strcat('i_itr: ',num2str(i_itr),'///////////','i_MC: ',num2str(i_MC)))
            data.iter.D_miss_table(i_itr,i_MC) = data.iter.D_miss;
            if data.iter.D_miss_table(i_itr,i_MC) > data.ship.D_kill(1,1)*2
                data.iter.S_rate(i_itr,i_MC) = 100;
            else
                data.iter.S_rate(i_itr,i_MC) = data.iter.D_miss_table(i_itr,i_MC)/(data.ship.D_kill(1,1)*5) * 100;
            end
            
            file_name = strcat(file_name_ini,'_i_itr',num2str(i_itr),'_i_MC',num2str(i_MC),'.mat');
            cd data
            cd iterative
            save(file_name,'data');
            cd ..
            cd ..
            data.t = [];
            data.ship = [];
            data.missile = [];
            data.decoy = [];
            data.TA = [];
        end
        polar_S_rate(i_itr) = sum(data.iter.S_rate(i_itr,:))/data.iter.N;
        polar_S_rate(i_itr)
        %         polarplot(handles.axes_polar,data.iter.theta(1:i_itr),data.iter.D_miss_table(:,1),data.iter.theta(1:i_itr),data.iter.S_rate(:,1));
        polar_plot = polar(handles.axes_polar,data.iter.theta(1:i_itr),polar_S_rate);
        set(polar_plot,'marker','*','markeredgecolor','m','markerfacecolor','m','color','m','linewidth',2)
        % polarplot(handles.axes_polar,data.iter.theta(1:i_itr),data.iter.D_miss_table(1:i_itr,i_MC));
        pause(1)
    end
    sys.flag_start = 0;
    sys.flag_ready = 1;
end

function pushbutton_stop_Callback(hObject, eventdata, handles)
global sys
sys.flag_stop = 2;

% iterative simulation: edit functions
function edit_missile_itN_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_itN_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
data.iter.N = str2num(get(handles.edit_missile_itN,'string'));

function edit_missile_R_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_R_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
data.iter.R = str2num(get(handles.edit_missile_R,'string'));

function edit_missile_theta_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_theta_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
data.iter.theta = str2num(get(handles.edit_missile_theta,'string'));

function edit_missile_dtheta1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_dtheta1_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
data.iter.theta = str2num(get(handles.edit_missile_dtheta1,'string'));

function edit_missile_dtheta2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_dtheta2_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
data.iter.theta = str2num(get(handles.edit_missile_dtheta2,'string'));

% missile: edit functions
function edit_missile_N_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_N_Callback(hObject, eventdata, handles)
global sys data
check = str2num(get(handles.edit_missile_N,'string'));
if isempty(check) == 1
    h = msgbox('숫자 1~3 사이 값을 입력하세요.', 'Error','error');
else
    if check >= 1 && check <= 3
        data.C.missile(1).N = check;
        set(handles.popupmenu_missile_No,'string',num2str([1:data.C.missile(1).N]'));
    else
        h = msgbox('숫자 1~3 사이 값을 입력하세요.', 'Error','error');
    end
end
sys.flag_ready = 1;

function popupmenu_missile_No_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_missile_No_Callback(hObject, eventdata, handles)
global data
r2d = 180/pi;
check = get(handles.popupmenu_missile_No,'value');
for i = 1:data.C.missile(1).N
    if check == i
        set(handles.edit_missile_X,...
            'string',num2str(data.C.missile(i).X));
        set(handles.edit_missile_Y,...
            'string',num2str(data.C.missile(i).Y));
        set(handles.edit_missile_Z,...
            'string',num2str(data.C.missile(i).Z));
        set(handles.edit_missile_V,...
            'string',num2str(data.C.missile(i).V));
        set(handles.edit_missile_psi,...
            'string',num2str(data.C.missile(i).psi*r2d));
        set(handles.edit_missile_P_rt,...
            'string',num2str(data.C.missile(i).P_rt*10^6));
        set(handles.edit_missile_G_rt,...
            'string',num2str(data.C.missile(i).G_rt));
        set(handles.edit_missile_G_rr,...
            'string',num2str(data.C.missile(i).G_rr));
        set(handles.edit_missile_F,...
            'string',num2str(data.C.missile(i).F));
        set(handles.edit_missile_FoV_lim,...
            'string',num2str(data.C.missile(i).FoV_lim*r2d));
    end
end

function edit_missile_X_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_X_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_missile_No,'value');
data.C.missile(check).X = str2num(get(handles.edit_missile_X,'string'));

function edit_missile_Y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_Y_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_missile_No,'value');
data.C.missile(check).Y = str2num(get(handles.edit_missile_Y,'string'));

function edit_missile_Z_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_Z_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_missile_No,'value');
data.C.missile(check).Z = str2num(get(handles.edit_missile_Z,'string'));

function edit_missile_V_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_V_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_missile_No,'value');
data.C.missile(check).V = str2num(get(handles.edit_missile_V,'string'));

function edit_missile_psi_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_psi_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_missile_No,'value');
d2r = pi/180;
data.C.missile(check).psi = str2num(get(handles.edit_missile_psi,'string'))*d2r;

function edit_missile_P_rt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_P_rt_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_missile_No,'value');
data.C.missile(check).P_rt = str2num(get(handles.edit_missile_P_rt,'string'))*10^-6;

function edit_missile_G_rt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_G_rt_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_missile_No,'value');
data.C.missile(check).G_rt = str2num(get(handles.edit_missile_G_rt,'string'));

function edit_missile_G_rr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_G_rr_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_missile_No,'value');
data.C.missile(check).G_rr = str2num(get(handles.edit_missile_G_rr,'string'));

function edit_missile_F_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_F_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_missile_No,'value');
data.C.missile(check).F= str2num(get(handles.edit_missile_F,'string'));

function edit_missile_FoV_lim_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_missile_FoV_lim_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_missile_No,'value');
d2r = pi/180;
data.C.missile(check).FoV_lim = str2num(get(handles.edit_missile_FoV_lim,'string'))*d2r;

% decoy: edit functions
function edit_decoy_N_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_decoy_N_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = str2num(get(handles.edit_decoy_N,'string'));
if isempty(check) == 1
    if sys.case == 1
        h = msgbox('숫자 1~2 사이 값을 입력하세요.', 'Error','error');
    elseif sys.case == 4
        h = msgbox('숫자 1~20 사이 값을 입력하세요.', 'Error','error');
    end
else
    if sys.case == 1
        if check >= 1 && check <= 2
            data.C.decoy(1).N = check;
            set(handles.popupmenu_decoy_No,'string',num2str([1:data.C.decoy(1).N]'));
        else
            h = msgbox('숫자 1~2 사이 값을 입력하세요.', 'Error','error');
        end
    elseif sys.case == 4
        if check >= 1 && check <= 20
            data.C.decoy(1).N = check;
            set(handles.popupmenu_decoy_No,'string',num2str([1:data.C.decoy(1).N]'));
        else
            h = msgbox('숫자 1~20 사이 값을 입력하세요.', 'Error','error');
        end
    end
end

function popupmenu_decoy_No_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_decoy_No_Callback(hObject, eventdata, handles)
global data
r2d = 180/pi;
check = get(handles.popupmenu_decoy_No,'value');
for i = 1:data.C.decoy(1).N
    if check == i
        set(handles.edit_decoy_V,...
            'string',num2str(data.C.decoy(i).V));
        set(handles.edit_decoy_psi,...
            'string',num2str(data.C.decoy(i).lau_psi*r2d));
        set(handles.edit_decoy_Z,...
            'string',num2str(data.C.decoy(i).Z));
        set(handles.edit_decoy_P_jt,...
            'string',num2str(data.C.decoy(i).P_jt*10^6));
        set(handles.edit_decoy_G_jt,...
            'string',num2str(data.C.decoy(i).G_jt));
        set(handles.edit_decoy_G_rr,...
            'string',num2str(data.C.decoy(i).G_rr));
        set(handles.edit_decoy_F,...
            'string',num2str(data.C.decoy(i).F));
    end
end

function edit_decoy_V_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_decoy_V_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_decoy_No,'value');
data.C.decoy(check).V = str2num(get(handles.edit_decoy_V,'string'));

function edit_decoy_psi_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_decoy_psi_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_decoy_No,'value');
d2r = pi/180;
data.C.decoy(check).lau_psi = str2num(get(handles.edit_decoy_psi,'string'))*d2r;

function edit_decoy_Z_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_decoy_Z_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_decoy_No,'value');
data.C.decoy(check).Z = str2num(get(handles.edit_decoy_Z,'string'));

function edit_decoy_P_jt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_decoy_P_jt_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_decoy_No,'value');
data.C.decoy(check).P_jt = str2num(get(handles.edit_decoy_P_jt,'string'))*10^-6;

function edit_decoy_G_jt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');g
end
function edit_decoy_G_jt_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_decoy_No,'value');
data.C.decoy(check).G_jt = str2num(get(handles.edit_decoy_G_jt,'string'));

function edit_decoy_G_rr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_decoy_G_rr_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_decoy_No,'value');
data.C.decoy(check).G_rr = str2num(get(handles.edit_decoy_G_rr,'string'));

function edit_decoy_F_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_decoy_F_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_decoy_No,'value');
data.C.decoy(check).F = str2num(get(handles.edit_decoy_F,'string'));

function edit_decoy_RCS_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_decoy_RCS_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = get(handles.popupmenu_decoy_No,'value');
data.C.decoy(check).RCS = str2num(get(handles.edit_decoy_RCS,'string'));

% ship: edit functions
function edit_ship_V_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_ship_V_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = 1;
data.C.ship(check).V = str2num(get(handles.edit_ship_V,'string'));

function edit_ship_psi_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_ship_psi_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = 1;
d2r = pi/180;
data.C.ship(check).V = str2num(get(handles.edit_ship_V,'string'))*d2r;

function edit_ship_RCS_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_ship_RCS_Callback(hObject, eventdata, handles)
global sys data
sys.flag_ready = 1;
check = 1;
data.C.ship(check).RCS = str2num(get(handles.edit_ship_RCS,'string'));

function main_CloseRequestFcn(hObject, eventdata, handles)
% global data
% save('sim_data.mat','data')
timer_all = timerfindall;
if isempty(timer_all) == 1
else
    stop(timer_all);
    delete(timer_all);
end
delete(hObject);
clear all;
% clc;
