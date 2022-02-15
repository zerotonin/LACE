function trace = ivT_IO_readIVfullTrace(filepos)
% This function reads full traces of ivTools program. This includes the x
% and y position, the yaw direction, area size of the animal and the ratio
% between long and short axis of the ellipsoide fitte to the animal.
%
% GETS:
%        filepos = string containing the trajectory file's position, if not
%                  given function asks in verbose mode
%
% RETURNS:
%          trace = mx9 matrix holding fly trajectories  m is the number 
%                  of frames;
%                  col(1) x-position pixels center of mass 
%                  col(2) y-position pixels center of mass
%                  col(3) yaw in radians center of mass
%                  col(4) space in pixels occupied by the larvae
%                  col(5) ratio between long and short axis of the
%                         elipsoid: 0.5 = circle 1 = line
%
% SYNTAX: trace = ivT_IO_readIVfullTrace(filepos); OR
%         trace = ivT_IO_readIVfullTrace;
%
% Author: Bart Geurten
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

trace = loadco(filepos, 2:6); ... % center of mass x,y,yaw and spaces

    

    