function id = grid2P(I1,I2,resolution)
% �� ������ ������ �� segment�� ���ϴ� �׸����� ID���� ��ȯ

    Ix = min([I1(:,1), I2(:,1)],[],2);  % x ���� ���� ���� ����
    Iy = min([I1(:,2), I2(:,2)],[],2);  % y ���� ���� ���� ����
    
    id = gridID(Ix,Iy,resolution);

end