function [strokePeaks,sumAngle,acc] = FMA_BA_strokeBendAnalysis(analysedData,metaData)

% calculate accumulated Angle for each frame

sumAngle = real(cellfun(@(x)  sum(180+x(2:end,2).*-1), analysedData.bendability));
nanIndices = find(isnan(sumAngle));
for i = 1:length(nanIndices)
    if nanIndices(i) ==1,
        if isnan(sumAngle(2))
            sumAngle(1) = 0;
        else
            sumAngle(1) =sumAngle(2);
        end
    elseif nanIndices(i) == length(sumAngle),
        sumAngle(end) =sumAngle(end-1);
    else
        sumAngle(nanIndices(i)) = sumAngle(nanIndices(i)-1);
    end
end
% filter this value
[B,A] = butter(2,0.1);
sumAngleF = filtfilt(B,A,sumAngle);

% calculate thrust accelerati
acc = [diff(analysedData.trace(:,4)); 0].*metaData.fps;

% calculate mix form
%strokeFinder = bsxfun(@times,acc,sumAngleF);
%find peaks
[~,strokePos] = findpeaks(sumAngleF,'MinPeakHeight',20,'MinPeakDistance',20);
% choose those that allow for acceleration analysis
strokeHalfWin = metaData.fps/10;
%strokePos = strokePos(strokePos > strokeHalfWin & strokePos <length(acc)-strokeHalfWin);
strokePos = strokePos( strokePos <length(acc)-(strokeHalfWin*2+1));

% find acceleration peaks around stroke peakx
accPeaks = arrayfun(@(x) findpeaks(acc(x:x+strokeHalfWin*2),'SortStr','descend','npeaks',1),strokePos,'UniformOutput',false);
%sumAnglePeaks = arrayfun(@(x) findpeaks(abs(sumAngleF(x-strokeHalfWin:x+strokeHalfWin)),'SortStr','descend','npeaks',1),strokePos,'UniformOutput',false);
sumAnglePeaks = num2cell(sumAngleF(strokePos));

% the findpeaks algorithm might not find a peak by eliminiating empty cells
% we filter such events
logIDX =~cellfun(@isempty,sumAnglePeaks) & ~cellfun(@isempty,accPeaks);
sumAnglePeaks = cell2mat(sumAnglePeaks(logIDX));
accPeaks = cell2mat(accPeaks(logIDX));


strokePeaks = [sumAnglePeaks accPeaks];
