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

h = calc_h(); % calculate h(q)


%% Problem 18 : Simulation parameters

STEP_SIZE = 0.001;
SIM_TIME = 8.;

omega_n = 15; %[rad/s]
zeta = 1;
tau_i = abs(Jeff);

K_p = (omega_n.^2*tau_i + 2*omega_n*zeta) ./ kT;
K_D = (2*omega_n*zeta*tau_i + 1 - feff) ./ kT;
K_I = omega_n^2 / kT * ones(4,1);

T_L = abs(h);
% T_L = h;

%% Transfor functions

% n0 = kT*K_I;
% n1 = kT*K_p;
% n2 = feff + kT*K_D;
% n3 = Jeff;
% 
% N = [tf([n3(1), n2(1), n1(1), n0],1);
%      tf([n3(2), n2(2), n1(2), n0],1);
%      tf([n3(3), n2(3), n1(3), n0],1);
%      tf([n3(4), n2(4), n1(4), n0],1)];
% 
% f0 = kT * K_I;
% f1 = kT * K_p;
% f2 = kT * K_D;
% 
% F = [tf([f2(1), f1(1), f0],1);
%      tf([f2(2), f1(2), f0],1)
%      tf([f2(3), f1(3), f0],1)
%      tf([f2(4), f1(4), f0],1)];
% 
% G = tf([1/n^2, 0],1);
% 
% fp0 = 1;
% fp1 = K_p ./ K_I;
% fp2 = K_D ./ K_I;
% 
% FP = [tf(1,[fp2(1), fp1(1), fp0]);
%       tf(1,[fp2(2), fp1(2), fp0])
%       tf(1,[fp2(3), fp1(3), fp0])
%       tf(1,[fp2(4), fp1(4), fp0])];

%% SIMULATION

simout = sim("Problem18_model_v2");

p = simout.p.Data;
px = p(:,1); py = p(:,2);
t = simout.tout;

%% PLOT A9
figure, h1 = subplot(1,1,1); set(h1,'FontName','times','FontSize',16)
hold on, grid on
plot(px,py,'-r','LineWidth',3)
ylabel('y','FontName','times','FontSize',16,'interpreter','latex')
xlabel('x','FontName','times','FontSize',16,'interpreter','latex')
% axis([-0.5,2,0,0.4])

sgtitle("A9")
