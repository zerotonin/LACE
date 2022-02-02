function [stitchedAna,stitchedMeta] = ET_pha_stitchFishParts(fPos)
% This function of the Ethotrack posthoc analysis toolbox (ET_phA_)
% concatenates and recalculates values for splitted analysis. It
% recalculates bendability and velocity values and concatenates traces,
% saccades and matlab file positions. Values that were ommitted by the user 
% have now NaN values
%
% GETS:
%       fPos = cellstring with the absolute filepositions of the files to
%              be stitched together
%
% RETURNS:
%           stitchedAna  = stitched back analyses file
%           stitchedMeta = stitched back meta data
%
% SYNTAX: [stitchedAna,stitchedMeta] = ET_pha_stitchFishParts(fPos); 
%
% Author: B.Geurten 02.05.2016
% 
% Notes:
% This might only work for Zebrafishes!
%
% see also FILA_ana_getSpine



%load data
load(fPos{1});
stitchedAna = analysedData;
stitchedMeta = metaData;
stitchedMeta.matFilePos = {stitchedMeta.matFilePos};
for j =2:length(fPos),
    load(fPos{j});
    % traceResult is kept
    % trace has to be fused
    nanIDX = [ ~isnan(stitchedAna.trace(:,1)) ~isnan(analysedData.trace(:,1))];
    nanIDX2 = sum(nanIDX,2)== 0;
    stitchedAna.trace = nansum(cat(3,analysedData.trace,stitchedAna.trace),3);
    stitchedAna.trace(nanIDX2,:) = NaN;
    % bendability has to be  fused
    newBendAngles = repmat({NaN(10,2)},length(analysedData.bendability),1);
    newBendAngles(nanIDX(:,1)) = stitchedAna.bendability(nanIDX(:,1));
    newBendAngles(nanIDX(:,2)) = analysedData.bendability(nanIDX(:,2));
    stitchedAna.bendability = newBendAngles;
    %saccs
    stitchedAna.saccs = [stitchedAna.saccs;analysedData.saccs];
    stitchedMeta.matFilePos = [stitchedMeta.matFilePos;{metaData.matFilePos}];
end
% saccs has to be updated
fps = metaData.fps;
saccs = stitchedAna.saccs;
trace = stitchedAna.trace;
% calculate overall saccades
trigAveL = triggeredAverage([rad2deg(trace(:,3)),trace(:,6)],saccs(saccs(:,4) == 1,2),fps/4,[],10);
trigAveR = triggeredAverage([rad2deg(trace(:,3)),trace(:,6)],saccs(saccs(:,4) == -1,2),fps/4,[],10);
taSacc = cat(4,trigAveL,trigAveR);
%calculate overall velocities
velocities = [nanmedian(abs(trace(:,4:6)));max(abs(trace(:,4:6)))];
saccI = arrayfun(@(start,stop) start:stop,saccs(:,1),saccs(:,3),'UniformOutput',false);
saccI =cell2mat(saccI');
% get bendability data
bendability2 = FMA_BA_getBendebility(stitchedAna.traceResult(:,3),metaData.pix2mm);
bendability2(sum(nanIDX,2) == 0) = {NaN(2,2)};
bendability2 = cellfun(@(x) [x(:,1)-min(x(:,1)) x(:,2)],bendability2,'UniformOutput',false );
bendability2 = cellfun(@(x) [x(:,1)./max(x(:,1)) x(:,2)],bendability2,'UniformOutput',false );
bendability = repmat({NaN(10,2)},size(bendability2));
bendability = bendability2;
bendability2 = bendability;
bendability = cell2mat(bendability);
% normalise bodylength
edges = 0:0.1:1;
binnedBend = NaN(3,10);
for K =1:length(edges)-1,
    temp = abs(bendability(bendability(:,1)>=edges(K) & bendability(:,1)<edges(K+1),2));
    binnedBend(:,K) = [min(temp); mean(temp); max(temp)];
end
% trigAve has to be updated
stitchedAna.trigAveSacc = taSacc;
% medMaxVelocities has to be updated
stitchedAna.medMaxVelocities = velocities;
stitchedAna.binnedBend = binnedBend;
stitchedAna.bendability = bendability2;