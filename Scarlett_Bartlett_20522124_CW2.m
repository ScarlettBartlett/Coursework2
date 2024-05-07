% Scarlett Bartlett
% egysb11@nottingham.ac.uk
% CW2

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]

clear a; % Clear any previous connections to Arduino
a=arduino("COM3", "Uno"); 

for i=1:20 % This was to repeat the loop 20 times (that can be changed)
    writeDigitalPin(a, 'D10', 1); % Turns LED ON
    pause(0.5); 
    writeDigitalPin(a, 'D10', 0); % Turns LED OFF
    pause(0.5); 
end

clear a; % Clears any connection to Arduino


%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

clear a;
a = arduino("COM3", "Uno");
duration = 600; % 10 minutes in seconds
timeInterval = 1; 

% Create arrays to store data
time = (0:timeInterval:duration); 
voltageValues = zeros(size(time)); 
temperatureValues = zeros(size(time));

% Loop to read voltage values every 1 second for 10 minutes
for i = 1:length(time)
    % Read voltage value from the temperature sensor
    voltage = readVoltage(a, 'A0');
    V_0 = 0.5;

    
    % Convert voltage value to temperature value using TC and V0°C
    temperature = ((voltage*1000)-V_0)/T_c ;  
    % Store data
    voltageValues(i) = voltage;
    temperatureValues(i) = temperature;
    
    % Pause for approximately 1 second
    pause(timeInterval);
end

% Calculate statistical quantities
minTemperature = min(temperatureValues);
maxTemperature = max(temperatureValues);
avgTemperature = mean(temperatureValues);

% Create temperature/time plot
figure;
plot(time, temperatureValues);
xlabel('Time (seconds)');
ylabel('Temperature (°C)');
title('Temperature vs Time');

% Print recorded cabin data 
fprintf('Recorded Cabin Data:\n');
fprintf('---------------------\n');
fprintf('Date: %s\n', 'datetime("Today")'); 
fprintf('Location: Cabin\n');
fprintf('---------------------\n');
for i = 1:length(time)
    fprintf('Minute %d:\tTemperature: %.2f°C\n', (i-1), temperatureValues(i));
end

% Write data to file 'cabin_temperature.txt'
fileID = fopen('cabin_temperature.txt', 'w');
fprintf(fileID, 'Recorded Cabin Data:\n');
fprintf(fileID, '---------------------\n');
fprintf(fileID, 'Date: %s\n', 'datetime("Today")'); 
fprintf(fileID, 'Location: Cabin\n');
fprintf(fileID, '---------------------\n');
for i = 1:length(time)
    fprintf(fileID, 'Minute %d:\tTemperature: %.2f°C\n', (i-1), temperatureValues(i));
end
fclose(fileID); % Closes the file

clear a;

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

y = 'D4'; % All variables re-defined; yellow LED located at channel D4
g = 'D11'; % Green LED located at channel D11
r = 'D13'; % Red LED located at channel D13

a = arduino("COM3","Uno");
c = 0.01;
V = 0.5;
duration = 600; % Duration of temperature recording in seconds
time = zeros(1,duration);
temp = zeros(1,duration);


figure; % Graph for live plotting of temperature against time
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Live Temperature Monitoring');
grid on;


tic; % Start timing
for i = 1:duration
    volt = readVoltage(a, 'A0');
    temp(i) = (volt - V) / c;
    time(i) = toc;

    plot(time(1:i), temp(1:i), 'b');  % Plot live temperature up to given duration
    xlim([0, time(i)]);  % Set x-axis to increase with time
    ylim([0, max(temp)]);  % Set y-axis based on maximum temperature so far
    
    xlabel('Time (s)');
    ylabel('Temperature (°C)');
    title('Live Temperature Monitoring');
    grid on;
    
    drawnow;  % Update the graph

if temp(i) >= 18 && temp(i) <= 24 % Conditions given for green LED to be lit constantly
    writeDigitalPin(a, g, 1);
    writeDigitalPin(a, y, 0);
    writeDigitalPin(a, r, 0);

elseif temp(i) < 18 % Condition given for yellow pin to flash at interval of 0.5s
    writeDigitalPin(a, g, 0);
    writeDigitalPin(a, r, 0);
    blink(a, y, 0.5); % Blink function created for desired LED to flash

else temp(i) > 24; % Condition given for red LED to flash at interval of 0.25s
    writeDigitalPin(a, g, 0);
    writeDigitalPin(a, y, 0);
    blink(a, r, 0.25);
end

end

writeDigitalPin(a, g, 0); % Turn all LEDs off post-recording in the case of any being left on
writeDigitalPin(a, y, 0);
writeDigitalPin(a, r, 0);

%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

a = arduino("COM3, Uno");
duration = 11;
AV = zeros(0,duration);
Time = zeros(0,duration-1);
Time(1) = 1;
for x = 1;duration;
    AV(x) = readVoltage(a, 'A0');
    Time(x+1) = 1 + Time(x);
    pause(0.5);
end
[Temperature,RoC, Prediciton] = temp_prediction (AV, duration, Time);
for i = 1:(duration)
    display = sprintf("Time: %2fs \nCurrent Temperature: %.2f Degrees \nTemperature in 5 minutes: %/.2f");
    disp(display)
end

%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here