function trace3D = ivT_analyse3DmanTrace(fpos,filterChoice)
% This function loads and filters a 3D space from ivTrace. This traces
% consists of all 6 degrees of freedom.



%get file
if ~isempty(fpos),
    trace3D = loadcoHACK2(fpos,2:7);
else
    [fname,pname] = uigetfile('*.tra','Select IVtrace trajectory file');
    trace3D = loadcoHACK2([pname fname],2:7);
end

% NaN removal of trajectory 
trace3D(isnan(trace3D(:,6)),:) = [];

% angle transformation from rotation axis to passive Fick angles
trace3D(:,4:6) = calcFickAnglesFromRotAxis(trace3D(:,4:6)); % get passive fick angle

% filter and unwrap the yaw angle and filter the coordinates
trace3D = IV_filterInvetorTrace(trace3D,filterChoice);

trace3D(:,4:6) = calcRotAxisFromFickAngles(trace3D(:,4:6),'p'); % get rotAxis



function r=loadcoHACK2(name, cols)    

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