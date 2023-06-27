filename = 'C:\Users\Administrator\Desktop\美赛\2023_MCM_Problem_Y_Boats.xlsx';
opts = spreadsheetImportOptions("NumVariables", 8);
opts.VariableNames = ["Make", "Variant", "Lengthft", "GeographicRegion", "CountryRegionState", "ListingPriceUSD", "Year", "IsSingle"];
opts.VariableTypes = ["categorical", "categorical", "double", "categorical", "categorical", "double", "double", "categorical"];
opts = setvaropts(opts, ["Make", "Variant", "GeographicRegion", "CountryRegionState", "IsSingle"], "EmptyFieldRule", "auto");

% 导入 Sheet1 数据
opts.Sheet = "Sheet1";
opts.DataRange = "A2:H3492";
data1 = readtable(filename, opts, "UseExcel", false);

% 导入 Sheet2 数据
opts.Sheet = "Sheet2";
opts.DataRange = "A2:H964";
data2 = readtable(filename, opts, "UseExcel", false);
