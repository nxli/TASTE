import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.model_selection import ShuffleSplit
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, roc_auc_score, average_precision_score

from TASTE.taste import A_join_X, fit, project, plot_rmse_time


def split_train_test(static_df, dynamic_df, base_train_patient_ids, base_test_patient_ids):
	static_train, static_test = static_df[static_df["patient_id"].isin(base_train_patient_ids)], static_df[static_df["patient_id"].isin(base_test_patient_ids)]
	dynamic_train, dynamic_test = dynamic_df[dynamic_df["patient_id"].isin(base_train_patient_ids)], dynamic_df[dynamic_df["patient_id"].isin(base_test_patient_ids)]
	return static_train, static_test, dynamic_train, dynamic_test


def plot_R_metrics(metrics, stat):
	R_vals = range(5, 41, 5)
	for comparator, R_metrics in stat.items():
		if comparator != "base":
			plt.clf()
			plt.title(metrics + "_" + comparator)
			plt.xlabel("R")
			plt.ylabel(metrics)
			plt.plot(R_vals, stat["base"], 'o-', color="b", label="base")
			plt.plot(R_vals, R_metrics, 'o-', color="r", label=comparator)
			plt.legend(loc="best")
			plt.savefig("./result/metrics/feature_manipulation/" + metrics + "_" + comparator + ".png", dpi=300)
			# plt.show()


def create_table_R_metrics(metrics, stat):
	print(metrics)
	print("        R       5      10      15      20      25      30      35      40")
	print("{:s}{:s}   {:.3f}   {:.3f}   {:.3f}   {:.3f}   {:.3f}   {:.3f}   {:.3f}   {:.3f}".format(' '*6, "base", *stat["base"]))
	for comparator in stat.keys():
		if comparator != "base":
			print("{:s}{:s}   {:.3f}   {:.3f}   {:.3f}   {:.3f}   {:.3f}   {:.3f}   {:.3f}   {:.3f}".format(' '*(10-len(str(comparator))), str(comparator), *stat[comparator]))


# read datasets
data_path = "./data/"
# base: all dummies, by date, 720 days observation window, with static features, full sample
base_static_df = pd.read_csv(data_path + "base/static.csv", names = ["patient_id","sex","race_white","race_black","race_others","race_hispanic","esrd","sp_alzhdmta","sp_chf","sp_chrnkidn","sp_cncr","sp_copd","sp_depressn","sp_ischmcht","sp_osteoprs","sp_ra_oa","sp_strketia","leq68","leq74","leq82","geq82","is_case"])
base_dynamic_df = pd.read_csv(data_path + "base/dynamic.csv", names=["patient_id", "r", "code"])
# without static
xstatic_static_df = base_static_df[["patient_id","is_case"]].copy()
xstatic_static_df["one"] = 1
xstatic_dynamic_df = base_dynamic_df
# typical N categorical to (N-1) dummy variable transformation
dummy_static_df = base_static_df.drop(["race_others", "geq82"], axis=1)
dummy_dynamic_df = base_dynamic_df
# by week
week_static_df = pd.read_csv(data_path + "week/static.csv", names = ["patient_id","sex","race_white","race_black","race_others","race_hispanic","esrd","sp_alzhdmta","sp_chf","sp_chrnkidn","sp_cncr","sp_copd","sp_depressn","sp_ischmcht","sp_osteoprs","sp_ra_oa","sp_strketia","leq68","leq74","leq82","geq82","is_case"])
week_dynamic_df = pd.read_csv(data_path + "week/dynamic.csv", names=["patient_id", "r", "code"])

# split train/test on base
print("--- split train/test on base---")
rs = ShuffleSplit(n_splits=1, test_size=0.2, random_state=None)
train_idx, test_idx = list(rs.split(base_static_df))[0]
train_idx.sort()
test_idx.sort()
base_static_train, base_static_test = base_static_df.loc[train_idx], base_static_df.loc[test_idx]
train_patient_ids, test_patient_ids = base_static_train["patient_id"], base_static_test["patient_id"]
base_dynamic_train, base_dynamic_test = base_dynamic_df[base_dynamic_df["patient_id"].isin(train_patient_ids)], base_dynamic_df[base_dynamic_df["patient_id"].isin(test_patient_ids)]

