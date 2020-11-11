clear
clc
close all
%% Problem 12 : INIT

STEP_SIZE = 0.01;
SIM_TIME = 2.;

Jeff = [0.0188, 0.0188, 0.0027, 0.0004].';
feff = 2.4*10^(-5);
n = 53;
kT = 0.17;
g = 9.8;

omega_n = 15; %[rad/s]
zeta = 1;

K_p = omega_n^2 * Jeff / kT;
K_D = 2*zeta/omega_n * K_p - feff / kT;


%% Transfor functions

% n1 = (feff + kT * K_D)./Jeff;
% n2 = kT * K_p ./ Jeff;
% 
% Ni = tf([1, n1(1), n2(1)],[1]);
% 
% f1 = kT * K_D ./ Jeff;
% f2 = kT * K_p ./ Jeff;
% F = [tf([f1(1),f2(1)],1);
%     tf([f1(2),f2(2)],1);
%     tf([f1(3),f2(3)],1);
%     tf([f1(4),f2(4)],1)];

%% SIMULATION

% reference step 1,2,3,4
qr = [0.34, 0.34, 0.34, 0.34];
% step time
step_time = 0.01; % used in simulation
simout = sim("Problem12_model_v2");

q = simout.q.Data;
u = simout.u.Data;
t = simout.q.Time;

%% PLOT A1

figure, h1 = subplot(1,1,1); set(h1,'FontName','times','FontSize',16)
hold on, grid on
plot(t,u(:,1),'--k')
plot(t,q(:,1),'-b','LineWidth',3)
ylabel('$q_1$','FontName','times','FontSize',16,'interpreter','latex')
xlabel('Time $[s]$','FontName','times','FontSize',16,'interpreter','latex')
% axis([-0.5,2,0,0.4])

plot(t,q(:,2),'-r','LineWidth',2)
plot(t,q(:,3),'-.g','LineWidth',2)
plot(t,q(:,4),'--c','LineWidth',2)

l = legend('$q_i^r$', '$q_1$','$q_2$', '$q_3$', '$q_4$','Location','SouthEast');
set(l,'FontName','times','FontSize',12,'interpreter','latex')
sgtitle("A1")

%% PLOT A2

zeta = 0;

K_p = omega_n^2 * Jeff / kT;
K_D = 2*zeta/omega_n * K_p - feff / kT;

% n1 = (feff + kT * K_D)./Jeff;
% n2 = kT * K_p ./ Jeff;
% 
% Ni = tf([1, n1(1), n2(1)],[1]);
% 
% f1 = kT * K_D ./ Jeff;
% f2 = kT * K_p ./ Jeff;
% F = [tf([f1(1),f2(1)],1);
%     tf([f1(2),f2(2)],1);
%     tf([f1(3),f2(3)],1);
%     tf([f1(4),f2(4)],1)];

% reference step 1,2,3,4
qr = [0.34, 0.34, 0.34, 0.34];
% step time
step_time = 0.01;
simout = sim("Problem12_model_v2");

q = simout.q.Data;
u = simout.u.Data;
t = simout.q.Time;

figure, h1 = subplot(1,1,1); set(h1,'FontName','times','FontSize',16)
hold on, grid on
plot(t,u(:,1),'--k')
plot(t,q(:,1),'-b','LineWidth',3)
ylabel('$q_1$','FontName','times','FontSize',16,'interpreter','latex')
xlabel('Time $[s]$','FontName','times','FontSize',16,'interpreter','latex')
% axis([-0.5,2,0,0.4])

plot(t,q(:,2),'-r','LineWidth',2)
plot(t,q(:,3),'-.g','LineWidth',2)
plot(t,q(:,4),'--c','LineWidth',2)

l = legend('$q_i^r$', '$q_1$','$q_2$', '$q_3$', '$q_4$','Location','SouthEast');
set(l,'FontName','times','FontSize',12,'interpreter','latex')
sgtitle("A2")