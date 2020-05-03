function [normX, normA, Size_input, TOTAL_running_TIME,RMSE,FIT_T,FIT_M,RMSE_TIME_ctrl,U,Q,H,V,W,F] = project(R, A, X, V, F, H, lambda_, mu, conv_tol,PARFOR_FLAG,Constraints, seed)
    if nargin == 6
        lambda_ = 1;
        mu = 1;
        conv_tol = 1e-4;
        PARFOR_FLAG = 0;
        Constraints = ['nonnegative', 'nonnegative','nonnegative','nonnegative'];
        seed = 1;
    end
    [normX, normA, Size_input] = claculate_norm(X,A,size(A, 1),PARFOR_FLAG);
    [TOTAL_running_TIME,RMSE,FIT_T,FIT_M,RMSE_TIME_ctrl,U,Q,H,V,W,F] = PARACoupl2_BPP( X,A,V,F,H,R,conv_tol,seed,PARFOR_FLAG,normX,normA,Size_input,Constraints,mu,lambda_ );
    my_plot(RMSE_TIME_ctrl, strcat(num2str(R), "_projection"));
end

