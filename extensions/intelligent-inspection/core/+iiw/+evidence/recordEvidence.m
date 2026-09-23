function [result, storedRecord] = recordEvidence(record, writer, roleCode, policy)
%RECORDEVIDENCE Validate, seal, and append one generic evidence record.
%   The injected writer is a function handle that returns a logical scalar.
%   scalar. No storage technology or location is assumed by this function.

result = emptyResult();
storedRecord = emptyLocalRecord();

try
    [valid, failureCode] = validateInputs(record, writer, roleCode, policy);
    if ~valid
        result.failureCode = failureCode;
        return
    end

    storedRecord = normalizeRecord(record, policy);
    storedRecord.integrityDigest = calculateDigest(storedRecord);
    externalRecord = makeExternalRecord(storedRecord);

    persisted = writer(storedRecord);
    if ~(islogical(persisted) && isscalar(persisted) && persisted)
        result.failureCode = uint8(7); % WRITE_FAILURE
        storedRecord = emptyLocalRecord();
        return
    end

    result.persistenceSucceeded = true;
    result.failureRecorded = false;
    result.successRecorded = true;
    result.humanReviewRequired = false;
    result.failureCode = uint8(0);
    result.evidenceRecord = externalRecord;
    result.localDigest = storedRecord.integrityDigest;
    result.deletionEligible = ~storedRecord.retentionHold;
catch
    result = emptyResult();
    result.failureCode = uint8(8); % INTERNAL_FAILURE
    storedRecord = emptyLocalRecord();
end
end

function [valid, code] = validateInputs(r, writer, roleCode, policy)
valid = false;
code = uint8(1); % INVALID_INPUT
if ~(isstruct(r) && isscalar(r) && isstruct(policy) && isscalar(policy))
    return
end
if isempty(writer) || ~isa(writer,"function_handle")
    code = uint8(6); % WRITER_UNAVAILABLE
    return
end
if ~(isa(roleCode,"uint8") && isscalar(roleCode) && ismember(roleCode,uint8([1 2 3])))
    code = uint8(5); % ACCESS_DENIED
    return
end
requiredPolicy = ["policyVersion","schemaVersion","defaultRetentionDays"];
if ~all(isfield(policy,requiredPolicy)) || ...
        ~scalarUint(policy.policyVersion,"uint16",false) || ...
        ~scalarUint(policy.schemaVersion,"uint16",false) || ...
        ~scalarUint(policy.defaultRetentionDays,"uint16",false) || ...
        policy.defaultRetentionDays ~= uint16(365)
    code = uint8(2); % INVALID_POLICY
    return
end
required = ["recordId","transactionId","stageId","actorOrComponent", ...
    "inputEvidenceRefs","inputReferenceCount","outputArtifactRef", ...
    "dataVersions","dataVersionCount","modelVersions","modelVersionCount", ...
    "configurationVersions","configurationVersionCount","softwareVersion", ...
    "timestamp","outcome","failureStatus","policyVersion","schemaVersion", ...
    "retentionDays","retentionHold"];
if ~all(isfield(r,required)) || hasProhibitedContent(r)
    return
end
valid = scalarUint(r.recordId,"uint32",false) && ...
    scalarUint(r.transactionId,"uint32",false) && ...
    scalarUint(r.stageId,"uint32",false) && ...
    scalarUint(r.actorOrComponent,"uint32",false) && ...
    fixedArray(r.inputEvidenceRefs,"uint32",[16 1]) && ...
    validCount(r.inputReferenceCount,r.inputEvidenceRefs) && ...
    scalarUint(r.outputArtifactRef,"uint32",false) && ...
    fixedArray(r.dataVersions,"uint16",[16 1]) && ...
    validCount(r.dataVersionCount,r.dataVersions) && ...
    fixedArray(r.modelVersions,"uint16",[16 1]) && ...
    validCount(r.modelVersionCount,r.modelVersions) && ...
    fixedArray(r.configurationVersions,"uint16",[16 1]) && ...
    validCount(r.configurationVersionCount,r.configurationVersions) && ...
    scalarUint(r.softwareVersion,"uint16",false) && ...
    scalarUint(r.timestamp,"uint64",false) && ...
    scalarUint(r.outcome,"uint8",false) && r.outcome <= uint8(6) && ...
    scalarUint(r.failureStatus,"uint8",true) && ...
    scalarUint(r.policyVersion,"uint16",false) && r.policyVersion == policy.policyVersion && ...
    scalarUint(r.schemaVersion,"uint16",false) && r.schemaVersion == policy.schemaVersion && ...
    scalarUint(r.retentionDays,"uint16",true) && ...
    islogical(r.retentionHold) && isscalar(r.retentionHold);
if ~valid
    code = uint8(1);
end
end

function tf = scalarUint(value, className, allowZero)
tf = isa(value,className) && isscalar(value) && isreal(value);
if tf && ~allowZero
    tf = value ~= 0;
end
end

function tf = fixedArray(value, className, expectedSize)
tf = isa(value,className) && isequal(size(value),expectedSize) && isreal(value);
end

