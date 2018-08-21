function [y]=model_missile_kin(x)
X_m = x(1);
Y_m = x(2);
psi_m = x(3);
V_m = x(4);
a_c = x(5);
lamb = x(6);
R = x(7);

X_t = x(8);
Y_t = x(9);
psi_t = x(10);
V_t = x(11);

R_dot = -V_m*cos(lamb-psi_m) + V_t*cos(lamb - psi_t);
lamb_dot = (V_m/R)*sin(lamb - psi_m) - (V_t/R)*sin(lamb - psi_t);
psi_dot = a_c;


y = [R_dot;lamb_dot;psi_dot];