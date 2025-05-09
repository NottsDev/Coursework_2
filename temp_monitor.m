function temp_monitor(a)
% Documentation:
% This function continuously measures the voltage using a
% thermoresistor connected to an Arduino. It then calculates the temperature,
% and uses three LEDs to indicate
%     - Comfortable temperature -> green LED ON
%     - Too Hot -> red LED ON
%     - Too Cold -> yellow LED ON
%
% The functions then also produces a live plot of the temperature by creating
% an empty plot which keeps updating in the loop
%
% The hardware setup includes:
%   - The thermoresistor connected to analog pin A1.
%   - Green LED connected to digital pin D9.
%   - Yellow LED connected to digital pin D10.
%   - Red LED connected to digital pin D11.
%
% Constants:
%   V0 - Voltage output from the sensor at 0°C (0.5 V).
%   TC - Temperature coefficient of the sensor (0.01 V/°C).
%
% Results from the loop:
%   - If the temperature is between 18°C to 24°C: Then Green LED is ON.
%   - If the temperature exceeds 24°C: Then Red LED is ON.
%   - If the temperature is below 18°C: Then Yellow LED is ON.

%Sensor & LED Configuration
V0 = 0.5;       % Voltage at 0°C (Volts)(TMP36)
TC = 0.01;      % Temperature coefficient (V/°C)
sensorPin = 'A1';

greenPin = 'D9';
yellowPin = 'D10';
redPin = 'D11';

% Configure pins

configurePin(a, greenPin, 'DigitalOutput');
configurePin(a, yellowPin, 'DigitalOutput');
configurePin(a, redPin, 'DigitalOutput');

%Initialize Plotting for speed and memory
figure;
h = plot(NaN, NaN, 'b.-');  % Empty plot
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Live Temperature Monitoring');
grid on;
hold on;

% Initialize data arrays
t_vals = [];
temp_vals = [];
t_start = tic; %for time keeping


% A condition for the loop for it do infinity or end
power = true;


% The Main Monitoring Loop
while power
    % Read time and temperature every second
    t_now = round(toc(t_start));
    voltage = readVoltage(a, sensorPin);
    temp = (voltage - V0) / TC;

    % Store data in the empty arrays
    t_vals(end+1) = t_now;
    temp_vals(end+1) = temp;

    %Update Plot with the draw now function
    set(h, 'XData', t_vals, 'YData', temp_vals);
    xlim([max(0, t_now - 30), t_now + 5]);  % Show last only the ~30s
    ylim([min(temp_vals)-1, max(temp_vals)+1]); % Show only a small range of values around the actual temp
    drawnow;

    % Set all LEDs to zero
    writeDigitalPin(a, greenPin, 0);
    writeDigitalPin(a, yellowPin, 0);
    writeDigitalPin(a, redPin, 0);

    if temp < 18
        % Blink yellow LED at 0.5s intervals
        writeDigitalPin(a, yellowPin, 1);
        pause(0.25);
        writeDigitalPin(a, yellowPin, 0);
        pause(0.25);
    elseif temp >= 18 && temp <= 24
        % Constant green LED
        writeDigitalPin(a, greenPin, 1);
        pause(1);  % Graph refresh rate
    else
        % Blink red LED at 0.25s intervals (blink twice per second)
        for i = 1:2  % Fit two blinks in ~1 sec
            writeDigitalPin(a, redPin, 1);
            pause(0.125);
            writeDigitalPin(a, redPin, 0);
            pause(0.125);
        end
    end
end
end

