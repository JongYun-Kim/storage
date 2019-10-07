function [d1, d2] = sepDistance(x1,y1,x2,y2,unfreeMap,resolution,unfreeSpaceID)
% 두 점을 넣었을 때, 입력 받은 그리드 맵에서 아래와 같은 두 가지 거리를 계산함
% d1 : free space를 통과하는 거리
% d2 : obstacle을 통과하는 거리
% 실제 두 점간 거리는 d = d1 + d2
% (x1,y1), (x2,y2) : 두 점 R1-R2  :: 지금은 점으로만 받아짐 :no array 555
% unfreeMap : map 데이터 - 장애물 있는 곳을 1으로 할것 otherwise 0
% resolution : 목적에 맞는 단위 사용
% % % unfreeSpaceID2 : unfreeSpaceID = find(map==0) => 다만.. (i,j) 형태로 바꿀것 성능향상을 위해서 : ㄴㄴ
% unfreeSpaceID : unfreeSpaceID = find(map==0) = find(unfreeMap == 1);

    %% 초기 파라미터 세팅
    
    if x1 > x2  % x1이 x2보다 작을 것이라 가정하기 때문에 x1이 크면 두 점을을 스왑
        tempx = x1;   tempy = y1;
        x1 = x2;      y1 = y2;
        x2 = tempx;   y2 = tempy;
    end
    
    [w,h] = size(unfreeMap);
    x_min = 0; x_max = resolution*w;
    y_min = 0; y_max = resolution*h;
    x = linspace(x_min,x_max,w+1)';    % x(k)는 k번째 열의 그리드의 왼쪽(작은) x좌표
    y = linspace(y_min,y_max,h+1)';
    if isinf((y2-y1)/(x2-x1))
%         error('m is infinity');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  어떡하지!!!!  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% 솔루션 제안1 : x2 = x1 + 0.1* resolution;
        %%% 솔루션 제안2 : 
        x2 = x2 + 0.05*resolution;
    end
    % 기울기가 정상적일 경우 (정상적으로 되버림)
    m = (y2-y1)/(x2-x1);  % 기울기
    x_range = x(x > x1 & x < x2);                  % x중에서 구하는 범위에 있는 x들. 그리드에 걸치면 제외
    y_range = y(y > min(y1,y2) & y < max(y1,y2));  % y중에서 구하는 범위에 있는 y들.
    
    
%    y(k+1) →  ______________
%               |            |
%               |            |
%               |            |
%               |            |
%      y(k) →  --------------
%               ↑           ↑
%              x(k)       x(k+1)


    %% Input Validation
    isOut = [x1<x_min; x1>x_max; x2<x_min; x2>x_max; y1<y_min; y1>y_max; y2<y_min; y2>y_max];
    if sum(isOut)  % 받은 점들이 맵 안에 있는지 체크
        error('an input coordinate is out of the map');
    end
    
    isMapFormed = sum(sum((unfreeMap==0 + unfreeMap))) - w*h;
    if isMapFormed
        error('map is not formed well : composed of 0(free), 1(obstacle)');
    end
    if (resolution <= 0) && (~isreal(resolution))
        error('resolution must be a positive real number');
    end
    
    %% 메인 MAIN
    
    % 교점 구하기 : 메인 그리드 선들과 교점
    y_its_wrt_x = m*(x_range-x1) + y1;      % x(i)와 교점들
    x_its_wrt_y = m^-1*(y_range-y1) + x1;   % y(j)   i,j in N
    its_unsort = [x_range, y_its_wrt_x; x_its_wrt_y, y_range];
    
    % 교점을 순서대로 배열
    its_sort = sortrows(its_unsort);
    
    % 구하고자 하는 선분을 조각내기 : get segments / segmentation
    I1 = [x1, y1; its_sort];   % segments의 앞점
    I2 = [its_sort; x2, y2];   % segments의 뒷점
    seg_id2 = grid2P(I1,I2,resolution);   % 각 segment가 속한 ID값. p1, p2가 포함이라는 점에 주의하라.
    seg_id1 = w*(seg_id2(:,2)-1) + seg_id2(:,1);  % segment id를 한 자리로 표현
    seg_length = sqrt( ( I2(:,1)-I1(:,1) ).^2  + ( I2(:,2)-I1(:,2) ).^2 );

    % 각 segment가 free인지 아닌지 체크
    seg_if_unfree = ismember(seg_id1, unfreeSpaceID); % free이면 0  unfree이면 1

    % 길이 더하기
    d1 = sum(seg_length .* ~seg_if_unfree);
    d2 = sum(seg_length .* seg_if_unfree);
    
    
end