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




%For temp reading calcs
input_pin = 'A1';
V0 = 0.5; %in V
TC = 0.01; %Temperature coefficient

%LED Output
green_pin = 'D9';
yellow_pin = 'D10';
red_pin = 'D11';

configurePin(a, green_pin, 'DigitalOutput');
configurePin(a, yellow_pin, 'DigitalOutput');
configurePin(a, red_pin, 'DigitalOutput');

temps = [];
times = [];
t_now = 0;
window_size = 5;
prediction_window = 5*60;

while true
    voltage = readVoltage(a, input_pin);
    temp = (voltage - V0) / TC;

    times(end+1) = t_now;
    temps(end+1) = temp;


rate = 0;

if length(temps) >= window_size
  N = min(20, length(temps)); 
  t_fit = times(end-N+1:end);
  temp_fit = temps(end-N+1:end);
  p = polyfit(t_fit, temp_fit, 1);  
  rate = p(1);  
end

rate_per_min = rate * 60;

predicted_temp = temp + (prediction_window * rate);

clc
fprintf('Time: %d s \nTemperature Now: %.2f °C \nTemperature in 5 mins: %.2f °C\nTemperature Rate: %.2f °C/min\n', t_now, temp, predicted_temp, rate_per_min);

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

pause(1);
t_now = t_now+1;

end

end