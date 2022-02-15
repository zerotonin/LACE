function TMP_avi2ivTraceTif(filepos,savePath,prefix)
% This function converts .avi files to .tif files. The .tifs have a single
% gray colour sheet. If no file location is given, the function asks to
% chose a file. If 'verbose' is put in, the function asks to chose a file
% directory. Otherwise, tifs are saved to D:\TemperatureMovieTifs\filename.
% If no prefix is given, prefixes are set to 'frame_' followed by the frame
% number. While the movie is split into frames, a wait bar shows the 
% progress of the splitting. The frames are then converted individually 
% from .avi to .tif.
%
% GETS
%        filepos = location of the .avi file
%       savePath = directory of the .tif file
%         prefix = common prefix in all frames of one movie. If none is
%                  specified, set to 'frame_'. Prefix is followed by the
%                  frame number.
%
% RETURNS
%       frame_nb = number of frames
%         digits = number of digits
%        tempPic = frame that is currently being converted (temporary file)
%     splitMovie = imports movie data from .avi file
%       
% SYNTAX: TMP_avi2ivTraceTif(filepos,savePath,prefix)
%
% Author: B. Geurten 14.03.2012
%
% see also imwrite, mmreader

% check if file position is given  if not ask
if ~exist('filepos','var'),
    [fname,path]=uigetfile('*.avi','Pick movie file');
    filepos = [path fname];
elseif strcmp(filepos,'verbose')
    [fname,path]=uigetfile('*.avi','Pick movie file');
    filepos = [path fname];
end

% check if file directory to save tifs in, is given  if not ask
if ~exist('savePath','var'),
    pname=fname(1:end-4);
    savePath = ['D:\TemperatureMovieTifs\' pname];
    mkdir(savePath)
elseif strcmp(savePath,'verbose')
    [savePath]=uigetdir('D:\','path to save tifs');
end

%check if prefix is given, otherwise set to frame_
if ~exist('prefix','var'),
   prefix = 'frame_';
end

% read avi metadata
splitMovie = mmreader(filepos);
%get number of frames and number of digits
frame_nb = splitMovie.NumberOfFrames;
digits = length(num2str(frame_nb));
h = waitbar(0,'splitting movie');
for i=1:frame_nb,
    %read frame from avi
    tempPic = read(splitMovie,i);
    % ivTrace takes only one color sheet
    tempPic = tempPic(:,:,1);
    %write out tiff
    imwrite(tempPic,gray,[savePath '\' prefix num2strleadingZero(i,digits) '.tif']);
    waitbar(i/frame_nb)
end
close(h)