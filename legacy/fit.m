function [normX, normA, Size_input, TOTAL_running_TIME,rmse,FIT_Tensor,FIT_Matrix,RMSE_TIME_case,U,Q,H,V,W,F] = fit(R, A, X, lambda_, mu, conv_tol, PARFOR_FLAG, Constraints, seed)
    if nargin == 3
        lambda_ = 1;
        mu = 1;
        conv_tol = 1e-4;
        PARFOR_FLAG = 0;
        Constraints = ['nonnegative', 'nonnegative','nonnegative','nonnegative'];
        seed = 1;
    end
    [normX, normA, Size_input] = claculate_norm(X,A,size(A, 1),PARFOR_FLAG);
    [TOTAL_running_TIME,rmse,FIT_Tensor,FIT_Matrix,RMSE_TIME_case,U,Q,H,V,W,F] = TASTE_BPP(X,A,R,conv_tol,seed,PARFOR_FLAG,normX,normA,Size_input,Constraints,mu,lambda_);
    my_plot(RMSE_TIME_case, num2str(R))
end

