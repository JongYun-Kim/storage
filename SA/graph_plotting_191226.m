%%% 결과 플롯 그리는 스크립트~
%%% 1: cir
%%% 2: rec_fast
%%% 3: rec_slow

%% Settings
clear all; close all;
SL = load('./data/paper_graph_all2.mat');
CP = load('./data/paper_graph_CPSO_191226.mat');
x = [CP.x; CP.x]';

%% PLOT1: 원형 진형
y_cir = [SL.y1_success2; CP.y1]';
y_cir_neg = [ SL.y1_min; CP.y1-CP.y1_min]';
y_cir_pos = [ SL.y1_max; CP.y1_max-CP.y1]';

% figure(1); grid on;
% errorbar(x,y_cir,y_cir_neg,y_cir_pos);

% figure/axes 생성
figure1 = figure(1);
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% errorbar에 대한 행렬 입력값을 사용하여 여러 오차 막대를 생성함
errorbar1 = errorbar(x,y_cir,y_cir_neg,y_cir_pos,'LineWidth',1.75);
set(errorbar1(1),'DisplayName','SL-PSO');
set(errorbar1(2),'DisplayName','PSO','LineStyle',':');
% label 생성
ylabel('Destruction rate (%)','FontWeight','bold');
xlabel('Number of UAVs','FontWeight','bold');

box(axes1,'on');
grid(axes1,'on');
% 나머지 axes 속성 설정
set(axes1,'FontSize',12,'FontWeight','bold');
% legend 생성
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.151021900357192 0.809450551035445 0.15416666418314 0.0948979566291887],...
    'FontSize',12);
figure1.Position = [ 2040 210 800 550 ];  % [left_pos, bottom_pos, width, height]


%% PLOT2: 사각진형 직진
y_rec1 = [SL.y2; CP.y2]';
y_rec1_neg = [ SL.y2_min; CP.y2-CP.y2_min]';
y_rec1_pos = [ SL.y2_max; CP.y2_max-CP.y2]';

% figure/axes 생성
figure2 = figure(2);
axes2 = axes('Parent',figure2);
hold(axes2,'on');

% errorbar에 대한 행렬 입력값을 사용하여 여러 오차 막대를 생성함
errorbar2 = errorbar(x,y_rec1,y_rec1_neg,y_rec1_pos,'LineWidth',1.75);
set(errorbar2(1),'DisplayName','SL-PSO');
set(errorbar2(2),'DisplayName','PSO','LineStyle',':');
% label 생성
ylabel('Destruction rate (%)','FontWeight','bold');
xlabel('Number of UAVs','FontWeight','bold');

box(axes2,'on');
grid(axes2,'on');
% 나머지 axes 속성 설정
set(axes2,'FontSize',12,'FontWeight','bold');
% legend 생성
legend2 = legend(axes2,'show');
set(legend2,...
    'Position',[0.151021900357192 0.809450551035445 0.15416666418314 0.0948979566291887],...
    'FontSize',12);
figure2.Position = [ 2090 210 800 550 ];  % [left_pos, bottom_pos, width, height]


%% PLOT3: 사각진형 후진
y_rec2 = [SL.y3_success; CP.y3]';
y_rec2_neg = [ SL.y3_min; CP.y3-CP.y3_min]';
y_rec2_pos = [ SL.y3_max; CP.y3_max-CP.y3]';

% figure/axes 생성
figure3 = figure(3);
axes3 = axes('Parent',figure3);
hold(axes3,'on');

% errorbar에 대한 행렬 입력값을 사용하여 여러 오차 막대를 생성함
errorbar3 = errorbar(x,y_rec2,y_rec2_neg,y_rec2_pos,'LineWidth',1.75);
set(errorbar3(1),'DisplayName','SL-PSO');
set(errorbar3(2),'DisplayName','PSO','LineStyle',':');
% label 생성
ylabel('Destruction rate (%)','FontWeight','bold');
xlabel('Number of UAVs','FontWeight','bold');

box(axes3,'on');
grid(axes3,'on');
% 나머지 axes 속성 설정
set(axes3,'FontSize',12,'FontWeight','bold');
% legend 생성
legend2 = legend(axes3,'show');
set(legend2,...
    'Position',[0.151021900357192 0.809450551035445 0.15416666418314 0.0948979566291887],...
    'FontSize',12);
figure3.Position = [ 2140 210 800 550 ];  % [left_pos, bottom_pos, width, height]


%% 그림 출력
% % % hgexport(figure(1), sprintf('cicular'), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % hgexport(figure(2), sprintf('rect1'), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% % % hgexport(figure(3), sprintf('rect2'), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
