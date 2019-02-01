clear
clc

%Create a spatial reference object that tells Matlab where your data are in
%space
R = georasterref();
R.RasterSize = [621 1405];
R.LatitudeLimits = [24.0625 49.9375];
R.LongitudeLimits = [-125.0208333 -66.4791667];
R.ColumnsStartFrom = 'north';
R.RowsStartFrom = 'west';

tmean = NaN(621,1405,444); 
count = 1; 
%Loop through all of the files, which are grouped by year and months
for i = 1981:2017
    for ii = 1:12
        
        if ii < 10
            fileName = ['PRISM_tmean_stable_4kmM3_' num2str(i) '0' num2str(ii) '_bil.bil']; 
        else
            fileName = ['PRISM_tmean_stable_4kmM3_' num2str(i) num2str(ii) '_bil.bil']; 
        end
        %open the PRISM file
        fid = fopen(fileName); 
        data = fread(fid,[1405 621],'float'); 
        fclose(fid); 
        %Replace missing values (-1000) with NaN
        for j = 1:621
            data(data(:,j) <= -1000, j) = NaN;
        end
        data = data'; %transpose the data to make it latitude x longitude
        
        tmean(:,:,count) = data; 
        count = count + 1; 
        
        clear fileName fid data 
    end
    
end

%The output of this code will be "tmean", which will be a 3-D object that
%is latitude x longitude x time (months). 
            