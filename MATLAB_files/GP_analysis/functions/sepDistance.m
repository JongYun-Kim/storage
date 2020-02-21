function [d1, d2] = sepDistance(x1,y1,x2,y2,unfreeMap,resolution,unfreeSpaceID)
% �� ���� �־��� ��, �Է� ���� �׸��� �ʿ��� �Ʒ��� ���� �� ���� �Ÿ��� �����
% d1 : free space�� ����ϴ� �Ÿ�
% d2 : obstacle�� ����ϴ� �Ÿ�
% ���� �� ���� �Ÿ��� d = d1 + d2
% (x1,y1), (x2,y2) : �� �� R1-R2  :: ������ �����θ� �޾��� :no array 555
% unfreeMap : map ������ - ��ֹ� �ִ� ���� 1���� �Ұ� otherwise 0
% resolution : ������ �´� ���� ���
% % % unfreeSpaceID2 : unfreeSpaceID = find(map==0) => �ٸ�.. (i,j) ���·� �ٲܰ� ��������� ���ؼ� : ����
% unfreeSpaceID : unfreeSpaceID = find(map==0) = find(unfreeMap == 1);

    %% �ʱ� �Ķ���� ����
    
    if x1 > x2  % x1�� x2���� ���� ���̶� �����ϱ� ������ x1�� ũ�� �� ������ ����
        tempx = x1;   tempy = y1;
        x1 = x2;      y1 = y2;
        x2 = tempx;   y2 = tempy;
    end
    
    [w,h] = size(unfreeMap);
    x_min = 0; x_max = resolution*w;
    y_min = 0; y_max = resolution*h;
    x = linspace(x_min,x_max,w+1)';    % x(k)�� k��° ���� �׸����� ����(����) x��ǥ
    y = linspace(y_min,y_max,h+1)';
    if isinf((y2-y1)/(x2-x1))
%         error('m is infinity');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  �����!!!!  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% �ַ�� ����1 : x2 = x1 + 0.1* resolution;
        %%% �ַ�� ����2 : 
        x2 = x2 + 0.05*resolution;
    end
    % ���Ⱑ �������� ��� (���������� �ǹ���)
    m = (y2-y1)/(x2-x1);  % ����
    x_range = x(x > x1 & x < x2);                  % x�߿��� ���ϴ� ������ �ִ� x��. �׸��忡 ��ġ�� ����
    y_range = y(y > min(y1,y2) & y < max(y1,y2));  % y�߿��� ���ϴ� ������ �ִ� y��.
    
    
%    y(k+1) ��  ______________
%               |            |
%               |            |
%               |            |
%               |            |
%      y(k) ��  --------------
%               ��           ��
%              x(k)       x(k+1)


    %% Input Validation
    isOut = [x1<x_min; x1>x_max; x2<x_min; x2>x_max; y1<y_min; y1>y_max; y2<y_min; y2>y_max];
    if sum(isOut)  % ���� ������ �� �ȿ� �ִ��� üũ
        error('an input coordinate is out of the map');
    end
    
    isMapFormed = sum(sum((unfreeMap==0 + unfreeMap))) - w*h;
    if isMapFormed
        error('map is not formed well : composed of 0(free), 1(obstacle)');
    end
    if (resolution <= 0) && (~isreal(resolution))
        error('resolution must be a positive real number');
    end
    
    %% ���� MAIN
    
    % ���� ���ϱ� : ���� �׸��� ����� ����
    y_its_wrt_x = m*(x_range-x1) + y1;      % x(i)�� ������
    x_its_wrt_y = m^-1*(y_range-y1) + x1;   % y(j)   i,j in N
    its_unsort = [x_range, y_its_wrt_x; x_its_wrt_y, y_range];
    
    % ������ ������� �迭
    its_sort = sortrows(its_unsort);
    
    % ���ϰ��� �ϴ� ������ �������� : get segments / segmentation
    I1 = [x1, y1; its_sort];   % segments�� ����
    I2 = [its_sort; x2, y2];   % segments�� ����
    seg_id2 = grid2P(I1,I2,resolution);   % �� segment�� ���� ID��. p1, p2�� �����̶�� ���� �����϶�.
    seg_id1 = w*(seg_id2(:,2)-1) + seg_id2(:,1);  % segment id�� �� �ڸ��� ǥ��
    seg_length = sqrt( ( I2(:,1)-I1(:,1) ).^2  + ( I2(:,2)-I1(:,2) ).^2 );

    % �� segment�� free���� �ƴ��� üũ
    seg_if_unfree = ismember(seg_id1, unfreeSpaceID); % free�̸� 0  unfree�̸� 1

    % ���� ���ϱ�
    d1 = sum(seg_length .* ~seg_if_unfree);
    d2 = sum(seg_length .* seg_if_unfree);
    
    
end