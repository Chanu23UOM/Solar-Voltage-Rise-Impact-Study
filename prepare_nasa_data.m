% --- Solar Voltage Rise Project: Step 1 (Updated API Method) ---

% 1. Setup Parameters (Colombo, Sri Lanka)
lat = '6.9271'; 
lon = '79.8612';
start_date = '20230321'; % March 21st
end_date   = '20230321'; % Same day for a 24h profile

% 2. Construct the URL (Using format=csv just like the Python example)
% We request both Solar (ALLSKY_SFC_SW_DWN) and Temperature (T2M)
% header=true tells NASA to give us column names, which readtable needs.
url = strcat('https://power.larc.nasa.gov/api/temporal/hourly/point?', ...
    'parameters=T2M,ALLSKY_SFC_SW_DWN', ...
    '&community=RE', ...
    '&longitude=', lon, ...
    '&latitude=', lat, ...
    '&start=', start_date, ...
    '&end=', end_date, ...
    '&format=csv', ... 
    '&header=true'); 

% 3. Fetch Data using readtable (MATLAB's version of pd.read_csv)
disp('Fetching data from NASA POWER API...');

% NASA CSVs have a metadata section at the top. 
% 'NumHeaderLines', 10 tells MATLAB to skip the text description and find the column names.
% If this fails, we try a standard read.
options = weboptions('Timeout', 30);
filename = 'nasa_solar_data.csv';

% Save to file first (safer connection)
websave(filename, url, options);

% Read the file, skipping metadata rows (NASA usually has ~10-15 lines of text)
% We look for the line starting with "YEAR"
data = readtable(filename, 'NumHeaderLines', 0, 'ReadVariableNames', true);

% 4. Clean the Data (Logic similar to pandas dataframe filtering)
% We need to find where the actual data starts if readtable picked up metadata
if ismember('Var1', data.Properties.VariableNames)
     % If headers were missed, reload skipping standard metadata length
     data = readtable(filename, 'NumHeaderLines', 10);
end

% 5. Create Time Vector
% Combine YEAR, MO, DY, HR into a MATLAB datetime
% NASA Hour is usually 0-23
timeVector = datetime(data.YEAR, data.MO, data.DY, data.HR, 0, 0);

% 6. Extract the Solar Column
% Variable name might vary slightly depending on CSV version, usually 'ALLSKY_SFC_SW_DWN'
solar_values = data.ALLSKY_SFC_SW_DWN;

% 7. Create Simscape TimeSeries Object
% We need seconds starting from 0 for the simulation
time_in_seconds = 0:3600:((length(timeVector)-1)*3600);

solar_profile = timeseries(solar_values, time_in_seconds);

% 8. Plot to Verify
figure;
plot(solar_profile);
title(['Solar Irradiance Profile: ', start_date]);
xlabel('Time (Seconds)');
ylabel('Irradiance (W/m^2)');
grid on;

disp('SUCCESS: Real NASA data loaded as "solar_profile"');
disp('You can now open Simscape.');