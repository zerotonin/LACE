function [traceResult,falseDetID] = ET_phA_removeAnimalManually(traceResult,tooMany,expectedAnimals,fPos,headSize)
% This function of the Ethotrack posthoc analysis toolbox (ET_phA_) asks
% the user to click on falsly detected objects. If a frame includes two
% falsly detected objects it is shown as often as false objects wwere
% detected.
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
%       tooMany = indices of the frames in which too many animals where 
%                 found
%expectedAnimals= number of animals that should be visible in the footage
%       filePos = absolute position of the seq file
%    headSize = size of the header information, this can be altered in
%               troublepix and therefore was has to take into account 
%               different header sizes. If not set it is 1024
%
% RETURNS:
%   traceResult = same as above only corrected
%    falseDetID = the indices of the regions that were discarded in the
%                 frames listed in tooMany
%
% SYNTAX: [traceResult,falseDetID] = ...
%           ET_phA_removeAnimalManually(traceResult,tooMany,expectedAnimals,fPos);
%
% Author: B.Geurten 11-30-2015
%
% Notes:
%
% see also ET_phA_deleteFalseDetectionPlot,ET_phA_fdfByAnimalNumber

if ~exist('headSize','var'),
    headSize = 1024;
end

[fid, endianType,headerInfo,~, IDX] = ivT_norpix_openSeq(fPos,'onlyHeader','');
%make cell array of length of the false detected frame
falseDetID =cell(length(tooMany),1);

%iterate through falsly detected frames
counter = 0;
for frameNumber=tooMany,
    % run the manuall correction as often as we detected superfluous
    % objects
    counter = counter+1;
    % read image
    frame = ivT_norpix_loadSingleImage(fid,headerInfo,endianType,IDX,frameNumber,headSize);
        % plot all animals in subplot
    figureH = figure(1);
    clf(figureH)
    h=ET_plot_animals2subplots(frame,frameNumber,traceResult,300,figureH);
    for j=1:size(traceResult{tooMany},1)-expectedAnimals,
        %manual detection
                falseDetection = ET_phA_deleteFalseDetectionPlot(h);
        % save number of object
        falseDetID{counter} =[falseDetID{counter}; falseDetection];
        
    end
    
end
close(figureH)
% make positive list (instead of the numbers to delet write down the number to keep)
falseDetID= cellfun(@(x,y) setdiff(1:size(y,1),x),falseDetID,traceResult(tooMany),'UniformOutput',false);
%modify traceResukt
traceResult(tooMany)  =  cellfun(@(x,y) x(y,:),traceResult(tooMany),falseDetID','UniformOutput',false);
% close file dialogue
fclose(fid)