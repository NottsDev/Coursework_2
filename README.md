These are all the files for the Matlab coursework 2, inlcluding the flow charts & txt files. 
Note: The txt file is needed to be regerated in from the code, as the one commited in git hub presents data spaing 20 seconds (for debugging purposes).

Below are the documentations of the functions in the code (**they are also accessable by using the doc function and the function name in the command window**): 

**Temp Monitor Documentation:**
This function continuously measures the voltage using a thermoresistor connected to an Arduino. It then calculates the temperature, and uses three LEDs to indicate
     - Comfortable temperature -> green LED ON
     - Too Hot -> red LED ON
     - Too Cold -> yellow LED ON

The functions then also produces a live plot of the temperature by creating an empty plot which keeps updating in the loop

The hardware setup includes:
   - The thermoresistor connected to analog pin A1.
   - Green LED connected to digital pin D9.
   - Yellow LED connected to digital pin D10.
   - Red LED connected to digital pin D11.

Constants:
   V0 - Voltage output from the sensor at 0°C (0.5 V).
   TC - Temperature coefficient of the sensor (0.01 V/°C).

Results from the loop:
   - If the temperature is between 18°C to 24°C: Then Green LED is ON.
   - If the temperature exceeds 24°C: Then Red LED is ON.
   - If the temperature is below 18°C: Then Yellow LED is ON.

**Temp Prediction Documentation:**
his function continuously measures the temperature using a thermoresistor connected to an Arduino. It then calculates the rate of temperature change, and predicts the temperature 5 minutes into the future. It uses three LEDs to visually indicate:
     - Stable temperature -> green LED ON
     - Fast temperature increase -> red LED ON
     - Rapid temperature decrease -> yellow LED ON

The prediction is based on a linear regression of the most recent temperature data, which also helps to smooth out local noise so that it does not provide false readings.

The hardware setup includes:
   - The thermoresistor connected to analog pin A1.
   - Green LED connected to digital pin D9.
   - Yellow LED connected to digital pin D10.
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
