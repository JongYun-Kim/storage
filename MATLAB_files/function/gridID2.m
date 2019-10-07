function id = gridID(position,resolution)
% 포인트가 주어지면 그리드 아이디를 반환;

% 계산 속도를 위해 일단 input validation은 안함
%     id = [floor(position(:,1)/resolution) + 1 , floor(position(:,2)/resolution) + 1];
    % 바깥 경계선에서는 에러가 있으나 쓸일이 없으니.. 일단 무시
    % 만약에 경계선에 도달할 일이 있다면 반드시.. 잘 고려하자...
    
    id = [floor(position/resolution) + 1];

end