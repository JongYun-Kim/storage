%% �ùķ��̼� 2
% 
% result_2_1 = cell(1,5);
% for i = 1:5
%     result_2_1{i} = zeros(30,4); % ���� ���� 4�� �ݺ�Ƚ�� 30ȸ
% end
% 
% 
% 
% for i = 1:30
%     for j = 1:30  % ���α� 30�� ���� ����
%         [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_2(j);
%         result_2_1{1}(i,1:j) = assignment;  % ���α� ����ŭ ����
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
% %% �ùķ��̼� 3_1 : 10�뿡 ��������
% 
% no_uav = 100;
% 
% result_3_1 = cell(1,5);
% for i = 1:5
%     result_3_1{i} = zeros(no_uav,10); % ���� ���� 10�� �ݺ�Ƚ�� 30ȸ
% end
% 
% 
% 
% for i = 1:30
%     for j = 1:no_uav  % ���α� 30�� ���� ����
%         [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_3_1(j);
%         result_3_1{1}(i,1:j) = assignment;  % ���α� ����ŭ ����
%         result_3_1{2}(i,1) = damage_tot;
%         disp(damage_tot);
%         result_3_1{3}(i,1:10) = damage_each;
%         result_3_1{4}(i,1) = dam_tot_unc;
%         result_3_1{5}(i,1:10) = dam_each_unc;
%         disp([i,j,2])
%     end
% end


%% �ùķ��̼� 3_2 : 10�뿡 ��������

N_UAV = [5,10,20,30,40,50,60,70,80,90,100]; %% 11��

result_3_2 = cell(1,5);
for i = 1:5
    result_3_2{i} = zeros(length(N_UAV),10); % ���� ���� 10�� �ݺ�Ƚ�� 30ȸ
end


for i = 1:1
    for j = 1:length(N_UAV)  % ���α� 30�� ���� ����
        [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_3_2(N_UAV(j));
        result_3_2{1}(i,1:N_UAV(j)) = assignment;  % ���α� ����ŭ ����
        result_3_2{2}(i,1) = damage_tot;
        disp(damage_tot);
        result_3_2{3}(i,1:10) = damage_each;
        result_3_2{4}(i,1) = dam_tot_unc;
        result_3_2{5}(i,1:10) = dam_each_unc;
        disp([i,j,3])
    end
end




%% �ùķ��̼� 3_3 : 10�� ���� ���� ������ �� ���� �ƴ϶� �Ѿư��� ����

result_3_3 = cell(1,5);
for i = 1:5
    result_3_3{i} = zeros(length(N_UAV),10); % ���� ���� 10�� �ݺ�Ƚ�� 30ȸ
end



for i = 1:1
    for j = 1:length(N_UAV)  % ���α� 30�� ���� ����
        [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_3_3(N_UAV(j));
        result_3_3{1}(i,1:j) = assignment;  % ���α� ����ŭ ����
        result_3_3{2}(i,1) = damage_tot;
        disp(damage_tot);
        result_3_3{3}(i,1:10) = damage_each;
        result_3_3{4}(i,1) = dam_tot_unc;
        result_3_3{5}(i,1:10) = dam_each_unc;
        disp([i,j,4])
    end
end


save('result23_try2.mat');