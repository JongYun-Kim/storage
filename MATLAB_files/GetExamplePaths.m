% 경로 미리 구해 보자! 어차피 돌리는건 그 때가서 하면 되니까
% 미션1에서 반듯경로 20개, 꼬불경로 200개 (10개씩 20번 실행)
% 미션2에서 반듯경로 20개, 꼬불경로 200개 (10개씩 20번 실행)

clear all; close all; rng('shuffle');

%% 세팅
BasePosition   = [ 37.8, 25.9;    % 다중 경로: 미션1
                   13.3, 62.5 ];  % 방화문 2 : 미션2

ClientPosition = [ 14.4, 56.2;    % 다중 경로: 미션1
                   14.7, 57.1 ];  % 방화문 2 : 미션2

pruning = [true;     %  경로타입 1
           false];   %  경로타입 1

% GetRRTStar(BasePosition(mission,:),ClientPosition(mission,:),pruning(pathtype),unfreeMap,resolution,unfreeSpaceID);


%% 변수 지정
Mission = struct();
for mission = 1:2
    for pathtype = 1:2
        if pathtype == 1
            for cases = 1:10
                Mission(mission).pathtype(pathtype).cases(cases).data = [];
            end
        else
            for cases = 1:50
                Mission(mission).pathtype(pathtype).cases(cases).data = [];
            end
        end
    end
end


%% 미션1: 다중경로
load('./data/mapData8F.mat','unfreeMap','unfreeSpaceID','resolution');
% 미션 지정
mission = 1;

% 반듯경로 구하자
pathtype = 1;
for cases = 1:1
    temp = GetRRTStar(BasePosition(mission,:),ClientPosition(mission,:),pruning(pathtype),unfreeMap,resolution,unfreeSpaceID);
    Mission(mission).pathtype(pathtype).cases(cases).data = GetNewPath(temp(:,1:2));
    fprintf('mission %d pathtype %d case %d\n',mission,pathtype,cases);
end

% 꼬불경로 구하자
pathtype = 2;
for cases = 1:1
    temp = GetRRTStar(BasePosition(mission,:),ClientPosition(mission,:),pruning(pathtype),unfreeMap,resolution,unfreeSpaceID);
    Mission(mission).pathtype(pathtype).cases(cases).data = GetNewPath(temp(:,1:2));
    fprintf('mission %d pathtype %d case %d\n',mission,pathtype,cases);
end
 

%% 미션2: 방화문 시나리오(2)
load('./data/mapData8Fire.mat','unfreeMap','unfreeSpaceID','resolution');
% 미션 지정
mission = 2;

% 반듯경로 구하자
pathtype = 1;
for cases = 1:5
    temp = GetRRTStar(BasePosition(mission,:),ClientPosition(mission,:),pruning(pathtype),unfreeMap,resolution,unfreeSpaceID);
    Mission(mission).pathtype(pathtype).cases(cases).data = GetNewPath(temp(:,1:2));
    fprintf('mission %d pathtype %d case %d\n',mission,pathtype,cases);
end

% 꼬불경로 구하자
pathtype = 2;
for cases = 1:5
    temp = GetRRTStar(BasePosition(mission,:),ClientPosition(mission,:),pruning(pathtype),unfreeMap,resolution,unfreeSpaceID);
    Mission(mission).pathtype(pathtype).cases(cases).data = GetNewPath(temp(:,1:2));
    fprintf('mission %d pathtype %d case %d\n',mission,pathtype,cases);
end
clear temp

%% 저장
%save('AllPath.mat');
% 끝나고 나면 다중미션에서 10개씩 5개씩 생성하는거 둘다 할 수도 있으니
% 경로 갯수 150개로 늘리기 (이전에 구했던 100개 더하셈)