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

GM = [0.0656   -0.3281    0.4375         0         0    1.4000
    0.1875   -0.9375    1.2500         0         0   -0.5000
    0.0656   -0.3281    0.4375         0         0    1.7500
   -0.1875    0.9375   -1.2500         0         0    0.5000
    0.0656   -0.3281    0.4375         0         0    2.1000
    0.1875   -0.9375    1.2500         0         0   -0.5000
    0.0656   -0.3281    0.4375         0         0    2.4500
   -0.1875    0.9375   -1.2500         0         0    0.5000];

Jeff = [0.0188, 0.0188, 0.0027, 0.0004].';
feff = 2.4*10^(-5);
n = 53;
kT = 0.17;
g = 9.8;

%% Problem 21 : Simulation parameters

STEP_SIZE = 0.001;
SIM_TIME = 8.;

omega_n = 15; %[rad/s]
zeta = 1;

K_p = omega_n^2 * Jeff / kT;
K_D = 2*zeta/omega_n * K_p - feff / kT;
K_I = zeros(4,1);

Kp1 = K_p(1); Kp2 = K_p(2); Kp3 = K_p(3); Kp4 = K_p(4);
KD1 = K_D(1); KD2 = K_D(2); KD3 = K_D(3); KD4 = K_D(4);
KI1 = K_I(1); KI2 = K_I(2); KI3 = K_I(3); KI4 = K_I(4);

%% SIMULATION

simout = sim("trc_dyn");

p = simout.p;
px = p(:,1); py = p(:,2);
t = simout.t;

%% PLOT A11
figure, h1 = subplot(1,1,1); set(h1,'FontName','times','FontSize',16)
hold on, grid on
plot(px,py,'-r','LineWidth',3)
ylabel('y','FontName','times','FontSize',16,'interpreter','latex')
xlabel('x','FontName','times','FontSize',16,'interpreter','latex')
% axis([-0.5,2,0,0.4])

sgtitle("A11")
