function u_robot = getRobotControls(NumControl,maxRate)
% �κ��� �ִ� �ּ� �ص�����Ʈ�� �־����� ��, ���� ��� ��ȭ�� ��ȯ
    
    u_robot = zeros(NumControl,1);  % ������~
    
    if NumControl == 1
        u_robot = 0;
        warning('��Ʈ���� ������ 0���� ���� �ۿ� ���մϴ�.')
    elseif NumControl > 1
        if maxRate <= 0
            error('The heading rate must be positive');
        else
            stepSize = (2*maxRate)/(NumControl-1);
            for i = 1:NumControl
                u_robot(i) = (-maxRate) + (i-1)*stepSize;
            end
        end
    else
        error('NumControl must be larger than 0') % �տ��� ��Ļ����ؼ� ������ ���� �ȵɵ�
    end
    
end