function [cost, NetFull_next] = costFunc(current_state,u,dt,spd,maxAngRate,coeffNMPC,GP,model_params,base_position,client_position,NetOrg,Xmin,Xmax,Ymin,Ymax,Qdist,isGMC)
% returns the cost
% INPUT current_state = [ x, y, psi ]:: (NumRelay) x (3)
%       u = (NumRelay) x (horizonLength)
%       dt = sampling time
% OUTPUT cost = [ total, comm, GPvar, dynamics ]
    
    global base_pos_meanfunc

    [NumRelay, horizonLength] = size(u);
    NumBase = size(GP,2);
    NumClient = size(client_position,1);
    NumNodes = NumBase + NumClient +NumRelay;
    x = current_state;
    cost = [   0,      0,     0,      0,        0       ];  % cost intialization
%            total   Comm   GPvar  dynamics   potential
    
    [del_x, del_y, del_ang] = posAngUpdate(current_state, u, dt, spd);
    
    % �ð��� ��ġ���
    x_temp_tot = zeros(NumRelay*horizonLength,3);
    for t = 1:horizonLength
        % state ������Ʈ
% % %         for i = 1:NumRelay
% % %             idx = (i-1)*horizonLength + t;
% % %             x_temp_tot(idx,:) = x + [ del_x(i,t), del_y(i,t), del_ang(i,t) ];
% % %         end
        x_temp = x + [ del_x(:,t), del_y(:,t), del_ang(:,t) ];
        x_temp_tot( (NumRelay*(t-1)+1):NumRelay*t, : ) = x_temp;  % �ý����� �ð������� �迭
        
        % comm cost computation: GMC
        if t == 1
            [temp, NetFull_next]   = commCostFunc(base_position, client_position, x_temp(:,1:2), GP, model_params, NetOrg,isGMC);
        
        else
            [temp]   = commCostFunc(base_position, client_position, x_temp(:,1:2), GP, model_params, NetOrg,isGMC);
        end
        cost(2) = cost(2) - temp;
                % GMC�� ���ѰŶ� minimization ������ �������� -1�� ���ؾ� �� ���� ��Ʈ��ũ ���� ����
    end
    if isGMC
        cost(2) = cost(2) / (horizonLength*(NumNodes-1));  % �ð����̴� ��ũ�� ��� �ڽ�Ʈ(GMC)
    else
        cost(2) = cost(2) / (horizonLength);  % �ð����̴� ��� �ڽ�Ʈ(WCC)
    end
    
    % GPvar cost computation
    for i = 1:NumBase  % �� ���̽� ���� GP�� �����ϱ�
        z = x_temp_tot(:,1:2);  % �ֵ��� ��� ��ǥ���� ��Ƴ�
        base_pos_meanfunc = base_position(i,:);
        [~, s2] = gp(GP(i).hyp_learned, GP(i).inffunc, GP(i).meanfunc, GP(i).covfunc, GP(i).likfunc, GP(i).D, GP(i).Y, z);
        cost(3) = cost(3) + sum(s2);  % �л��� ���� ����
    end
    base_pos_meanfunc = [];
    cost(3) = cost(3) / (NumBase*NumRelay*horizonLength*(-1));  % ������� ���� ��� ����: �������ϳ��� Ư�� GP���� �� ���Ǵ� ���� �� �մ� ��
                % �л갪�� ���̶� ����ε� ū���� ã�ƴٴϱ� ���� minimization ������ Ǯ����ϴϱ� (-1)�� ���ؾ���
    
    % dynamics cost computation
    cost(4) = sum(sum( u.^2 ))/(horizonLength*NumRelay*(maxAngRate^2));  % �����̿� �ð����� ������ >> coefficient ����
    
    % potential field penalty computation
    cost(5) = costPF(z,Xmin,Xmax,Ymin,Ymax,Qdist)/(NumRelay*horizonLength);
    
    % cost with coefficient
    cost(1) = cost(2:5) * coeffNMPC;  % ��� ���ε� ��Į��� �� ��������, �����ϰ� ���������� Ȯ���ؾ� �� ��
    

end