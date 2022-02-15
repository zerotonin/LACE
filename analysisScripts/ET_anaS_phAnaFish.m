function [trace,traceResult,newIDX] = ET_anaS_phAnaFish(traceResult,fps,...
                                 expectedAnimals,butterDeg,butterCo,pix2mm)



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
    
    [traceResult(:,1),stillMissing,traceResult(:,4),traceResult(:,5),...
        traceResult(:,2),traceResult(:,3)] = ...
        ET_phA_linearInterpolateMissingDetections(traceResult(:,1),...
        tooFew,expectedAnimals,gca,fps,traceResult(:,4),traceResult(:,5),...
        traceResult(:,2),traceResult(:,3));
    close(h)
    
end

% extract matrices
headP = cell2mat(traceResult(:,4));
tailP =cell2mat(traceResult(:,5));
spine = [traceResult{:,3}]';

% now achieve correct head body situation
bodyVec = abs(bsxfun(@minus,headP,tailP));
bodyLen = arrayfun(@(idx) norm(bodyVec(idx,:)), 1:size(bodyVec,1));
bodyLenThresh = mean(bodyLen)+std(bodyLen)*3;

headPChange = bsxfun(@minus,headP(2:end,:),headP(1:end-1,:));
tailSwap =bsxfun(@minus,headP(1:end-1,:),tailP(2:end,:));
headPChange = arrayfun(@(idx) norm(headPChange(idx,:)), 1:size(headPChange,1));
%tailSwap = arrayfun(@(idx) norm(tailSwap(idx,:)), 1:size(tailSwap,1));

% find head tail swaps
htsPos = find(headPChange > bodyLenThresh);

%correct tail swaps
for i = 1:length(htsPos),
    temp = traceResult(htsPos(i),4);
    traceResult(htsPos(i),4) = traceResult(htsPos(i),5);
    traceResult(htsPos(i),5) = temp;
end

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
else    
    newIDX = 1:size(traceResult,1);
end



%  angle calculation
% body yaw
numSpinePoints = cellfun(@length,spine);
midPoint = ceil(numSpinePoints/4);
midPoint = cell2mat(cellfun(@(x,y) x(y,:),spine,num2cell(midPoint),'UniformOutput',false));
yawVec = bsxfun(@minus,headP,midPoint);
yawBody = atan2(yawVec(:,1),yawVec(:,2));

% correct for  orientation
yawBody = unwrap(yawBody)-pi;

% % head yaw
% midPoint = cell2mat(cellfun(@(x) x(2,:),spine,'UniformOutput',false));
% yawVec = bsxfun(@minus,headP,midPoint);
% yawHead = atan2(yawVec(:,2),yawVec(:,1));
% yawHead = unwrap(yawHead)-pi;

% filter trace
trace = [headP yawBody];
if length(pix2mm) ==1,
    trace(:,1:2) = trace(:,1:2).*pix2mm;
else
    trace(:,1:2) = fliplr(ivT_pix2mm(pix2mm(:,:,1),pix2mm(:,:,2),trace(:,[2 1])));
end

[B,A] = butter(butterDeg,butterCo);
trace = filtfilt(B,A,trace);

% calculate  translational speeds
ts_speed = fliplr(ET_phA_calcAnimalSpeed2D(trace));
% calculate yaw velocity and add translational speeds with yaw to trace
% matrix
trace  = [trace [ts_speed [diff(rad2deg(trace(:,3))) ; NaN]].*fps];
% mm/s -> m/s
trace(:,4:5) = trace(:,4:5)./1000;


