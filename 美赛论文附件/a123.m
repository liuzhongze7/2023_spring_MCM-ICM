%% 导入数据 
opts = spreadsheetImportOptions("NumVariables", 8); 
opts.Sheet = "Sheet1"; opts.DataRange = "A2:H3492"; 
opts.VariableNames = ["Make", "Variant", "Lengthft", "GeographicRegion", "CountryRegionState", "ListingPriceUSD", "Year", "VarName8"]; 
opts.VariableTypes = ["categorical", "categorical", "double", "categorical", "categorical", "double", "double", "categorical"]; 
data = readtable("C:\Users\Administrator\Desktop\美赛\数据合并.xlsx", opts);

%% 数据处理 
% 按照所给变量选定要绘制箱线图的数据 
selectedData = data(:, 3:6);

% 对剔除异常值后的数据进行标准化
selectedDataNorm = (selectedData - mean(selectedData)) ./ std(selectedData);

% 筛选出在[-3, 3]范围内的数据 
selectedDataInRange = selectedDataNorm(abs(selectedDataNorm) < 3, :);

%% 绘制箱线图 
boxplot(selectedDataInRange, 'labels', selectedData.Properties.VariableNames(3:6)); 
title('Selected Vehicle Data'); % 设置标题 
ylabel('Value'); % 设置y轴标签