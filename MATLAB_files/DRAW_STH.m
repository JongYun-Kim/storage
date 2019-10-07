%% 세팅
mission = 1;   % 멀경우
% mission = 2;   % 방화문

% pathtype = 1;  % 직선경로: Gao
% pathtype = 2;  % 꼬불경로: GaoExt
% pathtype = 3;  % 차선경로: GaoExt
pathtype = 4;  % 나은경로: GaoExt

hold on;


% 경로 그리기
for trial = 1:NumTrial
    path = Mission(mission).pathtype(pathtype).cases(trial).data;
    path_length = size(path,1);
    plot3(path(:,1),path(:,2),ones(path_length,1),'LineWidth',1.5);
end


%% 릴레이 그리기
for trial = 1:NumTrial
    for i = 1:NumRelay
        rx = DATA_GaoExt(trial).relay(i,1);
        ry = DATA_GaoExt(trial).relay(i,2);
        plot3(rx,ry,1,'p','MarkerSize',4.5,'LineWidth',3);
    end
end