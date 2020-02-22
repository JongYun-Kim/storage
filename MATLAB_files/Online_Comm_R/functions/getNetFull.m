function NetFull = getNetFull(gpNode_pos, mobileNode_pos, GP,model_params,staticNet)
% This function returns a Fully connected network given positions of gp and mobile nodes 
    global base_pos_meanfunc
    % Without staticNet
    if nargin < 4
        error('인자가 모자랍니다.');
    elseif nargin == 4
        staticNet = [];
    end

    % static node info
    NumStatic = size(staticNet,1);
    if NumStatic ~= size(staticNet,2); error('정사각행렬이 아니에요 ㅠㅠ'); end
    % GP Node info
    NumGP = size(gpNode_pos,1);
    if NumGP ~= size(GP,2); error('GP 노드 크기가 인풋 위치정보랑 로봇숫자가 달라요 ㅠ'); end
    % size errors
    if NumStatic ~= 0           % static의 크기가 존재할 때 
        if NumStatic < NumGP    % GP의 숫자가 더 커버리면 안됨
            warning('고마해라 마이 뭇다;;;');
            error('Static 네트워크의 크기보다 GP노드 갯수가 많습니다. (non-empty staticNet)');
        end
    end
% % %     NumMobile = size(mobileNode_pos,1);
% % %     NumFull = NumGP + NumMobile;
% % %     NumRelay = NumFull - max(NumGP, NumStatic );
    
    % 경우 나눠서 하기
    if NumStatic == 0
    % staticNet이 없는 경우
        NumMobile = size(mobileNode_pos,1);  % GP가 아닌 다른 노드수
        
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
        subNetGPGP = 0.5 * (subNetGPGP + subNetGPGP');  % 양측으로 평균내줌; 원래 대칭도 만들어야하기도하고 어쨌든
        
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
        subNetmbmb = subNetmbmb + subNetmbmb';  % 대칭으로 맞춰주고 계산안한 나머지 부여
        
        % 전체 네트워크 계산
        NetFull = [ subNetGPGP, subNetGPmb';
                    subNetGPmb, subNetmbmb];
                
    else
    % staticNet이 있는 경우 (GP와 같을 수는 있음)
        % size 계산
        NumMobile = size(mobileNode_pos,1);
        NumClient = NumStatic - NumGP;
        NumRelay  = NumMobile - NumClient;
        
        % relay to base block
        subNetrb = zeros(NumRelay,NumGP);  % 하 삼각행렬의 br 블락
        for i = 1: NumGP
            base_pos_meanfunc = gpNode_pos(i,:);
            subNetrb(:,i) = gp(GP(i).hyp_learned, GP(i).inffunc, GP(i).meanfunc, GP(i).covfunc, GP(i).likfunc, GP(i).D, GP(i).Y, mobileNode_pos(NumClient+1:end,:));
                % i-th 베이스노드에서 모든 릴레이의 열벡터 GP시그널
        end
        base_pos_meanfunc = [];
        
        % relay to client block
        subNetrc = zeros(NumRelay,NumClient);
        for i = 1:NumClient
            subNetrc(:,i) = getSignals(mobileNode_pos(i,:),mobileNode_pos(NumClient+1:end,:),model_params);
                % 클라이언트 메인에서 릴레이들의 열벡터 시그널
        end
        
        % relay to relay block
        subNetrr = zeros(NumRelay);
        for i = 1:NumRelay
            subNetrr(i+1:end,i) = getSignals(mobileNode_pos(NumClient+i,:),mobileNode_pos(NumClient+i+1:end,:),model_params);
                % 하나의 릴레이 기준에서 나머지 릴레이들의 열벡터 시그널
        end
        subNetrr = subNetrr + subNetrr';
        
        % 전체 네트워크 계산
        NetFull = [staticNet, [subNetrb'; subNetrc'];
                   subNetrb ,  subNetrc , subNetrr   ];
    end

end