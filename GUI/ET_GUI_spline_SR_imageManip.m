function testimg = ET_GUI_spline_SR_imageManip(handles,frameNumber)
% This function of the Ethotrack graphical user interface toolbox (ET_GUI_)
% calculates image manipulations like is stanardly done during image
% analysis by the Ethotrack image manipulation toolbox (ET_im), and plots
% them in th
%
% GETS:
%             handles = struct holding all gui handles
%         frameNumber = the frame to be analysed
%
%
% RETURNS:
%             testimg = a twice as large image as the frame containing the
%                       original frame in the upper left corner. To the
%                       left of it is the difference image. Inthe lower
%                       left corner the frame is shown after binarisation
%                       and ROI usage. In the lower right corner the final
%                       image fro object detection is shown, e.g. after
%                       image erosion was done.
%
% SYNTAX: testimg = ET_GUI_spline_SR_imageManip(handles,frameNumber);
%
% Author: B.Geurten 01-26-2016
% 
% Notes:
% This might only work for Zebrafishes!
%
% see also FILA_ana_getSpine

%get data from handles
movieFpos = getappdata(handles.output,'movieFilePos');
bgDir = getappdata(handles.output,'bgDiff');
diffDir = getappdata(handles.output,'differenceDir');
angleCorrection = getappdata(handles.output,'angleCorr');
contrastThresh = getappdata(handles.output,'conThresh');
eroderR = getappdata(handles.output,'eroderR');
if  getappdata(handles.output,'useROI') ==1,
    maskIDX = getappdata(handles.output,'ROI');
else
    maskIDX = [];
end
% pre allocate
testimg = [];
% test if diffDir was set
if isempty(diffDir) || strcmp(diffDir,'difference direction'),
    errordlg('You have to pick a substraction mode first')
else
    
    %get background
    bg = ET_GUI_spline_SR_getOrCalcBG(handles,bgDir);
    
    %read image
    frame = ET_GUI_SR_loadFrame(handles,frameNumber);
    % get difference image
    diffImage = ET_im_diffImage(frame,bg,diffDir);
    % rotate image
    diffImage = ET_im_rotate(diffImage,angleCorrection);
    diffImage = ET_GUI_SR_undistort(handles,diffImage);
    
    % normalise differece image
    diffImage = ET_im_normImage(diffImage);
    % binarise image
    imageBin = diffImage > contrastThresh;
    % use ROI
    if ~isempty(maskIDX),
        imageBin(maskIDX) = false;
    end
    % erode bin image
    imageMask = ET_im_erode(imageBin,eroderR);
    
    testimg = [ET_im_normImage(frame),diffImage;imageBin,imageMask];
end
end
