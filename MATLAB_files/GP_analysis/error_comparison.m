% This is a script for comparison(s) b/w (1)model vs GP (2) GP: constant prior vs  modoel-based prior

clear all;
close all;


%% Environments

% Map data
load('./data/mapData8F.mat','unfreeMap','unfreeSpaceID','resolution');

% base positions
base_pos_set = [ 13.3, 62.5;    % odroid : XB21
                 37.8, 25.9;    % piA    : XB28    
                 51.4, 11.1];   % piC    : XB29


%% Models
load('./data/Comm_Model.mat');
C = model_params.C;
nu = model_params.nu;
alpha = model_params.alpha_val;


%% GP: settings :: functions in hyps
% GP samples data
load('./data/gprData.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global base_pos_meanfunc;
training = true;  % 학습을 또 할건가요 아니면 가져 올건가여
flg_base = 2;
% flg_mean = 0; % meanConst
% flg_mean = 1; % meanPathloss
Max_Err_Count = 20;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flg_base ==1
    samples = xb21(:,2:4);
    base_pos_meanfunc = base_pos_set(flg_base,:);
elseif flg_base == 2
    samples = xb28(:,2:4);
    base_pos_meanfunc = base_pos_set(flg_base,:);
elseif flg_base == 3
    samples = xb29(:,2:4);
    base_pos_meanfunc = base_pos_set(flg_base,:);
else
    % DO STH ELSE
end
    samples(:,3) = -samples(:,3);
size_samples = size(samples,1);

% dividing the samples into tr and tst sets
training_range = 1:6000;
test_range = 6001:size_samples;

% training set
tr_freq = 5;  % training idx frequency
tr_idx_logic  = mod(training_range,tr_freq)==1;  % 1 only when mod(10)=1 in a logic form
val_idx_logic = mod(training_range,tr_freq)~=1;  % 
tr_set = samples(tr_idx_logic,:);      % training data
val_set = samples(val_idx_logic,:);    % rest of the data in the tr_range : for the validation
tst_set = samples(test_range,:);       % TEST SET

% GP functions
meanfunc1 = @meanConst;                            % Constant mean function
hyp1.mean = -50;

meanfunc2 = @meanPathloss;                        % path loss mean function
hyp2.mean = [2.0; -28.0];

covfunc = @covSEiso;               % Squared Exponental covariance function
hyp1.cov = [0; 0];
hyp2.cov = hyp1.cov;

likfunc = @likGauss;                                  % Gaussian likelihood
sn = 0.2;
hyp1.lik = log(sn);
hyp2.lik = hyp1.lik;

% model-based prior::composite mean functions or custom gp mean functions


%% GP Training
if training
    % training
    n = size(tr_set,1);  % the number of training points (training samples)
    x = tr_set(:,1:2);  % training inputs
    Y = tr_set(:,3);  % training outputs

    % Hyperparameter learning
    hyp_trained1 = minimize(hyp1, @gp, -100, @infGaussLik, meanfunc1, covfunc, likfunc, x, Y);
    hyp_trained2 = minimize(hyp2, @gp, -100, @infGaussLik, meanfunc2, covfunc, likfunc, x, Y);
else
    % load trained data
    
end


%% GP-test
% validation in/outputs
z_val = val_set(:,1:2);  % validation inputs
w_val = val_set(:,3);    % validation outputs
w_model_val =  modelRSSI([z_val,repmat(base_pos_meanfunc,size(z_val,1),1)],model_params,unfreeMap,resolution,unfreeSpaceID);  % val outputs for the model

% training set in/outputs
z_tst = tst_set(:,1:2);  % test inputs
w_tst = tst_set(:,3);    % test outputs
w_model_tst =  modelRSSI([z_tst,repmat(base_pos_meanfunc,size(z_tst,1),1)],model_params,unfreeMap,resolution,unfreeSpaceID);  % test ouputs for the model
     
% GP reuslts: the validation and test
%     [m, s2] = gp(hyp_trained, @infExact, [], covfunc, likfunc, x, Y, z);
[w_gp1_val, s21_val] = gp(hyp_trained1, @infGaussLik, meanfunc1, covfunc, likfunc, x, Y, z_val);
[w_gp1_tst, s21_tst] = gp(hyp_trained1, @infGaussLik, meanfunc1, covfunc, likfunc, x, Y, z_tst);
[w_gp2_val, s22_val] = gp(hyp_trained2, @infGaussLik, meanfunc2, covfunc, likfunc, x, Y, z_val);
[w_gp2_tst, s22_tst] = gp(hyp_trained2, @infGaussLik, meanfunc2, covfunc, likfunc, x, Y, z_tst);


%% Error Computation
% err = |현재값 - 실제값|;
err_val = [w_model_val, w_gp1_val, w_gp2_val] - w_val;
err_tst = [w_model_tst, w_gp1_tst, w_gp2_tst] - w_tst;

% err count 변수: i행은 i-1~i의 에러 갯수
err_count_val = zeros(Max_Err_Count+1,size(err_val,2));
err_cuml_val  = zeros(Max_Err_Count+1,size(err_val,2));
err_count_tst = zeros(Max_Err_Count+1,size(err_tst,2));
err_cuml_tst  = zeros(Max_Err_Count+1,size(err_tst,2));

% 각 구간에 대해서 error 갯수 파악
for i = 1:Max_Err_Count  % error 20까지 측정
    % i-1이상 i미만의 갯수를 세어봄
    err_count_val(i,:) = sum( abs(err_val)>=(i-1) & abs(err_val)<i );
    err_cuml_val(i,:)  = sum( err_count_val(1:i,:));
    err_count_tst(i,:) = sum( abs(err_tst)>=(i-1) & abs(err_tst)<i );
    err_cuml_tst(i,:)  = sum( err_count_tst(1:i,:));
end
err_count_val(end,:) = sum( abs(err_val)>=Max_Err_Count);
err_cuml_val(end,:)  = sum( err_count_val);
err_count_tst(end,:) = sum( abs(err_tst)>=Max_Err_Count);
err_cuml_tst(end,:)  = sum( err_count_tst );


%% Plots: RSSIs
num_plot_x = size(z_val,1) + size(z_tst,1);
x_plot = 1:num_plot_x;

%  X1:  x 데이터의 벡터
%  YMATRIX1:  y 데이터의 행렬
%  X2:  x 데이터의 벡터
%  YMATRIX2:  y 데이터의 행렬
X1 = x_plot(1:size(z_val));
YMatrix1 = [w_val, w_model_val, w_gp1_val, w_gp2_val];
X2 = x_plot(size(z_val)+1:end);
YMatrix2 = [w_tst, w_model_tst, w_gp1_tst, w_gp2_tst];

%  MATLAB에서 09-Nov-2019 20:34:39에 자동 생성됨

% figure 생성
figure1 = figure(1);

% axes 생성
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% plot에 대한 행렬 입력값을 사용하여 여러 라인을 생성함
plot1 = plot(X1,YMatrix1,'Parent',axes1,'LineWidth',2);
set(plot1(1),'DisplayName','Samples (validation)','MarkerSize',8,...
    'Marker','.',...
    'LineStyle','none',...
    'Color',[0.7 0.7 0.7],...
    'LineWidth',0.5);
set(plot1(2),'DisplayName','Model (validation)','LineStyle',':','Color',[0.8500 0.3250 0.0980]);
set(plot1(3),'DisplayName','GP_{constant\_mean} (validation)','Color',[0 0.4470 0.7410]);
set(plot1(4),'DisplayName','GP_{path\_loss\_mean} (validation)','Color',[0.9290 0.6940 0.1250]);

% plot에 대한 행렬 입력값을 사용하여 여러 라인을 생성함
plot2 = plot(X2,YMatrix2,'Parent',axes1,'LineWidth',2);
set(plot2(1),'DisplayName','Samples (test)','MarkerSize',8,'Marker','.',...
    'LineStyle','none',...
    'Color',[0.38 0.38 0.38],...
    'LineWidth',0.5);
set(plot2(2),'DisplayName','Model (test)','LineStyle','-.','Color',[0.4940 0.1840 0.5560]);
set(plot2(3),'DisplayName','GP_{constant\_mean} (test)','Color',[0.4660 0.6740 0.1880]);
set(plot2(4),'DisplayName','GP_{path\_loss\_mean} (test)','Color',[0.6350 0.0780 0.1840]);

% ylabel 생성
ylabel('RSSI [dBm]','FontWeight','bold');

% xlabel 생성
xlabel('Sample number','FontWeight','bold');

% 다음 라인의 주석 처리를 제거하여 좌표축의 X 제한을 유지
% xlim(axes1,[0 6650]);
grid(axes1,'on');
% 나머지 axes 속성 설정
set(axes1,'FontSize',14,'FontWeight','bold');
% legend 생성
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.1371 0.6512 0.2267 0.2645],...
    'FontSize',13);
