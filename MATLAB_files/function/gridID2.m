function id = gridID(position,resolution)
% ����Ʈ�� �־����� �׸��� ���̵� ��ȯ;

% ��� �ӵ��� ���� �ϴ� input validation�� ����
%     id = [floor(position(:,1)/resolution) + 1 , floor(position(:,2)/resolution) + 1];
    % �ٱ� ��輱������ ������ ������ ������ ������.. �ϴ� ����
    % ���࿡ ��輱�� ������ ���� �ִٸ� �ݵ��.. �� �������...
    
    id = [floor(position/resolution) + 1];

end