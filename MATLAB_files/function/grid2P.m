function id = grid2P(I1,I2,resolution)
% 두 교점이 들어오면 그 segment가 속하는 그리드의 ID값을 반환

    Ix = min([I1(:,1), I2(:,1)],[],2);  % x 값중 작은 것을 택함
    Iy = min([I1(:,2), I2(:,2)],[],2);  % y 값중 작은 것을 택함
    
    id = gridID(Ix,Iy,resolution);

end