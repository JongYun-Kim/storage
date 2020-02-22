function D = Dist(X1,X2)
% This script returns distance between two sets of points
% INPUT: X1,2: [x,y,z] or [x,y] :: (#of points)x(2 or 3)
    
    dim = size(X1,2);
    if dim ~= size(X2,2)
        error('거리계산 두 행렬의 차원이 다릅니다.');
    end
    if dim ~=2
        if dim ~= 3
            error('거리계산 대상 행렬의 차원이 2,3차원이 아닙니다. [점갯수x차원] 으로 만들어주세요.');
        end
    end
    
    D = sqrt( sum( (X1-X2).^2 ,2 ) );

end