import numpy as np
import numpy.matlib
from matplotlib import pyplot as plt
import pandas as pd
from scipy.sparse import csr_matrix
# this package is from https://www.cc.gatech.edu/~hpark/nmfsoftware.php
import importlib
import sys

if "." not in sys.path:
    sys.path.append(".")

import taste_frame
import nonnegfac

# importlib.reload(taste_frame)
# importlib.reload(nonnegfac)

def A_join_X(A, X_df):
    X_height = X_df.shape[0]
    K = A.shape[0]
    X = []
    j = 0
    for i in range(K):
        while j < X_height and A.iloc[i, 0] != X_df.iloc[j, 0]:
            j += 1
        start = j
        while j < X_height and A.iloc[i, 0] == X_df.iloc[j, 0]:
            j += 1
        temp = X_df.iloc[start : j, 1:]
        X.append(csr_matrix(([1 for _ in range(temp.shape[0])], ((temp["r"]-1), (temp["code"]-1))), shape = (temp["r"].iloc[-1], max(X_df["code"]))))
    A = A.iloc[:, 1:-1].to_numpy() # A_case = np.ones(12494, 1)
    return A, X

def my_plot(RMSE_TIME, name):
    fig = plt.figure()
    plt.plot([tup[0] for tup in RMSE_TIME], [tup[1] for tup in RMSE_TIME])
    plt.xlabel("Time")
    plt.ylabel("RMSE")
    plt.savefig(name)

def fit(R, A, X, lambda_ = 1, mu = 1, conv_tol = 1e-4, PARFOR_FLAG = 0, Constraints = ['nonnegative', 'nonnegative','nonnegative','nonnegative'], seed = 1):
    normX, normA, Size_input = taste_frame.claculate_norm(X,A,A.shape[0],PARFOR_FLAG) #Calculate the norm of the input X
    TOTAL_running_TIME,rmse,FIT_Tensor,FIT_Matrix,RMSE_TIME_case,U,Q,H,V,W,F = taste_frame.TASTE_BPP(X,A,R,conv_tol,seed,PARFOR_FLAG,normX,normA,Size_input,Constraints,mu,lambda_)
    my_plot(RMSE_TIME_case, str(R) + ".png")
    return normX, normA, Size_input, TOTAL_running_TIME,rmse,FIT_Tensor,FIT_Matrix,RMSE_TIME_case,U,Q,H,V,W,F

def project(R, A, X,V,F,H,lambda_ = 1, mu = 1, conv_tol = 1e-4,PARFOR_FLAG = 0,Constraints = ['nonnegative', 'nonnegative','nonnegative','nonnegative'], seed = 1):
    normX, normA, Size_input = taste_frame.claculate_norm(X,A,A.shape[0],PARFOR_FLAG) #Calculate the norm of the input X
    TOTAL_running_TIME,RMSE,FIT_T,FIT_M,RMSE_TIME_ctrl,U,Q,H,V,W,F = taste_frame.PARACoupl2_BPP( X,A,V,F,H,R,conv_tol,seed,PARFOR_FLAG,normX,normA,Size_input,Constraints,mu,lambda_ )
    my_plot(RMSE_TIME_ctrl, str(R) + "_projection.png")

    return normX, normA, Size_input, TOTAL_running_TIME,RMSE,FIT_T,FIT_M,RMSE_TIME_ctrl,U,Q,H,V,W,F

if __name__ == '__main__':
    use_saved_np = False
    if use_saved_np:
        with np.load('AX.npz', allow_pickle = True) as data:
            X_case = data['X_case']
            X_ctrl = data['X_ctrl']
            A_case = data['A_case']
            A_ctrl = data['A_ctrl']
    else:
        A_df = pd.read_csv("data/static.csv", header = None, names = ["patient_id", "r", "code"])
        A_case = A_df[A_df["is_case"] == 1]
        A_ctrl = A_df[A_df["is_case"] == 0]

        X_df = pd.read_csv("data/dynamic.csv", header = None, names = ["patient_id","sex","race_white","race_black","race_others","race_hispanic","esrd","sp_alzhdmta","sp_chf","sp_chrnkidn","sp_cncr","sp_copd","sp_depressn","sp_ischmcht","sp_osteoprs","sp_ra_oa","sp_strketia","leq68","leq74","leq82","geq82","is_case"])

        A_case, X_case = A_join_X(A_case, X_df)
        A_ctrl, X_ctrl = A_join_X(A_ctrl, X_df)
        np.savez_compressed("AX.npz", X_case = X_case, A_case = A_case, X_ctrl = X_ctrl, A_ctrl = A_ctrl)

    R = 5

    normX, normA, Size_input, TOTAL_running_TIME,rmse,FIT_Tensor,FIT_Matrix,RMSE_TIME_case,U_case,Q_case,H,V,W_case,F = fit(R, A_case, X_case)

    normX, normA, Size_input, TOTAL_running_TIME,RMSE,FIT_T,FIT_M,RMSE_TIME_ctrl,U,Q,H,V,W,F = project(R, A_ctrl, X_ctrl, V, F, H)