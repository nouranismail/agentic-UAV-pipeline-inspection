classdef test_intelligent_workflow_integration < matlab.unittest.TestCase
    % Integration demonstration for the accepted intelligent-inspection core.

    properties
        RepositoryRoot
    end

    methods (TestClassSetup)
        function configurePaths(testCase)
            folder=fileparts(mfilename("fullpath"));
            root=fileparts(fileparts(folder));
            testCase.RepositoryRoot=string(root);
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
                fullfile(root,"extensions","intelligent-inspection","core")));
            testCase.applyFixture(matlab.unittest.fixtures.PathFixture( ...
                fullfile(root,"extensions","intelligent-inspection", ...
                "demonstrations","integration")));
        end
    end

    methods (Test)
        function IIW_TST_INT_001_stageConnectivity(testCase)
            r=runNominal(testCase);
            testCase.verifyEqual(r.quality.status,uint8(1));
            testCase.verifyNotEmpty(r.processedImage);
            testCase.verifyEqual(r.processedData.sourceItemId,r.quality.itemId);
            testCase.verifyEqual(r.detection.processedItemId, ...
                r.processedData.processedItemId);
            testCase.verifyEqual(r.features.sourceRefs(1),r.detection.resultId);
            testCase.verifyEqual(r.prediction.featureSetId,r.features.featureSetId);
            testCase.verifyEqual(r.risk.assessmentId,uint32(1301));
        end

        function IIW_TST_INT_002_contractConformance(testCase)
            r=runNominal(testCase);
            testCase.verifyTrue(r.featuresValid);
            testCase.verifyTrue(iiw.prediction.validateHealthPrediction(r.prediction));
            testCase.verifyTrue(r.prediction.estimateValid);
            testCase.verifyEqual(r.prediction.estimate,single(72));
            testCase.verifyEqual(r.prediction.uncertainty,single(0.10));
        end

        function IIW_TST_INT_003_qualityStopsDownstreamProcessing(testCase)
            r=run_intelligent_workflow_integration( ...
                testCase.RepositoryRoot,RejectQuality=true);
            testCase.verifyEqual(r.quality.status,uint8(3));
            testCase.verifyEmpty(r.processedImage);
            testCase.verifyEqual(r.detectionStatus,uint8(3));
            testCase.verifyFalse(r.recommendation.forwardingEligible);
        end

        function IIW_TST_INT_004_riskIsAdvisory(testCase)
            r=runNominal(testCase);
            testCase.verifyEqual(r.risk.riskLevel,uint8(2));
            testCase.verifyEqual(r.risk.policyVersion,uint16(1));
            prohibited=["missionCommand","safetyCommand","autonomousAction"];
            testCase.verifyEmpty(intersect(string(fieldnames(r.risk)),prohibited));
        end

        function IIW_TST_INT_005_humanApprovalControlsForwarding(testCase)
            approved=runNominal(testCase);
            rejected=run_intelligent_workflow_integration( ...
                testCase.RepositoryRoot,Approved=false);
            testCase.verifyTrue(approved.approval.forwardingEligible);
            testCase.verifyGreaterThan(approved.recommendation.code,uint8(0));
            testCase.verifyFalse(rejected.approval.forwardingEligible);
            testCase.verifyEqual(rejected.recommendation.code,uint8(0));
        end

        function IIW_TST_INT_006_evidenceChainIsComplete(testCase)
            r=runNominal(testCase);
            testCase.verifyTrue(all([r.evidenceResults.persistenceSucceeded]));
            testCase.verifyTrue(r.evidenceChain.valid);
            testCase.verifyEqual(r.evidenceChain.orphanReferenceCount,uint16(0));
            testCase.verifyEqual( ...
                r.evidenceChain.mandatoryIdentifierFailureCount,uint16(0));
        end

        function IIW_TST_INT_007_repeatability(testCase)
            first=runNominal(testCase);
            second=runNominal(testCase);
            first.processedImage=[];
            second.processedImage=[];
            testCase.verifyEqual(second,first);
        end

        function IIW_TST_INT_008_safetyAndScopeBoundary(testCase)
            r=runNominal(testCase);
            testCase.verifyFalse(r.phase7DeepLearningEnabled);
            testCase.verifyFalse(r.missionSupervisorConnected);
            testCase.verifyTrue(r.demonstrationOnly);
            testCase.verifyTrue(r.recommendation.advisoryOnly);
            source=lower(string(fileread(which( ...
                "run_intelligent_workflow_integration"))));
            prohibited=["returnto"+"home","safe"+"landing","actuatorcommand"];
            testCase.verifyFalse(any(contains(source,prohibited)));
        end
    end
end

function result=runNominal(testCase)
result=run_intelligent_workflow_integration(testCase.RepositoryRoot);
end
