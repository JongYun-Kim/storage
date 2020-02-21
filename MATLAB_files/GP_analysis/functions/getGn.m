function Gn = getGn(Node,gpGridNode,resolution,unfreeMap,unfreeSpaceID,model_params,see_warning)
% returns the Gn matrix
% you should specify the nodes and map information

    %% ���� �޾ƿ��� üũ
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
    node_position = reshape(p(particle,:),2,NumRelay)';  % �� �࿡ �� �������� (x,y) position����
    node_position_gridID = gridID2(node_position,resolution);
    node_position_gridID_short = node_position_gridID(:,1) + ( (mapSizeRowGridX).*(node_position_gridID(:,2)-1)) ;
    
    
    %% ���� ������ : GPR // GP2Model // Model2Model
    
    
    %% Gn �迭�ϱ�
    
    
    %% Gn ���ϱ�
    for i = 1:NumNode
        for j = 1:NumNode
            if i == j
                Gn(i,j) = 0;
                continue;
            end
            
            if (Node(i).GP+Node(j).GP)==2      % �Ѵ� ���̽��� ���
                % �� ���� ��� ���� �ȴ�.
                
            elseif (Node(i).GP+Node(j).GP)==1  % �ϳ��� ���̽��� ���
                % ���̽��� ã�Ƽ� GP���� ���Ѵ�.
                if Node(i).GP  % i �� ���̽��� ���
                    
                else           % j �� ���̽��ΰ��
                    
                end
            elseif (Node(i).GP+Node(j).GP)==0  % �Ѵ� �𵨷� �ؾ��ϴ� ���
                % �׳� �� �����ͼ� �ϸ�ȴ�.
                [d1, d2] = sepDistance(node_position(i,1),node_position(i,2),node_position(j,1),node_position(j,2),unfreeMap,resolution,unfreeSpaceID);
                Gn(i,j) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % ������ ������ �ݿ�
                if Gn(i,j) > too_close
                    if see_warning
                        warning('node %d�� node %d ������ �Ÿ��� �ʹ� �������ϴ�.\n',i,j);
                    end
                    Gn(i,j) = too_close;  % �ʹ� ������ ������ �������ְ� ���� : �÷����� ���� ��������..
                end
            else
                fprintf('Node(%d).GP+Node(%d).GP = %d \n',i,j,(Node(i).GP+Node(j).GP));
                error('sth if wrong while estimating Gn');
            end
        end
    end
    
    
    
    %% ���� üũ





end