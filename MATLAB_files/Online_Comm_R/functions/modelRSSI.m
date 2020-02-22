function signal =  modelRSSI(position_set,model_params,unfreeMap,resolution,unfreeSpaceID)
    % This function returns signal strength between RR or RC based on the model
    
    % model_params.alpha_val = -1.2922;
    % model_params.C = -27.8460;
    % model_params.nu = 0;
    
    % position_set: (���)x(2��=4d) ���
    
    % ��ü ������ �� ���� ����
    numP = size(position_set,1);
    
    % �� ���ڿ� �°� �Ķ���� Ʃ�� (Reshape)
    C = repmat(model_params.C,numP,1);
    nu = repmat(model_params.nu,numP,1);
    alpha = model_params.alpha_val;
    
    % Get effective distance De  = d1 + alpha * d2
    d1 = -1*ones(numP,1); d2 = -1*ones(numP,1);
    for i = 1:numP
        [d1(i), d2(i)] = sepDistance(position_set(i,1),position_set(i,2),position_set(i,3),position_set(i,4),unfreeMap,resolution,unfreeSpaceID);
    end
%     De = d1 + model_params.alpha_val*d2;
    D = d1+d2;
    
    % Get RSSI signal to the client based on the model
% %     signal = -1*(-20*log10(De) + C + nu);  % ������ RSSI ����� �ϴ°Ŷ�....
    signal = -20*log10(D) + C + alpha*d2;  % ������ ���� RSSI ���� ��
    
end