function [Net_mst, cost_mst, mst_adj] = getMST(Net_org)
% This function returns a MST graph of original graph

    NumAgent = size(Net_org,1);

    % Input validation
    if NumAgent ~= size(Net_org,2)         % 비 정사각 행렬이 들어올 경우
        error('인풋 네트워크 그래프는 정사각 행렬이어야 합니다.')
    elseif ( sum(diag(Net_org).^2) ) ~= 0  % 대각 성분이 하나라도 0이 아닐 경우
        error('인풋 네트워크 그래프의 대각성분은 항상 0입니다.');
    end
    
    % Weight vectors
    weight_n = Net_org(Net_org~=0);      % weights of adj mat (vector form)

    % Idx vectors => 2열로 바뀌어야함
    idx_n = find(Net_org~=0);            % indicies of the non-zero adj mat, Gn  (vector form)

    % Index vector to actual indices
    jn = ceil(idx_n/NumAgent);           % the column indicies of non-zero elements in Gn
    in = idx_n - ((jn-1)*NumAgent);      % the row    indicies of non-zero elements in Gn

    % Define PV mats
    PVn =  [in,  jn,  -weight_n ];       % PV mat, the input form of the MST algorithm
                                         % kruskal 알고리즘은 웨이트가 가장 작은 조합을 찾음
                                         % 원하는 weight합이 가장 높아야(통신이 잘되어야)하니까 weight의 부호를 바꿈.

    % Run the MST algorithm
    [cost_mst, mst_adj] = kruskal(PVn);  % weight의 합을 최소화 해줌.
    cost_mst = -cost_mst;                % cost를 음수(원래 부호)로 최종적으로 바꿔줌
    Net_mst = Net_org .* mst_adj;        % mst 네트워크 그래프 형성

end