function tf = validCount(count, values)
tf = isa(count,"uint8") && isscalar(count) && count <= uint8(16);
if ~tf
    return
end
n = double(count);
tf = all(values(n+1:end) == 0);
if n > 0
    tf = tf && all(values(1:n) ~= 0);
end
end

function tf = hasProhibitedContent(r)
names = lower(string(fieldnames(r)));
prohibited = ["credential","credentials","personalname","secret", ...
    "authenticationtoken","token","rawimage","sensorpayload","rawpayload"];
tf = any(ismember(names,prohibited));
end

function r = normalizeRecord(input, policy)
r = emptyLocalRecord();
fields = string(fieldnames(r));
for k = 1:numel(fields)
    name = fields(k);
    if name ~= "integrityDigest" && isfield(input,name)
        r.(name) = input.(name);
    end
end
if r.retentionDays == 0
    r.retentionDays = policy.defaultRetentionDays;
end
end

function digest = calculateDigest(r)
bytes = uint8([]);
ordered = ["recordId","transactionId","stageId","actorOrComponent", ...
    "inputEvidenceRefs","inputReferenceCount","outputArtifactRef", ...
    "dataVersions","dataVersionCount","modelVersions","modelVersionCount", ...
    "configurationVersions","configurationVersionCount","softwareVersion", ...
    "timestamp","outcome","failureStatus","policyVersion","schemaVersion", ...
    "retentionDays","retentionHold"];
for k = 1:numel(ordered)
    value = r.(ordered(k));
    if islogical(value)
        part = uint8(value(:));
    else
        part = typecast(value(:),"uint8");
    end
    bytes = [bytes; part(:)]; %#ok<AGROW>
end
md = java.security.MessageDigest.getInstance("SHA-256");
md.update(typecast(bytes,"int8"));
digest = reshape(typecast(md.digest(),"uint8"),[32 1]);
end

function out = makeExternalRecord(r)
out = emptyExternalRecord();
out.recordId = r.recordId;
out.eventType = r.outcome;
out.artifactRefs = r.inputEvidenceRefs;
if r.outputArtifactRef ~= 0 && r.inputReferenceCount < 16
    index = double(r.inputReferenceCount) + 1;
    out.artifactRefs(index) = r.outputArtifactRef;
    out.artifactReferenceCount = r.inputReferenceCount + uint8(1);
else
    out.artifactReferenceCount = r.inputReferenceCount;
end
out.dataVersions = r.dataVersions;
out.modelVersions = r.modelVersions;
out.configurationVersions = r.configurationVersions;
out.actorOrComponent = r.actorOrComponent;
out.timestamp = r.timestamp;
out.outcome = r.outcome;
out.integrityMetadata = r.recordId;
out.dataVersionCount = r.dataVersionCount;
out.modelVersionCount = r.modelVersionCount;
out.configurationVersionCount = r.configurationVersionCount;
end

function result = emptyResult()
result = struct( ...
    "persistenceSucceeded",false, ...
    "failureRecorded",true, ...
    "successRecorded",false, ...
    "humanReviewRequired",true, ...
    "failureCode",uint8(1), ...
    "evidenceRecord",emptyExternalRecord(), ...
    "localDigest",zeros(32,1,"uint8"), ...
    "deletionEligible",false);
end

function r = emptyExternalRecord()
r = struct("recordId",uint32(0),"eventType",uint8(0), ...
    "artifactRefs",zeros(16,1,"uint32"), ...
    "dataVersions",zeros(16,1,"uint16"), ...
    "modelVersions",zeros(16,1,"uint16"), ...
    "configurationVersions",zeros(16,1,"uint16"), ...
    "actorOrComponent",uint32(0),"timestamp",uint64(0), ...
    "outcome",uint8(0),"integrityMetadata",uint32(0), ...
    "artifactReferenceCount",uint8(0),"dataVersionCount",uint8(0), ...
    "modelVersionCount",uint8(0),"configurationVersionCount",uint8(0));
end

function r = emptyLocalRecord()
r = struct("recordId",uint32(0),"transactionId",uint32(0), ...
    "stageId",uint32(0),"actorOrComponent",uint32(0), ...
    "inputEvidenceRefs",zeros(16,1,"uint32"),"inputReferenceCount",uint8(0), ...
    "outputArtifactRef",uint32(0),"dataVersions",zeros(16,1,"uint16"), ...
    "dataVersionCount",uint8(0),"modelVersions",zeros(16,1,"uint16"), ...
    "modelVersionCount",uint8(0),"configurationVersions",zeros(16,1,"uint16"), ...
    "configurationVersionCount",uint8(0),"softwareVersion",uint16(0), ...
    "timestamp",uint64(0),"outcome",uint8(0),"failureStatus",uint8(0), ...
    "policyVersion",uint16(0),"schemaVersion",uint16(0), ...
    "retentionDays",uint16(0),"retentionHold",false, ...
    "integrityDigest",zeros(32,1,"uint8"));
end
