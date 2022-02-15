function [h1,h2] = errorareaTrans(xValues,yValues,err,lineColor, areaColor,alpha,axH)
% errorarea plots the 'yValues' as a function of the 'xValues' and indicates
% the estimation 'error' by drawing a coloured area with the bounderies
% yValues +- err. 'lineColor' is the color of the yValues plot and 'areaColor' 
% represents the colour of the error area. Both colour specifications can be
% the usual 'colorSpecs' for the plot function or a three element vector 
% specifying the colour in RGB space. 'xValues', 'yValues', and 'err' must
% be vectors!
% SYNTAX function errorarea(xValues,yValues,err,lineColor, areaColor)
% written by Jan Grewe; no guaranty given!
%
% SYNTAX errorarea(xValues,yValues,err,lineColor, areaColor)

%*********
if ~isvector(xValues) || ~isvector(yValues) || ~isvector(err)
    error('xValues,yValues, and error must be vectors!');
end
if (find(size(xValues) == max(size(xValues)))) == 2
    xValues = xValues';
end
if (find(size(yValues) == max(size(yValues)))) == 2
    yValues = yValues';
end
if (find(size(err) == max(size(err)))) == 2
    err = err';
end

if ~exist('axH','var')
        axH = gca;
else
    if isempty(axH)
        axH = gca;
    end
    
end
%**************************************************************************
%***                    prepare polygone vertices                       ***
x = cat(1,xValues,flipud(xValues));
y = cat(1,yValues+err,flipud(yValues-err));
%**************************************************************************
%***                    plot mean and deviation                         ***
h1 = fill(x,y,areaColor,'LineStyle','none','facealpha',alpha,'Parent',axH); 
hold(axH,'on');
h2 = plot(axH,xValues,yValues,'color',lineColor);
hold(axH,'off');
