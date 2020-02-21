% 알파값 구하는 스크립트 : 모델은 알파 단일 path loss : weighted obstacle distance d2

load('Comm_Model.mat');
load('MapDATA.mat');

% 거리 얻을 데이터 처리 미리 할 것
[d1, d2] = sepDistance(x1,y1,x2,y2,unfreeMap,resolution,unfreeSpaceID);

% 알파 계산
alpha = ( 10.^(-0.05*(RSSI + model_params.C)) - d1 ) / d2;