figure1.Position = [ 2000 190 1300 700 ];  % [left_pos, bottom_pos, width, height]
xlim([0, length(x_plot)]);

%% Path/Map Plots
if flg_base == 1
    xb = xb21;
elseif flg_base == 2
    xb = xb28;
elseif flg_base == 3
    xb = xb29;
else
    error('choose a proper xb')
end

%  MATLAB에서 09-Nov-2019 21:19:35에 자동 생성됨

% figure 생성
figure2 = figure;
colormap(gray);

% axes 생성
axes2 = axes('Parent',figure2);
hold(axes2,'on');

% training plot
plot3(xb(training_range,2),xb(training_range,3),ones(length(training_range),1),'DisplayName','Training and validation','LineWidth',1,...
    'Color',[0.85 0.325 0.098]);
% test path plot
plot3(xb(test_range,2),xb(test_range,3),ones(length(test_range),1),'DisplayName','Test','LineWidth',1,'Color',[0 0.447 0.741],'LineStyle','-.');

% base plot
plot3(base_pos_meanfunc(1),base_pos_meanfunc(2),1,'o','Color','g','MarkerSize',3,'LineWidth',3,'DisplayName','Base')

% map plot
surf(0:0.1:60.7,0:0.1:70.3,unfreeMap','Parent',axes2,'LineStyle','none','DisplayName','Map');

% label 생성
ylabel('y [m]','FontWeight','bold'); xlabel('x [m]','FontWeight','bold');

xlim(axes2,[0 60.7]);  ylim(axes2,[0 70.3]);  zlim(axes2,[0.01 1]);
% 나머지 axes 속성 설정
set(axes2,'CLim',[0 1.67],'FontSize',12,'FontWeight','bold');
% legend 생성
legend2 = legend(axes2,'show');
set(legend2,'FontSize',12);

figure2.Position = [ 250 150 690 750 ];  % [left_pos, bottom_pos, width, height]

%% Error Plots
% figure 생성
figure3 = figure(3);

% axes 생성
axes3 = axes('Parent',figure3);
hold(axes3,'on');

% plot에 대한 행렬 입력값을 사용하여 여러 라인을 생성함
plot_err = plot(X1,err_val,'Parent',axes3,'LineWidth',0.7);
set(plot_err(1),'DisplayName','Model (validation)','LineStyle',':','Color',[0.8500 0.3250 0.0980]);
set(plot_err(2),'DisplayName','GP_{constant\_mean} (validation)','Color',[0 0.4470 0.7410]);
set(plot_err(3),'DisplayName','GP_{path\_loss\_mean} (validation)','Color',[0.9290 0.6940 0.1250]);

% plot에 대한 행렬 입력값을 사용하여 여러 라인을 생성함
plot_err2 = plot(X2,err_tst,'Parent',axes3,'LineWidth',0.7);
set(plot_err2(1),'DisplayName','Model (test)','LineStyle','-.','Color',[0.4940 0.1840 0.5560]);
set(plot_err2(2),'DisplayName','GP_{constant\_mean} (test)','Color',[0.4660 0.6740 0.1880]);
set(plot_err2(3),'DisplayName','GP_{path\_loss\_mean} (test)','Color',[0.6350 0.0780 0.1840]);

% ylabel 생성
ylabel('Error [dBm]','FontWeight','bold');

% xlabel 생성
xlabel('Sample position','FontWeight','bold');

% 다음 라인의 주석 처리를 제거하여 좌표축의 X 제한을 유지
% xlim(axes1,[0 6650]);
grid(axes3,'on');
% 나머지 axes 속성 설정
set(axes3,'FontSize',13,'FontWeight','bold');
% legend 생성
legend3 = legend(axes3,'show');
set(legend3,...
    'Position',[0.1371 0.6512 0.2267 0.2645],...
    'FontSize',13);
figure3.Position = [ 2000 190 1300 700 ];  % [left_pos, bottom_pos, width, height]
xlim([0, length(x_plot)]);


%% Error Distributions Plots
x = 1:Max_Err_Count+1;
draw_model = 0;
lgd_err_str = {'model','meanConst','meanComm'};

% val errors
figure(4);
bar(x,err_count_val(:,(2-draw_model):end));
grid on; legend(lgd_err_str{(2-draw_model):end});
xlabel('Error [dBm]'); ylabel('# of errors')

figure(5);
bar(x,err_cuml_val(:,(2-draw_model):end));
grid on; legend(lgd_err_str{(2-draw_model):end});
xlabel('Error [dBm]'); ylabel('# of errors (cumulative)')

figure(6);
bar(x,err_count_tst(:,(2-draw_model):end));
grid on; legend(lgd_err_str{(2-draw_model):end});
xlabel('Error [dBm]'); ylabel('# of errors')

figure(7);
bar(x,err_cuml_tst(:,(2-draw_model):end));
grid on; legend(lgd_err_str{(2-draw_model):end});
xlabel('Error [dBm]'); ylabel('# of errors (cumulative)')


%% Exporting Figures
% hgexport(figure(1), sprintf(['base',num2str(flg_base),'_sample_model_gp']), hgexport('factorystyle'), 'Format', 'png','Resolution',300);
% hgexport(figure(2), sprintf(['base',num2str(flg_base),'path']), hgexport('factorystyle'), 'Format', 'png','Resolution',300);

