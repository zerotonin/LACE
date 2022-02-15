function ivT_artifact_reportFig(trace,fps,thrustE,slipE,yawE,startNstop,winIDX,traNo,axHandles,axLimTra,titleStr)
% This function checks for artifaxcts in the analysed 2D traces of insects.
% The routine expects speeds to be in the dimensions of mm*s-1 and deg*s-1.
% Then it looks for frames in which the animal exceeds this velocity. It
% returns the indices and values.
%
% GETS:
%           trace = mx6 matrix holding framenumber x-position in pix 
%                   y-position in pix yaw in rad size in pix and the
%                   eccentricity.
%             fps = framerate with which the trajectory was recorded
%         thrustE = a mx2 matrix, where m is the number of detected thrust
%                   artifacts, col(1) holds the frame number col(2) the
%                   speed value
%           slipE = a mx2 matrix, where m is the number of detected slip
%                   artifacts, col(1) holds the frame number col(2) the
%                   speed value
%            yawE = a mx2 matrix, where m is the number of detected yaw
%                   artifacts, col(1) holds the frame number col(2) the
%      startNstop = mx2 matrix col(1) starts and column 2 stops of the cut 
%                   out window
%          winIDX = alogical vector as long as the trajectory in which 1
%                   marks a frame that should be ommited due to artifacts
% optional variables
%           traNo = the number of the trajectory will be shown in the title
%       axHandles = the three plots can also be assigned to different
%                   axes, e.g. GUIs or subaxis figures. In this case
%                   provide the three axishandles as vector.
%        axLimTra = limits for the trajectory plot, [xmin xmax ymin ymax]
%       titleStr =  string with titles e.g. trajectory file
%                   position, otherwise title is tra No
%
% RETURNS: a figure
%
% SYNTAX:ivT_artifact_reportFig(trace,fps,thrustE,slipE,yawE,startNstop,...
%                               winIDX,traNo,axHandles)
%
% Author: B. Geurten 21.05.15
%
% see also ivT_artifact2D_findSpeedArtifacts, ivT_artifact2D_makeCutOutWin

%check if axis handles were provided
if ~exist('axHandles','var'),
    figure(),clf
    axHandles(1) = subplot(4,1, [1 2]);
    axHandles(2) = subplot(4,1,3);
    axHandles(3) = subplot(4,1,4);
else
    if length(axHandles) ~= 3,
        figure(),clf
        axHandles(1) = subplot(4,1, [1 2]);
        axHandles(2) = subplot(4,1,3);
        axHandles(3) = subplot(4,1,4);        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%
% trajectory sub graph %
%%%%%%%%%%%%%%%%%%%%%%%%

lollipopIndex = unique(round(linspace(1,size(trace,1),100)));
if exist('axLimTra','var'),
    maxDist = max([ axLimTra(2)-axLimTra(1) axLimTra(4)-axLimTra(3)]);
    x= [maxDist*0.1 0 0]';
    
else
    maxDist = max([ max(trace(:,1))-min(trace(:,1)) max(trace(:,2))-min(trace(:,2))]);
    x= [maxDist*0.1 0 0]';
end

cla(axHandles(1))
%plot
hold(axHandles(1),'on')



h5=plot(axHandles(1),trace(winIDX,1),trace(winIDX,2),'o','MarkerSize',6,'MarkerFaceColor',[0.5 .5 .5],'MarkerEdgeColor',[0.8 .8 .8]);
for z = lollipopIndex,
    
    
    rot_mat = getFickmatrix(trace(z,3),0,0,'p');
    x_temp = rot_mat * x;
    x_orient = bsxfun(@plus,x_temp(1:2)',trace(z,1:2));
    plot(axHandles(1),[trace(z,1) x_orient(1)],[trace(z,2) x_orient(2)],'Color','c')%[0.75 .75 .75])
    %plot(axHandles(1),trace(z,1),trace(z,2),'o','Color',[0.75 .75 .75],'MarkerFaceColor',[0.75 .75 .75])  % plots heads
