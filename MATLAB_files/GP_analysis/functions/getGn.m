function Gn = getGn(Node,gpGridNode,resolution,unfreeMap,unfreeSpaceID,model_params,see_warning)
% returns the Gn matrix
% you should specify the nodes and map information

    %% 정보 받아오기 체크
    % model info
    C = model_params.C;
    nu = model_params.nu;
    alpha = model_params.alpha_val;
    too_close = -25;
    
    % map info
    mapSizeRowGridX = size(unfreeMap,1);
    
    
    % node info
    NumNode = size(Node,2);
    Gn = -99*ones(NumNode);
    node_position = reshape(p(particle,:),2,NumRelay)';  % 각 행에 각 릴레이의 (x,y) position있음
    node_position_gridID = gridID2(node_position,resolution);
    node_position_gridID_short = node_position_gridID(:,1) + ( (mapSizeRowGridX).*(node_position_gridID(:,2)-1)) ;
    
    
    %% 구간 나누기 : GPR // GP2Model // Model2Model
    
    
    %% Gn 배열하기
    
    
    %% Gn 구하기
    for i = 1:NumNode
        for j = 1:NumNode
            if i == j
                Gn(i,j) = 0;
                continue;
            end
            
            if (Node(i).GP+Node(j).GP)==2      % 둘다 베이스인 경우
                % 두 개를 평균 내면 된다.
                
            elseif (Node(i).GP+Node(j).GP)==1  % 하나만 베이스인 경우
                % 베이스를 찾아서 GP값을 구한다.
                if Node(i).GP  % i 가 베이스인 경우
                    
                else           % j 가 베이스인경우
                    
                end
            elseif (Node(i).GP+Node(j).GP)==0  % 둘다 모델로 해야하는 경우
                % 그냥 모델 가져와서 하면된다.
                [d1, d2] = sepDistance(node_position(i,1),node_position(i,2),node_position(j,1),node_position(j,2),unfreeMap,resolution,unfreeSpaceID);
                Gn(i,j) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % 음수의 실제값 반영
                if Gn(i,j) > too_close
                    if see_warning
                        warning('node %d와 node %d 사이의 거리가 너무 가깝습니다.\n',i,j);
                    end
                    Gn(i,j) = too_close;  % 너무 가까우면 적당히 좋은값주고 말음 : 플러스로 가면 안좋아짐..
                end
            else
                fprintf('Node(%d).GP+Node(%d).GP = %d \n',i,j,(Node(i).GP+Node(j).GP));
                error('sth if wrong while estimating Gn');
            end
        end
    end
    
    
    
    %% 오류 체크





end