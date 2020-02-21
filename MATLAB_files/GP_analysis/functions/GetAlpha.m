% ���İ� ���ϴ� ��ũ��Ʈ : ���� ���� ���� path loss : weighted obstacle distance d2

load('Comm_Model.mat');
load('MapDATA.mat');

% �Ÿ� ���� ������ ó�� �̸� �� ��
[d1, d2] = sepDistance(x1,y1,x2,y2,unfreeMap,resolution,unfreeSpaceID);

% ���� ���
alpha = ( 10.^(-0.05*(RSSI + model_params.C)) - d1 ) / d2;