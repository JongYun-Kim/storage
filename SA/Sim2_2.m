clear; close all;
% % % % % %% �ùķ��̼� 2 : ���� 4�뿡�� ���α� 36����� ����
% % % % % Nrun = 10;
% % % % % Nvessel = 4;
% % % % % Nuav = 2:2:36;  % �຤�� / ������ ���α��� ���� ���� ����
% % % % % maxuav = max(Nuav);
% % % % % n = length(Nuav);  % ������ ���α� ������ ������
% % % % % 
% % % % %     r2.assignment = []; % ���α� ������ŭ�� ���� ����
% % % % %     r2.dam_t = [];
% % % % %     r2.dam_e = [];
% % % % %     r2.dam_t_u = [];
% % % % %     r2.dam_e_u = [];
% % % % %     
% % % % %     r2(Nrun,n) = r2;
% % % % % 
% % % % %             % for i = 1:Nrun  % �� �ݺ����迡 ���Ͽ�
% % % % %             %     r2.assignment(i) = -1*ones(n,maxuav); % ���α� ������ŭ�� ���� ����
% % % % %             %     r2.dam_t(i) = -1*ones(n,1);
% % % % %             %     r2.dam_e(i) = -1*ones(n,Nvessel);
% % % % %             %     r2.dam_t_u(i) = -1*ones(n,1);
% % % % %             %     r2.dam_e_u(i) = -1*ones(n,Nvessel);
% % % % %             % end
% % % % % 
% % % % % for i = 1:Nrun
% % % % %     for j = 1:n
% % % % %         [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_2(Nuav(j));
% % % % %         r2(i,j).assignment = assignment; % ���α� ������ŭ�� ���� ����
% % % % %         r2(i,j).dam_t = damage_tot;
% % % % %         disp(['tot_dam is ',num2str(damage_tot)]);
% % % % %         r2(i,j).dam_e = damage_each;
% % % % %         r2(i,j).dam_t_u = dam_tot_unc;
% % % % %         r2(i,j).dam_e_u = dam_each_unc;
% % % % %         disp([i,j,2]);
% % % % %     end
% % % % % end



%% �ùķ��̼� 3_1 : ���� 10�� ���α� �������� 100�����

Nrun = 10;
Nvessel = 10;
Nuav = [5,10:10:120];  % �຤�� / ������ ���α��� ���� ���� ����
maxuav = max(Nuav);
n = length(Nuav);  % ������ ���α� ������ ������

    r31.assignment = []; % ���α� ������ŭ�� ���� ����
    r31.dam_t = [];
    r31.dam_e = [];
    r31.dam_t_u = [];
    r31.dam_e_u = [];
    
    r31(Nrun,n) = r31;


for i = 1:Nrun  % �� �ݺ� ���࿡��
    for j = 1:n  % �� ���α� ���ڵ鿡 ���Ͽ�
        [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_3_1(Nuav(j));
        r31(i,j).assignment = assignment; % ���α� ������ŭ�� ���� ����
        r31(i,j).dam_t = damage_tot;
        disp(['tot_dam is ',num2str(damage_tot)]);
        r31(i,j).dam_e = damage_each;
        r31(i,j).dam_t_u = dam_tot_unc;
        r31(i,j).dam_e_u = dam_each_unc;
        disp([i,j,31]);
    end
end

%% �ùķ��̼� 3_2 : ���� 10�� ���α� �������� 100����� (�º΋H����)

Nrun = 10;
Nvessel = 10;
Nuav = [5,10:10:120];  % �຤�� / ������ ���α��� ���� ���� ����
maxuav = max(Nuav);
n = length(Nuav);  % ������ ���α� ������ ������

    r32.assignment = []; % ���α� ������ŭ�� ���� ����
    r32.dam_t = [];
    r32.dam_e = [];
    r32.dam_t_u = [];
    r32.dam_e_u = [];
    
    r32(Nrun,n) = r32;


for i = 1:Nrun  % �� �ݺ� ���࿡��
    for j = 1:n  % �� ���α� ���ڵ鿡 ���Ͽ�
        [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_3_2(Nuav(j));
        r32(i,j).assignment = assignment; % ���α� ������ŭ�� ���� ����
        r32(i,j).dam_t = damage_tot;
        disp(['tot_dam is ',num2str(damage_tot)]);
        r32(i,j).dam_e = damage_each;
        r32(i,j).dam_t_u = dam_tot_unc;
        r32(i,j).dam_e_u = dam_each_unc;
        disp([i,j,32]);
    end
end



%% �ùķ��̼� 3_3 : ���� 10�� ���α� �������� 100����� (���ѱ�)

Nrun = 10;
Nvessel = 10;
Nuav = [5,10:10:160];  % �຤�� / ������ ���α��� ���� ���� ����
maxuav = max(Nuav);
n = length(Nuav);  % ������ ���α� ������ ������

    r33.assignment = []; % ���α� ������ŭ�� ���� ����
    r33.dam_t = [];
    r33.dam_e = [];
    r33.dam_t_u = [];
    r33.dam_e_u = [];
    
    r33(Nrun,n) = r33;


for i = 1:Nrun  % �� �ݺ� ���࿡��
    for j = 1:n  % �� ���α� ���ڵ鿡 ���Ͽ�
        [assignment, damage_tot, damage_each, dam_tot_unc, dam_each_unc] = sim_main_3_3(Nuav(j));
        r33(i,j).assignment = assignment; % ���α� ������ŭ�� ���� ����
        r33(i,j).dam_t = damage_tot;
        disp(['tot_dam is ',num2str(damage_tot)]);
        r33(i,j).dam_e = damage_each;
        r33(i,j).dam_t_u = dam_tot_unc;
        r33(i,j).dam_e_u = dam_each_unc;
        disp([i,j,33]);
    end
end


%% ������ ����
save('R_191224_JYDT.mat');