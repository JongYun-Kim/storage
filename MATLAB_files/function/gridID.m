function id = gridID(x1,y1,resolution)
    
    id = [floor(x1/resolution) + 1 , floor(y1/resolution) + 1];
    % 바깥 경계선에서는 에러가 있으나 쓸일이 없으니.. 일단 무시

end