function IV_filterNcheckTrace(fpos,spos,filterChoice)



%get file
if ~isempty(fpos),
    trajectory = loadcoHACK2(fpos,2:7);
else
    [fname,pname] = uigetfile('*.tra','Select IVtrace trajectory file');
    trajectory = loadcoHACK2([pname fname],2:7);
end

% get file
if isempty(spos),
    spos = [fpos(1:end-4) '_filt' fpos(end-3:end)];
end

% NaN removal of trajectory 
trajectory(isnan(trajectory(:,6)),:) = [];

% angle transformation from rotation axis to passive Fick angles
trajectory(:,4:6) = calcFickAnglesFromRotAxis(trajectory(:,4:6)); % get passive fick angle

% filter and unwrap the yaw angle and filter the coordinates
trajectory = IV_filterInvetorTrace(trajectory,filterChoice);

trajectory(:,4:6) = calcRotAxisFromFickAngles(trajectory(:,4:6),'p'); % get rotAxis

IV_write_IVtraceTra(trajectory,spos)

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