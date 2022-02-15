function [bendSweetSpot,bendSweetSpot2,bendSweetSpotMat,data,data2,logIDX] = FMA_BA_probDenseUT(ROI,thrustThresh,analysedData)

% ROI
[in,on] = inpolygon(analysedData.trace(:,2),analysedData.trace(:,1),ROI(:,1),ROI(:,2));
% categoriser
[~,idxT,~,~] = FMA_manCategoriser( analysedData.trace, analysedData.saccs,thrustThresh);
%combine
logIDX = ~idxT ;%& (in | on);
if sum(logIDX) ~=0
    % calculate density probability
    bendSweetSpot = analysedData.traceResult(logIDX,3);
    bendSweetSpot = [bendSweetSpot{:}]';
    bendSweetSpot = cellfun(@(x) bsxfun(@minus,x,x(1,:)),bendSweetSpot,'UniformOutput',false);
    angle = cellfun(@(x) atan2(x(3,2),x(3,1)),bendSweetSpot,'UniformOutput',false);
    rotMat = cellfun(@(x) getFickmatrix(x,0,0,'a'),angle,'UniformOutput',false);
    bendSweetSpot2 = cellfun(@(x,y) [x zeros(size(x,1),1)]*y,bendSweetSpot,rotMat,'UniformOutput',false);
    bendSweetSpot2 = cellfun(@(x) bsxfun(@minus,x,x(1,:)),bendSweetSpot2,'UniformOutput',false);
    fishLen = cellfun(@(x) norm(x(:,1:2)),bendSweetSpot2,'UniformOutput',false);
    bendSweetSpot2 =cellfun(@(x,y) x(:,1:2)./y,bendSweetSpot2,fishLen,'UniformOutput',false);
    bendSweetSpotMat = cell2mat(bendSweetSpot2);
    data = hist2d(bendSweetSpotMat(:,1:2),0:.01:1,-0.2:.01:.2);
    data2 = bsxfun(@plus,data(:,1:20),fliplr(data(:,21:40)));
else
    bendSweetSpot=NaN;
    bendSweetSpot2=NaN;
    bendSweetSpotMat=NaN;
    data=NaN;
    data2=NaN;
end
    