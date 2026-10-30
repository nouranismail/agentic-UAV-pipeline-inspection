 %% Test UAV Supervisory Decision-Making Logic
% This script simulates the "brain" decisions based purely on sensor inputs 
% (Battery and Mission Flags), proving reusability without any physical plant/drone dynamics.

clear; clc;

disp('--- Starting UAV Mission Supervisor Logic Test ---');

% Simulate a sequence of mission telemetry data over time [Battery %, Anomaly Detected]
timeSteps = [
    100.0, 0;  % Start of mission: Full battery, no critical issues
     75.0, 0;  % Inspecting pipeline normally
     24.5, 0;  % Battery drops below 25% low threshold -> Should trigger RTH
     24.0, 1;  % Still returning home, pipeline anomaly noted
      9.5, 1;  % Battery drops below 10% critical threshold -> Should trigger Safe Landing
];

% Load thresholds (mocking our .sldd data dictionary values)
batteryLow = 25.0;
batteryCritical = 10.0;

currentMode = "Normal_Inspection";

for t = 1:size(timeSteps, 1)
    batteryLevel = timeSteps(t, 1);
    anomalyFlag  = timeSteps(t, 2);
    
    fprintf('\n[Telemetry Update] Battery: %.1f%% | Anomaly Detected: %d\n', batteryLevel, anomalyFlag);
    
    % Supervisory State Decision Logic (Reusable Brain)
    switch currentMode
        case "Normal_Inspection"
            if batteryLevel <= batteryCritical
                currentMode = "Safe_Landing";
            elseif batteryLevel <= batteryLow
                currentMode = "Return_to_Home";
            else
                currentMode = "Normal_Inspection";
            end
            
        case "Return_to_Home"
            if batteryLevel <= batteryCritical
                currentMode = "Safe_Landing";
            else
                currentMode = "Return_to_Home";
            end
            
        case "Safe_Landing"
            currentMode = "Safe_Landing"; % Terminal state
    end
    
    fprintf('--> Supervisor Decision / Mode: %s\n', currentMode);
end

disp('--- Logic Test Completed Successfully ---');