function temperature_prediction_model(a)

% Documentation:
% This function continuously measures the temperature using a
% thermoresistor connected to an Arduino. It then calculates the rate of
% temperature change, and predicts the temperature 5 minutes into the
% future. It uses three LEDs to visually indicate:
%     - Stable temperature -> green LED ON
%     - Fast temperature increase -> red LED ON
%     - Rapid temperature decrease -> yellow LED ON
%
%  The prediction is based on a linear regression of the most recent
%  temperature data, which also helps to smooth out local noise so that it
%  does not provide false readings.
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
%   - If the temperature change rate is within ±4°C per minute: Then Green LED is ON.
%   - If the rate exceeds +4°C per minute: Then Red LED is ON.
%   - If the rate goes below -4°C per minute: Then Yellow LED is ON.

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

%Initialize arrays
temps = [];
times = [];
t_now = 0;
window_size = 5; %This will be used to ensure there are enough data points to carry out prediction
prediction_window = 5*60;

% A condition for the loop for it loop infinity or end
power = true;

% The Main Prediction Loop
while power
    % Read time and temperature every second
    voltage = readVoltage(a, input_pin);
    temp = (voltage - V0) / TC;

    %Update arrays
    times(end+1) = t_now;
    temps(end+1) = temp;

    % Initial rate
    rate = 0;

    %Make prediction using a linear regression fit (which also smooths out
    %the data in the short timescale to avoid and false readings
    if length(temps) >= window_size
        N = min(20, length(temps));
        t_fit = times(end-N+1:end);
        temp_fit = temps(end-N+1:end);
        p = polyfit(t_fit, temp_fit, 1);
        rate = p(1);
    end

    %Calculate the rate per minute
    rate_per_min = rate * 60;

    %Make prediction using formula
    predicted_temp = temp + (prediction_window * rate);

    %Clear & update the prediction every loop while printing
    clc
    fprintf('Time: %d s \nTemperature Now: %.2f °C \nTemperature in 5 mins: %.2f °C\nTemperature Rate: %.2f °C/min\n', t_now, temp, predicted_temp, rate_per_min);

    %Logic for the lights bassed on the prediction
    if abs(rate_per_min) < 4
        writeDigitalPin(a, green_pin, 1);
        writeDigitalPin(a, yellow_pin, 0);
        writeDigitalPin(a, red_pin, 0);
    elseif rate_per_min >= 4
        writeDigitalPin(a, green_pin, 0);
        writeDigitalPin(a, yellow_pin, 0);
        writeDigitalPin(a, red_pin, 1);
    elseif rate_per_min <= -4
        writeDigitalPin(a, green_pin, 0);
        writeDigitalPin(a, yellow_pin, 1);
        writeDigitalPin(a, red_pin, 0);
    end

    %Pause every second
    pause(1);
    t_now = t_now+1;

end

end