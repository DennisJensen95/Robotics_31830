clear
clc
close all
%% INIT
global GM m1 m2 m3 m4 L1 L2 dd2 L3 a4 I2 I3 I4 I1yy I2zz I3yy g n kT feff d1;

addpath("./Models/");

%% Init constants
L1 = 0.67; r1 = 0.04;
L2 = 1.7; b2 = 0.22;
L3 = 1.65; b3 = 0.18;
a4 = 0.98; d1 = 1.5;

m1 = 4.9; m2 = 8.1; m3 = 4.9; m4 = 2.2;

g = 9.80;
dd2 = 0.34;

% equations
I1 = 1/12*m1*L1^2 + 1/4*m1*r1^2;
I1yy = 1/2*m1*r1^2;

I2 = m2*b2^2/6;
I2zz = m2*(L2^2 + b2^2)/12;

I3 = m3*b3^2/6;
I3yy = m3*(L3^2 + b3^2)/12;

I4 = 1/12*m4*a4^2;

GM = [0.1165   -0.5825    0.7767         0         0   -0.3430
   -0.0063    0.0314   -0.0419         0         0    1.7570
    0.0616   -0.3082    0.4109         0         0    1.5127
    0.0063   -0.0314    0.0419         0         0    2.9554
   -0.0960    0.4800   -0.6401         0         0    0.2783
   -0.0044    0.0222   -0.0296         0         0    1.7234
    0.0629   -0.3144    0.4192         0         0    1.8414
    0.0044   -0.0222    0.0296         0         0    2.9889
    0.0816   -0.4079    0.5438         0         0   -0.2337
   -0.0033    0.0164   -0.0218         0         0    1.6998
    0.0636   -0.3181    0.4242         0         0    2.1768
    0.0033   -0.0164    0.0218         0         0    3.0126
   -0.0709    0.3544   -0.4725         0         0    0.2013
   -0.0025    0.0125   -0.0167         0         0    1.6823
    0.0641   -0.3205    0.4274         0         0    2.5161
    0.0025   -0.0125    0.0167         0         0    3.0301];

% GM = [0.1165   -0.5825    0.7767         0         0   -0.3430
%    -0.0063    0.0314   -0.0419         0         0    1.7570
%     0.0616   -0.3082    0.4109         0         0    1.5127
%    -0.0063    0.0314   -0.0419         0         0    0.1862
%    -0.0960    0.4800   -0.6401         0         0    0.2783
%    -0.0044    0.0222   -0.0296         0         0    1.7234
%     0.0629   -0.3144    0.4192         0         0    1.8414
%    -0.0044    0.0222   -0.0296         0         0    0.1526
%     0.0816   -0.4079    0.5438         0         0   -0.2337
%    -0.0033    0.0164   -0.0218         0         0    1.6998
%     0.0636   -0.3181    0.4242         0         0    2.1768
%    -0.0033    0.0164   -0.0218         0         0    0.1290
%    -0.0709    0.3544   -0.4725         0         0    0.2013
%    -0.0025    0.0125   -0.0167         0         0    1.6823
%     0.0641   -0.3205    0.4274         0         0    2.5161
%    -0.0025    0.0125   -0.0167         0         0    0.1115];

Jeff = [0.0188, 0.0188, 0.0027, 0.0004].';
feff = 2.4*10^(-5);
n = 53;
kT = 0.17;
g = 9.8;

%% Calculate H
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


%% Problem 17 : Simulation parameters

STEP_SIZE = 0.001;
SIM_TIME = 8.;

omega_n = 15; %[rad/s]
zeta = 1;
tau_i = abs(Jeff);

K_p = (omega_n.^2*tau_i + 2*omega_n*zeta) ./ kT;
K_D = (2*omega_n*zeta*tau_i + 1 - feff) ./ kT;
K_I = omega_n^2 / kT;

T_L = abs(h);
% T_L = h;

%% Transfor functions

n0 = kT*K_I;
n1 = kT*K_p;
n2 = feff + kT*K_D;
n3 = Jeff;

N = [tf([n3(1), n2(1), n1(1), n0],1);
     tf([n3(2), n2(2), n1(2), n0],1);
     tf([n3(3), n2(3), n1(3), n0],1);
     tf([n3(4), n2(4), n1(4), n0],1)];

f0 = kT * K_I;
f1 = kT * K_p;
f2 = kT * K_D;

F = [tf([f2(1), f1(1), f0],1);
     tf([f2(2), f1(2), f0],1)
     tf([f2(3), f1(3), f0],1)
     tf([f2(4), f1(4), f0],1)];

G = tf([1/n^2, 0],1);

fp0 = 1;
fp1 = K_p ./ K_I;
fp2 = K_D ./ K_I;

FP = [tf(1,[fp2(1), fp1(1), fp0]);
      tf(1,[fp2(2), fp1(2), fp0])
      tf(1,[fp2(3), fp1(3), fp0])
      tf(1,[fp2(4), fp1(4), fp0])];

%% SIMULATION

simout = sim("Problem17_model");

p = simout.p.Data;
px = p(:,1); py = p(:,2);
q = simout.q.Data;
qr = simout.qr;
t = simout.q.Time;
e = simout.error.Data;

%% PLOT A5

figure, h1 = subplot(1,1,1); set(h1,'FontName','times','FontSize',16)
hold on, grid on
plot(t,q(:,1),'-b','LineWidth',3)
ylabel('State value','FontName','times','FontSize',16,'interpreter','latex')
% xlabel('Time $[s]$','FontName','times','FontSize',16,'interpreter','latex')
% axis([-0.5,2,0,0.4])

plot(t,q(:,2),'-r','LineWidth',2)
plot(t,q(:,3),'-.g','LineWidth',2)
plot(t,q(:,4),'--c','LineWidth',2)

l = legend('$q_1$','$q_2$', '$q_3$', '$q_4$','Location','SouthEast');
set(l,'FontName','times','FontSize',12,'interpreter','latex')
% ylim([0,0.4])
sgtitle("A7")

%% PLOT XY
figure, h1 = subplot(1,1,1); set(h1,'FontName','times','FontSize',16)
hold on, grid on
plot(px,py,'-r','LineWidth',3)
ylabel('y','FontName','times','FontSize',16,'interpreter','latex')
xlabel('x','FontName','times','FontSize',16,'interpreter','latex')
% axis([-0.5,2,0,0.4])

sgtitle("XY plot")
