function [maskIDX,anchors] = ET_im_getROI(bgMin,axH)
% This function of the Ethotrack image manipulation toolbox (ET_im_)
% offers the user to create a ROI which can be used for later calculation.
% NOTE! If you use a minimal background (black animal / white background)
% or maximal background (if vice versa) you can see the animals complete
% trajectory and create an optimal ROI.
%
% GETS:
%          bgMin = image 
%            axH = axis handle
%
% RETURNS:
%        
%
% SYNTAX: anchors = ET_im_getROI(bgMin,axH);
%
% Author: B.Geurten 15-01-2016
%
% see also ET_im_calcMaskCoord

% get figure axis
if isempty(axH),
    figure();
    axH = gca;
end
%normalise the backgrounf
bgMin = ET_im_normImage(double(bgMin));
% preallocate varibles
button = 1;
anchors = [];
while button ==1,
    %update plot
    ET_im_getROI_plot(axH,bgMin,anchors)
    [x,y,button] = ginput(1);
    anchors = [anchors; x y];
end
anchors= anchors(1:end-1,:);

%update plot with closed roi
ET_im_getROI_plot(axH,bgMin,[anchors;anchors(1,:)]);
%change Title and add half transperent ROI
title(axH,'ROI - region of interet')
% add half transperent ROI
hold on
patch(anchors(:,1),anchors(:,2),paletteKeiIto(2),'Marker','o','Parent',axH,'FaceAlpha',0.5);
hold off

maskIDX = ET_im_calcMaskCoord(bgMin,anchors);
end

function ET_im_getROI_plot(axH,bgMin,anchors)
% This subroutine of the ET_im_getROI update the axis with the background
% image and the chosen points for the roi

% image plotting
imshow(bgMin,'Parent',axH)
%title string including
title(axH,'make your ROI | left mouse button anchor point | right mouse button to stop')
% add anchor points if available
if ~isempty(anchors)
    hold on
    plot(axH,anchors(:,1),anchors(:,2),'ko-','MarkerFaceColor',paletteKeiIto(2),'MarkerSize',5)
    hold off
end
end