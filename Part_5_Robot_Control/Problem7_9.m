clear
clc
close all
%% CONSTANTS

L1 = 0.67; r1 = 0.04;
L2 = 1.7; b2 = 0.22;
L3 = 1.65; b3 = 0.18;
a4 = 0.98;

m1 = 4.9; m2 = 8.1; m3 = 4.9; m4 = 2.2;

%% Problem 7

syms m L r b a

% equations
I1 = 1/12*m*L^2 + 1/4*m*r^2;
I1yy = 1/2*m*r^2;

I2 = m*b^2/6;
I2zz = m*(L^2 + b^2)/12;

I4 = 1/12*m*a^2;

D1 = [double(vpa(subs(I1, [m,L,r], [m1, L1, r1]),5)); ...
      double(vpa(subs(I1yy, [m,r], [m1, r1]),5)); ...
      double(vpa(subs(I1, [m,L,r], [m1, L1, r1]),5))] .* eye(3);
  
D2 = [double(vpa(subs(I2, [m,b], [m2, b2]),5)); ...
      double(vpa(subs(I2, [m,b], [m2, b2]),5)); ...
      double(vpa(subs(I2zz, [m,L,b], [m2, L2, b2]),5))] .* eye(3);

D3 = [double(vpa(subs(I2, [m,b], [m3, b3]),5)); ...
      double(vpa(subs(I2zz, [m,L,b], [m3, L3, b3]),5)); ...
      double(vpa(subs(I2, [m,b], [m3, b3]),5))] .* eye(3);

D4 = [0; ...
      double(vpa(subs(I4, [m,a], [m4, a4]),5)); ...
      double(vpa(subs(I4, [m,a], [m4, a4]),5))] .* eye(3);

%% Problem 9

I1 = D1(1,1); I1yy = D1(2,2);
I2 = D2(1,1); I2zz = D2(3,3);
I3 = D3(1,1); I3yy = D3(2,2);
I4 = D4(2,2);

n = 53;
J_M = 1320*10^(-7);
Delta2 = 1;

% q2 = linspace(pi/6,3*pi);
% q3 = linspace(1.35, 3);
% q4 = linspace(-pi/2, 5*pi/4);


K0 = m2*(1/2*L2-Delta2)^2 + m3*(1/2*L3)^2;
K1 = 1/2*(I4 + 1/4*m4*a4^2);
K2 = 1/2*(I2 - I2zz + I3 - I3yy + K0);
K3 = I2 + I3 + K0 + 2*K1;
K4 = m3 + m4;
K5 = 1/2*(2*I1yy + I2zz + I3yy + K3);

f1 = @(q3) (1/2*K4*q3^2 - 1/2*m3*L3*q3);
f2 = @(q3) (m4*a4*q3);
f3 = @(q4) (1/2*a4*m4*cos(q4));

% diagonal elements
D11 = @(q2,q3,q4) K5 + f1(q3) - (K2+f1(q3))*cos(2*q2) + K1*cos(2*(q2+q4)) - f2(q3)*cos(q2+q4)*sin(q2);
D22 = @(q2,q3,q4) K3 + 2*f1(q3) + f2(q3)*sin(q4);
D33 = K4;
D44 = 2*K1;

x0 = [pi/6; 1.35; -pi/2];
x1 = [3*pi; 3; 5*pi/4];
A = eye(3);


sol1 = fmincon(@(x) -D11(x(1),x(2),x(3)), x0, [], [], [], [], x0, x1);
sol1;

sol2 = fmincon(@(x) -D22(x(1),x(2),x(3)), x0, [], [], [], [], x0, x1);
sol2;


supD = [D11(sol1(1), sol1(2), sol1(3)); D22(sol2(1), sol2(2), sol2(3)); D33; D44];

% my name is
Jeff = 1/n^2 .* supD + J_M