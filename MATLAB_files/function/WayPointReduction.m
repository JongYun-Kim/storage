function new_path = WayPointReduction(path,unfreeMap,resolution,unfreeSpaceID)
    % path�� �޾Ƽ� waypoint reduction �Ѱ��� ��ȯ��
    path_length = size(path,1);
    
    i = 1;
    goal_flag = false;
    while (i < path_length)
        path_length = size(path,1);
        for j = i+1:path_length
            if isLOS(path(i,1),path(i,2),path(j,1),path(j,2),unfreeMap,resolution,unfreeSpaceID)
                                           % LOS
                  if j == path_length            % ���� ����� �� �Է� �ִٸ�
                      goal_flag = true;
                      if j~=i+2
                          path(i+1:j-2,:) = [];  % path�� �����
                      end
                      break;                     % �׸��� Ż��
                  end
                                           % �Ϲ������δ� �ƹ��͵� ���� �ʴ´�.
            else                           % NLOS
                if j~=i+2                  % Ư������ ���� ��쿡��
                    path(i+1:j-2,:) = [];  % path�� �����
                end
                break;                     % �׸��� ���̻� �ڸ� ������ �ʴ´�.
            end

        end
        
        if goal_flag  % ����� �� ���Ŷ�� Ż��!
            break;
        end
        i = i+1;
    end
    
    new_path = path;
    
end


function LOS = isLOS(x1,y1,x2,y2,unfreeMap,resolution,unfreeSpaceID)
    % ������ LOS���θ� �˷��� LOSȮ�� ���θ� �˷���
    [d1, d2] = sepDistance(x1,y1,x2,y2,unfreeMap,resolution,unfreeSpaceID);
    if d2==0
        LOS = true;
    else
        LOS = false;
    end
    
end