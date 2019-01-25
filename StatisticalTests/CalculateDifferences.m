clear
clc

knox = importdata('Knoxville_Annual.csv'); 
knox = knox.data; 

%--------------------------------------------------------------------------
%Difference in means tests
%----------------------------------
%In this case we have 50 years of temperature data (column 2). Split the
%data into two, equal time periods to compute difference in the means of
%those periods
period1 = knox(1:25,:); %first period (the first 25 years of the data)
period2 = knox(26:end,:); %second period (last 25 years of the data)

d = mean(period2(:,2))-mean(period1(:,2)); %difference in means
degFree = length(period1(:,1))-2; 
%Now to run a hypothesis test to determine if the slope of the regression
%is (statistically) significantly different from 0
SE = sqrt(((std(period2(:,2))^2)/degFree)+((std(period1(:,2))^2)/degFree));  %calculate standard error of sampling distribution
tstat = d/SE; %calculate t-statistic for the slope

tdist2T = @(tstat,degFree) (1-betainc(degFree/(degFree+tstat^2),degFree/2,0.5)); %create function to compute 2-tail t test
tdist1T = 1-(1-tdist2T(tstat,degFree))/2; %apply it to our t-statistic (one-tail) and degrees of freedom
pval = 1-tdist1T; %p-value of the t-test
%-----------------------------------------------------------------------------------------------

