function [trace,traceResult,newIDX] = ET_anaS_phAnaFish(traceResult,fps,...
                        expectedAnimals,butterDeg,butterCo,pix2mm,yawCorr)


%yawCorr 
if ~exist('yawCorr','var')
    yawCorr =1;
end

% check if the correct number of animals where found
[tooMany,tooFew]= ET_phA_fdfByAnimalNumber(traceResult(:,1),expectedAnimals);

if ~isempty(tooMany),
    disp('help')
    pause()
    [traceResult(:,1),falseDetID] = ...
        ET_phA_removeAnimalManually(traceResult(:,1),tooMany,expectedAnimals,fPos);
end

if ~isempty(tooFew),
     h= figure();
    
    [traceResult(:,1),stillMissing,traceResult(:,5),traceResult(:,6)] = ...
        ET_phA_linearInterpolateMissingDetections(traceResult(:,1),tooFew,...
                expectedAnimals,gca,fps,traceResult(:,5),traceResult(:,6));
    close(h)
    
end

% extract matrices
if size(traceResult,2) > 5
    traceResult(:,5) = cellfun(@(x) x(1,:), traceResult(:,5),'UniformOutput',false);
    traceResult(:,6) = cellfun(@(x) x(1,:), traceResult(:,6),'UniformOutput',false);
    traceResult(:,4) = [];
end

emptyTR = cellfun(@isempty,traceResult);

if sum(sum(emptyTR)) ~= 0,
    warndlg('animals are still missing in some frames!')
    traceResult(emptyTR(:,5),5) = {[NaN,NaN]};
    traceResult(emptyTR(:,4),4) = {[NaN,NaN]};
    traceResult(emptyTR(:,3),3) = {repmat({NaN,NaN},expectedAnimals,1)};
    traceResult(emptyTR(:,2),2) = {repmat({NaN,NaN},expectedAnimals,1)};
    traceResult(emptyTR(:,1),1) = {NaN(expectedAnimals,13)};
end

headP = cell2mat(traceResult(:,4));
tailP =cell2mat(traceResult(:,5));
%spine = [traceResult{:,3}]';

% now achieve correct head body situation
bodyVec = abs(bsxfun(@minus,headP,tailP));
bodyLen = arrayfun(@(idx) norm(bodyVec(idx,:)), 1:size(bodyVec,1));
bodyLenThresh = nanmean(bodyLen)+nanstd(bodyLen)*3;

headPChange = bsxfun(@minus,headP(2:end,:),headP(1:end-1,:));
tailSwap =bsxfun(@minus,headP(1:end-1,:),tailP(2:end,:));
headPChange = arrayfun(@(idx) norm(headPChange(idx,:)), 1:size(headPChange,1));
% find broken Round Robins
brrPos = find(headPChange > bodyLenThresh*1.5);

%correct round robin breaks
if length(brrPos) ==1,
    traceResult= [traceResult(brrPos+1:end,:);traceResult(1:brrPos,:)];
    Htrace = cell2mat(traceResult(:,1));
    headP = cell2mat(traceResult(:,4));
    tailP =cell2mat(traceResult(:,5));
    spine = [traceResult{:,3}]';
    newIDX = [brrPos+1:size(traceResult,1) 1:brrPos];
elseif length(brrPos) >1,
    errordlg('This is weird I found more than one Round Robin Movie Break!')
    newIDX = [brrPos(1)+1:size(traceResult,1) 1:brrPos(1)];
    Htrace = cell2mat(traceResult(:,1));
    headP = cell2mat(traceResult(:,4));
    tailP =cell2mat(traceResult(:,5));
    spine = [traceResult{:,3}]';
    newIDX = [brrPos+1:size(traceResult,1) 1:brrPos];    
else    
    newIDX = 1:size(traceResult,1);
    Htrace = cell2mat(traceResult(:,1));
    headP = cell2mat(traceResult(:,4));
    tailP =cell2mat(traceResult(:,5));
    spine = [traceResult{:,3}]';
end



%  angle calculation
% body yaw
yaw = deg2rad(Htrace(:,5));
if yawCorr ==1,
    yaw = ET_phA_unwrapEllipseAngle(yaw,pi*0.5);
end

% compile position and orientation
trace = [Htrace(:,[2 1]) yaw];


%pixel -> mm
trace(:,1:2) = trace(:,1:2).*pix2mm;

% filter trace
[B,A] = butter(butterDeg,butterCo);
trace = filtfilt(B,A,trace);

% calculate  translational speeds
ts_speed = ET_phA_calcAnimalSpeed2D(trace);

% calculate yaw velocity and add translational speeds with yaw to trace
% matrix
% fliplr is inserted because the trace in line 88 is flipped dimensionaly
trace  = [trace [fliplr(ts_speed) [diff(rad2deg(trace(:,3))) ; NaN]].*fps];

% mm/s -> m/s
trace(:,4:5) = trace(:,4:5)./1000;


