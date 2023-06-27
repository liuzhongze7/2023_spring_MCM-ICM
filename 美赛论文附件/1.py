import matplotlib
import pandas as pd
import numpy as np

from sklearn.linear_model import Ridge
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error

df = pd.read_excel("2023_MCM_Problem_Y_Boats(1).xlsx")

# 处理缺失值
df.fillna(0, inplace=True)

# 转换数据类型
df["Length (ft)"] = df["Length (ft)"].astype(int)
df["ListingPrice(USD)"] = df["ListingPrice(USD)"].astype(float)

# 特征工程
df = pd.get_dummies(df, columns=["Make", "Variant", "Geographic Region", "Country/Region/State "])

# 划分训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(df.drop("ListingPrice(USD)", axis=1), df["ListingPrice(USD)"], test_size=0.15, random_state=42)
# 特征缩放
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)
# X_test_scaled = np.delete(X_test_scaled,543,axis=0)

# 模型选择和参数估计
alphas = np.logspace(-5, 2, 100)
ridge = Ridge()
params = {"alpha": alphas}
model = GridSearchCV(ridge, params, cv=5)
model.fit(X_train_scaled, y_train)

# 模型评估
y_pred = model.predict(X_test_scaled)
mse = mean_squared_error(y_test, y_pred)


import statsmodels.api as sm
import matplotlib.rcsetup as rcsetup
import tkinter 
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt

# 系数估计
model_sm = sm.OLS(y_train, sm.add_constant(X_train_scaled)).fit()

# 假设检验
print(model_sm.summary())

# 预测区间
print(X_test_scaled.shape)
arr = []
for i in range(352):
     arr.append(1.8548673734513337)
X_test_scaled = np.column_stack((X_test_scaled,np.array(arr)))
predictions = model_sm.get_prediction(sm.add_constant(X_test_scaled))
conf_int = predictions.conf_int()

# 可视化
plt.scatter(y_test, y_pred,edgecolors='black')
plt.plot([min(y_test), max(y_test)], [min(y_test), max(y_test)], "k--", lw=2)
plt.xlabel("True Values")
plt.ylabel("Predictions")
plt.show()