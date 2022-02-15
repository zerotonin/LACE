function IV_filterNcheckTrace3D(fpos,spos,filterChoice)
% This function filters and checks traces of the 3D version of flytrace.
% This can be easily used to filter large numbers of traces and check
% afterwards if the data can be used. This version will read in files with
% missing trajectory positions and set those to be NaN
%
% GETS:
%            fpos = file position of the trace, if empty this will be asked
%                   in verbose mode
%            spos = save position of the trace, if empty is identical to
%                   fpos, but before the file extension there will be a
%                   _filt suffix
%    filterChoice = flag to determine which filter to use (moszt often 3)
%                   1: Savitzky-Golay (3,21)
%                   2: Savitzky-Golay (3,31)
%                   3: Butterworth (2,0.1)
%                   4: Butterworth (2,0.05)
%                   5: Butterworth (3,0.1)
%                   6: Gauss 50 frame window | 3 frame sigma
%                   default and other values evoke no filtering
%
% RETURNS: nothing but writes resulting trajectory to disk at spos.
%
% SYNTAX: IV_filterNcheckTrace3D(fpos,spos,filterChoice)
%
% Author: B. Geurten
%
% see also: calcRotAxisFromFickAngles,loadcoHACK, IV_filterInvetorTrace, 
%           IV_write_IVtraceTra,uigetfile

%get file
if ~isempty(fpos),
    trajectory = loadcoHACK(fpos,2:7);
else % do it in verbose
    [fname,pname] = uigetfile('*.tra','Select IVtrace trajectory file');
    trajectory = loadcoHACK([pname fname],2:7);
end

%get file
if isempty(spos),% create outputfile
    spos = [fpos(1:end-4) '_filt' fpos(end-3:end)];
end

% angle transformation from rotation axis to passive Fick angles
trajectory(:,4:6) = calcFickAnglesFromRotAxis(trajectory(:,4:6)); % get passive fick angle

% filter and unwrap the yaw angle and filter the coordinates
trajectory = IV_filterInvetorTrace(trajectory,filterChoice);
% transform angles back to RotAxis
trajectory(:,4:6) = calcRotAxisFromFickAngles(trajectory(:,4:6),'p'); % get rotAxis
%write out trajectory
IV_write_IVtraceTra(trajectory,spos)

function r=loadcoHACK(name, cols)    

% This version of loadco reads in broken files as well, meaning if not all 
% trajectory positions are analysed, it fills those with NaNs.
%
% LOADCO load data from specific columns of an ascii file 
%   R=LOADCO(FILENAME, COLS) returns a matrix of values from FILENAME where
%   the columns is defined by an index expression COLS. Lines of FILENAME with 
%   more than COLS columns are truncated. If FILENAME contains lines with
%   too few columns for COLS, an error occurs. 

    fid=fopen(name);
    r=[];
    while 1
        ln=fgetl(fid);
        if (~ischar(ln)) 
            break 
        end
        nums=sscanf(ln, '%f');
        if length(nums) ==1, % cheap hack
            r = [r; NaN(1,length(cols))];
        else
            r=[r; nums(cols)'];
        end
    end
    fclose (fid);