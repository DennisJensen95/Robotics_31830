clear
clc
close all
%% Init

Q = [-0.3430   -0.1862    1.5127   -1.7570
    0.2783   -0.1526    1.8414   -1.7234
   -0.2337   -0.1290    2.1768   -1.6998
    0.2013   -0.1115    2.5161   -1.6823
   -0.1767   -0.0981    2.8580   -1.6689];

% path
px = [0, 0.35, 0.7, 1.05, 1.4] + 1.4;
py = [-0.5, 0.5, -0.5, 0.5, -0.5];

%% Trajectories

format short

%% Segment 1
syms a15 a14 a13 a12 a11 a10...
     a25 a24 a23 a22 a21 a20...
     a35 a34 a33 a32 a31 a30...
     a45 a44 a43 a42 a41 a40...
     a55 a54 a53 a52 a51 a50...
     a65 a64 a63 a62 a61 a60...
     a75 a74 a73 a72 a71 a70...
     a85 a84 a83 a82 a81 a80;

A1 = [a15 a14 a13 a12 a11 a10;
      a25 a24 a23 a22 a21 a20];

A2 = [a35 a34 a33 a32 a31 a30;
      a45 a44 a43 a42 a41 a40];

A3 = [a55 a54 a53 a52 a51 a50;
      a65 a64 a63 a62 a61 a60];

A4 = [a75 a74 a73 a72 a71 a70;
      a85 a84 a83 a82 a81 a80];

coef_1 = solve_xy_trajectory_segment(0, 2, A1, px(1:2), py(1:2))
coef_2 = solve_xy_trajectory_segment(0, 2, A2, px(2:3), py(2:3))
coef_3 = solve_xy_trajectory_segment(0, 2, A3, px(3:4), py(3:4))
coef_4 = solve_xy_trajectory_segment(0, 2, A4, px(4:5), py(4:5))

%% SUPPORT FUNCTIONS
function coef = solve_xy_trajectory_segment(t_start, t_end, A, Px, Py)
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
    segment1 = [Px(1) == F1_start(1), Py(1) == F1_start(2), ...
        Px(2) == F1_end(1), Py(2) == F1_end(2), ...
        dF1_start(1) == 0, dF1_start(2) == 0, ...
        dF1_end(1) == 0, dF1_end(2) == 0, ...
        ddF1_start(1) == 0, ddF1_start(2) == 0, ...
        ddF1_end(1) == 0, ddF1_end(2) == 0];

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
