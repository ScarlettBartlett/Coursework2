function temp_monitor
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
end