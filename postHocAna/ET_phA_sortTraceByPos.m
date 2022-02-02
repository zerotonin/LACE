 function traceResult = ET_phA_sortTraceByPos(traceResult)
% This function of the Ethotrack posthoc analysis toolbox (ET_phA_) sorts
% the  animals after their position over time, so that the same animal has
% allways the same ID number. The position is analysed via a Hungarian
% algorithmn
%
% GETS:
%   traceResult = a mx13 result where m is the number of found animals,
%                 columns are defined as follows:
%                 col  1: x-position in pixel
%                 col  2: y-position in pixel
%                 col  3: major axis length of the fitted ellipse
%                 col  4: minor axis length of the fitted ellipse
%                 col  5: ellipse angle in degree
%                 col  6: quality of the fit
%                 col  7: number of animals believed in their after final
%                         evaluation
%                 col  8: number of animals in the ellipse according to
%                         surface area
%                 col  9: number of animals in the ellipse according to
%                         contour length
%                 col 10: is the animal close to an animal previously traced 
%                         (1 == yes)
%                 col 11: evaluation weighted mean
%                 col 12: detection quality [aU] if
%                 col 13: correction index, 1 if the area had to be
%                         corrected automatically
%
% RETURNS:
%   traceResult = as above only the rows are sorted now
%
% SYNTAX: traceResult = ET_phA_sortTraceByPos(traceResult); 
%
% Author: B.Geurten 11-30-2015
% 
% Notes:
% This Matlab version is developed based on the orginal C++ version coded
% by Roy Jonker @ MagicLogic Optimization Inc on 4 September 1996.
% Reference:
% R. Jonker and A. Volgenant, "A shortest augmenting path algorithm for
% dense and spare linear assignment problems", Computing, Vol. 38, pp.
% 325-340, 1987.
%
% see also  lapjv

% WOOPS! This cannot work as a cellfunction because you have to repair the
% first frame tzhan the second based on the first etc!
% 
% distMat = cellfun(@(x,y) Hungarian_getDistMat(x(:,1:2),y(:,1:2),'euclidean'),traceResult(1:end-1),traceResult(2:end),'UniformOutput',false);
% rowsol = cellfun(@(x) lapjv(x),distMat, 'UniformOutput',false);
% traceResult(2:end) = cellfun(@(x,y) x(y,:) ,traceResult(2:end),rowsol,'UniformOutput',false);

% so it has to be a for loop

for i =2:length(traceResult)
    %get distance matix
    distMat = Hungarian_getDistMat(traceResult{i}(:,1:2),traceResult{i-1}(:,1:2), 'euclidean');
    % calculate matching
    rowsol = lapjv(distMat);
    % rearrange matrix
    traceResult{i} = traceResult{i}(rowsol,:);
end