function [a] = ICON_Duct(ax,transparency,SF)
%% reference coordinates
R = 0.186;
z_dir = -1;
x_r = 0*SF;
y_r = 0*SF;
z_r = 0*SF;
x_of = 0;
y_of = 0;
z_of = +0.3*SF;
line_width = 1;

% c_gray = vehicle_color;
c_gray = [180 180 180]/255;
% c_gray = [180 0 0]/255;
c_red = [255 0 0]/255;
c_blue = [0 0 255]/255;
c_green = [0 180 0]/255;
c_yellow = [255 255 0]/255;
c_dgray = [80 80 80]/255;

c_black = [0 0 0]/255;

D = R*2; % [m] sizing length, outter duct radious
N = 50;
%% fuselage_upper
theta = linspace(0,2*pi,N);

h_h = 0.3; % height of a fuselage
r_h_1 = 0.5*D*0; % radious of a top of surface of the fuselage
rho_h_1 = ones(1,N)*r_h_1;
[x_h(:,1),y_h(:,1)] = pol2cart(theta,rho_h_1);
z_h(:,1) = ones(length(x_h(:,1)),1)*0;

r_h_2 = 0.5*D*0.1;
rho_h_2 = ones(1,N)*r_h_2;
[x_h(:,2),y_h(:,2)] = pol2cart(theta,rho_h_2);
z_h(:,2) = ones(length(x_h(:,1)),1) * (-h_h*0.02);

r_h_3 = 0.5*D*0.5;
rho_h_3 = ones(1,N)*r_h_3;
[x_h(:,3),y_h(:,3)] = pol2cart(theta,rho_h_3);
z_h(:,3) = ones(length(x_h(:,1)),1) * (-h_h*0.07);

r_h_4 = 0.5*D*1;
rho_h_4 = ones(1,N)*r_h_4;
[x_h(:,4),y_h(:,4)] = pol2cart(theta,rho_h_4);
z_h(:,4) = ones(length(x_h(:,1)),1) * (-h_h*0.15);

r_h_5 = 0.5*D*1; % radious of an end of surface of the fuselage
rho_h_5 = ones(1,N)*r_h_5;
[x_h(:,5),y_h(:,5)] = pol2cart(theta,rho_h_5);
z_h(:,5) = ones(length(x_h(:,1)),1) * (-h_h*0.85);

r_h_6 = 0.5*D*0; % radious of an end of surface of the fuselage
rho_h_6 = ones(1,N)*r_h_6;
[x_h(:,6),y_h(:,6)] = pol2cart(theta,rho_h_6);
z_h(:,6) = ones(length(x_h(:,1)),1) * (-h_h);

h(1) = surface('parent',ax,'xdata',(x_h)*SF + x_r + x_of, 'ydata',(y_h)*SF + y_r + y_of, 'zdata',(-(z_h) * z_dir)*SF + z_r + z_of,...
    'facecolor',c_red,'edgecolor',c_red,...
    'linewidth',line_width,'facealpha',transparency,'edgealpha',transparency);



hg = [h];

%% Moving

a = hgtransform('Parent',ax);
set(hg,'Parent',a);