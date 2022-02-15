function [idx,idxT,idxS,idxNotTS] = FMA_manCategoriser(trace,saccs,thrustThresh)

% get all Nan
idxN = isnan(trace(:,6));
% get all saccade time stamps from get_saccades output
if isempty(saccs),
    idxS = zeros(length(idxN),1) ==1;
else
    idxS = indice2signal(saccs(:,1),saccs(:,3),ones(size(saccs,1),1),length(idxN))' ~= 0;
end
% all timepoints that are not NaN or a saccade
idxNotNS  = bsxfun(@and,~idxN,idxS)  == 0;

% all data points  equal and larger the threshold are  put in this index
idxAboveThrustT = trace(:,4)>=thrustThresh;
% all data points below the threshold are  put in this index
idxBelowThrustT = ~idxAboveThrustT;

% now all dataPoints during saccades and NaN values are excluded from these
% indexes
idxT = bsxfun(@and,idxAboveThrustT,idxNotNS);
idxNotTS  = bsxfun(@and,idxBelowThrustT,idxNotNS);

% make overall index in which saccades are 1 and thrust is 2 and all others
% are 3
idx = sum([idxS idxT.*2 idxNotTS.*3],2);