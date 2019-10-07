% ��� �̸� ���� ����! ������ �����°� �� ������ �ϸ� �Ǵϱ�
% �̼�1���� �ݵ��� 20��, ���Ұ�� 200�� (10���� 20�� ����)
% �̼�2���� �ݵ��� 20��, ���Ұ�� 200�� (10���� 20�� ����)

clear all; close all; rng('shuffle');

%% ����
BasePosition   = [ 37.8, 25.9;    % ���� ���: �̼�1
                   13.3, 62.5 ];  % ��ȭ�� 2 : �̼�2

ClientPosition = [ 14.4, 56.2;    % ���� ���: �̼�1
                   14.7, 57.1 ];  % ��ȭ�� 2 : �̼�2

pruning = [true;     %  ���Ÿ�� 1
           false];   %  ���Ÿ�� 1

% GetRRTStar(BasePosition(mission,:),ClientPosition(mission,:),pruning(pathtype),unfreeMap,resolution,unfreeSpaceID);


%% ���� ����
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


%% �̼�1: ���߰��
load('./data/mapData8F.mat','unfreeMap','unfreeSpaceID','resolution');
% �̼� ����
mission = 1;

% �ݵ��� ������
pathtype = 1;
for cases = 1:1
    temp = GetRRTStar(BasePosition(mission,:),ClientPosition(mission,:),pruning(pathtype),unfreeMap,resolution,unfreeSpaceID);
    Mission(mission).pathtype(pathtype).cases(cases).data = GetNewPath(temp(:,1:2));
    fprintf('mission %d pathtype %d case %d\n',mission,pathtype,cases);
end

% ���Ұ�� ������
pathtype = 2;
for cases = 1:1
    temp = GetRRTStar(BasePosition(mission,:),ClientPosition(mission,:),pruning(pathtype),unfreeMap,resolution,unfreeSpaceID);
    Mission(mission).pathtype(pathtype).cases(cases).data = GetNewPath(temp(:,1:2));
    fprintf('mission %d pathtype %d case %d\n',mission,pathtype,cases);
end
 

%% �̼�2: ��ȭ�� �ó�����(2)
load('./data/mapData8Fire.mat','unfreeMap','unfreeSpaceID','resolution');
% �̼� ����
mission = 2;

% �ݵ��� ������
pathtype = 1;
for cases = 1:5
    temp = GetRRTStar(BasePosition(mission,:),ClientPosition(mission,:),pruning(pathtype),unfreeMap,resolution,unfreeSpaceID);
    Mission(mission).pathtype(pathtype).cases(cases).data = GetNewPath(temp(:,1:2));
    fprintf('mission %d pathtype %d case %d\n',mission,pathtype,cases);
end

% ���Ұ�� ������
pathtype = 2;
for cases = 1:5
    temp = GetRRTStar(BasePosition(mission,:),ClientPosition(mission,:),pruning(pathtype),unfreeMap,resolution,unfreeSpaceID);
    Mission(mission).pathtype(pathtype).cases(cases).data = GetNewPath(temp(:,1:2));
    fprintf('mission %d pathtype %d case %d\n',mission,pathtype,cases);
end
clear temp

%% ����
%save('AllPath.mat');
% ������ ���� ���߹̼ǿ��� 10���� 5���� �����ϴ°� �Ѵ� �� ���� ������
% ��� ���� 150���� �ø��� (������ ���ߴ� 100�� ���ϼ�)