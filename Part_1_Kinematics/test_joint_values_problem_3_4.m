clear
clc
close all
%% Problem 3 - Joint coordinates for each knot-point

% Transformation matrix
T_task_0 = [1,0,0,1.4;0,1,0,0;0,0,1,0.2;0,0,0,1];

% Matrix elements of path in task frame
r11_t=zeros(1,5);
r21_t=zeros(1,5);
r31_t=-ones(1,5);
r14_t=[0, 0.35, 0.7, 1.05, 1.4];
r24_t=[-0.5, 0.5, -0.5, 0.5, -0.5];
r34_t=zeros(1,5);

% Matrix elements in base frame
r11 = r11_t;
r21 = r21_t;
r31 = r31_t;
r14 = r14_t + T_task_0(1,4);
r24 = r24_t;
r34 = 0.2*ones(1,5);


% CONSTANTS
a4 = 1.02;
d1 = 1.5;

%%

Q = [];

for i = 1:5
    q1 = atan2(r24(i)-a4*r21(i), r14(i)-a4*r11(i));
    q2 = atan2(r34(i)-a4*r31(i)-d1, sqrt((r24(i)-a4*r21(i))^2 + (r14(i)-a4*r11(i))^2));
    q3 = sqrt((r24(i)-a4*r21(i))^2 + (r14(i)-a4*r11(i))^2 + (r34(i)-a4*r31(i)-d1)^2);
    q4 = atan2(r31(i), sqrt(r11(i)^2 + r21(i)^2)) + q2;

    Q = [Q; q1, q2, q3, q4];
    
    fprintf('q = [%.2f deg, %.2f deg, %.2f m, %.2f deg]\n', rad2deg(q1), rad2deg(q2), q3, rad2deg(q4));
end

Q

%% Problem 4 - Trajectories

format short

%% Segment 1
syms a15 a14 a13 a12 a11 a10...
     a25 a24 a23 a22 a21 a20...
     a35 a34 a33 a32 a31 a30...
     a45 a44 a43 a42 a41 a40...
     a55 a54 a53 a52 a51 a50...
     a65 a64 a63 a62 a61 a60...
     a75 a74 a73 a72 a71 a70...
     a85 a84 a83 a82 a81 a80...
     a95 a94 a93 a92 a91 a90...
     a105 a104 a103 a102 a101 a100...
     a115 a114 a113 a112 a111 a110...
     a125 a124 a123 a122 a121 a120...
     a135 a134 a133 a132 a131 a130...
     a145 a144 a143 a142 a141 a140...
     a155 a154 a153 a152 a151 a150...
     a165 a164 a163 a162 a161 a160;

A1 = [a15 a14 a13 a12 a11 a10;
     a25 a24 a23 a22 a21 a20;
     a35 a34 a33 a32 a31 a30;
     a45 a44 a43 a42 a41 a40];
A2 = [a55 a54 a53 a52 a51 a50;
     a65 a64 a63 a62 a61 a60;
     a75 a74 a73 a72 a71 a70;
     a85 a84 a83 a82 a81 a80];
A3 = [a95 a94 a93 a92 a91 a90;
     a105 a104 a103 a102 a101 a100;
     a115 a114 a113 a112 a111 a110;
     a125 a124 a123 a122 a121 a120];
A4 = [a135 a134 a133 a132 a131 a130;
     a145 a144 a143 a142 a141 a140;
     a155 a154 a153 a152 a151 a150;
     a165 a164 a163 a162 a161 a160];


coef_1 = solve_trajectory_segment(0, 2, A1, Q(1,:), Q(2,:))
coef_2 = solve_trajectory_segment(0, 2, A2, Q(2,:), Q(3,:))
coef_3 = solve_trajectory_segment(0, 2, A3, Q(3,:), Q(4,:))
coef_4 = solve_trajectory_segment(0, 2, A4, Q(4,:), Q(5,:))

%% SUPPORT FUNCTIONS
function coef = solve_trajectory_segment(t_start, t_end, A, Q1, Q2)
    % Time vectors
    t = t_start;
    T_start = [t^5, t^4, t^3, t^2, t, 1].';
    dT_start = [5*t^4, 4*t^3, 3*t^2, 2*t, 1, 0].';
    ddT_start = [20*t^3, 12*t^2, 6*t, 2, 0, 0].';

    t = t_end;
    T_end = [t^5, t^4, t^3, t^2, t, 1].';
    dT_end = [5*t^4, 4*t^3, 3*t^2, 2*t, 1, 0].';
    ddT_end = [20*t^3, 12*t^2, 6*t, 2, 0, 0].';

    % Trajectory functions
    F1_start = A*T_start;
    dF1_start = A*dT_start;
    ddF1_start = A*ddT_start;

    F1_end = A*T_end;
    dF1_end = A*dT_end;
    ddF1_end = A*ddT_end;

    % equations
    segment1 = [Q1(1) == F1_start(1), Q1(2) == F1_start(2), Q1(3) == ...
        F1_start(3), Q1(4) == F1_start(4), ...
        Q2(1) == F1_end(1), Q2(2) == F1_end(2), Q2(3) == F1_end(3), Q2(4) == F1_end(4),...
        dF1_start(1) == 0, dF1_start(2) == 0, dF1_start(3) == 0, dF1_start(4) == 0, ...
        dF1_end(1) == 0, dF1_end(2) == 0, dF1_end(3) == 0, dF1_end(4) == 0, ...
        ddF1_start(1) == 0, ddF1_start(2) == 0, ddF1_start(3) == 0, ddF1_start(4) == 0, ...
        ddF1_end(1) == 0, ddF1_end(2) == 0, ddF1_end(3) == 0, ddF1_end(4) == 0];

    % solve numerically
    S = vpasolve(segment1, reshape(A,[1, numel(A)]));

    % extract coeffiecients
    coef = extract_coefficients(S, size(A));

end


function A = extract_coefficients(S, dim)
    
    A = zeros(dim(1),dim(2));
    
    S = struct2cell(S);
    
    k = 0;
    for j = 1:dim(2)
        for i = 1:dim(1)
            k = k + 1;
            A(i,j) = S{k};
        end
    end
    
end
