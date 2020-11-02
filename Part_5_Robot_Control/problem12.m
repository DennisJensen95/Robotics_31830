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

n1 = (feff + kT * K_D)./Jeff;
n2 = kT * K_p ./ Jeff;

Ni = tf([1, n1(1), n2(1)],[1]);

f1 = kT * K_D ./ Jeff;
f2 = kT * K_p ./ Jeff;
F = [tf([f1(1),f2(1)],1);
    tf([f1(2),f2(2)],1);
    tf([f1(3),f2(3)],1);
    tf([f1(4),f2(4)],1)];

%% SIMULATION

% reference step 1,2,3,4
qr = [0.34, 0.34, 0.34, 0.34];
% step time
step_time = 0.01;
simout = sim("Problem12_model");

q = simout.q.Data;
u = simout.u.Data;
t = simout.q.Time;

%% PLOT

figure, h1 = subplot(2,2,1); set(h1,'FontName','times','FontSize',16)
hold on, grid on
plot(t,q(:,1),'b','LineWidth',1.5)
plot(t,u(:,1),'--k')
ylabel('$q_1$','FontName','times','FontSize',16,'interpreter','latex')
% xlabel('Time $[s]$','FontName','times','FontSize',16,'interpreter','latex')
l = legend('$q_1$','Step','Location','SouthEast');
set(l,'FontName','times','FontSize',12,'interpreter','latex')
axis([-0.5,2,0,0.4])

h2 = subplot(2,2,2); set(h2,'FontName','times','FontSize',16)
hold on, grid on
plot(t,q(:,2),'r','LineWidth',1.5)
plot(t,u(:,2),'--k')
ylabel('$q_2$','FontName','times','FontSize',16,'interpreter','latex')
xlabel('Time $[s]$','FontName','times','FontSize',16,'interpreter','latex')
l = legend('$q_2$','Step','Location','SouthEast');
set(l,'FontName','times','FontSize',12,'interpreter','latex')
axis([-0.5,2,0,0.4])

h3 = subplot(2,2,3); set(h3,'FontName','times','FontSize',16)
hold on, grid on
plot(t,q(:,3),'g','LineWidth',1.5)
plot(t,u(:,3),'--k')
ylabel('$q_3$','FontName','times','FontSize',16,'interpreter','latex')
% xlabel('Time $[s]$','FontName','times','FontSize',16,'interpreter','latex')
l = legend('$q_3$','Step','Location','SouthEast');
set(l,'FontName','times','FontSize',12,'interpreter','latex')
axis([-0.5,2,0,0.4])

h4 = subplot(2,2,4); set(h4,'FontName','times','FontSize',16)
hold on, grid on
plot(t,q(:,4),'c','LineWidth',1.5)
plot(t,u(:,4),'--k')
ylabel('$q_4$','FontName','times','FontSize',16,'interpreter','latex')
xlabel('Time $[s]$','FontName','times','FontSize',16,'interpreter','latex')
l = legend('$q_4$','Step','Location','SouthEast');
set(l,'FontName','times','FontSize',12,'interpreter','latex')
axis([-0.5,2,0,0.4])