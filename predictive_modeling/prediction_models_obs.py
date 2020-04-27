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


def plot_R_metrics(metrics, stat, title):
	R_vals = range(5, 41, 5)
	plt.clf()
	plt.title(metrics + title)
	plt.xlabel("R")
	plt.ylabel(metrics)
	color = ["g", "b", "r", "orange"]
	for i, comparator in enumerate(sorted(stat.keys())):
		plt.plot(R_vals, stat[comparator], 'o-', color=color[i], label=comparator)
	plt.legend(loc="best")
	plt.savefig("./result/metrics/obs/" + metrics + title + ".png", dpi=300)
	# plt.show()


def create_table_R_metrics(metrics, stat):
	print(metrics)
	print("     R       5      10      15      20      25      30      35      40")
	for comparator in sorted(stat.keys()):
		print("{:s}{:s}   {:.3f}   {:.3f}   {:.3f}   {:.3f}   {:.3f}   {:.3f}   {:.3f}   {:.3f}".format(' '*(6-len(str(comparator))), str(comparator), *stat[comparator]))


# read datasets
data_path = "./data/"
obs180_static_df = pd.read_csv(data_path + "obs180/static.csv", names = ["patient_id","sex","race_white","race_black","race_others","race_hispanic","esrd","sp_alzhdmta","sp_chf","sp_chrnkidn","sp_cncr","sp_copd","sp_depressn","sp_ischmcht","sp_osteoprs","sp_ra_oa","sp_strketia","leq68","leq74","leq82","geq82","is_case"])
obs180_dynamic_df = pd.read_csv(data_path + "obs180/dynamic.csv", names=["patient_id", "r", "code"])
obs360_static_df = pd.read_csv(data_path + "obs360/static.csv", names = ["patient_id","sex","race_white","race_black","race_others","race_hispanic","esrd","sp_alzhdmta","sp_chf","sp_chrnkidn","sp_cncr","sp_copd","sp_depressn","sp_ischmcht","sp_osteoprs","sp_ra_oa","sp_strketia","leq68","leq74","leq82","geq82","is_case"])
obs360_dynamic_df = pd.read_csv(data_path + "obs360/dynamic.csv", names=["patient_id", "r", "code"])
obs540_static_df = pd.read_csv(data_path + "obs540/static.csv", names = ["patient_id","sex","race_white","race_black","race_others","race_hispanic","esrd","sp_alzhdmta","sp_chf","sp_chrnkidn","sp_cncr","sp_copd","sp_depressn","sp_ischmcht","sp_osteoprs","sp_ra_oa","sp_strketia","leq68","leq74","leq82","geq82","is_case"])
obs540_dynamic_df = pd.read_csv(data_path + "obs540/dynamic.csv", names=["patient_id", "r", "code"])
obs720_static_df = pd.read_csv(data_path + "base/static.csv", names = ["patient_id","sex","race_white","race_black","race_others","race_hispanic","esrd","sp_alzhdmta","sp_chf","sp_chrnkidn","sp_cncr","sp_copd","sp_depressn","sp_ischmcht","sp_osteoprs","sp_ra_oa","sp_strketia","leq68","leq74","leq82","geq82","is_case"])
obs720_dynamic_df = pd.read_csv(data_path + "base/dynamic.csv", names=["patient_id", "r", "code"])

# split train/test on obs720
print("--- split train/test on obs720---")
rs = ShuffleSplit(n_splits=1, test_size=0.2, random_state=None)
train_idx, test_idx = list(rs.split(obs720_static_df))[0]
train_idx.sort()
test_idx.sort()
obs720_static_train, obs720_static_test = obs720_static_df.loc[train_idx], obs720_static_df.loc[test_idx]
train_patient_ids, test_patient_ids = obs720_static_train["patient_id"], obs720_static_test["patient_id"]
obs720_dynamic_train, obs720_dynamic_test = obs720_dynamic_df[obs720_dynamic_df["patient_id"].isin(train_patient_ids)], obs720_dynamic_df[obs720_dynamic_df["patient_id"].isin(test_patient_ids)]

