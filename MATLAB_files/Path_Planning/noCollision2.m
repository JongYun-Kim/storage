function nc = noCollision2(n2, n1, unfreeMap,resolution,unfreeSpaceID)
    % this function returns whether there is an obstacle between n1 and n2
    
    
    nc = ~isObs(n1(1),n1(2),n2(1),n2(2),unfreeMap,resolution,unfreeSpaceID);
    
    
end