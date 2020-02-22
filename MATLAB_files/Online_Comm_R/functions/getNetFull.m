function NetFull = getNetFull(gpNode_pos, mobileNode_pos, GP,model_params,staticNet)
% This function returns a Fully connected network given positions of gp and mobile nodes 
    global base_pos_meanfunc
    % Without staticNet
    if nargin < 4
        error('���ڰ� ���ڶ��ϴ�.');
    elseif nargin == 4
        staticNet = [];
    end

    % static node info
    NumStatic = size(staticNet,1);
    if NumStatic ~= size(staticNet,2); error('���簢����� �ƴϿ��� �Ф�'); end
    % GP Node info
    NumGP = size(gpNode_pos,1);
    if NumGP ~= size(GP,2); error('GP ��� ũ�Ⱑ ��ǲ ��ġ������ �κ����ڰ� �޶�� ��'); end
    % size errors
    if NumStatic ~= 0           % static�� ũ�Ⱑ ������ �� 
        if NumStatic < NumGP    % GP�� ���ڰ� �� Ŀ������ �ȵ�
            warning('���ض� ���� ����;;;');
            error('Static ��Ʈ��ũ�� ũ�⺸�� GP��� ������ �����ϴ�. (non-empty staticNet)');
        end
    end
% % %     NumMobile = size(mobileNode_pos,1);
% % %     NumFull = NumGP + NumMobile;
% % %     NumRelay = NumFull - max(NumGP, NumStatic );
    
    % ��� ������ �ϱ�
    if NumStatic == 0
    % staticNet�� ���� ���
        NumMobile = size(mobileNode_pos,1);  % GP�� �ƴ� �ٸ� ����
        
        % GP-GP block
        subNetGPGP = zeros(NumGP);
        for i = 1:NumGP
            base_pos_meanfunc = gpNode_pos(i,:);
            for j = 1:NumGP
                if i==j
                    continue;
                else
                    subNetGPGP(i,j) = gp(GP(i).hyp_learned, GP(i).inffunc, GP(i).meanfunc, GP(i).covfunc, GP(i).likfunc, GP(i).D, GP(i).Y, gpNode_pos(j,:));
                end
            end
        end
        base_pos_meanfunc = [];
        subNetGPGP = 0.5 * (subNetGPGP + subNetGPGP');  % �������� ��ճ���; ���� ��Ī�� �������ϱ⵵�ϰ� ��·��
        
        % GP-mb block
        subNetGPmb = zeros(NumMobile,NumGP);
        for i = 1:NumGP
            base_pos_meanfunc = gpNode_pos(i,:);
            subNetGPmb(:,i) = gp(GP(i).hyp_learned, GP(i).inffunc, GP(i).meanfunc, GP(i).covfunc, GP(i).likfunc, GP(i).D, GP(i).Y, mobileNode_pos);
        end
        base_pos_meanfunc = [];
        
        % mb-mb block
        subNetmbmb = zeros(NumMobile);
        for i = 1:NumMobile
            subNetmbmb(i+1:end,i) = getSignals(mobileNode_pos(i,:),mobileNode_pos(i+1:end,:),model_params);
        end
        subNetmbmb = subNetmbmb + subNetmbmb';  % ��Ī���� �����ְ� ������ ������ �ο�
        
        % ��ü ��Ʈ��ũ ���
        NetFull = [ subNetGPGP, subNetGPmb';
                    subNetGPmb, subNetmbmb];
                
    else
    % staticNet�� �ִ� ��� (GP�� ���� ���� ����)
        % size ���
        NumMobile = size(mobileNode_pos,1);
        NumClient = NumStatic - NumGP;
        NumRelay  = NumMobile - NumClient;
        
        % relay to base block
        subNetrb = zeros(NumRelay,NumGP);  % �� �ﰢ����� br ���
        for i = 1: NumGP
            base_pos_meanfunc = gpNode_pos(i,:);
            subNetrb(:,i) = gp(GP(i).hyp_learned, GP(i).inffunc, GP(i).meanfunc, GP(i).covfunc, GP(i).likfunc, GP(i).D, GP(i).Y, mobileNode_pos(NumClient+1:end,:));
                % i-th ���̽���忡�� ��� �������� ������ GP�ñ׳�
        end
        base_pos_meanfunc = [];
        
        % relay to client block
        subNetrc = zeros(NumRelay,NumClient);
        for i = 1:NumClient
            subNetrc(:,i) = getSignals(mobileNode_pos(i,:),mobileNode_pos(NumClient+1:end,:),model_params);
                % Ŭ���̾�Ʈ ���ο��� �����̵��� ������ �ñ׳�
        end
        
        % relay to relay block
        subNetrr = zeros(NumRelay);
        for i = 1:NumRelay
            subNetrr(i+1:end,i) = getSignals(mobileNode_pos(NumClient+i,:),mobileNode_pos(NumClient+i+1:end,:),model_params);
                % �ϳ��� ������ ���ؿ��� ������ �����̵��� ������ �ñ׳�
        end
        subNetrr = subNetrr + subNetrr';
        
        % ��ü ��Ʈ��ũ ���
        NetFull = [staticNet, [subNetrb'; subNetrc'];
                   subNetrb ,  subNetrc , subNetrr   ];
    end

end