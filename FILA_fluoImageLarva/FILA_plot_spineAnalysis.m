function FILA_plot_spineAnalysis(anaRes,axisHandle,tString,legendPos)

if exist('axisHandle','var')
    if isempty(axisHandle)
        figure();
        axisHandle= gca;
    end
else
    figure();
    axisHandle= gca;
end

if exist('tString','var')
    if isempty(tString)
        tString = 'larva detection';
    end
else
    tString = 'larva detection';
end

% preallocate handle variable
h = NaN(7,1);

imshow(anaRes.image','Parent',axisHandle )
hold(axisHandle,'on')
h(1)=plot(axisHandle,anaRes.outterBoundary(:,1),anaRes.outterBoundary(:,2),'g');
h(2)=plot(axisHandle,anaRes.innerBoundary (:,1),anaRes.innerBoundary (:,2),'g--');
h(3)=plot(axisHandle,anaRes.centroid (:,1),anaRes.centroid (:,2),'go','MarkerSize',10);
h(4)=plot(axisHandle,anaRes.spline(:,1),anaRes.spline(:,2),'b--');
h(5)=plot(axisHandle,anaRes.splineEdges(:,1),anaRes.splineEdges(:,2),'c.-');
h(6)=plot(axisHandle,anaRes.gutCenter(:,1),anaRes.gutCenter(:,2),'rp','MarkerSize',10);
h(7)=plot(axisHandle,anaRes.gutBoundary(:,1),anaRes.gutBoundary(:,2),'r--');
hold(axisHandle,'off')

legend(h,{'animal hull','central body','center of mass','central line','inner line','gut center','gut boundary'},'Location', legendPos)
title(tString)