end

h1=plot(axHandles(1),trace(:,1),trace(:,2),'k');
h2=plot(axHandles(1),trace(1,1),trace(1,2),'go','MarkerFaceColor','g');
h3=plot(axHandles(1),trace(end,1),trace(end,2),'ro','MarkerFaceColor','r');
h4=plot(axHandles(1),trace([thrustE(:,1);slipE(:,1);yawE(:,1)],1),trace([thrustE(:,1);slipE(:,1);yawE(:,1)],2),'b.');
hold(axHandles(1),'off')

%configure axis
axis(axHandles(1),'equal')
if exist('axLimTra','var'),
axis(axHandles(1),axLimTra)
end

% title labeles and legends
ylabel(axHandles(1),'y-pos [mm]')
xlabel(axHandles(1),'x-pos [mm]')
if sum(winIDX) ~= 0,
hL= legend(axHandles(1),[ h1 h2 h3 h4 h5],'trajectory','start','end','artifacts detected','cut out area');
else
hL= legend(axHandles(1),[ h1 h2 h3 ],'trajectory','start','end');
end
set(hL,'Box','off','Location','NorthEast')
% title 
if exist('titleStr','var'),
    if exist('traNo','var'),
        title(axHandles(1),['trace No: ' num2str(traNo) ' ' titleStr]);
    else
    title(axHandles(1),titleStr)
    end
else
    if exist('traNo','var'),
        title(axHandles(1),['trace No: ' num2str(traNo)]);
    end
    
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translational velocities %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cla(axHandles(2))
%make time axis
timeAx = linspace(1,length(trace./fps),length(trace));
%plot
hold(axHandles(2),'on')
%plot cut out patches
    minY =min(min(trace(:,6:7)));
    maxY =max(max(trace(:,6:7)));
for j =1:size(startNstop,1),
    maxX = timeAx(startNstop(j,2));
    minX = timeAx(startNstop(j,1));
    h = patch([maxX maxX minX minX],[minY maxY maxY minY],'k', 'Parent', axHandles(2));
    set(h,'FaceColor',[.8 .8 .8],'EdgeColor',[1 1 1],'LineStyle','none')
end
h1=plot(axHandles(2),timeAx,trace(:,6),'k');
h2=plot(axHandles(2),timeAx,trace(:,7),'r');
hold(axHandles(2),'off')
ylim(axHandles(2),[minY maxY])

% title labeles and legends
if sum(winIDX) ~= 0,
    hL= legend(axHandles(2),[ h h1 h2],'cutOut','thrust','slip');
else
    hL= legend(axHandles(2),[ h1 h2],'thrust','slip');
end

set(hL,'Box','off')
set(hL,'Location','NorthEast')
ylabel(axHandles(2),'[mm/s]')
set(axHandles(2),'XTickLabel',[])

%%%%%%%%%%%%%%%%%%%%%%%%%
% rotational velocities %
%%%%%%%%%%%%%%%%%%%%%%%%%
cla(axHandles(3))

%plot cut out patches
hold(axHandles(3),'on')
for j =1:size(startNstop,1),
    minY =min(min(trace(:,[3 8])));
    maxY =max(max(trace(:,[3 8])));
    maxX = timeAx(startNstop(j,2));
    minX = timeAx(startNstop(j,1));
    h = patch([maxX maxX minX minX],[minY maxY maxY minY],'k', 'Parent', axHandles(3));
    set(h,'FaceColor',[.8 .8 .8],'EdgeColor',[1 1 1],'LineStyle','none')
end

%plot
[AX,H1,H2] = plotyy(axHandles(3),timeAx,rad2deg(trace(:,3)),timeAx,trace(:,8));
xlabel(axHandles(3),'time [s]')


% title labeles and legends
set(get(AX(2),'Ylabel'),'String','yaw velocity [deg*s-1]')
set(get(AX(1),'Ylabel'),'String','yaw angle [deg]')
hold(axHandles(3),'off')


end