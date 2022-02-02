function [bgFileName,roiFileName,scriptFileName,variablesFileName,...
              resultFileName] = ET_GUI_spline_SR_autoNamingScripts(handles)
% This function of the Ethotrack graphical user interface toolbox (ET_GUI_)
% this  makes the auto naming files as:
% scriptsPath / subfolder / detScriptTag typeTage .mat
%
% GETS:
%             handles = struct holding all gui handles
%
%
% RETURNS:
%             plot img via imagesc to handles.axes1
%
% SYNTAX:  [bgFileName,roiFileName,scriptFileName,variablesFileName,...
%            resultFileName] = ET_GUI_spline_SR_autoNamingScripts(handles);
%
% Author: B.Geurten 01-26-2016
% 
% Notes:
% This might only work for Zebrafishes!
%
% see also ET_GUI_spline_SR_imageManip

movieFpos = getappdata(handles.output,'movieFilePos');
detScriptPath = getappdata(handles.output,'detScriptPath');
detScriptTag = getappdata(handles.output,'detScriptTag');



%get movie position
movFileName = movieFpos.fPos;
% get file basis name
[~,fileBasis,~]=fileparts(movFileName);
idx = strfind(fileBasis,'-');
fileBasis(idx) = '_';
% make background name
bgFileName = [detScriptPath 'backGrounds' filesep detScriptTag fileBasis '_bg.mat'];
% make ROI name
roiFileName = [detScriptPath 'ROIs' filesep detScriptTag fileBasis '_roi.mat'];
% make script name
scriptFileName = [detScriptPath 'scripts' filesep 'ETscript_' detScriptTag '_'  fileBasis '.m'];
% make variables name
variablesFileName = [detScriptPath 'variables' filesep detScriptTag fileBasis '_var.mat'];
% make Result name
resultFileName = [detScriptPath 'traceResults' filesep detScriptTag fileBasis '_result.mat'];