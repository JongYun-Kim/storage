%% 시뮬레이션 2
% 
% result_2_1 = cell(1,5);
% for i = 1:5
%     result_2_1{i} = zeros(30,4); % 적함 숫자 4대 반복횟수 30회
% end
% 
% 
% 
% for i = 1:30
%     for j = 1:30  % 무인기 30대 까지 투입
%         [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_2(j);
%         result_2_1{1}(i,1:j) = assignment;  % 무인기 수만큼 벡터
%         result_2_1{2}(i,1) = damage_tot;
%         disp(damage_tot);
%         result_2_1{3}(i,1:4) = damage_each;
%         result_2_1{4}(i,1) = dam_tot_unc;
%         result_2_1{5}(i,1:4) = dam_each_unc;
%         disp([i,j,1])
%     end
% end
% 
% 
% %% 시뮬레이션 3_1 : 10대에 원형진형
% 
% no_uav = 100;
% 
% result_3_1 = cell(1,5);
% for i = 1:5
%     result_3_1{i} = zeros(no_uav,10); % 적함 숫자 10대 반복횟수 30회
% end
% 
% 
% 
% for i = 1:30
%     for j = 1:no_uav  % 무인기 30대 까지 투입
%         [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_3_1(j);
%         result_3_1{1}(i,1:j) = assignment;  % 무인기 수만큼 벡터
%         result_3_1{2}(i,1) = damage_tot;
%         disp(damage_tot);
%         result_3_1{3}(i,1:10) = damage_each;
%         result_3_1{4}(i,1) = dam_tot_unc;
%         result_3_1{5}(i,1:10) = dam_each_unc;
%         disp([i,j,2])
%     end
% end


%% 시뮬레이션 3_2 : 10대에 선형진형

N_UAV = [5,10,20,30,40,50,60,70,80,90,100]; %% 11개

result_3_2 = cell(1,5);
for i = 1:5
    result_3_2{i} = zeros(length(N_UAV),10); % 적함 숫자 10대 반복횟수 30회
end


for i = 1:1
    for j = 1:length(N_UAV)  % 무인기 30대 까지 투입
        [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_3_2(N_UAV(j));
        result_3_2{1}(i,1:N_UAV(j)) = assignment;  % 무인기 수만큼 벡터
        result_3_2{2}(i,1) = damage_tot;
        disp(damage_tot);
        result_3_2{3}(i,1:10) = damage_each;
        result_3_2{4}(i,1) = dam_tot_unc;
        result_3_2{5}(i,1:10) = dam_each_unc;
        disp([i,j,3])
    end
end




%% 시뮬레이션 3_3 : 10대 선형 진형 하지만 맞 대응 아니라 쫓아가는 대응

result_3_3 = cell(1,5);
for i = 1:5
    result_3_3{i} = zeros(length(N_UAV),10); % 적함 숫자 10대 반복횟수 30회
end



for i = 1:1
    for j = 1:length(N_UAV)  % 무인기 30대 까지 투입
        [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_3_3(N_UAV(j));
        result_3_3{1}(i,1:j) = assignment;  % 무인기 수만큼 벡터
        result_3_3{2}(i,1) = damage_tot;
        disp(damage_tot);
        result_3_3{3}(i,1:10) = damage_each;
        result_3_3{4}(i,1) = dam_tot_unc;
        result_3_3{5}(i,1:10) = dam_each_unc;
        disp([i,j,4])
    end
end


save('result23_try2.mat');