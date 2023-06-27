% 导入数据
opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:H3492";
opts.VariableNames = ["Make", "Variant", "Lengthft", "GeographicRegion", "CountryRegionState", "ListingPriceUSD", "Year", "VarName8"];
opts.VariableTypes = ["categorical", "categorical", "double", "categorical", "categorical", "double", "double", "categorical"];
data = readtable("C:\Users\Administrator\Desktop\美赛\数据合并.xlsx", opts);

% 分离训练集和验证集
cvp = cvpartition(size(data, 1), 'Holdout', 0.2);
dataTrain = data(cvp.training,:);
dataVal = data(cvp.test,:);

% 可视化探索价格的分布情况

% 将价格进行对数变换
data.ListingPriceUSD_log = log(data.ListingPriceUSD);

% 绘制原始价格数据的直方图和核密度估计图
subplot(2, 1, 1);
histogram(data.ListingPriceUSD);
title('Histogram of ListingPriceUSD');
subplot(2, 1, 2);
ksdensity(data.ListingPriceUSD);
title('Kernel Density Estimation of ListingPriceUSD');

% 绘制对数变换后的数据的直方图和核密度估计图
figure;
subplot(2, 1, 1);
histogram(data.ListingPriceUSD_log);
title('Histogram of log(ListingPriceUSD)');
subplot(2, 1, 2);
ksdensity(data.ListingPriceUSD_log);
title('Kernel Density Estimation of log(ListingPriceUSD)');



%可视化探索分析length和价格之间的关系
% 绘制带回归线的散点图
figure;
scatter(data.Lengthft, data.ListingPriceUSD_log, 'filled');
xlabel('Lengthft');
ylabel('log(ListingPriceUSD)');
title('Scatter Plot of Lengthft vs. ListingPriceUSD');

% 添加回归线
hold on;
x = data.Lengthft;
X = [ones(length(x), 1), x];
[b, bint] = regress(data.ListingPriceUSD_log, X);
plot(x, b(1) + b(2)*x, 'r');
legend('Data', 'Regression Line');




%可视化探索分析length和价格之间的关系(是否受到GeographicRegion的影响)
%选择需要绘制回归线的区域
regions = {'Caribbean', 'Europe', 'USA'}; 

%对应的回归线颜色和图例名称
colors = {'#f44336', '#4caf50', '#2196f3'};
shapes = {'o', 's', 'x'};
legends = {'Caribbean', 'Europe', 'USA'};

%设置散点图和回归线的大小和样式
markerSize = 50;
markerColor = [0.8 0.8 0.8];
lineWidth = 2;

figure
hold on
for i = 1:length(regions)
    region = regions{i};
    color = colors{i};
    filter = data.GeographicRegion == region;
    x = data.Lengthft(filter);
    y = data.ListingPriceUSD(filter);
    
    % 绘制散点图
    scatter(x, y, markerSize, 'MarkerFaceColor', color, 'MarkerEdgeColor', markerColor)
    
    % 绘制回归线
    p = polyfit(x, y, 1);
    xfit = linspace(min(x), max(x), 100);
    yfit = polyval(p, xfit);
    plot(xfit, yfit, 'LineWidth', lineWidth, 'Color', color);
end
hold off
grid on
xlabel('Length (ft)')
ylabel('Listing Price (USD)')

% 设置图例
legend('Caribbean', 'Europe', 'USA');






%length和价格之间的关系(是否受到Year的影响)
% 将散点的颜色设置为年份，并添加颜色图例
figure
scatter(data.Lengthft, data.ListingPriceUSD, 10, data.Year, 'filled')
colormap('jet')
colorbar()
xlabel('Length (ft)')
ylabel('Listing Price (USD)')




% 指定需要保留的Make值
selectedMakes = ["Lagoon", "Beneteau", "Jeanneau", "Bavaria", "Hanse", "Dufour", "Fountaine Pajot", "Other"];
% 对Make变量进行映射，不在selectedMakes中的值归为"other"
data.Make = categorical(mergecats(data.Make, setdiff(categories(data.Make), selectedMakes)), selectedMakes);

% 可视化分析
meanPrice = splitapply(@mean, data.ListingPriceUSD, findgroups(data.Make));
boxplot(data.ListingPriceUSD, data.Make, 'Notch', 'on');
hold on;

hold off;
xlabel('Make', 'FontSize', 12);
ylabel('Listing Price (USD)', 'FontSize', 12);
title('Relationship between Make and Listing Price', 'FontSize', 14);
legend('Listing Price', 'Mean Price', 'Location', 'Best');

if any(strcmp(data.Properties.VariableNames, 'ListingPriceUSD_log'))
    disp('ListingPriceUSD_log 存在，变量名命名正确');
else
    error('变量名命名错误或不存在');
end


% 建立决策树回归模型
tree = fitrtree(dataTrain(:,1:end-2), dataTrain.ListingPriceUSD_log);

% 在训练集和验证集上进行预测，并计算预测精度
yTrainPred = predict(tree, dataTrain(:,1:end-2));
yValPred = predict(tree, dataVal(:,1:end-2));
trainRmse = sqrt(mean((dataTrain.ListingPriceUSD_log - yTrainPred).^2));
valRmse = sqrt(mean((dataVal.ListingPriceUSD_log - yValPred).^2));

fprintf('Training RMSE: %.3f\n', trainRmse);
fprintf('Validation RMSE: %.3f\n', valRmse);





% 分离训练集和验证集
cvp = cvpartition(size(data, 1), 'Holdout', 0.2);
dataTrain = data(cvp.training,:);
dataVal = data(cvp.test,:);

% 建立决策树回归模型
tree = fitrtree(dataTrain(:,1:end-2), dataTrain.ListingPriceUSD_log);

% 在验证集上进行预测，并计算预测结果与真实结果
yValPred = predict(tree, dataVal(:,1:end-2));

% 绘制模型预测结果与真实结果的比较图
figure;
h1 = plot(dataVal.ListingPriceUSD_log, 'o', 'MarkerSize', 4, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue');
hold on;
h2 = plot(yValPred, 'o', 'MarkerSize', 4, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red');
ylim([-2,12]) %设置y轴范围，使其与对数变换后的价格相对应
xlabel('Observation');
ylabel('Listing Price (log scale)');
title('Comparison between Actual and Predicted Prices on Validation Set');
legend([h1,h2],{'Actual Price','Predicted Price'}, 'Location','best');
hold off;