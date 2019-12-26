% 시뮬레이션 1
% 단함공격 시나리오
% UAV8 또는 변화하며 실험
% pkill=0.1452 r=750 e=8
% 모든 무인기는 정확히 동일한 가상의 무인기
% (같은 시간에 같은 위치에 존재함, 하지만 여러대인것 같은 영향을 미침 : 여러 변인을 통제하면서 기존 모델의 대수의 효과를 알아보기 위함임)

%% (1) 8대의 무인기에 대하여 방공망이 있는 경우와 없는경우 비교
    % 방공망이 없는 경우는 그냥 실험 안하고 90프로하면 됨.
% % % result_1_1 = cell(1,5);
% % % 
% % % for i = 1:30
% % %     [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_1(0);
% % %     result_1_1{1}(i,:) = assignment;
% % %     result_1_1{2}(i,:) = damage_tot;
% % %     result_1_1{3}(i,:) = damage_each;
% % %     result_1_1{4}(i,:) = dam_tot_unc;
% % %     result_1_1{5}(i,:) = dam_each_unc;
% % % end
% % % 
% % % % dam : 2.5329 == health_e : 68.34%
% % % 
% % % %% (2) 단함에 1대부터 여러대의 무인기를 완전격침까지 날려보기
% % % 
% % % result_1_2 = cell(30,5);
% % % 
% % % for i = 1:30 % 반복횟수
% % %     for j = 1:20 % 무인기를 1대에서 30대까지 넣어봄
% % %         [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_2(j,0.05);
% % %         result_1_2{j,1}(i,:) = assignment;
% % %         result_1_2{j,2}(i,:) = damage_tot;
% % %         result_1_2{j,3}(i,:) = damage_each;
% % %         result_1_2{j,4}(i,:) = dam_tot_unc;
% % %         result_1_2{j,5}(i,:) = dam_each_unc;
% % %     end
% % % end


%% (3) 단함에 민감도 분석 다양한 파라미터 분석(기존의 스킴과 같이 하되 숫자 잘보기)

result_1_3_1 = cell(9,5);
result_1_3_2 = cell(7,5);

for i = 1:30
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(500,0.1252,15,0);
        result_1_3_1{1,1}(i,:) = assignment;
        result_1_3_1{1,2}(i,:) = damage_tot;
        result_1_3_1{1,3}(i,:) = damage_each;
        result_1_3_1{1,4}(i,:) = dam_tot_unc;
        result_1_3_1{1,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(750,0.1252,15,0);
        result_1_3_1{2,1}(i,:) = assignment;
        result_1_3_1{2,2}(i,:) = damage_tot;
        result_1_3_1{2,3}(i,:) = damage_each;
        result_1_3_1{2,4}(i,:) = dam_tot_unc;
        result_1_3_1{2,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(1000,0.1252,15,0);
        result_1_3_1{3,1}(i,:) = assignment;
        result_1_3_1{3,2}(i,:) = damage_tot;
        result_1_3_1{3,3}(i,:) = damage_each;
        result_1_3_1{3,4}(i,:) = dam_tot_unc;
        result_1_3_1{3,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(500,0.1452,15,0);
        result_1_3_1{4,1}(i,:) = assignment;
        result_1_3_1{4,2}(i,:) = damage_tot;
        result_1_3_1{4,3}(i,:) = damage_each;
        result_1_3_1{4,4}(i,:) = dam_tot_unc;
        result_1_3_1{4,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(750,0.1452,15,0);
        result_1_3_1{5,1}(i,:) = assignment;
        result_1_3_1{5,2}(i,:) = damage_tot;
        result_1_3_1{5,3}(i,:) = damage_each;
        result_1_3_1{5,4}(i,:) = dam_tot_unc;
        result_1_3_1{5,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(1000,0.1452,15,0);
        result_1_3_1{6,1}(i,:) = assignment;
        result_1_3_1{6,2}(i,:) = damage_tot;
        result_1_3_1{6,3}(i,:) = damage_each;
        result_1_3_1{6,4}(i,:) = dam_tot_unc;
        result_1_3_1{6,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(500,0.1652,15,0);
        result_1_3_1{7,1}(i,:) = assignment;
        result_1_3_1{7,2}(i,:) = damage_tot;
        result_1_3_1{7,3}(i,:) = damage_each;
        result_1_3_1{7,4}(i,:) = dam_tot_unc;
        result_1_3_1{7,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(750,0.1652,15,0);
        result_1_3_1{8,1}(i,:) = assignment;
        result_1_3_1{8,2}(i,:) = damage_tot;
        result_1_3_1{8,3}(i,:) = damage_each;
        result_1_3_1{8,4}(i,:) = dam_tot_unc;
        result_1_3_1{8,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(1000,0.1652,15,0);
        result_1_3_1{9,1}(i,:) = assignment;
        result_1_3_1{9,2}(i,:) = damage_tot;
        result_1_3_1{9,3}(i,:) = damage_each;
        result_1_3_1{9,4}(i,:) = dam_tot_unc;
        result_1_3_1{9,5}(i,:) = dam_each_unc;
        
end


for i = 1:30
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(750,0.1452,0,0);
        result_1_3_2{1,1}(i,:) = assignment;
        result_1_3_2{1,2}(i,:) = damage_tot;
        result_1_3_2{1,3}(i,:) = damage_each;
        result_1_3_2{1,4}(i,:) = dam_tot_unc;
        result_1_3_2{1,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(750,0.1452,7.5,0);
        result_1_3_2{2,1}(i,:) = assignment;
        result_1_3_2{2,2}(i,:) = damage_tot;
        result_1_3_2{2,3}(i,:) = damage_each;
        result_1_3_2{2,4}(i,:) = dam_tot_unc;
        result_1_3_2{2,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(750,0.1452,7.5,pi/2);
        result_1_3_2{3,1}(i,:) = assignment;
        result_1_3_2{3,2}(i,:) = damage_tot;
        result_1_3_2{3,3}(i,:) = damage_each;
        result_1_3_2{3,4}(i,:) = dam_tot_unc;
        result_1_3_2{3,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(750,0.1452,7.5,pi);
        result_1_3_2{4,1}(i,:) = assignment;
        result_1_3_2{4,2}(i,:) = damage_tot;
        result_1_3_2{4,3}(i,:) = damage_each;
        result_1_3_2{4,4}(i,:) = dam_tot_unc;
        result_1_3_2{4,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(750,0.1452,15,0);
        result_1_3_2{5,1}(i,:) = assignment;
        result_1_3_2{5,2}(i,:) = damage_tot;
        result_1_3_2{5,3}(i,:) = damage_each;
        result_1_3_2{5,4}(i,:) = dam_tot_unc;
        result_1_3_2{5,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(750,0.1452,15,pi/2);
        result_1_3_2{6,1}(i,:) = assignment;
        result_1_3_2{6,2}(i,:) = damage_tot;
        result_1_3_2{6,3}(i,:) = damage_each;
        result_1_3_2{6,4}(i,:) = dam_tot_unc;
        result_1_3_2{6,5}(i,:) = dam_each_unc;
    [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_3(750,0.1452,15,pi);
        result_1_3_2{7,1}(i,:) = assignment;
        result_1_3_2{7,2}(i,:) = damage_tot;
        result_1_3_2{7,3}(i,:) = damage_each;
        result_1_3_2{7,4}(i,:) = dam_tot_unc;
        result_1_3_2{7,5}(i,:) = dam_each_unc;
        
end