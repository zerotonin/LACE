function [bgFileName,roiFileName,scriptFileName,variablesFileName,...
              resultFileName] = ET_GUI_spline_SR_remoteNamingScripts(handles,...
              bgFileName,roiFileName,scriptFileName,variablesFileName,...
              resultFileName)
% This function of the Ethotrack graphical user interface toolbox (ET_GUI_)
% sets the remote filenames and overwrites existing ones
%
% GETS:
%             handles = struct holding all gui handles
%
%
% RETURNS:
%             plot img via imagesc to handles.axes1
%
% SYNTAX:  [bgFileName,roiFileName,scriptFileName,variablesFileName,...
%              resultFileName] = ET_GUI_spline_SR_autoNamingScripts(handles,...
%              bgFileName,roiFileName,scriptFileName,variablesFileName,...
%              resultFileName);
%
% Author: B.Geurten 01-26-2016
% 
% Notes:
% This might only work for Zebrafishes!
%
% see also ET_GUI_spline_SR_imageManip
    remMovSource = getappdata(handles.output,'remMovSource');
    remBGSource = getappdata(handles.output,'remBGSource');
    remROISource = getappdata(handles.output,'remROISource');
    remScriptSource = getappdata(handles.output,'remScriptSource');
    remVarSource = getappdata(handles.output,'remVarSource');
    remResultSource = getappdata(handles.output,'remResultSource');
    scriptAutoNaming = getappdata(handles.output,'scriptAutoNaming');
    
    
    %remote filenames
    if scriptAutoNaming == 0 && ~isempty(remMovSource),
        movFileName = remMovSource;
    end
    if scriptAutoNaming == 0 && ~isempty(remBGSource),
        bgFileName = remBGSource;
    end
    if scriptAutoNaming == 0 && ~isempty(remROISource),
        roiFileName = remROISource;
    end
    if scriptAutoNaming == 0 && ~isempty(remScriptSource),
        scriptFileName = remScriptSource;
    end
    if scriptAutoNaming == 0 && ~isempty(remVarSource),
        variablesFileName = remVarSource;
    end
    if scriptAutoNaming == 0 && ~isempty(remResultSource),
        resultFileName = remResultSource;
    end