clear
clc
close all
%% Rotation matrix

P0 = [-92.50; -311.51; 1009.27]./1000;
Px = [-332.21; -291.52; 1006.69]./1000;
Py = [-84.44; -164.67; 1010.34]./1000;

R = task_base_transformation(P0, Px, Py);

% check
Ptask = [0.1; 0.15; 0.01];

Pbase = (R*Ptask + P0)*1000

%% 