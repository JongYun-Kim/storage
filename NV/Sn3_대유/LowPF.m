function [Z] = LowPF(X)
x = X(1);
x_pre = X(2);
tau = X(3);
dt = X(4);


y = tau/(tau+dt)*x_pre + dt/(tau+dt)*x;

Z(1) = y;