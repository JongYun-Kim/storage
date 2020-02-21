function new_path = WayPointReduction(path,unfreeMap,resolution,unfreeSpaceID)
    % path를 받아서 waypoint reduction 한것을 반환함
    path_length = size(path,1);
    
    i = 1;
    goal_flag = false;
    while (i < path_length)
        path_length = size(path,1);
        for j = i+1:path_length
            if isLOS(path(i,1),path(i,2),path(j,1),path(j,2),unfreeMap,resolution,unfreeSpaceID)
                                           % LOS
                  if j == path_length            % 만약 골까지 다 뚤려 있다면
                      goal_flag = true;
                      if j~=i+2
                          path(i+1:j-2,:) = [];  % path를 지운다
                      end
                      break;                     % 그리고 탈출
                  end
                                           % 일반적으로는 아무것도 하지 않는다.
            else                           % NLOS
                if j~=i+2                  % 특별하지 않은 경우에만
                    path(i+1:j-2,:) = [];  % path를 지운다
                end
                break;                     % 그리고 더이상 뒤를 보지는 않는다.
            end

        end
        
        if goal_flag  % 골까지 다 본거라면 탈출!
            break;
        end
        i = i+1;
    end
    
    new_path = path;
    
end


function LOS = isLOS(x1,y1,x2,y2,unfreeMap,resolution,unfreeSpaceID)
    % 두점의 LOS여부를 알려줌 LOS확보 여부를 알려줌
    [d1, d2] = sepDistance(x1,y1,x2,y2,unfreeMap,resolution,unfreeSpaceID);
    if d2==0
        LOS = true;
    else
        LOS = false;
    end
    
end