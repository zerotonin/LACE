 function [trace,metaData] = ET_phA_cell2mat(traceResult)
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
%         trace = mxnxp matrix, m is the number of frames and p the number
%                 of animals.The columns n hold informations as follows:
%                 col  1: x-position in pixel
%                 col  2: y-position in pixel
%                 col  3: ellipse angle in degree
%      metaData = mxnxp matrix, m is the number of frames and p the number
%                 of animals.The columns n hold informations as follows:
%                 col  1: major axis length of the fitted ellipse
%                 col  2: minor axis length of the fitted ellipse
%                 col  3: quality of the fit
%                 col  4: number of animals believed in their after final
%                         evaluation
%                 col  5: number of animals in the ellipse according to
%                         surface area
%                 col  6: number of animals in the ellipse according to
%                         contour length
%                 col  7: is the animal close to an animal previously traced 
%                         (1 == yes)
%                 col  8: evaluation weighted mean
%                 col  9: detection quality [aU] if
%                 col 10: correction index, 1 if the area had to be
%                         corrected automatically
%
% SYNTAX: trace = ET_phA_cell2mat(traceResult); 
%
% Author: B.Geurten 11-30-2015
% 
% Notes:
%
% see also  

% reshape 
trace = cellfun(@(x) reshape(x',[1,13,size(x,1)]),traceResult,'UniformOutput',false);
% make matrix of cell array
trace = cell2mat(trace');
% split the data in pure trace and meta data
metaData = trace(:,[3 4 6:13],:);
trace = trace(:,[1 2 5],:);