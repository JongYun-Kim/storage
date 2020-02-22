function [del_x, del_y, del_ang] = posAngUpdate(currentState, u_sys_at_t, sampleTime, relaySpd)
% Ư�� ��Ʈ�� ��ǲ�� ������ �� ������ ������Ʈ�� ����
% INPUT: u_sys_at_t: ��������!! Ư���ð����� �����̺��� ��Ʈ�� ��(���ӵ��� ����)
%                    ��� ���;ƴ� ��ķ� ���� ��� �� ��° ������ horizon�� ���� �Դϴ�.
%                    ex) u_sys_at_t = [ 0 0 1;
%                                      -1 1 0] : ������ �� ���� ���; horizonLength = 3; 
%        sampleTime: ��Į��
% OUTPUT: del_x: (NumRelay) x (�ð�����) ���

    del_ang = u_sys_at_t * sampleTime;
    del_dist = relaySpd * sampleTime;
    
    % "����" �ð� ��ȭ���� �˾Ƴ���
    del_x = cumsum( del_dist * cos(currentState(:,3)+del_ang), 2 );
    del_y = cumsum( del_dist * sin(currentState(:,3)+del_ang), 2 );
    del_ang = cumsum( del_ang ,2 );
    
end