function pixTable =  ivT_pixLineGUI(frameS,cmap)
% This function calculates the coordinate system of a movie frame in real
% world dimensions [mm]. Normally a picture of a ruler or object of defined
% size is used. Then the user marks a line along that object. Afterwards
% the factor is calculated to transform mm to pix. The return value is a
% 4x2 matrix where the 4 corners (lower-left,upper-left,upper-right,lower right)
% are given in pixels and mm.
% If this pixel coordinates can be related to real world coordinates, they c
% an be also be used to interpolate a pixel trajectory to real world co-
% ordinates, as for example by ivT_pix2mm.
%
% GETS
%       frameS = an image matrix
%         cmap = a colormap matrix
%
% RETURNS
%       pixTable = 4x2 matrix col(1) x-values col(2) y- values
%                      rows (1- 4) hold mm values rows(1-8) corresponding
%                      pxiel values
%
% SYNTAX: pixBox =  ivT_pixBoxGUI(frameS,cmap);
%
% Author: B. Geurten 20.2.12
%
% see also ivT_pix2mm, ginput, patch, questdlg, ivT_pixCircleGUI

% open a new figure
h = figure();
% declare and preallocate variables
goOn = 1;
pixBox = NaN(2,2);


while goOn % check if user wants to redo points    
    
    %plot image
    figure(h)
    clf(h)
    imagesc(frameS)
    colormap(cmap)
    %scale axis
    axis equal
    axis tight
    % get the pixel coordinates of the rectangle shaped arena
    [pixBox(:,1),pixBox(:,2),button] = ginput(2);
    
    % plot user defined points as rectangle and numbers
    hold on
    text(pixBox(:,1)+20,pixBox(:,2)+20,num2str((1:2)'),'FontSize',12,'FontWeight','b','Color','r')
    line(pixBox(:,1),pixBox(:,2),'Color','b','Marker','o')%,'MarkerFaceColor','flat')%,'FaceColor','none')
    hold off
    
    % Construct a questdlg with three options to clarify if user wants to
    % redo points
    choice = questdlg('Are you satisfied with these points?', ...
        'Redo Points?', ...
        'Yes','No','Cancel','No');
    
    % Handle response
    switch choice
        case 'Yes'
            %turn off repetition
            goOn = 0;
            % ask for real value
            prompt={'Enter the distance [mm]:'};
            name='Input distance in SI';
            numlines=1;
            defaultanswer={'10'};
            realNorm=str2double(inputdlg(prompt,name,numlines,defaultanswer));
            % now build factor
            pixVecNorm = norm(diff(pixBox,1));
            pix2real = realNorm/pixVecNorm;
            frameH = size(frameS,1);
            frameW = size(frameS,2);
            pixTable = [0,0; 0,frameH; frameW,frameH; frameW,0];
            pixTable = [pixTable.*pix2real;pixTable];
            
        case 'No'
            goOn = 1;
        case 'Cancel'
            close(h) % close figure
            return; % leave function
    end
    
end
close(h)