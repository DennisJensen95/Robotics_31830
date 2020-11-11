function h = calc_h()

%% Calculate H

L1 = 0.67; r1 = 0.04;
L2 = 1.7; b2 = 0.22;
L3 = 1.65; b3 = 0.18;
a4 = 0.98; d1 = 1.5;

m1 = 4.9; m2 = 8.1; m3 = 4.9; m4 = 2.2;

g = 9.80;
dd2 = 0.34;

% lower bound
x0 = [pi/6; 1.35; -pi/2];

% upper bound
x1 = [3*pi/4; 3; 5*pi/4];

% elements
h1 = 0;
h2 = @(q2,q3,q4) g*(1/2*m4*a4*cos(q2+q4) + (m2*(dd2 - 1/2*L2) + m3*(1/2*L3-q3)...
    - m4*q3) *sin(q2));
h3 = @(q2) g*(m3+m4)*cos(q2);
h4 = @(q2,q4) g*1/2*a4*m4*cos(q2+q4);

% find maximum value
% sol1 = fmincon(@(x) -h1(x(1),x(2),x(3)), x0, [], [], [], [], x0, x1);
sol2 = fmincon(@(x) -abs(h2(x(1),x(2),x(3))), x0, [], [], [], [], x0, x1);
sol3 = fmincon(@(x) -(h3(x)), x0(1), [], [], [], [], x0(1), x1(1));
% sol4 = fmincon(@(x) h4(x(1),x(2)), x0(1:2:3), [], [], [], [], x0(1:2:3), x1(1:2:3));
sol4 = [pi/2, -pi/2];

% construct supD vector
h = [h1; h2(sol2(1), sol2(2), sol2(3)); ...
    h3(sol3(1)); h4(sol4(1), sol4(2))];

end