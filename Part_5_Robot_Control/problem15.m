clear
clc
close all
%% Problem 13 : Find max load
h = calc_h();


%% Problem 15 : INIT

STEP_SIZE = 0.001;
SIM_TIME = 2.;

Jeff = [0.0188, 0.0188, 0.0027, 0.0004].';
feff = 2.4*10^(-5);
n = 53;
kT = 0.17;
g = 9.8;

omega_n = 15; %[rad/s]
zeta = 1;
tau_i = abs(Jeff);

K_p = (omega_n.^2*tau_i + 2*omega_n*zeta) ./ kT;
K_D = (2*omega_n*zeta*tau_i + 1 - feff) ./ kT;
K_I = omega_n^2 / kT * ones(4,1);

T_L = abs(h);
% T_L = zeros(4,1);

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

%% SIMULATION

% reference step 1,2,3,4
qr = [0.35, 0.35, 0.35, 0.35];
% step time
step_time = 0.01; % used in simulation
simout = sim("Problem15_model_v2");

q = simout.q.Data;
u = simout.u.Data;
t = simout.q.Time;
e = simout.error.Data;

%% PLOT A4

figure, h1 = subplot(1,1,1); set(h1,'FontName','times','FontSize',16)
hold on, grid on
plot(t,u(:,1),'--k')
plot(t,q(:,1),'-b','LineWidth',3)
ylabel('State value','FontName','times','FontSize',16,'interpreter','latex')
% xlabel('Time $[s]$','FontName','times','FontSize',16,'interpreter','latex')
% axis([-0.5,2,0,0.4])

plot(t,q(:,2),'-r','LineWidth',2)
plot(t,q(:,3),'-.g','LineWidth',2)
plot(t,q(:,4),'--c','LineWidth',2)

% xlim([0,0.6])

l = legend('$q_i^r$', '$q_1$','$q_2$', '$q_3$', '$q_4$','Location','SouthEast');
set(l,'FontName','times','FontSize',12,'interpreter','latex')
sgtitle("A4")

% %% PLOT ERROR
% figure, h1 = subplot(1,1,1); set(h1,'FontName','times','FontSize',16)
% hold on, grid on
% plot(t,e(:,1),'-b','LineWidth',3)
% ylabel('State value','FontName','times','FontSize',16,'interpreter','latex')
% % xlabel('Time $[s]$','FontName','times','FontSize',16,'interpreter','latex')
% % axis([-0.5,2,0,0.4])
% 
% plot(t,e(:,2),'-r','LineWidth',2)
% plot(t,e(:,3),'-.g','LineWidth',2)
% plot(t,e(:,4),'--c','LineWidth',2)
% 
% l = legend('$e_{q_1}$','$e_{q_2}$', '$e_{q_3}$', '$e_{q_4}$','Location','NorthEast');
% set(l,'FontName','times','FontSize',12,'interpreter','latex')
% sgtitle("Error")
