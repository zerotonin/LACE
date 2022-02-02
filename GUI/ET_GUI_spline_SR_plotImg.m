function ET_GUI_spline_SR_plotImg(handles,img,titleStr, turnFlag)
% This function of the Ethotrack graphical user interface toolbox (ET_GUI_)
% plots the img image to handles.axes1
%
% GETS:
%             handles = struct holding all gui handles
%                 img = a mxn matrix that will be ploted using imagesc and
%                       colormap gray
%            titleStr = string with title information
%            turnFlag = if 1 or undefined the image will be turned
%
%
% RETURNS:
%             plot img via imagesc to handles.axes1
%
% SYNTAX: bg = ET_GUI_spline_SR_getOrCalcBG(handles,bgDir);
%
% Author: B.Geurten 01-26-2016
% 
% Notes:
% This might only work for Zebrafishes!
%
% see also ET_GUI_spline_SR_imageManip


% turn flag
if ~exist('turnFlag','var'),
    turnFlag = 1;
end

img = ET_GUI_SR_undistort(handles,img);

% turn the image
if turnFlag == 1,
    angleCorrection = getappdata(handles.output,'angleCorr');
    img = ET_im_rotate(img,angleCorrection);
end

% clear axis
cla(handles.axes1)

% plot image
imagesc(img,'Parent',handles.axes1)
colormap(handles.axes1,'gray');
axis(handles.axes1,'image');
title(titleStr)
end