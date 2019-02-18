clear
clc

%Create georeference object for the NCEP/NCAR grid
R = georasterref;
R.RasterSize = [94,192];
R.Latlim = [-88.542, 88.542];
R.Lonlim = [0, 358];
R.ColumnsStartFrom = 'north';
R.RowsStartFrom = 'west';

ncep = dir('*.nc'); 

pet = NaN(94,192,2922); %output variable "pet" will contain all daily PET
%from 2003 to 2010 for all NCEP/NCAR grid cells

count = 1; %count is used to keep track of time dimension
for p = 1:length(ncep) %loop through NCEP/NCAR files
    p
    finfo = ncinfo(ncep(p).name); %query to find information about the netCDF file
    ncid = netcdf.open(ncep(p).name); %open the netCDF file
    
    pevpr = netcdf.getVar(ncid,3); %extract PET, the 4th variable
    pevpr = double(pevpr); 
    
    time = netcdf.getVar(ncid,2); %extract time, the 3rd variable
    netcdf.close(ncid); %make sure to close your netCDF file
    
    %NCEP/NCAR produces PET as an energy flux in W/m2. We need to convert to mm/day 
    pevpr = pevpr.*(1/2453600); 
    pevpr = pevpr.*86400; 
        
    %Loop through time dimension
    for i = 1:length(time)
        sub(1:192,1:94) = pevpr(:,:,i); 
        for ii = 1:94
            sub(sub(:,ii) < 0, ii) = NaN; %Make missing values NaN
        end
        
        pet(:,:,count) = sub'; %flip the data so dimensions are lat x lon x time
        count = count + 1; 
        clear sub
    end   
    
    clear finfo ncid pevpr time   
    clc
end
%Your output variable is now "pet", which contains daily PET from 2003 to
%2010 across all NCEP/NCAR grid cells. 
    
stations = dir('*.csv'); 
for p = 1:length(stations)
    wsData = importdata(stations(p).name); 
       
    lat = wsData(1,end-1); 
    lon = wsData(1,end); 
    
    [row,col] = latlon2pix(R,lat,lon); 
    row = round(row); col = round(col); 
    sub(1:2922,1) = pet(row,col,:); 
    
    wsData(:,11) = sub; 
    csvwrite([stations(p).name(1:end-4) '_NCEP.csv'], wsData); 
    
    clear wsData sub row col lat lon 
end
%     
    
    
    
    