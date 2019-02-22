clear all
clc

%%

c35r = load('curve_35.mat');
c35r =cell2mat(struct2cell(c35r));

c40r = load('curve_40.mat');
c40r =cell2mat(struct2cell(c40r));

c45r = load('curve_45.mat');
c45r =cell2mat(struct2cell(c45r));

c50r = load('curve_50.mat');
c50r =cell2mat(struct2cell(c50r));


c35r(c35r(:,1,1)==0,:,:)=[];
c40r(c40r(:,1,1)==0,:,:)=[];
c45r(c45r(:,1,1)==0,:,:)=[];
c50r(c50r(:,1,1)==0,:,:)=[];

%% GPR type 1 data generation (not mixed)

n_type = 4;

sample_num = 1900;
sliced_num = 80;

obs_size = 20;
obs_dim = 2;

out_dim = 2;

gpT1a_inp = zeros(sample_num*sliced_num, obs_size, obs_dim);
gpT1a_out = zeros(sample_num*sliced_num, out_dim);

gpT1b_inp = zeros(sample_num*sliced_num, obs_size, obs_dim);
gpT1b_out = zeros(sample_num*sliced_num, out_dim);

gpT1c_inp = zeros(sample_num*sliced_num, obs_size, obs_dim);
gpT1c_out = zeros(sample_num*sliced_num, out_dim);

gpT1d_inp = zeros(sample_num*sliced_num, obs_size, obs_dim);
gpT1d_out = zeros(sample_num*sliced_num, out_dim);

cout = 1;

%slice 20 samples from trajectories
for outer=1:sample_num
   for slicer=1:80
       gpT1a_inp(cout,:,:) = c35r(outer,slicer:slicer+obs_size-1,:);
       gpT1b_inp(cout,:,:) = c40r(outer,slicer:slicer+obs_size-1,:);
       gpT1c_inp(cout,:,:) = c45r(outer,slicer:slicer+obs_size-1,:);
       gpT1d_inp(cout,:,:) = c50r(outer,slicer:slicer+obs_size-1,:);
        
       gpT1a_out(cout,:) = c35r(outer,slicer+obs_size);
       gpT1b_out(cout,:) = c40r(outer,slicer+obs_size);
       gpT1c_out(cout,:) = c45r(outer,slicer+obs_size);
       gpT1d_out(cout,:) = c50r(outer,slicer+obs_size);
       
       cout=cout+1;
   end
end



%% GPR type 2 data generation (mixed)

gpT2_inp = zeros(n_type*sample_num*sliced_num, obs_size, obs_dim);
gpT2_out = zeros(n_type*sample_num*sliced_num, out_dim);

gpT2_inp(1:1*sample_num*sliced_num,:,:) = gpT1a_inp(:,:,:);
gpT2_inp(1*sample_num*sliced_num+1:2*sample_num*sliced_num,:,:) = gpT1b_inp;
gpT2_inp(2*sample_num*sliced_num+1:3*sample_num*sliced_num,:,:) = gpT1c_inp;
gpT2_inp(3*sample_num*sliced_num+1:4*sample_num*sliced_num,:,:) = gpT1d_inp;

gpT2_out(1:1*sample_num*sliced_num,:,:) = gpT1a_out(:,:,:);
gpT2_out(1*sample_num*sliced_num+1:2*sample_num*sliced_num,:,:) = gpT1b_out;
gpT2_out(2*sample_num*sliced_num+1:3*sample_num*sliced_num,:,:) = gpT1c_out;
gpT2_out(3*sample_num*sliced_num+1:4*sample_num*sliced_num,:,:) = gpT1d_out;

%% Shuffle for type 1 and 2
% 
% mini_randex = randperm(sample_num*sliced_num);
% larg_randex = randperm(sample_num*sliced_num*n_type);
% 
% gpT1a_inp(:,:,:) = gpT1a_inp(mini_randex,:,:);
% gpT1a_out(:,:,:) = gpT1a_out(mini_randex,:);
% gpT1b_inp(:,:,:) = gpT1b_inp(mini_randex,:,:);
% gpT1b_out(:,:,:) = gpT1b_out(mini_randex,:);
% gpT1c_inp(:,:,:) = gpT1c_inp(mini_randex,:,:);
% gpT1c_out(:,:,:) = gpT1c_out(mini_randex,:);
% gpT1d_inp(:,:,:) = gpT1d_inp(mini_randex,:,:);
% gpT1d_out(:,:,:) = gpT1d_out(mini_randex,:);
% 
% 
% gpT2_inp(:,:,:) = gpT2_inp(larg_randex,:,:);
% gpT2_out(:,:,:) = gpT2_out(larg_randex,:);
% 
% 
% 

%% gpT1a
        clearvars -except gpT1a_inp gpT1a_out
% clear;
tin = gpT1a_inp; clear gpT1a_inp;
tout= gpT1a_out; clear gpT1a_out;
[samples,b,c] = size(tin);
trainingInputDataSize = b*c;
trainingOutputDataSize = size(tout,2);

% 원본 데이터 학습할 수 있게 모양 바꾸기
x_pre = tin(1:18:end,:,:);
sampleSize = size(x_pre,1);  % 학습할 사이즈
Y = tout(1:18:end,:,:); 
% clear tin tout; % 테스트하려면 주석해서 여기서 자료 뽑으면 됨

x = [];
for i = 1:sampleSize  % 인풋 모양 바꾸기
    temp = x_pre(i,:,1);
    tempp= x_pre(i,:,2);
    x = [x; temp, tempp];
end
clear x_pre;

% GP settings
covfunc = @covSEiso; 
likfunc = @likGauss; sn = 0.1;
hyp2.cov = [0 ; 0];    
hyp2.lik = log(0.1);

% GP training
tic;
hyp2 = minimize(hyp2, @gp, -100, @infGaussLik, [], covfunc, likfunc, x, Y);
fprintf('The training took %5.1f seconds\n\n',toc);

% M = zeros(100,2);
% S2 = zeros(100,2);
% for i = 1:100
% [m, s2] = gp(hyp2, @infExact, [], covfunc, likfunc, x(1:numTraining*timeSize), Y(1:numTraining*timeSize,:), i);
% M(i,:) = m;
% S2(i,:) = s2;
% end
% SIGMA = sqrt(S2);
fprintf('Please use [m, s2] = gp(hyp2, @infExact, [], covfunc, likfunc, x, Y, z_test) \n')
fprintf('to get mean m and variance s2 at the test point z_test; it might take a long time...555 \n')

save('test_RNNlike_01')
