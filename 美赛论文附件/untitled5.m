% 帆船长度和价格的样本数据
boatLength = data.Lengthft;
boatPrice = data.ListingPriceUSD;

% 使用 corrcoef() 函数计算帆船长度和价格之间的皮尔逊相关系数
r = corrcoef(boatLength, boatPrice);

% 绘制散点图
scatter(boatLength, boatPrice, 'filled');
xlabel('Boat Length (ft)');
ylabel('Price (USD)');
title(['Pearson Correlation Analysis of Boat Length and Price (r = ', num2str(r(1, 2)), ')']);

% 添加回归线
hold on;
coefficients = polyfit(boatLength, boatPrice, 1);
xrange = [min(boatLength), max(boatLength)];
yrange = polyval(coefficients, xrange);
plot(xrange, yrange, 'r-', 'LineWidth', 2);

% 添加图例
legend('Data Points', 'Regression Line');

% 改变图例和坐标轴标签的字体大小
legendFontSize = 12;
labelFontSize = 14;
set(gca, 'FontSize', labelFontSize);
set(get(gca,'xlabel'),'FontSize', labelFontSize);
set(get(gca,'ylabel'),'FontSize', labelFontSize);
legend('FontSize', legendFontSize);
