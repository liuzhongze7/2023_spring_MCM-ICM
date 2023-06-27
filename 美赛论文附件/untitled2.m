%% 导入电子表格中的数据
% 用于从以下电子表格导入数据的脚本:
%
%    工作簿: C:\Users\Administrator\Desktop\美赛\数据合并.xlsx
%    工作表: Sheet1
%
% 由 MATLAB 于 2023-04-01 22:17:17 自动生成

% 导入数据
opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:H3492";
opts.VariableNames = ["Make", "Variant", "Lengthft", "GeographicRegion", "CountryRegionState", "ListingPriceUSD", "Year", "VarName8"];
opts.VariableTypes = ["categorical", "categorical", "double", "categorical", "categorical", "double", "double", "categorical"];
opts = setvaropts(opts, ["Make", "Variant", "GeographicRegion", "CountryRegionState", "VarName8"], "EmptyFieldRule", "auto");
data = readtable("C:\Users\Administrator\Desktop\美赛\数据合并.xlsx", opts, "UseExcel", false);

%计算均值和标准差
mu = mean(data{:, 6});
sigma = std(data{:, 6});

%计算标准差数
z = abs((data{:, 6} - mu) ./ sigma);

%找到异常数据点
threshold = 3;
predicate = z > threshold;

%将异常数据保存到新的表格中
exceptions = data(predicate, :);
writetable(exceptions, 'C:\Users\Administrator\Desktop\美赛\exception.xlsx');

%删除异常数据
data(predicate, :) = [];

%计算数据的基本统计量
n = height(data);
mean_price = mean(data.ListingPriceUSD);
std_price = std(data.ListingPriceUSD);
min_price = min(data.ListingPriceUSD);
max_price = max(data.ListingPriceUSD);

%绘制箱线图
boxplot(data.ListingPriceUSD,'Labels',{'ListingPriceUSD'});
ylabel('Price (USD)');
title('Listing Price Distribution in Data');
print('-dpng', 'C:\Users\Administrator\Desktop\美赛\boxplot.png');

%输出结果
fprintf('数据基本统计信息:\n 数据样本数目: %d\n 平均价格: %g\n 标准差: %g\n 最小价格: %g\n 最大价格: %g\n', ...
        n, mean_price, std_price, min_price, max_price);
fprintf('发现%d个异常数据点\n', height(exceptions));


%% 清除临时变量
clear opts