# experiment on xstatic, dummy, and by week
accuracy_dict, auc_dict, prauc_dict = dict(), dict(), dict()
print("--- Experiments on Feature Manipulation ---")
experiments = {"xstatic":[xstatic_static_df, xstatic_dynamic_df], "dummy":[dummy_static_df, dummy_dynamic_df], "week":[week_static_df, week_dynamic_df], "base":[]}
for experiment, dfs in experiments.items():
	print("=== Experiment = " + str(experiment) + " ===")

	# split train/test
	if experiment == "base":
		static_train, static_test, dynamic_train, dynamic_test = base_static_train, base_static_test, base_dynamic_train, base_dynamic_test
	else:
		print("--- split train/test on " + str(experiment) + " ---")
		static_df, dynamic_df = dfs
		static_train, static_test, dynamic_train, dynamic_test = split_train_test(static_df, dynamic_df, train_patient_ids, test_patient_ids)
		
	# convert static/dynamic to A/X
	print("--- convert static/dynamic to A/X ---")
	train_case = static_train[static_train["is_case"] == 1]
	train_ctrl = static_train[static_train["is_case"] == 0]
	test_case = static_test[static_test["is_case"] == 1]
	test_ctrl = static_test[static_test["is_case"] == 0]
	print("--- train_case ---")
	A_train_case, X_train_case = A_join_X(train_case, dynamic_train)
	print("--- train_ctrl ---")
	A_train_ctrl, X_train_ctrl = A_join_X(train_ctrl, dynamic_train)
	print("--- test_case ---")
	A_test_case, X_test_case = A_join_X(test_case, dynamic_test)
	print("--- test_ctrl ---")
	A_test_ctrl, X_test_ctrl = A_join_X(test_ctrl, dynamic_test)
	np.savez_compressed("./mid_result/AX/feature_manipulation/" + "AX_feature_" + str(experiment) + ".npz", A_train_case=A_train_case, X_train_case=X_train_case, A_train_ctrl=A_train_ctrl, X_train_ctrl=X_train_ctrl, A_test_case=A_test_case, X_test_case=X_test_case, A_test_ctrl=A_test_ctrl, X_test_ctrl=X_test_ctrl)

	# vary R
	R_accuracy, R_auc, R_prauc = [], [], []
	R_vals = range(5, 41, 5)
	for R_val in R_vals:
		print("--- R = " + str(R_val) + " ---")

		# fit TASTE onto train case and extract phenotypes
		print("--- fit TASTE ---")
		try:
			_, _, _, _, _, _, _, rmse_time, _, _, H, V, W_train_case, F = fit(R_val, A_train_case, X_train_case)
			plot_rmse_time(rmse_time, "./result/rmse_time/feature_manipulation/" + "rmse_time_" + str(experiment) + "_R_" + str(R_val) + "_train_case.png")
			# project existing phenotypes onto train ctrl, test case, test ctrl
			print("--- project phenotypes ---")
			_, _, _, _, _, _, _, rmse_time, _, _, _, _, W_train_ctrl, _ = project(R_val, A_train_ctrl, X_train_ctrl, V, F, H)
			plot_rmse_time(rmse_time, "./result/rmse_time/feature_manipulation/" + "rmse_time_" + str(experiment) + "_R_" + str(R_val) + "_train_ctrl.png")
			_, _, _, _, _, _, _, rmse_time, _, _, _, _, W_test_case, _ = project(R_val, A_test_case, X_test_case, V, F, H)
			plot_rmse_time(rmse_time, "./result/rmse_time/feature_manipulation/" + "rmse_time_" + str(experiment) + "_R_" + str(R_val) + "_test_case.png")
			_, _, _, _, _, _, _, rmse_time, _, _, _, _, W_test_ctrl, _ = project(R_val, A_test_ctrl, X_test_ctrl, V, F, H)
			plot_rmse_time(rmse_time, "./result/rmse_time/feature_manipulation/" + "rmse_time_" + str(experiment) + "_R_" + str(R_val) + "_test_ctrl.png")

			# convert to new features X and labels Y
			print("--- convert to new features X and labels Y")
			X_train = np.concatenate((W_train_case, W_train_ctrl))
			Y_train = np.concatenate((np.ones((W_train_case.shape[0], 1)), np.zeros((W_train_ctrl.shape[0], 1))))
			X_test = np.concatenate((W_test_case, W_test_ctrl))
			Y_test = np.concatenate((np.ones((W_test_case.shape[0], 1)), np.zeros((W_test_ctrl.shape[0], 1))))
			pd.DataFrame(X_train).to_csv("./mid_result/new_features/feature_manipulation/" + "X_train_feature_" + str(experiment) + "_R_" + str(R_val) + ".csv")
			pd.DataFrame(Y_train).to_csv("./mid_result/new_features/feature_manipulation/" + "Y_train_feature_" + str(experiment) + "_R_" + str(R_val) + ".csv")
			pd.DataFrame(X_test).to_csv("./mid_result/new_features/feature_manipulation/" + "X_test_feature_" + str(experiment) + "_R_" + str(R_val) + ".csv")
			pd.DataFrame(Y_test).to_csv("./mid_result/new_features/feature_manipulation/" + "Y_test_feature_" + str(experiment) + "_R_" + str(R_val) + ".csv")

			# train logistic regression model on W_train
			print("--- fit and predict with logistic regression ---")
			lr = LogisticRegression(class_weight="balanced")
			lr.fit(X_train, Y_train.ravel())
			Y_pred = lr.predict(X_test)
			Y_pred_prob = lr.predict_proba(X_test)[:,1]

			# compute metrics
			accuracy = accuracy_score(Y_test, Y_pred)
			auc = roc_auc_score(Y_test, Y_pred_prob)
			prauc = average_precision_score(Y_test, Y_pred_prob)
			print("Accuracy: " + str(accuracy))
			print("AUC: " + str(auc))
			print("PRAUC: " + str(prauc))

		except np.linalg.LinAlgError:
			print("LinAlgError: Singular matrix")
			accuracy = 0
			auc = 0
			prauc = 0
		except np.linalg.linalg.LinAlgError:
			print("LinAlgError: Singular matrix")
			accuracy = 0
			auc = 0
			prauc = 0

		# append metrics for each R
		R_accuracy.append(accuracy)
		R_auc.append(auc)
		R_prauc.append(prauc)

	accuracy_dict[experiment] = R_accuracy
	auc_dict[experiment] = R_auc
	prauc_dict[experiment] = R_prauc

# plot R_metrics for observation window comparison
# accuracy
plot_R_metrics("Accuracy", accuracy_dict)
# auc
plot_R_metrics("AUC", auc_dict)
# prauc
plot_R_metrics("PRAUC", prauc_dict)

# create table of metrics for R_size
# accuracy
create_table_R_metrics("Accuracy", accuracy_dict)
# auc
create_table_R_metrics("AUC", auc_dict)
# prauc
create_table_R_metrics("PRAUC", prauc_dict)
