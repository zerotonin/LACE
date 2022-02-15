function trace = ivT_IO_readMultFullIVtrace(filepos,traID)
% This function reads multiple traces from a ivTrace trajectory file. If
% the entry variables are not given the function acquires them in verbose
% mode.
%
% GETS:
%        filepos = string containing the trajectory file's position
%          traID = trajectory identification numbers as matlab syntax in
%                  string format, e.g. "1:5, 7, 23, 6". If set to 'all',
%                  all traces in the trajectory file will be read.
%
% RETURNS:
%          trace = mx5xn matrix holding fly trajectories  m is the number 
%                  of frames, col(1) xposition col(2) y-position col(3) yaw
%                  in radians; col(4) eccentricity col(5) area size  
%                  p is the number of trajectories
%
% SYNTAX: trace = ivT_IO_readMultFullIVtrace(filepos,traID);
%
% Author: Bart Geurten 10.03.14
% 
% see also: loadco

% check if fileposition is given
if ~exist('filepos','var'),
    [fname,path]=uigetfile('*.tra','Pick ivTrace trajectory');
    filepos = [path fname];
elseif isempty(filepos)
    [fname,path]=uigetfile('*.tra','Pick ivTrace trajectory');
    filepos = [path fname];
end

if ~exist('traID','var'),
    prompt = {'Enter tra IDs in Matlab syntax (e.g. 1:10):'};
    dlg_title = 'trajectory IDs';
    num_lines = 1;
    def = {'1'};
    mlSyntax = inputdlg(prompt,dlg_title,num_lines,def);
    eval(['traID = ' mlSyntax{1} ';']);
elseif isempty(traID)
    prompt = {'Enter tra IDs in Matlab syntax (e.g. 1:10):'};
    dlg_title = 'trajectory IDs';
    num_lines = 1;
    def = {'1'};
    mlSyntax = inputdlg(prompt,dlg_title,num_lines,def);
    eval(['traID = ' mlSyntax{1} ';']);
end

if strcmp(traID,'all'),
    fid = fopen(filepos);
    line = fgetl(fid);
    numbers = sscanf(line,'%f',[1 inf]);
    traID = (length(numbers)-1)/5;
    traID =1:traID;
    fclose(fid);
end
%read tra file    
trace = textread(filepos);
% reduce frameNumbers
trace = trace(:,2:end);
%reshape to mx5xp
[rows,cols]= size(trace);
AreaNum = cols/5;
trace = reshape(trace,[rows,5,AreaNum]);