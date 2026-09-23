function summary = generate_pipeline_degradation_dataset(outputPath)
%GENERATE_PIPELINE_DEGRADATION_DATASET Create frozen synthetic demonstration data.

arguments
    outputPath (1,1) string
end

seed = 20260910;
generatorVersion = "1.1";
groupCount = 100;
days = [0 30 60 90 120 150];
rowsPerGroup = numel(days);
rng(seed,"twister");

groupIds = uint32((1:groupCount).');
keys = strings(groupCount,1);
for k=1:groupCount
    keys(k) = sha256(string(groupIds(k))+":"+string(seed));
end
[~,order] = sort(keys);
partitionByGroup = zeros(groupCount,1,"uint8");
partitionByGroup(order(1:70)) = uint8(1);
partitionByGroup(order(71:85)) = uint8(2);
partitionByGroup(order(86:100)) = uint8(3);

rowCount = groupCount*rowsPerGroup;
features = zeros(rowCount,15,"single");
validity = true(rowCount,15);
targets = zeros(rowCount,1,"single");
rowGroupIds = zeros(rowCount,1,"uint32");
observationDays = zeros(rowCount,1,"uint16");
partitions = zeros(rowCount,1,"uint8");
row = 0;

for groupIndex=1:groupCount
    latentInitial = 0.65*rand;
    dailyProgression = 0.0015*rand;
    priorCount = 0;
    priorHealth = 100;
    maintenanceAge = 0;
    for observationIndex=1:rowsPerGroup
        row = row+1;
        day = days(observationIndex);
        severity = clip(latentInitial+dailyProgression*day,0,1);
        presence = rand < (0.05+0.90*severity);
        confidence = presence*clip(0.50+0.45*severity+0.03*randn,0,1);
        locationAvailableCandidate = rand >= 0.05;
        locationAvailable = presence && locationAvailableCandidate;
        longitudinal = locationAvailable*(double(groupIds(groupIndex))*100+day/30);
        lateral = locationAvailable*(20*sin(double(groupIds(groupIndex))));
        ambient = clip(22+8*sin(2*pi*day/365)+2*randn,-80,80);
        difference = clip(80*severity+5*randn,-160,380);
        surface = clip(ambient+difference,-80,300);
        gas = clip(100000*severity^2+2500*randn,0,1e6);
        pressure = clip(5000*(1-0.30*severity)+100*randn,0,1e5);
        pressureRate = clip(-500*severity+25*randn,-5e4,5e4);
        inspectionAge = double(observationIndex>1)*30;
        if presence, priorCount=priorCount+1; end
        if severity>=0.85, maintenanceAge=0; else, maintenanceAge=maintenanceAge+inspectionAge; end

        f1=presence*confidence; f2=clip(max(difference,0)/100,0,1);
        f3=clip(gas/100000,0,1); f4=clip(abs(pressure-5000)/5000,0,1);
        f5=clip(abs(pressureRate)/1000,0,1); f6=clip(inspectionAge/3650,0,1);
        f7=clip(priorCount/20,0,1); f8=clip((100-priorHealth)/100,0,1);
        f9=clip(maintenanceAge/3650,0,1);
        burden=0.20*f1+0.12*f2+0.12*f3+0.12*f4+0.10*f5+0.06*f6+0.08*f7+0.12*f8+0.08*f9;
        noise=clip(randn,-2,2);
        target=clip(100*(1-burden)-30*(0.02+0.18*burden)+noise,0,100);

        features(row,:) = single([presence confidence locationAvailable longitudinal lateral ...
            surface ambient difference gas pressure pressureRate inspectionAge priorCount priorHealth maintenanceAge]);
        targets(row)=single(target); rowGroupIds(row)=groupIds(groupIndex);
        observationDays(row)=uint16(day); partitions(row)=partitionByGroup(groupIndex);
        priorHealth=target;
    end
end

dataset = struct("generatorVersion",generatorVersion,"seed",uint32(seed), ...
    "featureIds",uint16((101:115).'),"activeFeatureIds",uint16([101;102;103;(106:115).']), ...
    "groupIds",rowGroupIds,"observationDays",observationDays,"partition",partitions, ...
    "features",features,"validity",validity,"targetHealth30Day",targets, ...
    "contextId",uint32(9001),"testEvaluationCount",uint8(0));
save(outputPath,"dataset","-v7.3");
summary=struct("generatorVersion",generatorVersion,"seed",uint32(seed), ...
    "rows",rowCount,"groups",groupCount,"trainRows",sum(partitions==1), ...
    "validationRows",sum(partitions==2),"testRows",sum(partitions==3), ...
    "trainGroups",numel(unique(rowGroupIds(partitions==1))), ...
    "validationGroups",numel(unique(rowGroupIds(partitions==2))), ...
    "testGroups",numel(unique(rowGroupIds(partitions==3))), ...
    "groupOverlapCount",groupOverlapCount(rowGroupIds,partitions), ...
    "invariantViolationCount",sum(features(:,3)==1 & features(:,1)==0));
end

function value=clip(value,minimum,maximum), value=min(max(value,minimum),maximum); end
function count=groupOverlapCount(ids,partitions)
train=unique(ids(partitions==1)); validation=unique(ids(partitions==2)); test=unique(ids(partitions==3));
count=numel(intersect(train,validation))+numel(intersect(train,test))+numel(intersect(validation,test));
end
function value=sha256(text)
digest=java.security.MessageDigest.getInstance("SHA-256");
bytes=digest.digest(uint8(char(text)));
value=lower(join(string(dec2hex(typecast(bytes,"uint8"),2)).',""));
end
