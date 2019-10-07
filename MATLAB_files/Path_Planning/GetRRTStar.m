function path = GetRRTStar(start,goal,pruning,unfreeMap,resolution,unfreeSpaceID)
    % This functioin returns a RRT-Star path
    % start : (x,y)
    % goal  : (x,y)
    % unfreeMap     : 0 for free space, 1 for unfree(obstacle)
    % resolution    : map resolution = length of a grid of a grid map
    % unfreeSpaceID : grid ID where the grid is pre-occupied (obstacle)
    
    % Use "load('MapDATA.mat','unfreeMap','resolution','unfreeSpaceID')" to
    % get the three variables
    
    % DO NOT plot anything at all
    
    %% Parameter Settings
    NumOfNodes = 10000*2;  % 마지막에 반환하고자하는 노드 수
    smoothing = 1;         % 스무딩 플래그 변수
    EPS = 1;               % 노드사이 최대 거리
    End_to_nodeiter = 1;   % 0:goal까지 경로생성하면 종료, 1:NumOfNodes까지 iter  
%    pruning = false;        % pruning 할지 말지~~
%     r = 1/3*EPS;               % q_new의 nearest를 찾는 반경 % RRT*가 아니라서 안쓰임 ㅋㅋㅋ
    %%% USE your parameters such as numNodes, EPS(?), x_max, q_start.coord, etc
    
    %% Main Loop
    %%% Calculate what you have to do to get RRT path
    [w,h] = size(unfreeMap); % grid맵 정보
    x_min = 0; x_max = resolution*w; % 실제 맵 크기
    y_min = 0; y_max = resolution*h;
    
    if size(start,1) > size(start,2) % return column vector to row vector
       start = start';
    end
   if size(goal,1) > size(goal,2) 
       goal = goal';
   end
    
%     q_start.coord = start;
%     q_start.cost = 0;
%     q_start.parent = 0;
    q_start = [start 0 0 0]; % 1,2 는 좌표 3은 골과 연결성 확인 4는 cost 5는 parent
%     q_goal.coord = goal; 
%     q_goal.cost = 0;
    q_goal = [goal 0 0 0];
    isOut = [q_start(1) < x_min; q_start(1) > x_max; q_start(2) < y_min; q_start(2) > y_max];
    isOut2 = [q_goal(1) < x_min; q_goal(1) > x_max; q_goal(2) < y_min; q_goal(2) > y_max];
    if sum(isOut)  % 시작점이 맵 안에 있는지 체크
        error('start coordinate is out of the map');
    elseif sum(isOut2)  % 목표점이 맵 안에 있는지 체크
        error('goal coordinate is out of the map');
    end
    
    % 시작점과 목표점을 grid로 표현