# experiment on different observation window
obs_accuracy, obs_auc, obs_prauc = dict(), dict(), dict()
print("--- Observation Window Experiment ---")
obs_wins = {180:[obs180_static_df, obs180_dynamic_df], 360:[obs360_static_df, obs360_dynamic_df], 540:[obs540_static_df, obs540_dynamic_df], 720:[]}
for obs_win, dfs in obs_wins.items():
	print("=== Observation Window = " + str(obs_win) + " ===")

	# split train/test
	if obs_win == 720:
		static_train, static_test, dynamic_train, dynamic_test = obs720_static_train, obs720_static_test, obs720_dynamic_train, obs720_dynamic_test
	else:
		print("--- split train/test on obs" + str(obs_win) + " ---")
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
	np.savez_compressed("./mid_result/AX/obs/" + "AX_obs_" + str(obs_win) + ".npz", A_train_case=A_train_case, X_train_case=X_train_case, A_train_ctrl=A_train_ctrl, X_train_ctrl=X_train_ctrl, A_test_case=A_test_case, X_test_case=X_test_case, A_test_ctrl=A_test_ctrl, X_test_ctrl=X_test_ctrl)

	# vary R
	R_accuracy, R_auc, R_prauc = [], [], []
	R_vals = range(5, 41, 5)
	for R_val in R_vals:
		print("--- R = " + str(R_val) + " ---")

		# fit TASTE onto train case and extract phenotypes
		print("--- fit TASTE ---")
		try:
			_, _, _, _, _, _, _, rmse_time, _, _, H, V, W_train_case, F = fit(R_val, A_train_case, X_train_case)
			plot_rmse_time(rmse_time, "./result/rmse_time/obs/" + "rmse_time_obs_" + str(obs_win) + "_R_" + str(R_val) + "_train_case.png")
			# project existing phenotypes onto train ctrl, test case, test ctrl
			print("--- project phenotypes ---")
			_, _, _, _, _, _, _, rmse_time, _, _, _, _, W_train_ctrl, _ = project(R_val, A_train_ctrl, X_train_ctrl, V, F, H)
			plot_rmse_time(rmse_time, "./result/rmse_time/obs/" + "rmse_time_obs_" + str(obs_win) + "_R_" + str(R_val) + "_train_ctrl.png")
			_, _, _, _, _, _, _, rmse_time, _, _, _, _, W_test_case, _ = project(R_val, A_test_case, X_test_case, V, F, H)
			plot_rmse_time(rmse_time, "./result/rmse_time/obs/" + "rmse_time_obs_" + str(obs_win) + "_R_" + str(R_val) + "_test_case.png")
			_, _, _, _, _, _, _, rmse_time, _, _, _, _, W_test_ctrl, _ = project(R_val, A_test_ctrl, X_test_ctrl, V, F, H)
			plot_rmse_time(rmse_time, "./result/rmse_time/obs/" + "rmse_time_obs_" + str(obs_win) + "_R_" + str(R_val) + "_test_ctrl.png")

			# convert to new features X and labels Y
			print("--- convert to new features X and labels Y")
			X_train = np.concatenate((W_train_case, W_train_ctrl))
			Y_train = np.concatenate((np.ones((W_train_case.shape[0], 1)), np.zeros((W_train_ctrl.shape[0], 1))))
			X_test = np.concatenate((W_test_case, W_test_ctrl))
			Y_test = np.concatenate((np.ones((W_test_case.shape[0], 1)), np.zeros((W_test_ctrl.shape[0], 1))))
			pd.DataFrame(X_train).to_csv("./mid_result/new_features/obs/" + "X_train_obs_" + str(obs_win) + "_R_" + str(R_val) + ".csv")
			pd.DataFrame(Y_train).to_csv("./mid_result/new_features/obs/" + "Y_train_obs_" + str(obs_win) + "_R_" + str(R_val) + ".csv")
			pd.DataFrame(X_test).to_csv("./mid_result/new_features/obs/" + "X_test_obs_" + str(obs_win) + "_R_" + str(R_val) + ".csv")
			pd.DataFrame(Y_test).to_csv("./mid_result/new_features/obs/" + "Y_test_obs_" + str(obs_win) + "_R_" + str(R_val) + ".csv")

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

	obs_accuracy[obs_win] = R_accuracy
	obs_auc[obs_win] = R_auc
	obs_prauc[obs_win] = R_prauc

# plot R_metrics for observation window comparison
# accuracy
plot_R_metrics("Accuracy", obs_accuracy, "_obs_win")
# auc
plot_R_metrics("AUC", obs_auc, "_obs_win")
# prauc
plot_R_metrics("PRAUC", obs_prauc, "_obs_win")

# create table of metrics for R_obs
# accuracy
create_table_R_metrics("Accuracy", obs_accuracy)
# auc
create_table_R_metrics("AUC", obs_auc)
# prauc
create_table_R_metrics("PRAUC", obs_prauc)
