clear
clc
close all
%% CONSTANTS

STEP_SIZE = 0.1;
SIM_TIME = 10;

J_M_i = 1320*10^(-7);
f_M_i = 2.4*10^(-5);
n_i = 53;
k_T_i = 0.17;

%%

t = 0:STEP_SIZE:(SIM_TIME);
n = length(t);

tau_i = [t', ones(n,1)*0];
q_ref = [t', ones(n,1)*1];

%% Simulation

simout = sim("Problem8_model");

%% Figure

q = simout.logsout{1}.Values.Data *180/pi;

figure(1)
plot(t,q,'r','LineWidth',2)
grid on
xlabel('Time [sec]')
ylabel('q [deg]')