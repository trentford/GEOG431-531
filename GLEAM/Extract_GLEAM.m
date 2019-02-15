clear
clc

%Create the georeference object
R = georasterref;
R.RasterSize = [720,1440];
R.Latlim = [-89.875, 89.875];
R.Lonlim = [-179.88, 179.88];
R.ColumnsStartFrom = 'north';
R.RowsStartFrom = 'west';
%----------------------------------

PET = NaN(121,281,2922); 
petCount = 1; 
%Loop through all, yearly GLEAM files - 2003 to 2010
files = dir('*.nc'); 
for p = 1:length(files)
    p
    tic
    finfo = ncinfo(files(p).name); 
    ncid = netcdf.open(files(p).name); %open the netCDF file 
    lon = netcdf.getVar(ncid,0); %extract latitude variable
    lat = netcdf.getVar(ncid,1); %extract longitude variable
    time = netcdf.getVar(ncid,2); %extract time
    start = [159 199 0]; count = [121 281 length(time)]; 
    pevap = netcdf.getVar(ncid,3,start,count); %extract PET variable
    %only extract the extent of US: latitude 20 - 50N, longitude -130 - -60W 
    netcdf.close(ncid); %close netCDF file    
        
    %Loop through the time to replace missing values 
    for i = 1:length(pevap(1,1,:))  
        i
        sub(1:121,1:281) = pevap(:,:,i); 
        for ii = 1:281
            sub(sub(:,ii) < -100, ii) = NaN; 
        end
    
        PET(:,:,petCount) = sub; 
        petCount = petCount + 1; 
        clear sub    
        clc
    end
    toc    
    clear pevap time lat lon ncid evap start count
    clc
end



