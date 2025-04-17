function temp_monitor(a)
% temp_monitor - Live temperature monitoring with LED control and real-time plotting
% a - Arduino object passed from main script

    %Sensor & LED Configuration
    V0 = 0.5;       % Voltage at 0°C (TMP36)
    TC = 0.01;      % Temperature coefficient
    sensorPin = 'A1';
    
    greenPin = 'D9';
    yellowPin = 'D10';
    redPin = 'D11';

    configurePin(a, greenPin, 'DigitalOutput');
    configurePin(a, yellowPin, 'DigitalOutput');
    configurePin(a, redPin, 'DigitalOutput');

    %Initialize Plotting
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
    t_start = tic;

    % Main Monitoring Loop
    while true
        % Read time and temperature
        t_now = round(toc(t_start));
        voltage = readVoltage(a, sensorPin);
        temp = (voltage - V0) / TC;

        % Store data
        t_vals(end+1) = t_now;
        temp_vals(end+1) = temp;

        %Update Plot
        set(h, 'XData', t_vals, 'YData', temp_vals);
        xlim([max(0, t_now - 30), t_now + 5]);  % Show last ~30s
        ylim([min(temp_vals)-1, max(temp_vals)+1]);
        drawnow;

        % Control LEDs Based on Temperature
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

