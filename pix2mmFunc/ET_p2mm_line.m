function pix2mm = ET_p2mm_line(bgMin,axH)
% This function of the Ethotrack pixel 2 millimeter toolbox (ET_p2mm_) ask
% the user to mark a line in a frame and than to identify how long this
% line is in mm. Thereby a factor can be calculated tht converts pixel to
% mm.
%
% GETS:
%          bgMin = image 
%            axH = axis handle
%
% RETURNS:
%        pix2mm = the factor with which to calculate mm coordinates from
%                 pixels
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
    ET_p2mm_getROI_plot(axH,bgMin,anchors)
    [x,y,button] = ginput(1);
    
    anchors = [anchors; x y];
    %delete old points
    if size(anchors,1) >2 && button ==1;
        anchors(1,:) = [];
    end
end
anchors= anchors(1:end-1,:);
lineNorm = norm(diff(anchors,1));
lineMM = inputdlg('Enter the length of the line [mm] size:','line length [mm]');
lineMM = str2double(lineMM{1});
pix2mm = lineMM/lineNorm;

%update plot with line
ET_p2mm_getROI_plot(axH,bgMin,anchors);
%change Title and add half transperent ROI
title(axH,['line length [pix]: ' num2str(lineNorm) ' | line length [mm]: ' num2str(lineMM) ' | factor: ' num2str(pix2mm)] )

end

function ET_p2mm_getROI_plot(axH,bgMin,anchors)
% This subroutine of the ET_im_getROI update the axis with the background
% image and the chosen points for the roi

% image plotting
imshow(bgMin,'Parent',axH)
%title string including
title(axH,'make your line | left mouse button anchor point | right mouse button to stop')
% add anchor points if available
if ~isempty(anchors)
    hold on
    plot(axH,anchors(:,1),anchors(:,2),'ko-','MarkerFaceColor',paletteKeiIto(2),'MarkerSize',5)
    hold off
end
end