%     start_grid = [w-floor(q_start.coord(2)/resolution),floor(q_start.coord(1)/resolution)+1];
%     goal_grid = [w-floor(q_goal.coord(2)/resolution),floor(q_goal.coord(1)/resolution)+1];
    start_grid = gridID(q_start(1),q_start(2),resolution);
    goal_grid = gridID(q_goal(1),q_goal(2),resolution);
    if start_grid(1) == 0
       start_grid(1) = 1;
    elseif start_grid(2) == h+1
        start_grid(2) = h;
    elseif goal_grid(1) == 0
        goal_grid(1) = 1;
    elseif goal_grid(2) == h+1
        goal_grid(2) = h;
    end
    
    if unfreeMap(start_grid(1),start_grid(2)) == 1 % 시작점이 장애물 위에 있는지 확인
        error('start coordinate is on the obstacle');
    elseif unfreeMap(goal_grid(1),goal_grid(2)) == 1 % 목표점이 장애물 위에 있는지 확인
        error('goal coordinate is on the obstacle');
    end
    
    nodes(1,:) = q_start; 
    %% Extend tree
    for i = 1:NumOfNodes % start NumOfNodes iter
        q_rand = rand; % 좌표로 rand node 생성
        if q_rand < .05 % bias to goal
            randomPoint = q_goal(1:2);
        else
            randomPoint = [rand*x_max rand*y_max];
        end
        
        % Pick the closest node from existing list to branch out from
        tmp = nodes(:,1:2) - ones(size(nodes,1),1)*randomPoint;
        [val,idx] = min(sqrt(diag(tmp*tmp')));
        q_near = nodes(idx,:);
        
        q_new = zeros(1,5);
        q_new(1:2) = steer(randomPoint, q_near(1:2), val, EPS);
        if noCollision2(q_new(1:2), q_near(1:2), unfreeMap,resolution,unfreeSpaceID)
            q_new(4) = dist(q_new(1:2), q_near(1:2)) + q_near(4); % cost
            q_new(5) = idx; % parent
            nodes = [nodes; q_new];
            if (norm(q_new(1:2) - goal) < EPS) && (noCollision2(q_new(1:2), goal, unfreeMap,resolution,unfreeSpaceID))
                nodes(end,3) = 1;
                if End_to_nodeiter == 0
                    break
                end
            end
        end
        if mod(i,3000)==0
            disp(i)
        end
    end % NumOfNodes
    
    %% Find minimum path
%     num = 1;
%     candi_cost = [];
%     candi = [];
%     for j = 1:length(nodes)
%         if noCollision2(q_goal.coord, nodes(j).coord, unfreeMap,resolution,unfreeSpaceID)
%             candi_cost(num) = nodes(j).cost;
%             candi(num) = j;
%             num = num + 1;
%         end
%     end
    Index = find(nodes(:,3)==1);
    disp(length(Index));
    connectingNodes = nodes(Index,:);
    [tmp,idx] = min(connectingNodes(:,4));
    idx = Index(idx);
    if ~noCollision2(nodes(idx,1:2), q_goal(1:2), unfreeMap,resolution,unfreeSpaceID)
        error('there is no path due to lack of nodes');
    else
        q_goal(5) = idx;
        q_goal(4) = dist(nodes(idx,1:2), q_goal(1:2)) + nodes(idx,4);
        nodes = [nodes; q_goal];
        q_end = q_goal;
        path = [];
        while q_end(5) ~= 0
            path = [q_end; path ];
            start = q_end(5);
    %         line([q_end.coord(1), nodes(start).coord(1)], [q_end.coord(2), nodes(start).coord(2)], 'Color', 'r', 'LineWidth', 2);
    %         hold on
            q_end = nodes(start,:);
        end
        path = [q_start; path];
    end
    
    %% Path pruning
    if pruning
        begin_po = path(1,:);
        end_po   = path(2,:);
        % end_node = path_final(end,:);
        i = 1;j=2;
        final_point_e_LOS=[];
        while (end_po(1,1:2) ~= q_goal(1,1:2))
                if noCollision2(begin_po(1,1:2), end_po(1,1:2), unfreeMap,resolution,unfreeSpaceID)
                    j=j+1;
                    end_po = path(j,:);            
                else
                    begin_po    = path(j-1,:);
                    end_po      = path(j,:);
                    final_point_e_LOS(i,:) = path(j-1,:);
                    i = i + 1;      
                end   

        end
        final_point=[path(1,:);final_point_e_LOS;path(end,:)];
        path = final_point;
    end    
    
%     %% Searching the goal
%     %%% pick the path that is optimal among what you created so far
%     D = [];
%     for j = 1:1:length(nodes)
%         tmpdist = dist(nodes(j).coord, q_goal.coord);
%         D = [D tmpdist];
%     end
%     
%     % Search backwards from goal to start to find the optimal least cost path
%     [val, idx] = min(D);
%     q_final = nodes(idx);
%     q_goal.parent = idx;
%     q_goal.cost = nodes(idx).cost + dist(nodes(idx).coord, q_goal.coord);
%     nodes = [nodes q_goal];
%     q_end = q_goal;
%     path = [];
%     while q_end.parent ~= 0
%         path = [q_end path ];
%         start = q_end.parent;
% %         line([q_end.coord(1), nodes(start).coord(1)], [q_end.coord(2), nodes(start).coord(2)], 'Color', 'r', 'LineWidth', 2);
% %         hold on
%         q_end = nodes(start);
%     end
%     path = [q_start path];
    
    %% Path Modification
    %%% modify path to return the generated array of nodes indicating the path
    %%% You may want to make the path composed of NumOfNodes
    
    if smoothing
        %
    end
    
    %% Return the Path
    
%     path = 999;
    
end