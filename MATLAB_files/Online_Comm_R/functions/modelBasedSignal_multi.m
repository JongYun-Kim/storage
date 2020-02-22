function signal = modelBasedSignal_multi(p_pri,p_post,model_params,unfreeMap,resolution,unfreeSpaceID)
    % This function returns signal strength between RR or RC based on the model
    % model_params.alpha_val = -1.2922;
    % model_params.C = -27.8460;
    % model_params.nu = 0;
    
    % 전체 들어오는 점 숫자 세기
    numP = size(p_pri,1);
    if size(p_post,1)~=numP
        error('앞 뒤 포지션의 전체 숫자가 일치하지 않습니다.')
    end
    
    % 점 숫자에 맞게 파라미터 튜닝 (Reshape)
    C = repmat(model_params.C,numP,1);
%     nu = repmat(model_params.nu,numP,1);
    alpha = model_params.alpha_val;
    
    % Get effective distance De  = d1 + alpha * d2
    d1 = -1*ones(numP,1); d2 = -1*ones(numP,1);
    for i = 1:numP
        [d1(i), d2(i)] = sepDistance(p_pri(i,1),p_pri(i,2),p_post(i,1),p_post(i,2),unfreeMap,resolution,unfreeSpaceID);
    end
%     De = d1 + model_params.alpha_val*d2;
    D = d1+d2;
    
    % Get RSSI signal to the client based on the model
% %     signal = -1*(-20*log10(De) + C + nu);  % 지금은 RSSI 양수로 하는거라서....
    signal = -20*log10(D) + C + alpha*d2;  % 음수의 실제 RSSI 값을 줌
    
end