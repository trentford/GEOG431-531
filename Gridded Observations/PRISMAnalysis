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

tmean = NaN(621,1405,37); 
count = 1; 
%Loop through all of the files, which are grouped by year and months
for i = 1981:2017
    fileName = ['PRISM_tmean_stable_4kmM2_' num2str(i) '01_bil.bil']; 
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

%The output of this code will be "tmean", which will be a 3-D object that
%is latitude x longitude x time (months).

%------------------------------------------------------------------------
%%Correlation code for PRISM and ENSO
%Import the Nino 3.4 index anomalies from 1981-2017
enso = importdata('Nino34.csv'); 

%Loop through the grid cells in PRISM (621 rows x 1405 columns) and pull
%out each individual grid cell's 37 year time series. 
for i = 1:621 %rows
    i
    for ii = 1:1405 %columns
        
        subset(1:37,1) = tmean(i,ii,:); %pulls out 37 year time series of
        %temperature or precipitation from prism row i, column ii
        
        %calculate correlation coefficient between grid cell temperature or
        %precipitation and Nino 3.4 index (column 2 of enso) 
        [r,p] = corrcoef(subset,enso(:,2),'rows','complete'); 
        
        %----------------------------------------------------------------
        %If you only want to retain the statistically significant
        %correlations, then you can screen out those for which the p-value
        %exceeded 0.05
%         if p(2) <= 0.05
%             corrs(i,ii) = r(2); 
%         else
%             corrs(i,ii) = 0; 
%         end
        %If you would instead like to plot all correlations, irrespective
        %of their significance, then just comment out the code from lines
        %23 to 27
        %----------------------------------------------------------------
        
        clear subset r p
    end
    clc
end
%--------------------------------------------------------------------
%%Mapping Code for Correlation - requires "red_blue.mat" file
ax = usamap('conus'); %open an empty map with U.S. extent
states = shaperead('usastatelo','UseGeoCoords',true); %import the built-in Matlab U.S. state shapefile
cmap = load('red_blue.mat'); %Import the red to blue colormap. You will need the "red_blue.mat" file
cmap = cmap.red_blue; 

geoshow(corrs,R,'DisplayType','TextureMap'); %map the correlation coefficients on the map
geoshow(ax,states,'DisplayType','Polygon','FaceColor','None'); %map the state shapefile
colormap(cmap./255); %use the red-to-blue colormap
caxis([-1 1]); %set the range of your colormap to the range of correlations (-1 to 1)
