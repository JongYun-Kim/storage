function xu = genIndPoints(MapBound,density, Qdist)
% returns induced points within the MapBound with the density except for the PF-region of the Qdist. 

%%% MapBound = [ Xmin, Xmax, Ymin, Ymax ]
%%% density: a scarlar :: �̰ݰŸ� ����
%%% Qdist : safety zone ���� in the PF zone

    % declear the bounds
    xb1 = MapBound(1) + Qdist;
    xb2 = MapBound(2) - Qdist;
    yb1 = MapBound(3) + Qdist;
    yb2 = MapBound(4) - Qdist;
    
    % mesh the map
    [x,y] = meshgrid(xb1:density:xb2, yb1:density:yb2);
    
    % generate induced inputs
    xu = [x(:), y(:)];
end