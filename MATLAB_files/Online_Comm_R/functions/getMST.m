function [Net_mst, cost_mst, mst_adj] = getMST(Net_org)
% This function returns a MST graph of original graph

    NumAgent = size(Net_org,1);

    % Input validation
    if NumAgent ~= size(Net_org,2)         % �� ���簢 ����� ���� ���
        error('��ǲ ��Ʈ��ũ �׷����� ���簢 ����̾�� �մϴ�.')
    elseif ( sum(diag(Net_org).^2) ) ~= 0  % �밢 ������ �ϳ��� 0�� �ƴ� ���
        error('��ǲ ��Ʈ��ũ �׷����� �밢������ �׻� 0�Դϴ�.');
    end
    
    % Weight vectors
    weight_n = Net_org(Net_org~=0);      % weights of adj mat (vector form)

    % Idx vectors => 2���� �ٲ�����
    idx_n = find(Net_org~=0);            % indicies of the non-zero adj mat, Gn  (vector form)

    % Index vector to actual indices
    jn = ceil(idx_n/NumAgent);           % the column indicies of non-zero elements in Gn
    in = idx_n - ((jn-1)*NumAgent);      % the row    indicies of non-zero elements in Gn

    % Define PV mats
    PVn =  [in,  jn,  -weight_n ];       % PV mat, the input form of the MST algorithm
                                         % kruskal �˰����� ����Ʈ�� ���� ���� ������ ã��
                                         % ���ϴ� weight���� ���� ���ƾ�(����� �ߵǾ��)�ϴϱ� weight�� ��ȣ�� �ٲ�.

    % Run the MST algorithm
    [cost_mst, mst_adj] = kruskal(PVn);  % weight�� ���� �ּ�ȭ ����.
    cost_mst = -cost_mst;                % cost�� ����(���� ��ȣ)�� ���������� �ٲ���
    Net_mst = Net_org .* mst_adj;        % mst ��Ʈ��ũ �׷��� ����

end