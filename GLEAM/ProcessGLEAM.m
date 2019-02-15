clear
clc

%Create georeference object for the NCEP/NCAR grid
R = georasterref;
R.RasterSize = [121,281];
R.Latlim = [20, 50];
R.Lonlim = [-130,-60];
R.ColumnsStartFrom = 'north';
R.RowsStartFrom = 'west';

PET = load('PET_2003_2010.mat'); %load the GLEAM data
PET = PET.PET; 

stations = dir('*.csv'); 
for p = 1:length(stations)
    p
    %Open daily surface weather station data
    wsData = importdata(stations(p).name); 
       
    lat = wsData(1,end-1); %extract station latitude
    lon = wsData(1,end); %extract station longitude
    
    %Find the grid cell (row, col) of my stations
    [row,col] = latlon2pix(R,lat,lon); 
    row = round(row); col = round(col); 
    sub(1:2922,1) = PET(row,col,:); %pull out PET time series
    
    wsData(:,11) = sub; %append GLEAM PET to the end of the weather station data
    
    csvwrite([stations(p).name(1:end-4) '_GLEAM.csv'], wsData); 
    
    clear wsData sub row col lat lon 
    clc
end
%     
    
    
    
    