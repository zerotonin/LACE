function [hL,hA]=ET_plot_frameNellipses(frame,frameNumber,traceResult,Nb,axisH)
% This function of the Ethotrack plot toolbox (ET_plot_) plots the frame
% and the ellipses, their direction and animal ID number.
% %
% GETS:
%         frame = the orignial image used for detection as a mxn matrix
%   frameNumber = the index of the frame in the movie
%   traceResult = a mx13 matrix where m is the number of found animals,
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
%            Nb = number of points drawn in ellipse
%         axisH = parent axis handle
%
% RETURNS:
%            hL = handle of the ellipses
%            hA = handle of the angle line
%
% SYNTAX: [hL,hA]=ET_plot_addEllipse(traceResult,colorMap,Nb,axisH)
%
% Author: B. Geurten 11-30-15
%
% NOTE: 
%
%
% see also  ET_plot_addEllipse, ET_plot_animals2subplots

% clear axis
cla(axisH)
% plot image
imagesc(frame,'Parent',axisH)
% set axis 
axis(axisH,'image')
% set colormap
colormap(axisH,gray)
% add ellipses

if iscell(traceResult),
    traceResult = traceResult{frameNumber};
else
    traceResult = traceResult(:,:,frameNumber);
end

    [hL,hA]=ET_plot_addEllipse(traceResult,'spring',Nb,axisH,1,1);

    