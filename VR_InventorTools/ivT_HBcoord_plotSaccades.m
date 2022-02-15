function ivT_HBcoord_plotSaccades(average,frameRate,frameWin,speeds,modus,col,col2)
% This 


if isempty(col),
    col = [.35 .7 .9];
end
if isempty(col2),
    col2 = [0 .45 .70];
end
% make time axis
timeAxis = linspace(frameWin/frameRate*-1000,frameWin/frameRate*1000,2*frameWin+1);
% labels for the y-axis and title
labels = {'yaw' 'pitch' 'roll'};
for i =speeds,
    %plot angle velocity
  %  figure()
    subplot(2,1,1)
    if strcmp(modus,'trans'),
        
        errorareaTrans(timeAxis,average(i,:,1),average(i,:,2),col,col,.5);
        hold on
        errorareaTrans(timeAxis,average(i+3,:,1),average(i+3,:,2),col2,col2,.5);
    elseif strcmp(modus,'eps')
        errorarea(timeAxis,average(i,:,1),average(i,:,2),col,col);
        hold on
        errorarea(timeAxis,average(i+3,:,1),average(i+3,:,2),col2,col2);
    else
        error(['ivT_HBcoord_plotSaccades: modus was wrong defined as ' modus 'choose from "trans" or "eps"']);
    end
    title([labels{i} ' velocity'])
    xlabel('time [ms]')
    ylabel([labels{i} ' velocity [deg*s^-^1]'])
    % plot angle position
    subplot(2,1,2)
    if strcmp(modus,'trans'),
        errorareaTrans(timeAxis,average(i+6,:,1),average(i+6,:,2),col,col,.5);
        hold on
        errorareaTrans(timeAxis,average(i+9,:,1),average(i+9,:,2),col2,col2,.5);
    elseif strcmp(modus,'eps')
        errorarea(timeAxis,average(i+6,:,1),average(i+6,:,2),col,col);
        hold on
        errorarea(timeAxis,average(i+9,:,1),average(i+9,:,2),col2,col2);
    else
        error(['ivT_HBcoord_plotSaccades: modus was wrong defined as ' modus 'choose from "trans" or "eps"']);
    end
    title(labels{i} )
    xlabel('time [ms]')
    ylabel([labels{i} '  [deg]'])
    
end
