clear
clc
close all
%% Constants

J = 2;
Km = 10;
Ra = 1;
La = 1;
b = 0.5;
Kb = 0.1;

%% Transfer function

G = tf(Km,[J*La, J*Ra + La*b, Kb*Km + Ra*b, 0]);