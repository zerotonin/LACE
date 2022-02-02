function [tooMany,tooFew]= ET_phA_fdfByAnimalNumber(traceResult,expectedAnimals)
% This function of the Ethotrack posthoc analysis toolbox (ET_phA_) detects
% the falsly detected frames via the number of found animals. If the number
% of animals does not match the number of the expected animals, this frame
% index is returned.
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
%expectedAnimals= number of animals that should be visible in the footage
%
% RETURNS:
%       tooMany = indices of the frames in which too many animals where
%                 found
%        tooFew = indices of the frames in which too few animals where
%                 found
%
% SYNTAX: [tooMany,tooFew]= ET_phA_fdfByAnimalNumber(traceResult,expectedAnimals); 
%
% Author: B.Geurten 11-30-2015
% 
% Notes:
%
% see also 

% get number of found animals per frame
foundAnimals = cellfun(@(x) size(x,1),traceResult);
% find those that are not identical to the expectation
tooMany = find(foundAnimals > expectedAnimals);
tooFew = find(foundAnimals < expectedAnimals);