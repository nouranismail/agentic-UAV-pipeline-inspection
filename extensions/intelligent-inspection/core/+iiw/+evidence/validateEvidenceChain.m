function validation = validateEvidenceChain(records, policy)
%VALIDATEEVIDENCECHAIN Validate identifiers, references, and ordering.

validation = emptyValidation();
try
    if ~(isstruct(records) && ~isempty(records) && isstruct(policy) && isscalar(policy) && ...
            isfield(policy,"policyVersion") && isfield(policy,"schemaVersion"))
        return
    end
    ids = [records.recordId];
    validation.duplicateRecordIdCount = uint16(numel(ids)-numel(unique(ids)));
    validation.mandatoryIdentifierFailureCount = uint16(sum(ids == 0));
    adjacency = false(numel(records));
    for recordIndex = 1:numel(records)
        r = records(recordIndex);
        validation.mandatoryIdentifierFailureCount = validation.mandatoryIdentifierFailureCount + ...
            uint16(~mandatoryValid(r,policy));
        if isfield(r,"integrityDigest") && isa(r.integrityDigest,"uint8") && ...
                isequal(size(r.integrityDigest),[32 1]) && ~isequal(r.integrityDigest,calculateDigest(r))
            validation.integrityFailureCount = validation.integrityFailureCount + uint16(1);
        end
        count = double(r.inputReferenceCount);
        refs = r.inputEvidenceRefs(1:count);
        validation.selfReferenceCount = validation.selfReferenceCount + uint16(sum(refs == r.recordId));
        for referenceIndex = 1:numel(refs)
            parent = find(ids == refs(referenceIndex),1);
            if isempty(parent)
                validation.orphanReferenceCount = validation.orphanReferenceCount + uint16(1);
            else
                adjacency(recordIndex,parent) = true;
                if records(parent).transactionId ~= r.transactionId || records(parent).stageId >= r.stageId
                    validation.incorrectStageOrderCount = validation.incorrectStageOrderCount + uint16(1);
                end
            end
        end
    end
    validation.circularReferenceCount = uint16(hasCycle(adjacency));
    validation.unresolvedReferenceCount = validation.orphanReferenceCount;
    validation.valid = validation.duplicateRecordIdCount == 0 && ...
        validation.mandatoryIdentifierFailureCount == 0 && ...
        validation.orphanReferenceCount == 0 && validation.selfReferenceCount == 0 && ...
        validation.circularReferenceCount == 0 && validation.incorrectStageOrderCount == 0 && ...
        validation.integrityFailureCount == 0;
    if validation.valid
        validation.failureCode = uint8(0);
    else
        validation.failureCode = uint8(3); % INVALID_CHAIN
    end
catch
    validation = emptyValidation();
    validation.failureCode = uint8(8); % INTERNAL_FAILURE
end

function tf = hasCycle(adjacency)
nodeCount = size(adjacency,1);
reachable = logical(adjacency);
for pivotIndex = 1:nodeCount
    for sourceIndex = 1:nodeCount
        if reachable(sourceIndex,pivotIndex)
            for targetIndex = 1:nodeCount
                reachable(sourceIndex,targetIndex) = reachable(sourceIndex,targetIndex) || ...
                    reachable(pivotIndex,targetIndex);
            end
        end
    end
end
tf = any(diag(reachable));
end

function digest = calculateDigest(r)
bytes = uint8([]);
ordered = ["recordId","transactionId","stageId","actorOrComponent", ...
    "inputEvidenceRefs","inputReferenceCount","outputArtifactRef", ...
    "dataVersions","dataVersionCount","modelVersions","modelVersionCount", ...
    "configurationVersions","configurationVersionCount","softwareVersion", ...
    "timestamp","outcome","failureStatus","policyVersion","schemaVersion", ...
    "retentionDays","retentionHold"];
for fieldIndex = 1:numel(ordered)
    if ~isfield(r,ordered(fieldIndex))
        digest = zeros(32,1,"uint8");
        return
    end
    value = r.(ordered(fieldIndex));
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
end

function tf = mandatoryValid(r,policy)
required = ["recordId","transactionId","stageId","actorOrComponent", ...
    "inputEvidenceRefs","inputReferenceCount","outputArtifactRef", ...
    "softwareVersion","timestamp","outcome","policyVersion","schemaVersion", ...
    "retentionDays","integrityDigest"];
tf = all(isfield(r,required));
if ~tf
    return
end
tf = isa(r.recordId,"uint32") && isscalar(r.recordId) && r.recordId ~= 0 && ...
    isa(r.transactionId,"uint32") && isscalar(r.transactionId) && r.transactionId ~= 0 && ...
    isa(r.stageId,"uint32") && isscalar(r.stageId) && r.stageId ~= 0 && ...
    isa(r.actorOrComponent,"uint32") && isscalar(r.actorOrComponent) && r.actorOrComponent ~= 0 && ...
    isa(r.inputEvidenceRefs,"uint32") && isequal(size(r.inputEvidenceRefs),[16 1]) && ...
    isa(r.inputReferenceCount,"uint8") && isscalar(r.inputReferenceCount) && r.inputReferenceCount <= 16 && ...
    isa(r.outputArtifactRef,"uint32") && isscalar(r.outputArtifactRef) && r.outputArtifactRef ~= 0 && ...
    isa(r.softwareVersion,"uint16") && isscalar(r.softwareVersion) && r.softwareVersion ~= 0 && ...
    isa(r.timestamp,"uint64") && isscalar(r.timestamp) && r.timestamp ~= 0 && ...
    isa(r.outcome,"uint8") && isscalar(r.outcome) && r.outcome >= 1 && r.outcome <= 6 && ...
    isa(r.policyVersion,"uint16") && isscalar(r.policyVersion) && r.policyVersion == policy.policyVersion && ...
    isa(r.schemaVersion,"uint16") && isscalar(r.schemaVersion) && r.schemaVersion == policy.schemaVersion && ...
    isa(r.retentionDays,"uint16") && isscalar(r.retentionDays) && r.retentionDays ~= 0 && ...
    isa(r.integrityDigest,"uint8") && isequal(size(r.integrityDigest),[32 1]) && any(r.integrityDigest ~= 0);
end

function v = emptyValidation()
v = struct("valid",false,"orphanReferenceCount",uint16(0), ...
    "selfReferenceCount",uint16(0),"duplicateRecordIdCount",uint16(0), ...
    "circularReferenceCount",uint16(0),"incorrectStageOrderCount",uint16(0), ...
    "integrityFailureCount",uint16(0), ...
    "mandatoryIdentifierFailureCount",uint16(0), ...
    "unresolvedReferenceCount",uint16(0),"failureCode",uint8(1));
end
