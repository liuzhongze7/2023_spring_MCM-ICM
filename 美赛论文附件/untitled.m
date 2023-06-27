% 导入数据集
opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:H3492";
opts.VariableNames = ["Make", "Variant", "Lengthft", "GeographicRegion", "CountryRegionState", "ListingPriceUSD", "Year", "VarName8"];
opts.VariableTypes = ["categorical", "categorical", "double", "categorical", "categorical", "double", "double", "categorical"];

data = readtable("C:\Users\Administrator\Desktop\美赛\数据合并.xlsx", opts);

% 将类别数据转换为数值类型
X = data(:,1:end-1);
X.Make = categorical(X.Make);
X.Variant = categorical(X.Variant);
X.Lengthft = categorical(X.Lengthft);
X.GeographicRegion = categorical(X.GeographicRegion);
X.CountryRegionState = categorical(X.CountryRegionState);
X.Make = grp2idx(X.Make);
X.Variant = grp2idx(X.Variant);
X.Lengthft = grp2idx(X.Lengthft);
X.GeographicRegion = grp2idx(X.GeographicRegion);
X.CountryRegionState = grp2idx(X.CountryRegionState);

y = data.ListingPriceUSD;

% 划分训练集和测试集
[trainInd, testInd] = dividerand(height(X), 0.8, 0.2);
X_train = X(trainInd, :);
X_test = X(testInd, :);
y_train = data.ListingPriceUSD(trainInd, :);
y_test = data.ListingPriceUSD(testInd, :);

% 创建 LightGBM 模型
params = struct();
params.boostingType = 'gbdt';
params.numLeaves = 50;
params.maxDepth = -1;
params.minDataInLeaf = 20;
params.learningRate = 0.1;
params.featureFraction = 1.0;
params.extraTrees = false;
params.numIterations = 100;
params.earlyStopping = 20;
params.objective = 'regression';
params.categoricalFeatures = [1 2 3 4 5];
model = fitLightGBM(X_train, y_train, 'param', params);

% 预测测试集数据
y_pred = predict(model, X_test);

% 计算特征重要性
importance = featureImportance(model);

% 可视化各特征重要性
bar(importance);
xlabel('特征');
ylabel('重要性');
xticklabels(X_train.Properties.VariableNames);
title('各特征对价格的影响');

% 对模型进行仿真处理
simin = [X_test, y_test];
simout = predict(model, X_test);

% 可视化模型输出与实际输出的对比
figure;
plot(y_test); hold on;
plot(simout);
xlabel('样本序号');
ylabel('房价');
title('模型输出与实际输出对比');
legend('实际输出', '模型输出');