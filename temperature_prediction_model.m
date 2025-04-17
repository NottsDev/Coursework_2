function temperature_prediction_model(a)

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