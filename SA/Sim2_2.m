clear; close all;
% % % % % %% 시뮬레이션 2 : 적함 4대에서 무인기 36대까지 공격
% % % % % Nrun = 10;
% % % % % Nvessel = 4;
% % % % % Nuav = 2:2:36;  % 행벡터 / 실험할 무인기의 숫자 순서 벡터
% % % % % maxuav = max(Nuav);
% % % % % n = length(Nuav);  % 실험할 무인기 숫자의 가짓수
% % % % % 
% % % % %     r2.assignment = []; % 무인기 갯수만큼씩 값이 들어옴
% % % % %     r2.dam_t = [];
% % % % %     r2.dam_e = [];
% % % % %     r2.dam_t_u = [];
% % % % %     r2.dam_e_u = [];
% % % % %     
% % % % %     r2(Nrun,n) = r2;
% % % % % 
% % % % %             % for i = 1:Nrun  % 각 반복실험에 대하여
% % % % %             %     r2.assignment(i) = -1*ones(n,maxuav); % 무인기 갯수만큼씩 값이 들어옴
% % % % %             %     r2.dam_t(i) = -1*ones(n,1);
% % % % %             %     r2.dam_e(i) = -1*ones(n,Nvessel);
% % % % %             %     r2.dam_t_u(i) = -1*ones(n,1);
% % % % %             %     r2.dam_e_u(i) = -1*ones(n,Nvessel);
% % % % %             % end
% % % % % 
% % % % % for i = 1:Nrun
% % % % %     for j = 1:n
% % % % %         [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_2(Nuav(j));
% % % % %         r2(i,j).assignment = assignment; % 무인기 갯수만큼씩 값이 들어옴
% % % % %         r2(i,j).dam_t = damage_tot;
% % % % %         disp(['tot_dam is ',num2str(damage_tot)]);
% % % % %         r2(i,j).dam_e = damage_each;
% % % % %         r2(i,j).dam_t_u = dam_tot_unc;
% % % % %         r2(i,j).dam_e_u = dam_each_unc;
% % % % %         disp([i,j,2]);
% % % % %     end
% % % % % end



%% 시뮬레이션 3_1 : 적함 10대 무인기 원형진형 100대까지

Nrun = 10;
Nvessel = 10;
Nuav = [5,10:10:120];  % 행벡터 / 실험할 무인기의 숫자 순서 벡터
maxuav = max(Nuav);
n = length(Nuav);  % 실험할 무인기 숫자의 가짓수

    r31.assignment = []; % 무인기 갯수만큼씩 값이 들어옴
    r31.dam_t = [];
    r31.dam_e = [];
    r31.dam_t_u = [];
    r31.dam_e_u = [];
    
    r31(Nrun,n) = r31;


for i = 1:Nrun  % 각 반복 실행에서
    for j = 1:n  % 각 무인기 숫자들에 대하여
        [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_3_1(Nuav(j));
        r31(i,j).assignment = assignment; % 무인기 갯수만큼씩 값이 들어옴
        r31(i,j).dam_t = damage_tot;
        disp(['tot_dam is ',num2str(damage_tot)]);
        r31(i,j).dam_e = damage_each;
        r31(i,j).dam_t_u = dam_tot_unc;
        r31(i,j).dam_e_u = dam_each_unc;
        disp([i,j,31]);
    end
end

%% 시뮬레이션 3_2 : 적함 10대 무인기 선형진형 100대까지 (맞부딫히기)

Nrun = 10;
Nvessel = 10;
Nuav = [5,10:10:120];  % 행벡터 / 실험할 무인기의 숫자 순서 벡터
maxuav = max(Nuav);
n = length(Nuav);  % 실험할 무인기 숫자의 가짓수

    r32.assignment = []; % 무인기 갯수만큼씩 값이 들어옴
    r32.dam_t = [];
    r32.dam_e = [];
    r32.dam_t_u = [];
    r32.dam_e_u = [];
    
    r32(Nrun,n) = r32;


for i = 1:Nrun  % 각 반복 실행에서
    for j = 1:n  % 각 무인기 숫자들에 대하여
        [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_3_2(Nuav(j));
        r32(i,j).assignment = assignment; % 무인기 갯수만큼씩 값이 들어옴
        r32(i,j).dam_t = damage_tot;
        disp(['tot_dam is ',num2str(damage_tot)]);
        r32(i,j).dam_e = damage_each;
        r32(i,j).dam_t_u = dam_tot_unc;
        r32(i,j).dam_e_u = dam_each_unc;
        disp([i,j,32]);
    end
end



%% 시뮬레이션 3_3 : 적함 10대 무인기 선형진형 100대까지 (뒤쫓기)

Nrun = 10;
Nvessel = 10;
Nuav = [5,10:10:160];  % 행벡터 / 실험할 무인기의 숫자 순서 벡터
maxuav = max(Nuav);
n = length(Nuav);  % 실험할 무인기 숫자의 가짓수

    r33.assignment = []; % 무인기 갯수만큼씩 값이 들어옴
    r33.dam_t = [];
    r33.dam_e = [];
    r33.dam_t_u = [];
    r33.dam_e_u = [];
    
    r33(Nrun,n) = r33;


for i = 1:Nrun  % 각 반복 실행에서
    for j = 1:n  % 각 무인기 숫자들에 대하여
        [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_3_3(Nuav(j));
        r33(i,j).assignment = assignment; % 무인기 갯수만큼씩 값이 들어옴
        r33(i,j).dam_t = damage_tot;
        disp(['tot_dam is ',num2str(damage_tot)]);
        r33(i,j).dam_e = damage_each;
        r33(i,j).dam_t_u = dam_tot_unc;
        r33(i,j).dam_e_u = dam_each_unc;
        disp([i,j,33]);
    end
end


%% 데이터 저장
save('R_191224_JYDT.mat');