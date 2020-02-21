function [val, tree] = fitEval(p,d,GMC,mGMC,WCC,beta,Gn,gpGridNode,resolution,unfreeMap,unfreeSpaceID,model_params)
% fitness val�� ��ȯ��; GPR_p���迡 �°� �Ǿ� ����.

% p : particles - (m x p) matrix
% d : dimension; d=NumRelays
% GMC, mGMC, WMC : communication performance metrics
% Gn : Adj matrix b/w grounds
% gpGridNode(1:Numnodes).data : gp grid data for fast computation instead of the gp functions

%% Parameter settting
NumNodes = size(Gn,1);
NumRelay = d/2;
m = size(p,1);  % the swarm size
% C = repmat(model_params.C,m,1);
C = model_params.C;
nu = model_params.nu;
% nu = repmat(model_params.nu,m,1);
alpha = model_params.alpha_val;
mapSizeRowGridX = size(unfreeMap,1);  % 608
% % % mapSizeColGridY = size(unfreeMap,2);  % 704
see_warning = false;

% output ũ�� �����Ҵ�
val = -1*ones(m,1);    % ���� ������ ����� �ɸ��� �ϱ� üũ
tree(m).Gnr2 = [];
% tree(m).PVnr = [];

too_close = -30;



for particle = 1:m  % �� particle�� ���ؼ�,
    
%% Get Gnr matrix
    relay_position = reshape(p(particle,:),2,NumRelay)';  % �� �࿡ �� �������� (x,y) position����
    relay_position_gridID = gridID2(relay_position,resolution);
    relay_position_gridID_short = relay_position_gridID(:,1) + ( (mapSizeRowGridX).*(relay_position_gridID(:,2)-1)) ;
    map_out_num = sum(unfreeMap(relay_position_gridID_short));  % �� ���� �����̰� �� ������ �����ִ���
    if map_out_num  % ���࿡ �� �ۿ� �� �� �̻� �ִٸ�.
        if GMC
            val(particle,1) = 100*(NumNodes+NumRelay);       % �κ� ���� ��ŭ �ִ� val���� ���� �ֱ�
            tree(particle).Gnr2 = zeros(NumNodes+NumRelay);  % dummy tree ���� : ���߿� �̰� �� ������ ���� ������ �ִٰ� �˾Ƽ� �����ϼ�
        elseif mGMC
            val(particle,1) = 100*map_out_num*beta;          % ���� �����̸�ŭ ������. ���� ������ ������ �ְ� �սô�.
            tree(particle).Gnr2 = zeros(NumNodes+NumRelay);  % dummy tree
        elseif WCC
            val(particle,1) = 100;                           % ���� ���� connection�� �Ű澲�� �׳� 100
            tree(particle).Gnr2 = zeros(NumNodes+NumRelay);  % dummy tree
        else
            error('Check... why...!')
        end
        continue;  % �ϴ� ���� �ֵ��� ������ �� ��ġ�� ����.
    end

    
    % Gnr�� GPR�����Ϳ��� ���� �� �ִ� �κ� ���� ���
    Gnr_ground_to_relay = -1*ones(NumNodes,NumRelay);    % GPR�����ͷ� ���� �� �ִ� �κ� (Gnr�� ������ �κ�(�Ʒ� ����))
