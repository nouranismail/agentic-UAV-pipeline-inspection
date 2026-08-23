clearvars;
clc;

projectRoot = 'C:\Users\Nouran Ismail\Documents\GitHub\agentic-UAV-pipeline-inspection';

requiredFolders = [
    fullfile(projectRoot, "models")
    fullfile(projectRoot, "data")
    fullfile(projectRoot, "tests")
    fullfile(projectRoot, "scripts")
    fullfile(projectRoot, "reports")
];

for i = 1:numel(requiredFolders)
    if ~isfolder(requiredFolders(i))
        mkdir(requiredFolders(i));
    end
end

dictionaryFile = fullfile(projectRoot, "models", "uav_mission_supervisor.sldd");
if isfile(dictionaryFile)
    dictionary = Simulink.data.dictionary.open(dictionaryFile);
else
    dictionary = Simulink.data.dictionary.create(dictionaryFile);
end
cleanupObj = onCleanup(@() close(dictionary));

sec = getSection(dictionary, "Design Data");

p1 = Simulink.Parameter(25.0);
p1.DataType = 'double';
p1.Unit = 'percent';

p2 = Simulink.Parameter(10.0);
p2.DataType = 'double';
p2.Unit = 'percent';

if isempty(find(sec, 'Name', 'Battery_Threshold_Low'))
    addEntry(sec, 'Battery_Threshold_Low', p1);
else
    setValue(find(sec, 'Name', 'Battery_Threshold_Low'), 25.0);
end

if isempty(find(sec, 'Name', 'Battery_Threshold_Critical'))
    addEntry(sec, 'Battery_Threshold_Critical', p2);
else
    setValue(find(sec, 'Name', 'Battery_Threshold_Critical'), 10.0);
end

saveChanges(dictionary);
disp('UAV Mission Supervisor data dictionary initialized successfully!');