function pixBox =  ET_p2mm_box(axH,bgMin)
% This function of the Ethotrack pixel 2 millimeter toolbox (ET_p2mm_) ask
% the user to mark a line in a frame and than to identify how long this
% line is in mm. Thereby a factor can be calculated tht converts pixel to
% mm.
% This function can be used to get the pixel coordinates of rectangular
% shaped arenas. The user is asked to point to the four corners of a
% rectangular arena. Afterwards the chosen rectangle is superimposed on the
% image. If this pixel coordinates can be related to real world
% coordinates, they can be also be used to interpolate a pixel trajectory
% to real world coordinates, as for example by ivT_pix2mm.
%
% GETS
%          axH = axis handle
%       frameS = an image matrix
%         cmap = a colormap matrix
%
% RETURNS
%       pixBox = the pixel coordinates of a rectangle enclosing the 
%                relevant part of the image (e.g. the arena) as 4x2 matrix
%                col(1) x-pos col(2) y-pos
%
% SYNTAX: pixBox =  ivT_pixBoxGUI(frameS,cmap);
%
% Author: B. Geurten 20.2.12
%
% see also ivT_pix2mm, ginput, patch, questdlg, ivT_pixCircleGUI

% open a new figure
% declare and preallocate variables

% get figure axis
if isempty(axH),
    figure();
    axH = gca;
end

%normalise the backgrounf
bgMin = ET_im_normImage(double(bgMin));
% preallocate varibles
anchors = NaN(4,2);
mmBox = cell(4,2);
for i=1:4,
    %update plot
    ET_p2mm_getROI_plot(axH,bgMin,anchors)
    [x,y] = ginput(1);
    mmBox(i,:) = ET_GUI_boxQuest();
    anchors(i,:) = [x y];
end


%update plot with line
ET_p2mm_getROI_plot(axH,bgMin,anchors)
hold on
patch(anchors(:,1),anchors(:,2),paletteKeiIto(2),'Marker','o','Parent',axH,'FaceAlpha',0.25);
for i =1:4,
text(round(size(bgMin,2)/2),round(size(bgMin,1)/2) +((i-1)*20 -40),...
    {['Point No ' num2str(i) ': ' mmBox{i,2} ' ' num2str(mmBox{i,1})]},...
    'FontSize',12,'FontWeight','b','Color','k','HorizontalAlignment','center');
end
hold off

%change Title 
title(axH,'done, central your results are shown')

pixBox = cat(3,anchors,cell2mat(mmBox(:,1)));

end





function ET_p2mm_getROI_plot(axH,bgMin,anchors)
% This subroutine of the ET_im_getROI update the axis with the background
% image and the chosen points for the roi

% image plotting
imshow(bgMin,'Parent',axH)
%title string including
title(axH,'click 4 times onto the screen for the 4 corners of the Box')
% add anchor points if available
if ~isempty(anchors)
    hold on
    plot(axH,anchors(:,1),anchors(:,2),'ko-','MarkerFaceColor',paletteKeiIto(2),'MarkerSize',5)
    text(anchors(:,1)+20,anchors(:,2)+20,num2str([1:size(anchors,1)]'),'FontSize',12,'FontWeight','b','Color',paletteKeiIto(2))
    hold off
end
end
