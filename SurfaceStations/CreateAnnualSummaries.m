clear
clc
tic
%---------------------------------------
%Import daily ASOS station observations into Matlab
knox = importdata('Knoxville.csv'); 
knox = knox.data; 

%------------------------------------------------------
%Loop through all data years and compute annual average or total
%----if you don't know how many years are in the data----
% years = unique(knox(:,1)); 
%--------------------------------
for i = 1961:2010
    subset = knox(knox(:,1) == i, :); %subset data to just year "i", which is 1961, then 1962, etc.
    annual(i-1960,1) = i; 
    
    %Now we loop through the variables (8 in this case) to calculate the annual mean/total
    %for each one
    for ii = 4:9 %variables are in columns 4 through 11 of the data
        %we need to calculate means or sums of only rows that do not
        %contain a NaN
        annual(i-1960,ii-2) = mean(subset(isnan(subset(:,ii)) == 0, ii)); 
    end
    
    for ii = 10:11 %we need to sum PET and precipitation, not mean
        annual(i-1960,ii-2) = sum(subset(isnan(subset(:,ii)) == 0, ii)); 
    end
    
    clear subset
end

%The resulting output "annual" will contain annual averages or sums for all
%variables
 toc   
    


