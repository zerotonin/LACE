function [h1,h2] = errorareaTrans24GUI(xValues,yValues,errH,errL,lineColor, areaColor,alpha,axH)
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

%**************************************************************************
%***                    check input arguments                           ***
if nargin ~= 8 
    error('wrong number of input arguments!');
end
if ~isvector(xValues) || ~isvector(yValues) || ~isvector(errH) || ~isvector(errL)
    error('xValues,yValues, and error must be vectors!');
end
if (find(size(xValues) == max(size(xValues)))) == 2
    xValues = xValues';
end
if (find(size(yValues) == max(size(yValues)))) == 2
    yValues = yValues';
end
if (find(size(errH) == max(size(errH)))) == 2
    errH = errH';
end
if (find(size(errL) == max(size(errL)))) == 2
    errL = errL';
end
%**************************************************************************
%***                    prepare polygone vertices                       ***
x = cat(1,xValues,flipud(xValues));
y = cat(1,errH,flipud(errL));
%**************************************************************************
%***                    plot mean and deviation                         ***
h1 = fill(x,y,areaColor,'LineStyle','none','facealpha',alpha,'Parent',axH); hold(axH,'on');
h2 = plot(axH,xValues,yValues,'color',lineColor);hold(axH,'off');
