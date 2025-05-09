% Dev Bhatt
% egydb6@nottingham.ac.uk

%bathay ma thi ai nikadwanu che

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]
clear
a = arduino('/dev/tty.usbmodem1101', 'uno'); %Initialize arduino

for i = 1:10   % A for which loops 10 times
    writeDigitalPin(a, 'D8', 1);  % Turn LED ON
    pause(0.5);                    % Wait for 0.5 seconds
    writeDigitalPin(a, 'D8', 0);  % Turn LED OFF
    pause(0.5);                    % Wait for 0.5 seconds
end


%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
clear
clc

a = arduino('/dev/tty.usbmodem1101', 'uno'); %Initialize arduino (repeated for section testing)
% Duration in seconds (10 mins) 
% Note: only a 20 second duration was used during testing to speed up the
% process
duration = 600;

% Thermistor parameters from the thermistor data sheet
V0 = 500e-3;      % Voltage at 0°C (volts) (TMP36)
TC = 10e-3;       % Temperature coefficient (V/°C)

% Initialize arrays for time, voltage, and temperature 
% (prelocated for speed)
time = zeros(1, duration);
voltage = zeros(1, duration);
temperature = zeros(1, duration);

% Loop to collect data every second
for t = 1:duration
    time(t) = t;  % Time in seconds
    voltage(t) = readVoltage(a, 'A1');  % Read from analog pin A1
    temperature(t) = (voltage(t) - V0) / TC;  % Converts voltage to temperature
    pause(0.2);  % 0.2 second delay
end

% Calculate statistics
minTemp = min(temperature);
maxTemp = max(temperature);
avgTemp = mean(temperature);

% Ploting figure of Temperature vs Time
figure;
plot(time, temperature, 'r-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Temperature vs Time');
grid on;

% Variables for recording date and location
recordingDate = '05/4/2025';
location = 'Nottingham, UK';

% Print the Header for the command window
fprintf('Data Logging Initiated - %s\n', recordingDate);
fprintf('Location - %s\n\n', location);

% Print each minute's data (every 60 seconds) for the command window
for i = 1:10  
    minute = i - 1;
    temp = temperature(i * 2);  % Temperature at 0s, 60s, 120s and more
    fprintf('Minute\t\t\t%.2f\n', minute)
    fprintf('Temperature\t\t%.2f°C\n\n', temp) 
end

% Print the statistics for the command window
fprintf('Minimum Temperature: %.2f °C\n', minTemp);
fprintf('Maximum Temperature: %.2f °C\n', maxTemp);
fprintf('Average Temperature: %.2f °C\n\n', avgTemp);

fprintf('Data logging terminated');

% Opens a file with writing permission (if one doesn't exists it creates
% one with the same name
fileID = fopen('cabin_temperature.txt', 'w');

% Write header for the file
fprintf(fileID, 'Data Logging Initiated - %s\n', recordingDate);
fprintf(fileID, 'Location: %s\n\n', location);

% Write each line of data for the file
for i = 1:10
    minute = i - 1;
    temp = temperature(i * 2);
    fprintf(fileID, 'Minute\t\t\t%.2f\n', minute);
    fprintf(fileID, 'Temperature\t\t%.2f°C\n\n', temp);
end

fprintf(fileID, 'Data logging terminated');

% Close the file
fclose(fileID);


%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
clear
clc
a = arduino('/dev/tty.usbmodem1101', 'uno');  %Initialize arduino (repeated for section testing)

temp_monitor(a);  %Start monitoring temperature (begin function temp_monitior)


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

clear
clc
a = arduino('/dev/tty.usbmodem1101', 'uno');  %Initialize arduino (repeated for section testing)

temperature_prediction_model(a); 


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% --- Reflective Statement ---

% This project involved having developing Matlab code for an arduino hardware 
% to measure, plot and predict the ambient temperature in a aircraft cabin. 
% Throughout the development process of this project, several challenges 
% were faced such as figuring out the implementation of the prediction model 
% in matlab. Earlier versions of the code involved just using averages over 
% a moving window which wasn't enough. Hence an linear regression fit over 
% a moving data window to smooth out the noise and give an accurate reading 
% was implemented in the code.

% A strength of this project was the successful integration of multiple 
% functionalities together without (for the most part) any bulky code. 
% These features are live data plotting, LED feedback, temperature prediction, 
% and rate-of-change monitoring. Each feature was modular  developed, allowing 
% to make it easier testing and debugging. The code also implements a better 
% real life scenario while setting both the functions main while loops to 
% "power" as in real life they would not be running indefinitely.

% However, there are some limitations. The temperature sensor is very prone 
% to noise, which impacted short-term readings (in all function) and made 
% the prediction less reliable in fluctuating conditions. While basic 
% smoothing such as moving-window regression line were implemented in the code, 
% more sophisticated filtering techniques (like exponential smoothing) could 
% help improve accuracy. 

% For future improvements the LED system could be changed for a more
% comprehensive indication system as it was far too simplistic and required
% two entirely different systems to two task (temperature monitoring and
% predictions), and is in a whole inefficient. Another improvement could be
% to the prediction method, as even with smoothing the prediction is not
% very accurate. The solution here could be in more complicated methods
% such as mathematical model & machine learning.

%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answers here, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order.