% Dev Bhatt
% egydb6@nottingham.ac.uk

%bathay ma thi ai nikadwanu che

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]
clear
a = arduino('/dev/tty.usbmodem1101', 'uno');

for i = 1:10   % Blinks 10 times
    writeDigitalPin(a, 'D8', 1);  % Turn LED ON
    pause(0.5);                    % Wait for 0.5 seconds
    writeDigitalPin(a, 'D8', 0);  % Turn LED OFF
    pause(0.5);                    % Wait for 0.5 seconds
end


%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
clear
clc

a = arduino('/dev/tty.usbmodem1101', 'uno');
% Duration in seconds
duration = 20;

% Thermistor parameters (example values – adjust based on your datasheet)
V0 = 500e-3;      % Voltage at 0°C in volts (adjust this)
TC = 10e-3;     % Temperature coefficient in V/°C (e.g., 10mV/°C)

% Initialize arrays for time, voltage, and temperature
time = zeros(1, duration);
voltage = zeros(1, duration);
temperature = zeros(1, duration);

% Loop to collect data every second
for t = 1:duration
    time(t) = t;  % Time in seconds
    voltage(t) = readVoltage(a, 'A1');  % Read from analog pin A1
    temperature(t) = (voltage(t) - V0) / TC;  % Convert voltage to temperature
    pause(0.2);  % 1 second delay
end

% Calculate statistics
minTemp = min(temperature);
maxTemp = max(temperature);
avgTemp = mean(temperature);

figure;
plot(time, temperature, 'r-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Temperature vs Time');
grid on;

% Example metadata
recordingDate = '05/4/2025';
location = 'Nottingham, UK';

% Print header
fprintf('Data Logging Initiated - %s\n', recordingDate);
fprintf('Location - %s\n\n', location);

% Print each minute's data (every 60 seconds)
for i = 1:10  % Adjust range if needed
    minute = i - 1;
    temp = temperature(i * 2);  % Temperature at 0s, 60s, 120s, etc.
    fprintf('Minute\t\t\t%.2f\n', minute)
    fprintf('Temperature\t\t%.2f°C\n\n', temp) % Double tab for alignment
end

% Print results
fprintf('Minimum Temperature: %.2f °C\n', minTemp);
fprintf('Maximum Temperature: %.2f °C\n', maxTemp);
fprintf('Average Temperature: %.2f °C\n\n', avgTemp);

fprintf('Data logging terminated');

% Open the file with write permission
fileID = fopen('cabin_temperature.txt', 'w');

% Write header
fprintf(fileID, 'Data Logging Initiated - %s\n', recordingDate);
fprintf(fileID, 'Location: %s\n\n', location);

% Write each line of data
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
a = arduino('/dev/tty.usbmodem1101', 'uno');  % Or your specific setup like: arduino('COM4', 'Uno');

temp_monitor(a);  % Start monitoring temperature


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

clear
clc
a = arduino('/dev/tty.usbmodem1101', 'uno');  % Or your specific setup like: arduino('COM4', 'Uno');

temperature_prediction_model(a); 


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert reflective statement here (400 words max)


%% TASK 5 - COMMENTING, VERSION CONTROL AND PROFESSIONAL PRACTICE [15 MARKS]

% No need to enter any answershere, but remember to:
% - Comment the code throughout.
% - Commit the changes to your git repository as you progress in your programming tasks.
% - Hand the Arduino project kit back to the lecturer with all parts and in working order.