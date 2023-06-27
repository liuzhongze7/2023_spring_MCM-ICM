% 导入数据
opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:H3492";
opts.VariableNames = ["Make", "Variant", "Lengthft", "GeographicRegion", "CountryRegionState", "ListingPriceUSD", "Year", "VarName8"];
opts.VariableTypes = ["categorical", "categorical", "double", "categorical", "categorical", "double", "double", "categorical"];
data = readtable("C:\Users\Administrator\Desktop\美赛\数据合并.xlsx", opts);


