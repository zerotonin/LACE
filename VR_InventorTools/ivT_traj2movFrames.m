function ivT_traj2movFrames(fPos,traAna,fps,modus,tailLength,cometWake,mapChoice,titleFlag,outPutFrameNo,tightFigFlag,saveFlag,saveDir)
% This function plots a two dimensional trajectory consisting of the pixel
% coordinates and the rotational angle of the object. 
%
% GETS:
%      fPos = a cell matrix with the file position of the frames in
%             ascending order
%    anaTRA = mx3xp where m is the number of frames | col(1) x-pixel-coords
%             | col(2) y-pixel-coords | col(3) yaw in radians and unwrapped
%             with ivT_unwrapYaw
%       fps = scalar frames per second
%     modus = if set to 'comet' each animal will drag a small comet wake
%             behind it, if set to 'trailBlazer'  it will mark the
%             trajectory after the animal 
%tailLength = how long the stick of the lollipop should be, if empty or not
%             set it is set to 5% of the maximal distance in the
%             trajectory
% cometWake = the length of the wake
% mapChoice = if set to 1 the lollipos will be color coded in darkgray | 2)
%             jet | 3) summer
% titleFlag = if set to 1  the title will show the time in seconds
% outPutFrameNo = the number of frames that are created
% tightFigFlag  = if set to 1 the figure will be tight around the plots,
%                 important for saving
%  saveFlag = if set to 1 all frames are saved in save Dir as frame_*.jpg
%   saveDir = string to the directory were frames are saved.
%
% SYNTAX: ivT_traj2movFrames(traAna,fps,modus,tailLength,cometWake,...
%         mapChoice,titleFlag,outPutFrameNo,tightFigFlag,saveFlag,saveDir);
%
% Author: B. Geurten 25.7.15
%
% see also ivT_plot_2Dtra,ivT_plot_2DtraEllipse

h = figure();
if strcmp(modus,'trailBlazer')
    cometWake = 0;
end
traNb = size(traAna,3);
for i = unique(round(linspace(cometWake+1,size(traAna,1),outPutFrameNo))),
    figure(h);
    clf(h);
    imshow(imread(fPos{i}))
    axis image
    axis tight
    hold on
    for j=1:traNb,
        if j ==1, cBFlag =1;else cBFlag =0;end
        switch modus
            case 'comet'
                tempTRA = traAna(i-cometWake:i,:,j);
                ivT_plot_2Dtra(tempTRA,fps,10,mapChoice,cBFlag,tailLength)
            case 'trailBlazer'
                tempTRA = traAna(1:i,:,j);
                ivT_plot_2Dtra(tempTRA,fps,[100 size(traAna,1)],mapChoice,cBFlag,tailLength)
        end
    end
    if titleFlag,
        title(['time: ' num2str(round(i/fps*.04)) ' s'])
    end
    if tightFigFlag,
        tightfig;
    end
    if saveFlag
        
        saveas(h,[saveDir filesep 'frame_' num2strleadingZero(i,floor(log10(outPutFrameNo))+1) '.jpg'])
    end
    
end

