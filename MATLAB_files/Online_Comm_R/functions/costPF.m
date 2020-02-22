function cost = costPF(x,Xmin,Xmax,Ymin,Ymax,Qdist)
% This function returns the cost for a potential field

    distPF_min = distPF(x,Xmin,Xmax,Ymin,Ymax);
    
    cost = zeros(size(distPF_min));
    cost(distPF_min < Qdist) = ( (1./distPF_min(distPF_min < Qdist)) - (1/Qdist) ).^2;
    % 거리가 Qdist보다 짧으면 포텐셜필드 계산 (항상 양수)
    % 그렇지 않으면 미리 지정한 0
    
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
    
    distMin = min(temp,[],2);  % x랑 같은 세로길이(=row수=column벡터의길이)의 벡터

end