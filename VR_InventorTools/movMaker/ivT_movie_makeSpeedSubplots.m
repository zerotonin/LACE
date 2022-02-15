function ivT_movie_makeSpeedSubplots(axHandle,frameH,offSet,traLen,fps,anaTRA,frameNb,saccadeT,saccadePos)
% This subroutine of the ivT_movie toolbox (ivTrace movie making toolbox)
% actually set size and position of a figure to a predefined set of
% values. This set consits of struct with the fields PaperUnits, Position
% and Paper Position, as correspondend to the figure properties. This can
% be easily defined by ivT_movie_GWYSsize
%
% GETS:
% axHandles = the axis handles for the subplots inorder (yaw,yawVel,thrust,
%             slip)
%    frameH = handle for the subplot containing the video frame and
%             trajectory
%    offSet = horizontal space between frame and subplots in diemsionless 
%             figure distance (0 -> 1 | default 0.025)  
%    traLen = length of the trajectory in frames;
%       fps = origanl frames per second
%    anaTRA = mx3xp where m is the number of frames | col(1) x-mm-coords
%             | col(2) y-mm-coords | col(3) yaw in radians and unwrapped
%             with ivT_unwrapYaw | size of the object | eccentricity of the
%             object | thrust [mm*s⁻¹] | slip [mm*s⁻¹] | lift [mm*s⁻¹]
%   frameNb = number of the frame to be plotted
%  saccadeT = saccade threshold used for detection -> get_saccades
%saccadePos = frame indices at which the saccades happen, from get_saccades
%             second column of the return value
%
% RETURNS: nothing
%
% SYNTAX: ivT_movie_makeSpeedSubplots(axHandle,frameH,offSet,traLen,fps,anaTRA,frameNb,saccadeT,saccadePos)
%
% Author: B. Geurten 13.10.15
%
% see also ivT_movie_frame4speedNtraj,get_saccades

% define the x-axes in seconds
xAx =linspace(0,frameNb/fps,frameNb);


%%%%%%%%%%%%%
% SUBPLOT 1 %
%%%%%%%%%%%%%


subPlotHandle = axHandle(1);

%adjust position of the subplot
ivT_movie_makeSpeedSubplots_adjustPos(frameH,subPlotHandle,offSet)
%start plotting
plot(subPlotHandle,xAx,rad2deg(anaTRA(1:frameNb,3)),'Color',paletteKeiIto(6),'LineWidth',2)

%adjust axes and labels
set(subPlotHandle,'XTickLabel', [])
labelStr ='yaw [deg]';
data= rad2deg(anaTRA(:,3));
ivT_movie_makeSpeedSubplots_adjustAx(traLen,fps,data,labelStr,subPlotHandle);

%%%%%%%%%%%%%
% SUBPLOT 2 %
%%%%%%%%%%%%%

subPlotHandle = axHandle(2);
%adjust position of the subplot
ivT_movie_makeSpeedSubplots_adjustPos(frameH,subPlotHandle,offSet)

%start plotting
plot(subPlotHandle,xAx,anaTRA(1:frameNb,8),'Color',paletteKeiIto(3),'LineWidth',2)
hold(subPlotHandle,'on')
plot(subPlotHandle,[0 traLen/fps], [saccadeT saccadeT],'k--')
plot(subPlotHandle,[0 traLen/fps], [saccadeT saccadeT].*-1,'k--')
saccadePos(saccadePos>frameNb) = [];
if ~isempty(saccadePos),
    plot(subPlotHandle,xAx(saccadePos),anaTRA(saccadePos,8),'ro')
end
hold(subPlotHandle,'off')
    
%adjust axes and labels
set(subPlotHandle,'XTickLabel', [])
labelStr ='yaw vel [deg/s]';
data= anaTRA(:,8);
ivT_movie_makeSpeedSubplots_adjustAx(traLen,fps,data,labelStr,subPlotHandle);

%%%%%%%%%%%%%
% SUBPLOT 3 %
%%%%%%%%%%%%%

subPlotHandle = axHandle(3);
%adjust position of the subplot
ivT_movie_makeSpeedSubplots_adjustPos(frameH,subPlotHandle,offSet)

%start plotting
plot(subPlotHandle,xAx,anaTRA(1:frameNb,6),'Color',paletteKeiIto(2),'LineWidth',2)
hold(subPlotHandle,'on')

plot(subPlotHandle,[0 traLen/fps], zeros(2,1),'k--')
hold(subPlotHandle,'off')

%adjust axes and labels
set(subPlotHandle,'XTickLabel', [])
labelStr ='thrust [mm/s]';
data= anaTRA(:,6);
ivT_movie_makeSpeedSubplots_adjustAx(traLen,fps,data,labelStr,subPlotHandle);

%%%%%%%%%%%%%
% SUBPLOT 4 %
%%%%%%%%%%%%%

subPlotHandle = axHandle(4);
%adjust position of the subplot
ivT_movie_makeSpeedSubplots_adjustPos(frameH,subPlotHandle,offSet)

%start plotting
plot(xAx,anaTRA(1:frameNb,7),'Color',paletteKeiIto(7),'LineWidth',2)
hold(subPlotHandle,'on')
plot([0 traLen/fps], zeros(2,1),'k--')
hold(subPlotHandle,'off')

%adjust axes and labels
labelStr ='slip [mm/s]';
data= anaTRA(:,7);
ivT_movie_makeSpeedSubplots_adjustAx(traLen,fps,data,labelStr,subPlotHandle);
xlabel(subPlotHandle,'time [s]')

end

function ivT_movie_makeSpeedSubplots_adjustAx(allFrames,fps,data,labelStr,subPlotHandle)
% This subroutine adjusts the axis labels and limits. As the plots are
% slowly built we have to allready rserve space for the complete plots
xlim(subPlotHandle,[0 allFrames/fps])
yExtremes = [min(data) max(data)];
yAmp = abs(yExtremes(2)-yExtremes(1))/20;
ylim(subPlotHandle,[yExtremes(1)-yAmp yExtremes(2)+yAmp]);
set(subPlotHandle,'yaxisLocation','right')
ylabel(subPlotHandle,labelStr)
end


function ivT_movie_makeSpeedSubplots_adjustPos(frameHandle,subPlotHandle,offSet)
%make the space between frames and subplots smaller
framePos = get(frameHandle,'Position');
subPos = get(subPlotHandle,'Position');
subPos(1) = framePos(1)+framePos(3)+offSet;
set(subPlotHandle,'Position',subPos);
end
