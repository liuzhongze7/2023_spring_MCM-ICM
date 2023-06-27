%Import Data
opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:H3492";
opts.VariableNames = ["Make", "Variant", "Lengthft", "GeographicRegion", "CountryRegionState", "ListingPriceUSD", "Year", "VarName8"];
opts.VariableTypes = ["categorical", "categorical", "double", "categorical", "categorical", "double", "double", "categorical"];
data = readtable("C:\Users\Administrator\Desktop\数学建模\美赛\数据合并.xlsx", opts);


%Visualize and explore the distribution of prices
%Perform logarithmic transformation on prices
data.ListingPriceUSD_log = log(data.ListingPriceUSD);

%Draw histogram and kernel density estimation chart of original price data
subplot(2, 1, 1);
histogram(data.ListingPriceUSD);
title('Histogram of ListingPriceUSD');
subplot(2, 1, 2);
ksdensity(data.ListingPriceUSD);
title('Kernel Density Estimation of ListingPriceUSD');

%Draw histogram and kernel density estimation diagram of logarithmically transformed data
figure;
subplot(2, 1, 1);
histogram(data.ListingPriceUSD_log);
title('Histogram of log(ListingPriceUSD)');
subplot(2, 1, 2);
ksdensity(data.ListingPriceUSD_log);
title('Kernel Density Estimation of log(ListingPriceUSD)');

%Visual exploration and analysis of the relationship between length and price
%Draw scatter plot with tropic

figure;
scatter(data.Lengthft, data.ListingPriceUSD_log, 'filled');
xlabel('Lengthft');
ylabel('log(ListingPriceUSD)');
title('Scatter Plot of Lengthft vs. ListingPriceUSD');

%Add tropic
hold on;
x = data.Lengthft;
X = [ones(length(x), 1), x];
[b, bint] = regress(data.ListingPriceUSD_log, X);
plot(x, b(1) + b(2)*x, 'r');
legend('Data', 'Regression Line');




%Visual exploration and analysis of the relationship between length and price (whether influenced by GeographRegion)
%Select the area where tropic needs to be drawn
regions = {'Caribbean', 'Europe', 'USA'}; 

%Corresponding tropic color and legend name
colors = {'#f44336', '#4caf50', '#2196f3'};
shapes = {'o', 's', 'x'};
legends = {'Caribbean', 'Europe', 'USA'};

%Set the size and style of scatter plot and tropic
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
    
    %Draw a scatter plotv
    scatter(x, y, markerSize, 'MarkerFaceColor', color, 'MarkerEdgeColor', markerColor)
    
    %Draw tropic
    p = polyfit(x, y, 1);
    xfit = linspace(min(x), max(x), 100);
    yfit = polyval(p, xfit);
    plot(xfit, yfit, 'LineWidth', lineWidth, 'Color', color);
end
hold off
grid on
xlabel('Length (ft)')
ylabel('Listing Price (USD)')

%Set Legend
legend('Caribbean', 'Europe', 'USA');






%The relationship between length and price (whether influenced by Year)
%Set the color of scatter points to year and add a color legend
figure
scatter(data.Lengthft, data.ListingPriceUSD, 10, data.Year, 'filled')
colormap('jet')
colorbar()
xlabel('Length (ft)')
ylabel('Listing Price (USD)')




%Specify the Make value that needs to be preservedv
selectedMakes = ["Lagoon", "Beneteau", "Jeanneau", "Bavaria", "Hanse", "Dufour", "Fountaine Pajot", "Other"];
% Map the Make variable and assign values that are not in selectedMakes to 'other'
data.Make = categorical(mergecats(data.Make, setdiff(categories(data.Make), selectedMakes)), selectedMakes);

% 可视化分析
Visual analysis
meanPrice = splitapply(@mean, data.ListingPriceUSD, findgroups(data.Make));
boxplot(data.ListingPriceUSD, data.Make, 'Notch', 'on');
hold on;
plot(get(gca, 'XLim'), meanPrice, 'r--', 'LineWidth', 1.5);
hold off;
xlabel('Make', 'FontSize', 12);
ylabel('Listing Price (USD)', 'FontSize', 12);
title('Relationship between Make and Listing Price', 'FontSize', 14);
legend('Listing Price', 'Mean Price', 'Location', 'Best');





