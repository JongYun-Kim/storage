%% ����
mission = 1;   % �ְ��
% mission = 2;   % ��ȭ��

% pathtype = 1;  % �������: Gao
% pathtype = 2;  % ���Ұ��: GaoExt
% pathtype = 3;  % �������: GaoExt
pathtype = 4;  % �������: GaoExt

hold on;


% ��� �׸���
for trial = 1:NumTrial
    path = Mission(mission).pathtype(pathtype).cases(trial).data;
    path_length = size(path,1);
    plot3(path(:,1),path(:,2),ones(path_length,1),'LineWidth',1.5);
end


%% ������ �׸���
for trial = 1:NumTrial
    for i = 1:NumRelay
        rx = DATA_GaoExt(trial).relay(i,1);
        ry = DATA_GaoExt(trial).relay(i,2);
        plot3(rx,ry,1,'p','MarkerSize',4.5,'LineWidth',3);
    end
end