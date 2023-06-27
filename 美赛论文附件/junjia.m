% Load the data
opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:H3492";
opts.VariableNames = ["Make", "Variant", "Lengthft", "GeographicRegion", "CountryRegionState", "ListingPriceUSD", "Year", "VarName8"];
opts.VariableTypes = ["categorical", "categorical", "double", "categorical", "categorical", "double", "double", "categorical"];
data = readtable("C:\Users\Administrator\Desktop\美赛\数据合并.xlsx", opts);

% Compute mean ListingPriceUSD by CountryRegionState and GeographicRegion
avg_price_by_state = groupsummary(data, {'CountryRegionState', 'GeographicRegion'}, 'mean', 'ListingPriceUSD');

% Write the results to a new Excel file
writetable(avg_price_by_state, "C:\Users\Administrator\Desktop\美赛\均价统计123.xlsx");
