%clc;
clearvars;
close all;

addpath(genpath('./TASTE_Framework'));
addpath(genpath('./nonnegfac-matlab-master')); % this package is from https://www.cc.gatech.edu/~hpark/nmfsoftware.php

% Case need to be fit before projection!!

use_saved_np = true;

if use_saved_np
    load("AX.mat", 'X_case', 'X_ctrl', 'A_case', 'A_ctrl');
else
    A_df = readtable("../data/static.csv", 'HeaderLines',0);
    sele = A_df{:, end};
    sele = sele(:, :);
    A_case = A_df(sele==1, :);
    A_ctrl = A_df(sele==0, :);

    X_df = readtable("../data/dynamic.csv", 'HeaderLines',0);

    [A_case, X_case] = A_join_X(A_case, X_df);
    [A_ctrl, X_ctrl] = A_join_X(A_ctrl, X_df);
    save('AX.mat','X_case','A_case', 'X_ctrl', 'A_ctrl');
end

R = 5;

A_case = A_case{:, :};
A_ctrl = A_ctrl{:, :};

[normX, normA, Size_input, TOTAL_running_TIME,rmse,FIT_Tensor,FIT_Matrix,RMSE_TIME_case,U_case,Q_case,H,V,W_case,F] = fit(R, A_case, X_case);

[normX, normA, Size_input, TOTAL_running_TIME,RMSE,FIT_T,FIT_M,RMSE_TIME_ctrl,U,Q,H,V,W,F] = project(R, A_ctrl, X_ctrl, V, F, H);
