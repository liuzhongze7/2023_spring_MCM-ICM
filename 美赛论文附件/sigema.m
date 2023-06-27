opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:H3492";
opts.VariableNames = ["Make", "Variant", "Lengthft", "GeographicRegion", "CountryRegionState", "ListingPriceUSD", "Year", "VarName8"];
opts.VariableTypes = ["categorical", "categorical", "double", "categorical", "categorical", "double", "double", "categorical"];
opts = setvaropts(opts, ["Make", "Variant", "GeographicRegion", "CountryRegionState", "VarName8"], "EmptyFieldRule", "auto");
data = readtable("C:\Users\Administrator\Desktop\美赛\数据合并.xlsx", opts, "UseExcel", false);

% 将空值转为 NaN 
data{strcmp(data{:,'ListingPriceUSD'}, ''), 'ListingPriceUSD'} = NaN;

% 将 Make 和 Variant 拼接成一个新的变量，以便于后续分类 
data.Model = strcat(data.Make, '-', data.Variant); 
data = removevars(data, {'Make', 'Variant'}); 
% 删除原有的变量
% 将 Year 从 double 类型转换为 categorical 类型 
data.Year = categorical(data.Year);

% 使用 removecats 函数删除掉只出现过一次的分类变量值 
data.Model = removecats(data.Model); 
data.GeographicRegion = removecats(data.GeographicRegion); 
data.CountryRegionState = removecats(data.CountryRegionState);

% 计算平均值和标准差 
mu = mean(data{:, 3:5}, 'omitnan'); 
sigma = std(data{:, 3:5}, 'omitnan');

lower_bound = mu - 3*sigma; 
upper_bound = mu + 3*sigma;

% 找出异常值 
outlier_idx = (data{:, 3} < lower_bound(1)) | (data{:, 3} > upper_bound(1)) ... | (data{:, 4} < lower_bound(2)) | (data{:, 4} > upper_bound(2)) ... | (data{:, 5} < lower_bound(3)) | (data{:, 5} > upper_bound(3)); 
outliers = data(outlier_idx, :);

% 绘制直方图和异常点 
figure; histogram(data{:, 3:5}, 20);
hold on plot3(outliers.ListingPriceUSD, outliers.Lengthft, outliers.GeographicRegion, 'r*') 
hold off

% 输出异常值 
outliers = sortrows(outliers, 'ListingPriceUSD', 'descend'); 
fprintf('ListingPriceUSD\tLengthft\tGeographicRegion\tCountryRegionState\tYear\tModel\n'); 
for i = 1:
    size(outliers, 1) 
    fprintf('%f\t%f\t%s\t%s\t%d\t%s\n', outliers.ListingPriceUSD(i), outliers.Lengthft(i), ... outliers.GeographicRegion(i), outliers.CountryRegionState(i), outliers.Year(i), outliers.Model{i}); 
        end


% 计算平均值和标准差 
mu = mean(data{:, 3:6}, 'omitnan'); 
sigma = std(data{:, 3:6}, 'omitnan'); 
% 计算异常数据阈值 
lower_bound = mu - 3*sigma; 
upper_bound = mu + 3*sigma; 
% 判断异常数据 
outlier_idx = (data{:, 3:6} < lower_bound) | (data{:, 3:6} > upper_bound); 
% 获取异常数据 
outliers = data(outlier_idx); 
% 绘制数据分布直方图 
figure; histogram(data{:, 3:6}, 20); 
%将数据分为20个区间 
hold on 
% 在图形中标记异常数据点 
plot(outliers{:, [3, 4, 5, 6]}, zeros(size(outliers,1),4),'r*') 
hold off 
title('数据直方图'); 
xlabel('数据值'); 
ylabel('频数'); 
xlim([min(data{:, 3:6},[],'all') max(data{:, 3:6},[],'all')]); 
% 输出异常数据的表格 
is_outlier = outlier_idx; 
T = table(data{:, 3:6}, is_outlier); 
% 创建表格 
disp(T);
