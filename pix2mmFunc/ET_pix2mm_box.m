function pixBox =  ivT_pixBoxGUI(frameS,cmap,titleStr)
% This function can be used to get the pixel coordinates of rectangular
% shaped arenas. The user is asked to point to the four corners of a
% rectangular arena. Afterwards the chosen rectangle is superimposed on the
% image. If this pixel coordinates can be related to real world
% coordinates, they can be also be used to interpolate a pixel trajectory
% to real world coordinates, as for example by ivT_pix2mm.
%
% GETS
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
h = figure('units','normalized','outerposition',[0 0 1 1]);
% declare and preallocate variables
goOn = 1;
pixBox = NaN(4,2);

while goOn % check if user wants to redo points
    
    %plot image
    figure(h)
    clf(h)
    imagesc(frameS)
    colormap(cmap)
    %scale axis
    axis equal
    
    if exist('titleStr','var'),
        title(titleStr);
    end
    xlim([0 size(frameS,2)])
    ylim([0 size(frameS,1)])
    % get the pixel coordinates of the rectangle shaped arena
    [pixBox(:,1),pixBox(:,2),button] = ginput(4);
    
    % plot user defined points as rectangle and numbers
    hold on
    text(pixBox(:,1)+20,pixBox(:,2)+20,num2str([1:4]'),'FontSize',12,'FontWeight','b','Color','r')
    patch(pixBox(:,1),pixBox(:,2),ones(4,1),'Marker','o','MarkerFaceColor','flat','FaceColor','none')
    hold off
    
    % Construct a questdlg with three options to clarify if user wants to
    % redo points
    choice = questdlg('Are you satisfied with these points?', ...
        'Redo Points?', ...
        'Yes','No','Cancel','No');
    
    % Handle response
    switch choice
        case 'Yes'
            goOn = 0;
        case 'No'
            goOn = 1;
        case 'Cancel'
            close(h) % close figure
            return; % leave function
    end
    
end
close(h);
