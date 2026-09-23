classdef test_temperature_controller < matlab.unittest.TestCase

    properties
        ProjectRoot (1,1) string
    end

    methods (TestClassSetup)
        function buildModel(testCase)
            testFolder = fileparts(mfilename("fullpath"));
            testCase.ProjectRoot = string(fileparts(testFolder));
            addpath(fullfile(testCase.ProjectRoot,"models"));
            build_temperature_controller(testCase.ProjectRoot);
        end
    end

    methods (TestClassTeardown)
        function closeModel(~)
            if bdIsLoaded("temperature_controller")
                close_system("temperature_controller",0);
            end
        end
    end

    methods (Test)
        function temperature10(testCase)
            testCase.verifyCase(10,true,false);
        end

        function temperature17(testCase)
            testCase.verifyCase(17,true,false);
        end

        function temperature17Point9(testCase)
            testCase.verifyCase(17.9,true,false);
        end

        function temperature18(testCase)
            testCase.verifyCase(18,false,false);
        end

        function temperature25(testCase)
            testCase.verifyCase(25,false,false);
        end

        function temperature34Point9(testCase)
            testCase.verifyCase(34.9,false,false);
        end

        function temperature35(testCase)
            testCase.verifyCase(35,false,true);
        end

        function temperature40(testCase)
            testCase.verifyCase(40,false,true);
        end
    end

    methods
        function verifyCase(testCase,temperatureC,expectedHeater,expectedAlarm)
            modelPath = fullfile(testCase.ProjectRoot,"models", ...
                "temperature_controller.slx");
            load_system(modelPath);

            inputData = timeseries(temperatureC,0);
            simInput = Simulink.SimulationInput("temperature_controller");
            simInput = simInput.setExternalInput(inputData);
            simInput = simInput.setModelParameter( ...
                "StopTime","0", ...
                "SaveOutput","on", ...
                "OutputSaveName","yout", ...
                "SaveFormat","Dataset");

            simOutput = sim(simInput);
            heater = simOutput.yout.getElement("heaterRequest").Values.Data;
            alarm = simOutput.yout.getElement( ...
                "highTemperatureAlarm").Values.Data;

            testCase.verifyEqual(logical(heater(end)),logical(expectedHeater));
            testCase.verifyEqual(logical(alarm(end)),logical(expectedAlarm));
        end
    end
end
