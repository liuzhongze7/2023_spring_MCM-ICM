import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
import xgboost as xgb
from scipy.stats import norm
import matplotlib.pyplot as plt

# 导入数据集
data = pd.read_excel('城市增加吞吐量修改Make改GeographicRegion改Variant改Country.xls')
data.drop('Displacement', axis=1, inplace=True)



# 将类别数据转换为数值类型
cat_cols = ['Make', 'Variant', 'Length', 'GeographicRegion', 'Country_Region_State']
for col in cat_cols:
    data[col] = pd.factorize(data[col])[0]

X = data.drop('ListingPrice', axis=1)
y = data.loc[:,'ListingPrice']

# 划分训练集和测试集
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 创建 XGBoost 模型
params = {'max_depth': 10,
          'learning_rate': 0.1,
          'objective': 'reg:squarederror',
          'eval_metric': 'rmse'}
model = xgb.train(params=params,
                  dtrain=xgb.DMatrix(X_train, y_train),
                  num_boost_round=100,
                  early_stopping_rounds=20,
                  evals=[(xgb.DMatrix(X_test, y_test), 'test')])

# 预测测试集数据
y_pred = model.predict(xgb.DMatrix(X_test))

# 对模型输出结果进行仿真处理
n_simulations = 1000
y_simulations = np.zeros((n_simulations, len(y_pred)))
for i in range(n_simulations):
    y_simulations[i] = y_pred + norm.rvs(loc=0, scale=50, size=y_pred.shape[0])
import matplotlib
matplotlib.use('TkAgg')  # 假设您想要使用 "TkAgg" 后端
# 绘制仿真处理后的模型输出结果与实际输出结果的对比
simin = pd.concat([X_test, y_test], axis=1)
simin.columns = X.columns.tolist() + ['Price']
plt.plot(simin.Price[:100], label='Actual')
for i in range(10):
    plt.plot(y_simulations[i][:100], label='Simulated %d' % (i+1), linestyle='--')
plt.xlabel('Sample')
plt.ylabel('Price')
plt.title('Comparison of actual and simulated prices')
plt.legend()
plt.show()