% % %     for ground = 1:NumNodes
% % %         for relay = 1:NumRelay
% % %             Gnr_ground_to_relay(ground,relay) = gpGridNode(ground).data(relay_position_gridID(relay,1),relay_position_gridID(relay,2));            
% % %         end
% % %     end

    for ground = 1:NumNodes
        Gnr_ground_to_relay(ground,:) = gpGridNode(ground).data(relay_position_gridID_short);
    end

    
    % Gnr�� ������ ���ؾ��ϴ� (�����̰�) �Ϳ� ���ؼ� ���
    Gnr_bw_relay = -1*ones(NumRelay);   % Gnr�� ���ϴ� ���簢 ���; ������ ���� ��� adj ��� (�������)
    for relay1 = 1: NumRelay
        for relay2 = 1:NumRelay
            if relay1==relay2
                Gnr_bw_relay(relay1,relay2) = 0;
            else
                [d1, d2] = sepDistance(relay_position(relay1,1),relay_position(relay1,2),relay_position(relay2,1),relay_position(relay2,2),unfreeMap,resolution,unfreeSpaceID);
                Gnr_bw_relay(relay1,relay2) = -20*log10((d1+d2)) + C + alpha*d2 + nu; % ������ ������ �ݿ�
                if Gnr_bw_relay(relay1,relay2) > too_close
                    if see_warning
                        warning('Relay %d�� Relay %d ������ �Ÿ��� �ʹ� �������ϴ�.\n      PSO �˰����� ����� ���ư����� Ȯ���ؾ��� �� �� �ֽ��ϴ�.',relay1,relay2);
                    end
                    Gnr_bw_relay(relay1,relay2) = too_close;  % �ʹ� ������ ������ �������ְ� ���� : �÷����� ���� ��������..
                end                    
            end
        end
    end
    
    Gnr = [Gn, Gnr_ground_to_relay; Gnr_ground_to_relay', Gnr_bw_relay];
    
%% Compute PV matrix
    % weight vectors
    weight_nr = Gnr(Gnr~=0); % weights of adj mat (vector form)

    % idx vectors => 2���� �ٲ�����
    idx_nr = find(Gnr~=0);   % indicies of the non-zero adj mat, Gnr (vector form)

    % index vector to actual indices
    jnr = ceil(idx_nr/(NumNodes+NumRelay));        % the column indicies of non-zero elements in Gnr
    inr = idx_nr - ((jnr-1)*(NumNodes+NumRelay));  % the row    indicies of non-zero elements in Gnr

    % define PV mats
    PVnr = [inr, jnr, -weight_nr];  % PV mat, the input form of the MST algorithm

%% Get a MST set
    % run a MST algorithm
    [mst_w_nr, mst_tree_nr] = kruskal(PVnr);  % weight�� ���� �ּ�ȭ ����.
    
%% Compute Cost: cost������ ��·�� ����� �ؾ� ��. minimization ���� Ǫ�°Ŷ� �ϴ�..

    if GMC        % GMC metric �� �� cost���
        val(particle,1) = mst_w_nr;  % ��ü ��Ʈ��ũ �ٰ� fitness :: ������� �� Ȯ������
        tree(particle).Gnr2 = -Gnr.*mst_tree_nr;
    elseif mGMC   % mGMC metric �� �� cost���
        Gnr2 = -Gnr.*mst_tree_nr;              % Ʈ���� �ִ� ���� ����� ����� �ٲ�
        tree(particle).Gnr2 = Gnr2;
        MST_tree_weight = Gnr2(Gnr2>0);        % 0�� �����ϰ� ���� ���·� �ٲ�
        mGMC_val = sort(MST_tree_weight(:),'descend');   % �װ� ������
        val(particle,1) = sum(  mGMC_val(2:2:(2*beta))  );  % �� �߿� beta���� ��ŭ ����
        %%%%%%%%%%%%%%%%%%%%%%%%%% mGMC_val ���� ������ ��� �������� �� ������. ��Ī�ΰ� ��������������!!!
        
    elseif WCC    % WMC metric �� �� cost���
        Gnr2 = -Gnr.*mst_tree_nr;              % Ʈ���� �ִ� ���� ����� ����� �ٲ�
        tree(particle).Gnr2 = Gnr2;
        MST_tree_weight = Gnr2(Gnr2>0);        % 0�� �����ϰ� ���� ���·� �ٲ�
        mGMC_val = sort(MST_tree_weight(:),'descend');   % �װ� ������
%         val(particle,1) = sum(  mGMC_val(2:2:(2*beta))  );  % �� �߿� beta���� ��ŭ ����
        val(particle,1) = sum(  mGMC_val(2)  );  % �� �߿� beta���� ��ŭ ����
        %%%%%%%%%%%%%%%%%%%%%%%%%% mGMC_val ���� ������ ��� �������� �� ������. ��Ī�ΰ� ��������������!!!
    else
        error('you must put a certain comm perf metric')
    end
    
    
    
end % end particle for



end % function end; do not care
