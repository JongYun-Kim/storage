function [fitness, indiv] = cost_func2(x,r,e,dt,n_u,n_s,L_cell,PL,spd_rel,bomb,hit_eff)
% returns cost(damage)
    %%% x�� �ݵ�� �����Ϳ��� �Ѵ�.
%     rng('default');  % reset random seed
%     rng('shuffle');  % shuffling random seed
    
    x = ceil(x);
    
    D = zeros(n_u,n_s);   mask_pass = zeros(n_s,n_u);
%     D = [];  mask_pass = [];
    for k = 1:n_u
        target = x(k);
%         D = [D; dt{k}(target,:)]; % n_u x n_s matrix  % uav i�� target�� �Ҵ� �Ǿ��� ��, �ٸ� ������ �Ÿ� : ���� �Ҵ��Ȳ���� �Ÿ���
        D(k,:) = dt{k}(target,:);
        ispass = L_cell{k}(:,target) > 0 ;  % n_s column vector  % uav i �� target�� �Ҵ� �Ǿ��� ��, �������� ���̵�
%         mask_pass = [mask_pass, ispass];
        mask_pass(:,k) = ispass;
    end
    mask_pass = mask_pass';  % n_u x n_s matrix  % ���� �Ҵ� ���¿��� �� uav�� �� �踦 ���������� ����.
%     mj = sum((1 - (D.^2 ./ (repmat(r,n_u,1)).^2 ) ).*mask_pass);  
    n = sum(mask_pass); % n_s row vector
    nn = repmat(n,n_u,1);
    m_pre = mask_pass .* ( 1 + ( 1./nn -1 ).*D./repmat(r,n_u,1) );
    m_pre(isnan(m_pre)) = 0;
    mj = sum(m_pre);% n_s row vector  % �� �谡 ������ ���α� ���� ��ȿ���
    
    asn = zeros(n_u,n_s);  % uav�� ship���� ������ �����
    for k = 1:n_s
        isship = x==k;     % 
        asn(:,k) = isship;
    end
    
    PL = PL ./ repmat(mj,n_u,1); 
    uav_surv = 1 - PL./spd_rel;
    mask_surv = uav_surv < 0;
    uav_surv = uav_surv .* (~mask_surv);  % n_u x n_s matrix  % 1�밡 �󸶳� ��� ������
    dam_sole = uav_surv .* repmat(bomb,1,n_s) .* repmat(hit_eff,1,n_s);  % n_u x n_s matrix  % 1�밡 �󸶳� ����� �� �� �ִ���
    
    indiv = sum(dam_sole.*asn); % .* sat_model(mj);  % n_s row vector  % individual damages
    mask_indi = indiv > e;  % ���������� ū ��
    indiv = indiv.*(~mask_indi) + e.*(mask_indi);
    fitness = sum(indiv);

end