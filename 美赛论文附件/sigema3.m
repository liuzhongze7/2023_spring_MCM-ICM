% 导入数据
opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:H3492";
opts.VariableNames = ["Make", "Variant", "Lengthft", "GeographicRegion", "CountryRegionState", "ListingPriceUSD", "Year", "VarName8"];
opts.VariableTypes = ["categorical", "categorical", "double", "categorical", "categorical", "double", "double", "categorical"];
opts = setvaropts(opts, ["GeographicRegion", "CountryRegionState", "VarName8"], "EmptyFieldRule", "auto");
data = readtable("C:\Users\Administrator\Desktop\美赛\数据合并.xlsx", opts, "UseExcel", false);

% 找到需要处理的数据
data_to_process = data(:, {'Lengthft', 'ListingPriceUSD'});

% 对数据按 Lengthft 进行分组，计算四分位数和 IQR
grouped_data = splitapply(@(x) {quantile(x, [.25 .5 .75]), iqr(x)}, data_to_process.ListingPriceUSD, findgroups(data_to_process.Lengthft));

% 对于每组数据，根据 IQR 来计算上下界
bound = cell(size(grouped_data));
for i = 1:length(grouped_data)
    if ~isempty(grouped_data{i})
        Q1 = grouped_data{i}(1,1);
        Q3 = grouped_data{i}(1,3);
        IQR = Q3 - Q1;
        bound{i} = [Q1-1.5*IQR, Q3+1.5*IQR];
    else
        bound{i} = [];
    end
end

% 处理超出上下界的数据，将其赋值为上下界
for i = 1:length(grouped_data)
    if ~isempty(bound{i})
        data_rows = find(data_to_process.Lengthft == i);
        outlier_rows = data_to_process.ListingPriceUSD(data_rows) < bound{i}(1) | data_to_process.ListingPriceUSD(data_rows) > bound{i}(2);
        outlier_values = data_to_process.ListingPriceUSD(data_rows(outlier_rows));
        outlier_values(outlier_values < bound{i}(1)) = bound{i}(1);
        outlier_values(outlier_values > bound{i}(2)) = bound{i}(2);
        data_to_process.ListingPriceUSD(data_rows(outlier_rows)) = outlier_values;

    end
end


% 绘制数据可视化
% 绘制箱线图
figure;
boxplot(data_to_process.ListingPriceUSD, data_to_process.Lengthft);
title('Boxplot for ListingPriceUSD');
xlabel('Lengthft');
ylabel('Price (USD)');



