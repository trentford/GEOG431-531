clear
clc

knox = importdata('Knoxville_Annual.csv'); 
knox = knox.data; 

%--------------------------------------------------------------------------
%Ordinary least squares regression
%----------------------------------
x = (1:50)'; %independent variable (x) is just 1 to 50
y = knox(:,2); %dependent variable (y) is one of the ASOS variables

%calculate the slope or regression coefficient of a linear regression of y on x. 
%Make sure to include the column of ones in front of x, which will force
%Matlab to include a y-intercept
X = [ones(length(x),1) x]; 
b1 = X\y;  
yHat = X*b1; %calclate the predicted variable each year using the linear regression
%------------------------
%plot the data with the regression fit
plot(y); 
hold on
plot(yHat); 
%-----------------------
%To evaluate how well your regression fits the data, calculate the Rsquared
resid = y-yHat; %Calculate the residuals
SSresid = sum(resid.^2); %sum of squares
SStotal = (length(y)-1)*var(y); %total sum of squares

rsq = 1-SSresid/SStotal; 
%------------------------

%Now to run a hypothesis test to determine if the slope of the regression
%is (statistically) significantly different from 0
SE = (sqrt(sum(resid.^2)/(length(y)-2)))/(sqrt(sum((x-mean(x)).^2))); %calculate standard error of slope
tstat = b1(2)/SE; %calculate t-statistic for the slope

v = length(y)-2; %degrees of freedom
tdist2T = @(t,v) (1-betainc(v/(v+tstat^2),v/2,0.5)); %create function to compute 2-tail t test
tdist1T = 1-(1-tdist2T(tstat,v))/2; %apply it to our t-statistic (one-tail) and degrees of freedom
pval = 1-tdist1T; %p-value of the t-test
%-----------------------------------------------------------------------------------------------

%Theil-Sen median pairwise slopes
n = length(parameters);
    count = 0;
    for i = 1:n
        for p = 1:n
            if(i~=p)
                count = count+1;
                b(count) = (parameters(i)-parameters(p))/(i-p);
            end
        end
    end
    mpws_trend = nanmedian(b);
    for i = 1:n
        res(i) = parameters(i)-(mpws_trend*i);
    end
mpws_intercept = nanmedian(res);

%--------------------------------------------------------------------------

[RHO,PVAL] = corr(years,parameters,'Type','Spearman','rows','complete');



