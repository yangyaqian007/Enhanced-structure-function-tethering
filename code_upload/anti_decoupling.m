%% anti-decoupling
% use the variable 'a' in 'high_frequency.m'

%% node-wise prediction 
% 15:70 flat
rsq = zeros(N, 1); 
for jj = 1:N    
    y = fc(:, jj);   
    x1 = zscore(BEC_sort(:,434:N));  % standardize predictors of 434 eigenmodes    
    % fit multiple regression (OLS, main effects only) exclude self-connections for all variables. N.B., 
    lm = fitlm(x1, y, 'Exclude', jj);
    rsq(jj) = lm.Rsquared.Ordinary;     % record adjusted R-square for parcellation ii, node jj
end
rsq1=sqrt(rsq);

%% plot R and gradient
figure;
y = rsq1;
%[rho, pval] = corr(xx, y,'type','Spearman'); %-0.48
[rho, pval] = corr(xx, y); %-0.48
lm = fitlm(xx, y);
xhat = linspace(min(xx), max(xx), 100);
yhat = lm.Coefficients.Estimate(1) + (lm.Coefficients.Estimate(2) * xhat);
plot(xx, y, '.','Markersize',20); hold on
plot(xhat, yhat,'LineWidth',1)
title(['rho = ' num2str(rho) ', p = ' num2str(pval)]);
axis square
xlabel('gradient');ylabel('R');
