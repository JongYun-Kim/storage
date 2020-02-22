function u_robot = getRobotControls(NumControl,maxRate)
% 로봇의 최대 최소 해딩레이트가 주어졌을 때, 가능 헤딩 변화값 반환
    
    u_robot = zeros(NumControl,1);  % 열벡터~
    
    if NumControl == 1
        u_robot = 0;
        warning('컨트롤의 개수가 0개라서 직진 밖에 못합니다.')
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
        error('NumControl must be larger than 0') % 앞에서 행렬생성해서 어차피 실행 안될듯
    end
    
end