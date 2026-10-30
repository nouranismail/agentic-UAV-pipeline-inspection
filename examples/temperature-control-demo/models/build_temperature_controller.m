function modelPath = build_temperature_controller(projectRoot)
%BUILD_TEMPERATURE_CONTROLLER Generate the reuse-demonstration model.
%
% modelPath = build_temperature_controller(projectRoot) creates
% temperature_controller.slx beneath projectRoot/models.

arguments
    projectRoot (1,1) string
end

modelName = "temperature_controller";
modelFolder = fullfile(projectRoot,"models");
modelPath = fullfile(modelFolder,modelName + ".slx");

if ~isfolder(modelFolder)
    mkdir(modelFolder);
end

if bdIsLoaded(modelName)
    close_system(modelName,0);
end

new_system(modelName);
cleanup = onCleanup(@()closeIfLoaded(modelName));

set_param(modelName, ...
    "SolverType","Fixed-step", ...
    "Solver","FixedStepDiscrete", ...
    "FixedStep","1", ...
    "StopTime","0", ...
    "SaveOutput","on", ...
    "OutputSaveName","yout", ...
    "SaveFormat","Dataset");

add_block("simulink/Sources/In1",modelName + "/temperatureC", ...
    "Position",[40 95 80 115], ...
    "OutDataTypeStr","double");

add_block("simulink/Logic and Bit Operations/Compare To Constant", ...
    modelName + "/BelowHeatingThreshold", ...
    "Position",[175 45 335 85], ...
    "relop","<", ...
    "const","18");

add_block("simulink/Logic and Bit Operations/Compare To Constant", ...
    modelName + "/HighTemperatureThreshold", ...
    "Position",[175 135 335 175], ...
    "relop",">=", ...
    "const","35");

add_block("simulink/Sinks/Out1",modelName + "/heaterRequest", ...
    "Position",[445 55 485 75]);

add_block("simulink/Sinks/Out1",modelName + "/highTemperatureAlarm", ...
    "Position",[445 145 485 165]);

add_line(modelName,"temperatureC/1","BelowHeatingThreshold/1", ...
    "autorouting","on");
add_line(modelName,"temperatureC/1","HighTemperatureThreshold/1", ...
    "autorouting","on");

heaterLine = add_line(modelName,"BelowHeatingThreshold/1", ...
    "heaterRequest/1","autorouting","on");
alarmLine = add_line(modelName,"HighTemperatureThreshold/1", ...
    "highTemperatureAlarm/1","autorouting","on");

set_param(heaterLine,"Name","heaterRequest");
set_param(alarmLine,"Name","highTemperatureAlarm");

Simulink.BlockDiagram.arrangeSystem(modelName);
set_param(modelName,"SimulationCommand","update");
save_system(modelName,modelPath);
close_system(modelName,0);
clear cleanup
end

function closeIfLoaded(modelName)
if bdIsLoaded(modelName)
    close_system(modelName,0);
end
end
