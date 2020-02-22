function pos = randGenPos(NumAgent,MapBound,maxIter,minDist)
% returns a random position set;
    if nargin == 2
        maxIter = 500;
        minDist = 3;
    elseif nargin == 3
        minDist = 3;  % ����Ʈ ����
    elseif nargin == 4
        if minDist <= 0 
            error('minDist ���� �׻� ��� �Դϴ�.')
        end
    else
        error('�� ����; ��ǲ ���ڰ� �ʹ� ����...')
    end
    
    endCond = false;
    iter = 0;
    while(~endCond)
        % �����Ǹ� �׸����� �Ф�
        if iter > maxIter
            warning('�ʹ��ʹ� ������� ���̼� ��������');
            break;
        end
        % �ϴ� ���� ���ô�
        pos = (rand(NumAgent,2)-0.5) .* repmat([(MapBound(2)-MapBound(1)), (MapBound(4)-MapBound(3))],NumAgent,1);    % random generation
        if NumAgent == 1  % �ϳ�¥���� �� �ʿ� ����
            break;
        end
        % ���Ÿ��� ���մϴ�.
        NumRelDist = NumAgent*(NumAgent-1)/2;
        ii = 1;
        relDist = zeros(NumRelDist,1);
        for i = 1:NumAgent-1
            for j = i+1:NumAgent
                relDist(ii) = Dist(pos(i,:),pos(j,:));
                ii = ii + 1;  % ���� ��������.. �ε��� �ڵ��� �ƴ�..
            end
        end
        % ������ �ִ��� üũ
        if sum(relDist < minDist) > 0
            iter = iter + 1;
            continue;
        end
        
        break;
    end

end