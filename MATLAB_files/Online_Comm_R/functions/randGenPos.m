function pos = randGenPos(NumAgent,MapBound,maxIter,minDist)
% returns a random position set;
    if nargin == 2
        maxIter = 500;
        minDist = 3;
    elseif nargin == 3
        minDist = 3;  % 디폴트 벨류
    elseif nargin == 4
        if minDist <= 0 
            error('minDist 값은 항상 양수 입니다.')
        end
    else
        error('그 뭐냐; 인풋 숫자가 너무 없음...')
    end
    
    endCond = false;
    iter = 0;
    while(~endCond)
        % 때가되면 그만하자 ㅠㅠ
        if iter > maxIter
            warning('너무너무 가까워요 둘이서 누구더라');
            break;
        end
        % 일단 구해 봅시다
        pos = (rand(NumAgent,2)-0.5) .* repmat([(MapBound(2)-MapBound(1)), (MapBound(4)-MapBound(3))],NumAgent,1);    % random generation
        if NumAgent == 1  % 하나짜리는 할 필요 없음
            break;
        end
        % 상대거리를 구합니다.
        NumRelDist = NumAgent*(NumAgent-1)/2;
        ii = 1;
        relDist = zeros(NumRelDist,1);
        for i = 1:NumAgent-1
            for j = i+1:NumAgent
                relDist(ii) = Dist(pos(i,:),pos(j,:));
                ii = ii + 1;  % 버그 생길지도.. 인덱스 자동이 아님..
            end
        end
        % 가까운게 있는지 체크
        if sum(relDist < minDist) > 0
            iter = iter + 1;
            continue;
        end
        
        break;
    end

end