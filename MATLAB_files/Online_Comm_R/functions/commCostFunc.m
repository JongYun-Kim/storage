function [commCost, Net_mst, mst_adj] = commCostFunc(base_pos, client_pos, relay_pos, GP, model_params, NetOrg,isGMC)
% ��� �ڽ�Ʈ �����: GMC, minimization
    
    % ��Ʈ��ũ �׷��� ���
    NetFull = getNetFull(base_pos, [client_pos; relay_pos], GP, model_params,NetOrg);
    
    % MST ã�� & Communciation cost ���
    if isGMC
        [Net_mst, commCost, mst_adj] = getMST(NetFull);
    else  % WCC�� ���
        [Net_mst, ~, mst_adj] = getMST(NetFull);
        commCost = min(Net_mst(Net_mst~=0));
    end
end