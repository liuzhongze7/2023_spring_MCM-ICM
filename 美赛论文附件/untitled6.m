% 导入数据
opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:H3492";
opts.VariableNames = ["Make", "Variant", "Lengthft", "GeographicRegion", "CountryRegionState", "ListingPriceUSD", "Year", "VarName8"];
opts.VariableTypes = ["categorical", "categorical", "double", "categorical", "categorical", "double", "double", "categorical"];
data = readtable("C:\Users\Administrator\Desktop\美赛\数据合并.xlsx", opts);

% 提取出厂年份和价格数据
year = data.Year;
price = data.ListingPriceUSD;

% 绘制出厂年份与价格数据的散点图
scatter(year, price);
xlabel('Year');
ylabel('Price');

% 拟合ARIMA模型
model = arima(3,1,3);
fit = estimate(model, price);

% 预测价格
[Y, std] = forecast(fit, 10, 'Y0',price);
ci95 = [Y-1.96*std, Y+1.96*std];

% 绘制预测结果和置信区间
hold on;
plot(2001:2010, Y, 'r', 'LineWidth', 2);
plot(2001:2010, ci95(:, 1), 'k--', 'LineWidth', 1);
plot(2001:2010, ci95(:, 2), 'k--', 'LineWidth', 1);
hold off;

