function ivT_movie_lollipopTrace(fPos,anaTRA,lolliN,mapChoice,tailLength,frameNb,frameH,pix2mm)
% This function plots a two dimensional trajectory consisting of the pixel
% coordinates and the rotational angle of the object. 
%
% GETS:
%      fPos = cell list with the absolute file positions of the frames in
%             the identical succesion as the anaTra
%    anaTRA = mx3xp where m is the number of frames | col(1) x-mm-coords
%             | col(2) y-mm-coords | col(3) yaw in radians and unwrapped
%             with ivT_unwrapYaw | size of the object | eccentricity of the
%             object | thrust [mm*s⁻¹] | slip [mm*s⁻¹] | lift [mm*s⁻¹]
%    lolliN = the number tells you distance between two lollipops the
%             second number the position of the last lollipop
% mapChoice = if set to 1 the lollipos will be color coded in darkgray | 2)
%             jet | 3) summer
%tailLength = how long the stick of the lollipop should be, if empty or not
%             set it is set to 5% of the maximal distance in the
%             trajectory
%   frameNb = tells you which frame should be plotted
%    frameH = axes handles to the frame and trajectory
%    pix2mm = the factor to calculate from pixels 2 mm 
%
% SYNTAX: ivT_plot_2DtraMov(fPos,anaTRA,fps,lolliN,mapChoice,tailLength,...
%                           frameNb,fH,saccadeT,saccadePos,pix2mm);
%
% Author: B. Geurten 13.10cd.15
%
% see also ivT_traj2movFrames,ivT_plot_2DtraEllipse


%%%%%%%%%%%%%%%%
% prepare data %
%%%%%%%%%%%%%%%%

% mm trajectories have to be recalculcated to pixels
anaTRA(:,1:2) = anaTRA(:,1:2)./pix2mm;

% make the lollipop index, meaning find out at which frames the position
% and orientation of the animal should be plotted
lollipopIndex = 1:lolliN:frameNb;
lollipopIndex(lollipopIndex>size(anaTRA,1)) = [];

% decide on trace colormap
traLen = size(anaTRA,1);
switch mapChoice
    case 1
        cmap =colormap(darkgray(traLen));
        lineCol = 'w';
    case 2
        cmap =colormap(jet(traLen));
        lineCol = 'r';
    case 3
        cmap =colormap(summer(traLen));
        lineCol = 'g';
        
end

% decide on length for the orientation tail
if exist('tailLength','var'),
    if ~isempty(tailLength),
        x= [tailLength 0 0]';
    else
        
        maxDist = max([ max(anaTRA(:,1))-min(anaTRA(:,1)) max(anaTRA(:,2))-min(anaTRA(:,2))]);
        x= [maxDist*0.1 0 0]';
    end
    
else
    maxDist = max([ max(anaTRA(:,1))-min(anaTRA(:,1)) max(anaTRA(:,2))-min(anaTRA(:,2))]);
    x= [maxDist*0.1 0 0]';
end
% get the trajectory numbers

traNb = size(anaTRA,3);

%%%%%%%%%%%%%%%%
% now plotting %
%%%%%%%%%%%%%%%%

% movie Frame
for j =1:traNb,
    try
        imshow(imadjust(imread(fPos{frameNb})), 'Parent',frameH )
    catch,
        imshow(imadjust(rgb2gray(imread(fPos{frameNb}))), 'Parent',frameH )
    end
    hold on
    plot(frameH,anaTRA(1:frameNb,1,1,j),anaTRA(1:frameNb,2,1,j), lineCol,'LineWidth',2)
    for z = lollipopIndex,
        rot_mat = getFickmatrix(anaTRA(z,3,j),0,0,'p');
        x_temp = rot_mat * x;
        x_orient = bsxfun(@plus,x_temp(1:2)',anaTRA(z,1:2));
        plot(frameH,[anaTRA(z,1,j) x_orient(1)],[anaTRA(z,2,j) x_orient(2)],'Color',cmap(z,:))
        plot(frameH,anaTRA(z,1,j),anaTRA(z,2,j),'o','Color',cmap(z,:),'MarkerFaceColor',cmap(z,:))
    end
end
hold off


