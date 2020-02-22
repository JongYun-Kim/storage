function sig = getSignals(mainNode,mobileNodes,model_params)
% This function returns computed signals based on a communication model and noise
% INPUT: mainNode  : column vector 일단은 한 대라고 가정
%        mobileNodes: (NumBase)x(2) >> 그냥 통신값얻을 주변 노드들이라고 생각해도됨 노이즈 없이 쓸꺼면
%%%%%%%%%%%%%%%% 반드시 그거 인풋의 차원을 row vec 스택으로 해주세요 ㅠㅠ휴 %%%%%%%%%%%%%%%%%%%%%
% 참고: mainNode가 기준노드고, 모델로 알고싶은 다른 노드를 mobileNodes라고 생각하면 될듯
    % The number of mobileNodes
    NumMobile = size(mobileNodes,1);
    
    % Parameters
    C = repmat(model_params.C,NumMobile,1);
    nu = model_params.nu;
    
    % Distance computation
    D = Dist(repmat(mainNode,NumMobile,1),mobileNodes);
    
    if nu == 0
        sig = -20*log10(D) + C ;  % 음수의 실제 RSSI 값을 줌; 노이즈 없음
    else
        sig = -20*log10(D) + C + nu*randn(NumMobile,1);  % 음수의 실제 RSSI 값을 줌; 노이즈도 섞었음
    end
    
    sig(sig > -20) = -20;  % 너무 가까운애들은 비슷한 시그널로 처리
                           % 왜냐하면 너무 가까울때 모델이 조금 틀리기도 하지만
                           % GMC 같은데서는 지수함수적으로 증가하는 것 때문에 둘이 거의 붙어버림 ㄷㄷㄷㄷ
                           % 코스트 혼자 다먹어서..
                           % 참고로, 반면, WCC는 어차피 일정 수준 좋아지면 다른 곳을 릴레이하러 가야하기
                           % 때문에 굳이 가까워져도 코스트가 안변해서 상관이 없음 ㄷㄷ
end