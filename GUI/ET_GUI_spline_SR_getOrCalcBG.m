function bg = ET_GUI_spline_SR_getOrCalcBG(handles,bgDir)
% This function of the Ethotrack graphical user interface toolbox (ET_GUI_)
% calculates teh background image via ET_bg_calcForNorPixSeq or if this has
% allready happend recalls it from handles.
%
% GETS:
%             handles = struct holding all gui handles
%               bgDir = background type; string that is either 'minBG' or
%                       'maxBG' or 'meanBG'
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
% SYNTAX: bg = ET_GUI_spline_SR_getOrCalcBG(handles,bgDir);
%
% Author: B.Geurten 01-26-2016
%
% Notes:
% This might only work for Zebrafishes!
%
% see also ET_GUI_spline_SR_imageManip

try,
    headSize = getappdata(handles.output,'headerSize');
catch
    headSize = 1024
end

movieIOtype = getappdata(handles.output,'movieIOtype');
%get background
switch bgDir,
    case 'min BG'
        bg = getappdata(handles.output,'minBG');
    case 'max BG'
        bg = getappdata(handles.output,'maxBG');
    case 'mean BG'
        bg = getappdata(handles.output,'meanBG');
end

% if background is empty you have to calculate it
if isempty(bg),
    % check the file dialogue
    movieFpos = getappdata(handles.output,'movieFilePos');
    
    switch movieIOtype,
        % Norpix File Seq
        case 'norpix',
            
            %save background to GUI
            switch bgDir,
                case 'min BG'
                    bg = ET_bg_calcForNorPixSeq(movieFpos.fid,movieFpos.headerInfo,movieFpos.endianType,movieFpos.IDX,'min',1,headSize);
                    setappdata(handles.output,'minBG',double(bg));
                case 'max BG'
                    bg = ET_bg_calcForNorPixSeq(movieFpos.fid,movieFpos.headerInfo,movieFpos.endianType,movieFpos.IDX,'max',1,headSize);
                    setappdata(handles.output,'maxBG',double(bg));
                case 'mean BG'
                    bg = ET_bg_calcForNorPixSeq(movieFpos.fid,movieFpos.headerInfo,movieFpos.endianType,movieFpos.IDX,'mean',1,headSize);
                    setappdata(handles.output,'meanBG',double(bg));
            end
            
        % Video Reader        
        case 'videoReader'
            %save background to GUI
            switch bgDir,
                case 'min BG'
                    [bg,IDX] = ET_bg_calcForVRobj(movieFpos.movObj,movieFpos.IDX,'min',1);
                    movieFpos.IDX = IDX;
                    setappdata(handles.output,'movieFilePos',movieFpos );
                    setappdata(handles.output,'minBG',double(bg));
                case 'max BG'
                    [bg,IDX] = ET_bg_calcForVRobj(movieFpos.movObj,movieFpos.IDX,'max',1);
                    movieFpos.IDX = IDX;
                    setappdata(handles.output,'movieFilePos',movieFpos );
                    setappdata(handles.output,'maxBG',double(bg));
                case 'mean BG'
                    [bg,IDX] = ET_bg_calcForVRobj(movieFpos.movObj,movieFpos.IDX,'mean',1);
                    movieFpos.IDX = IDX;
                    setappdata(handles.output,'movieFilePos',movieFpos );
                    setappdata(handles.output,'meanBG',double(bg));
            end
            
            
                    % Image Stack
                case 'imageStack'
            switch bgDir,
                case 'min BG'
                    bg =ET_bg_calcForImgStack(movieFpos.fPos,movieFpos.IDX,'min',1);
                    setappdata(handles.output,'minBG',double(bg));
                case 'max BG'
                    bg = ET_bg_calcForImgStack(movieFpos.fPos,movieFpos.IDX,'max',1);
                    setappdata(handles.output,'maxBG',double(bg));
                case 'mean BG'
                    bg = ET_bg_calcForImgStack(movieFpos.fPos,movieFpos.IDX,'mean',1);
                    setappdata(handles.output,'meanBG',double(bg));
            end
            
        otherwise
            errordlg('Not implemented yet!');
    end
    bg = double(bg);
end