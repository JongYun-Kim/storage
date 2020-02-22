function D = Dist(X1,X2)
% This script returns distance between two sets of points
% INPUT: X1,2: [x,y,z] or [x,y] :: (#of points)x(2 or 3)
    
    dim = size(X1,2);
    if dim ~= size(X2,2)
        error('�Ÿ���� �� ����� ������ �ٸ��ϴ�.');
    end
    if dim ~=2
        if dim ~= 3
            error('�Ÿ���� ��� ����� ������ 2,3������ �ƴմϴ�. [������x����] ���� ������ּ���.');
        end
    end
    
    D = sqrt( sum( (X1-X2).^2 ,2 ) );

end