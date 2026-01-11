% Solar Voltage Rise Project:

% Setup Parameters (Colombo, Sri Lanka)
lat = '6.9271'; 
lon = '79.8612';
start_date = '20230321'; 
end_date   = '20230321'; 


url = strcat('https://power.larc.nasa.gov/api/temporal/hourly/point?', ...
    'parameters=T2M,ALLSKY_SFC_SW_DWN', ...
    '&community=RE', ...
    '&longitude=', lon, ...
    '&latitude=', lat, ...
    '&start=', start_date, ...
    '&end=', end_date, ...
    '&format=csv', ... 
    '&header=true'); 


filename = 'nasa_solar_data.csv';
disp('Downloading data from NASA...');
websave(filename, url);


% We open the file and look for the line that starts with "YEAR"
fid = fopen(filename, 'r');
headerLine = 0;
while ~feof(fid)
    tline = fgetl(fid);
    
    if contains(tline, 'YEAR,MO,DY') 
        break; 
    end
    headerLine = headerLine + 1;
end
fclose(fid);

disp(['Found headers at line: ', num2str(headerLine + 1)]);


opts = detectImportOptions(filename, 'NumHeaderLines', headerLine);
opts.VariableNamingRule = 'preserve';
data = readtable(filename, opts);



timeVector = datetime(data.YEAR, data.MO, data.DY, data.HR, 0, 0);

% Extract Solar Data

solar_values = data.ALLSKY_SFC_SW_DWN; 


time_in_seconds = 0:3600:((length(timeVector)-1)*3600);
solar_profile = timeseries(solar_values, time_in_seconds);


figure;
plot(solar_profile);
title(['Solar Irradiance: ', start_date]);
xlabel('Time (s)');
ylabel('W/m^2');
grid on;
