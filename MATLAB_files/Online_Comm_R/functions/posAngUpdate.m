function [del_x, del_y, del_ang] = posAngUpdate(currentState, u_sys_at_t, sampleTime, relaySpd)
% 특정 컨트롤 인풋이 들어왔을 때 포지션 업데이트를 해줌
% INPUT: u_sys_at_t: 열벡터임!! 특정시간에서 릴레이별로 컨트롤 값(각속도로 들어옴)
%                    사실 벡터아닌 행렬로 들어올 경우 두 번째 차원이 horizon의 길이 입니다.
%                    ex) u_sys_at_t = [ 0 0 1;
%                                      -1 1 0] : 릴레이 두 대의 경우; horizonLength = 3; 
%        sampleTime: 스칼라
% OUTPUT: del_x: (NumRelay) x (시간길이) 행렬

    del_ang = u_sys_at_t * sampleTime;
    del_dist = relaySpd * sampleTime;
    
    % "누적" 시간 변화량을 알아내자
    del_x = cumsum( del_dist * cos(currentState(:,3)+del_ang), 2 );
    del_y = cumsum( del_dist * sin(currentState(:,3)+del_ang), 2 );
    del_ang = cumsum( del_ang ,2 );
    
end