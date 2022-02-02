function h = ET_plot_frameNcontours(frame,objectContours,axisH)
% This function of the Ethotrack plot toolbox (ET_plot_) plots the frame
% and the ellipses, their direction and animal ID number.
% %
% GETS:
%         frame = the orignial image used for detection as a mxn matrix
%objectContours = a cell array containing the x and y coordinates for the
%                 boundaries of all found objects, carefull most likely 
%                 these are not only animals you are looking for
%         axisH = parent axis handle
%
% RETURNS:
%            h = handles to graphic objects. 1) for the image 2-end are the
%                object contours
%
% SYNTAX: [hL,hA]=ET_plot_addEllipse(traceResult,colorMap,Nb,axisH)
%
% Author: B. Geurten 12-02-15
%
% NOTE: 
%
%
% see also  ET_plot_addEllipse, ET_plot_animals2subplots

% clear axis
cla(axisH)

%%%%%%%%%%%%%%
% plot image %
%%%%%%%%%%%%%%
imagesc(imageBin,'Parent',axisH)
colormap = gray;
axis image

%%%%%%%%%%%%%%%%%%%%%%%%
% superimpose contours %
%%%%%%%%%%%%%%%%%%%%%%%%
hold on
% colormap
cmap = jet(length(objectContours));
% main loop
for i =1:length(objectContours),
    temp = objectContours{i};
    plot(axisH,temp(:,2),temp(:,1),'Color',cmap(i,:),'LineWidth',2)
end
hold off