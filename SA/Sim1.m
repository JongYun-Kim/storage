% �ùķ��̼� 1
% ���԰��� �ó�����
% UAV8 �Ǵ� ��ȭ�ϸ� ����
% pkill=0.1452 r=750 e=8
% ��� ���α�� ��Ȯ�� ������ ������ ���α�
% (���� �ð��� ���� ��ġ�� ������, ������ �������ΰ� ���� ������ ��ħ : ���� ������ �����ϸ鼭 ���� ���� ����� ȿ���� �˾ƺ��� ������)

%% (1) 8���� ���α⿡ ���Ͽ� ������� �ִ� ���� ���°�� ��
    % ������� ���� ���� �׳� ���� ���ϰ� 90�����ϸ� ��.
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
% % % %% (2) ���Կ� 1����� �������� ���α⸦ ������ħ���� ��������
% % % 
% % % result_1_2 = cell(30,5);
% % % 
% % % for i = 1:30 % �ݺ�Ƚ��
% % %     for j = 1:20 % ���α⸦ 1�뿡�� 30����� �־
% % %         [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_1_2(j,0.05);
% % %         result_1_2{j,1}(i,:) = assignment;
% % %         result_1_2{j,2}(i,:) = damage_tot;
% % %         result_1_2{j,3}(i,:) = damage_each;
% % %         result_1_2{j,4}(i,:) = dam_tot_unc;
% % %         result_1_2{j,5}(i,:) = dam_each_unc;
% % %     end
% % % end


%% (3) ���Կ� �ΰ��� �м� �پ��� �Ķ���� �м�(������ ��Ŵ�� ���� �ϵ� ���� �ߺ���)

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