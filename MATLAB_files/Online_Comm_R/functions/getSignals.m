function sig = getSignals(mainNode,mobileNodes,model_params)
% This function returns computed signals based on a communication model and noise
% INPUT: mainNode  : column vector �ϴ��� �� ���� ����
%        mobileNodes: (NumBase)x(2) >> �׳� ��Ű����� �ֺ� �����̶�� �����ص��� ������ ���� ������
%%%%%%%%%%%%%%%% �ݵ�� �װ� ��ǲ�� ������ row vec �������� ���ּ��� �Ф��� %%%%%%%%%%%%%%%%%%%%%
% ����: mainNode�� ���س���, �𵨷� �˰���� �ٸ� ��带 mobileNodes��� �����ϸ� �ɵ�
    % The number of mobileNodes
    NumMobile = size(mobileNodes,1);
    
    % Parameters
    C = repmat(model_params.C,NumMobile,1);
    nu = model_params.nu;
    
    % Distance computation
    D = Dist(repmat(mainNode,NumMobile,1),mobileNodes);
    
    if nu == 0
        sig = -20*log10(D) + C ;  % ������ ���� RSSI ���� ��; ������ ����
    else
        sig = -20*log10(D) + C + nu*randn(NumMobile,1);  % ������ ���� RSSI ���� ��; ����� ������
    end
    
    sig(sig > -20) = -20;  % �ʹ� �����ֵ��� ����� �ñ׳η� ó��
                           % �ֳ��ϸ� �ʹ� ����ﶧ ���� ���� Ʋ���⵵ ������
                           % GMC ���������� �����Լ������� �����ϴ� �� ������ ���� ���� �پ���� ��������
                           % �ڽ�Ʈ ȥ�� �ٸԾ..
                           % �����, �ݸ�, WCC�� ������ ���� ���� �������� �ٸ� ���� �������Ϸ� �����ϱ�
                           % ������ ���� ��������� �ڽ�Ʈ�� �Ⱥ��ؼ� ����� ���� ����
end