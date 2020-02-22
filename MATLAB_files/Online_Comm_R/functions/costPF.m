function cost = costPF(x,Xmin,Xmax,Ymin,Ymax,Qdist)
% This function returns the cost for a potential field

    distPF_min = distPF(x,Xmin,Xmax,Ymin,Ymax);
    
    cost = zeros(size(distPF_min));
    cost(distPF_min < Qdist) = ( (1./distPF_min(distPF_min < Qdist)) - (1/Qdist) ).^2;
    % �Ÿ��� Qdist���� ª���� ���ټ��ʵ� ��� (�׻� ���)
    % �׷��� ������ �̸� ������ 0
    
% % %     if distPF_min <= Qdist
% % %         cost = ( (1./distPF_min) - (1/Qdist) ).^2;
% % %         cost(cost>1e4) = 1e4;
% % %     else
% % %         cost = zeros(size(distPF_min));
% % %     end
    cost = sum(cost);

end


function distMin = distPF(x,Xmin,Xmax,Ymin,Ymax)
% returns the distance for PF in a squared map
% INPUTS: x       : (NumR*horLen)*2 martix
%         XYminmax: scarlars
%         Qdist   : a scarlar
    temp = [(x(:,1)-Xmin), (Xmax-x(:,1)), (x(:,2)-Ymin), (Ymax-x(:,2))];
    
    distMin = min(temp,[],2);  % x�� ���� ���α���(=row��=column�����Ǳ���)�� ����

end