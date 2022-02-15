function ivT_movie_makeMovieFrame(fPos,anaTRA,SPmode,Fmode,fps,lolliN,mapChoice,tailLength,frameNb,fH,saccadeT,saccadePos,pix2mm,offSet,cometWake)
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
%       fps = scalar frames per second
%    lolliN = the number tells you distance between two lollipops the
%             second number the position of the last lollipop
% mapChoice = if set to 1 the lollipos will be color coded in darkgray | 2)
%             jet | 3) summer
%tailLength = how long the stick of the lollipop should be, if empty or not
%             set it is set to 5% of the maximal distance in the
%             trajectory
%   frameNb = tells you which frame should be plotted
%        fH = figure Handle where to plot to
%  saccadeT = saccade threshold used for detection -> get_saccades
%saccadePos = frame indices at which the saccades happen, from get_saccades
%             second column of the return value
%    pix2mm = the factor to calculate from pixels 2 mm 
%    SPmode = if subplotmode is set to 'on' the velocity subplots will be
%             plotted
%     Fmode = frame version to plot either 'comet' or normal 'lollipop'
% cometWake = how many frames is the comet wake long or how many positions
%             are shown before the last
%
% SYNTAX:  ivT_movie_makeMovieFrame(fPos,anaTRA,SPmode,Fmode,fps,lolliN,...
%              mapChoice,tailLength,frameNb,fH,saccadeT,saccadePos,...
%              pix2mm,offSet,cometWake);
%
% Author: B. Geurten 13.10.15
%
% see also ivT_movie_lollipopTrace,ivT_movie_makeSpeedSubplots


% create a figure if not as variable
if exist('fH','var'),
    if isempty(fH),
        fH = figure();
    else
        %clf(fH);
    end
else
        fH = figure();
end


%%%%%%%%%%%%%%%%
% now plotting %
%%%%%%%%%%%%%%%%

% frame Handle
if strcmp(SPmode,'on'), %check if ser wants velocity sub plots
    frameHandle = subplot(4,2,[1 3 5 7 ]);
else
    frameHandle = gca;
end

% decide which kind of trajectory plot
switch Fmode
    case 'lollipop',
        ivT_movie_lollipopTrace(fPos,anaTRA,lolliN,mapChoice,tailLength,frameNb,frameHandle,pix2mm)
    case 'comet',
        if frameNb <= cometWake,
           start = 1;
           newFrameNb = frameNb;
        else
            start = frameNb-cometWake;
            newFrameNb = frameNb-(start-1);
        end
        ivT_movie_lollipopTrace(fPos(start:end),anaTRA(start:end,:,:),round(cometWake/2),mapChoice,tailLength,newFrameNb,frameHandle,pix2mm)          
    otherwise
        error('ivT_movie_makeMovieFrame:WrongTrajType','The chosen trajectory plot type does not exists.')
end

if strcmp(SPmode,'on'),%check if ser wants velocity sub plots
    % subplot handles
    axHandle(1)=subplot(4,2,2);
    axHandle(2)=subplot(4,2,4);
    axHandle(3)=subplot(4,2,6);
    axHandle(4)=subplot(4,2,8);
    traLen = size(anaTRA,1);
    ivT_movie_makeSpeedSubplots(axHandle,frameHandle,offSet,traLen,fps,anaTRA,frameNb,saccadeT,saccadePos);
end

%tightfig;