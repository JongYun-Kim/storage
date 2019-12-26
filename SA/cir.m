function p = cir(center, radi, n)
% center should be (x,y)
% radi should be a positive real scalar number
% n should be a natural number

    theta = linspace(0,2*pi,n+1);
    theta = del(theta)';
    
    x = radi * cos(theta) + center(1);
    y = radi * sin(theta) + center(2);
    
    p = [x,y];
    
end