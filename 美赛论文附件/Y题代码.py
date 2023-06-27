# 导入相关库
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

# 读取数据
df = pd.read_excel('2023_MCM_Problem_Y_Boats.xlsx', sheet_name='Monohull')
# 数据清洗
df.dropna(inplace=True)
df = df[df['Listing Price']>0]
# 特征提取
X = df[['Length (ft)', 'Year', 'Country/Region/State']]
X = pd.get_dummies(X)
y = df['Listing Price']
# 划分训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
# 模型训练
model = LinearRegression()
model.fit(X_train, y_train)
# 模型评估
y_pred = model.predict(X_test)
mse = mean_squared_error(y_test, y_pred)
rmse = np.sqrt(mse)
r2 = model.score(X_test, y_test)

# 输出模型评估结果
print('MSE:', mse)
print('RMSE:', rmse)
print('R2 score:', r2)
