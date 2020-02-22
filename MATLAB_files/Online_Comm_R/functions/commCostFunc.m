function [commCost, Net_mst, mst_adj] = commCostFunc(base_pos, client_pos, relay_pos, GP, model_params, NetOrg,isGMC)
% 통신 코스트 계산함: GMC, minimization
    
    % 네트워크 그래프 계산
    NetFull = getNetFull(base_pos, [client_pos; relay_pos], GP, model_params,NetOrg);
    
    % MST 찾음 & Communciation cost 계산
    if isGMC
        [Net_mst, commCost, mst_adj] = getMST(NetFull);
    else  % WCC인 경우
        [Net_mst, ~, mst_adj] = getMST(NetFull);
        commCost = min(Net_mst(Net_mst~=0));
    end
end