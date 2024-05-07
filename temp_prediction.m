function [Temperature, RoC, Prediction] = temp_prediction (AV, duration, Time)
RoC = zeros(1,duration);
Prediction = zeros(1,duration);
Temperature =[];
Tc = 0.01;
V0 = 0.5;
for a = 1:duration
    Temperature = (AV - V0)/Tc;
end
RoC(1) = 0;
for b = 1:duration - 1
    RoC(b) = Temperature(b+1) - Temperature(b)/(Time(b+1)/Time(b));
    Prediction(b) = (RoC(b) *300) + Temperature(b);
end
