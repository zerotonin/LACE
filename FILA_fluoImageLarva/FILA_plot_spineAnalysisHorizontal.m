function FILA_plot_spineAnalysisHorizontal(anaRes,axisHandle,tString,legendPos)

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
h = NaN(5,1);
cla(axisHandle.axes17)
cla(axisHandle.axLarva)
imshow(anaRes.image,'Parent',axisHandle.axes17 )
hold(axisHandle.axLarva,'on')
try
h(1)=plot(axisHandle.axLarva,anaRes.outterBoundary(:,2),anaRes.outterBoundary(:,1),'g');
end
try
h(2)=plot(axisHandle.axLarva,anaRes.centroid(:,2),anaRes.centroid(:,1),'go','MarkerSize',10);
end
try
h(3)=plot(axisHandle.axLarva,anaRes.spline(:,2),anaRes.spline(:,1),'b--');
end
try
h(4)=plot(axisHandle.axLarva,anaRes.splineEdges(:,2),anaRes.splineEdges(:,1),'c.-');
end
try
h(5)=plot(axisHandle.axLarva,anaRes.gutCenter(:,2),anaRes.gutCenter(:,1),'rp','MarkerSize',10);
end
hold(axisHandle.axLarva,'off')
axis(axisHandle.axLarva,'auto')
axis(axisHandle.axLarva,'equal')
try
    legend(h,{'animal hull','center of mass','central line','inner line','gut center'},'Location', legendPos)
end
title(axisHandle.axLarva,tString)