clear
clc
tic
%---------------------------------------
%Import daily ASOS station observations into Matlab
knox = importdata('Knoxville.csv'); 
knox = knox.data; 

%------------------------------------------------------
%Loop through all of the variables to find 90th and 10th percentiles
for i = 4:9
    subset = [knox(:,1) knox(:,i)]; %subset the variable 
    s = sortrows(subset,2,'ascend'); %sort the daily observations ascending
    s(isnan(s(:,1)) == 1, :) = []; %get rid of NaN values
    
    cold = s(round(length(s)*0.1),2); %find the 10th percentile
    hot = s(round(length(s)*0.9),2); %find the 90th percentile
    
    %Loop through all of the years to find the number of days exceeding the
    %hot and cold thresholds
    for ii = 1961:2010 %replace years
        data = knox(knox(:,1) == ii, :); %subset data to just year ii
        hotDays(ii-1960,1) = ii; 
        hotDays(ii-1960,i-2) = length(data(data(:,i) >= hot, i)); 
        
        coldDays(ii-1960,1) = ii; 
        coldDays(ii-1960,i-2) = length(data(data(:,i) <= cold, i)); 
        
        clear data
    end
    
    clear subset s cold hot
        
    
end
