function trajectory=IV_ivTrace2IVrenderTrj(filepos)
% This function tranforms a IVtrace 3D trajectory in to a Inventor readable
% camera trajectory. Therefore the orientations has to betransformed from
% a rotation axis normalized to the roationan angle (ivTrace) into the
% passive Fick angles (Inventor). Also the y,z axis have to be adjusted to
% the different coordinate system. The trajectory furthermore is filtered
% with a 2nd degree Butterworth filter with a cut off frequency of .1
%
% GETS
%       filepos = absolute file position, if not given file position of the
%                 IVtrace trajectory will be asked
%
% RETURNS
%       trajectory mx6 matrix consisting of x,y,z position in Inventor
%       coordinates and yaw pitch roll as passive Fick angles
%
% SYNTAX IV_ivTrace2IVrenderTrj(trajectory,filepos);
%
% Author: B. Geurten
%
% see also IV_writeInventorTrj, IV_write_discArena,
% calcFickAnglesFromRotAxis

%get file
if exist('filepos','var'),
    trajectory = loadcoHACK(filepos,2:7);
else
    [fname,pname] = uigetfile('*.tra','Select IVtrace trajectory file');
    trajectory = loadcoHACK([pname fname],2:7);
end

% angle transformation from rotation axis to passive Fick angles
trajectory(:,4:6) = calcFickAnglesFromRotAxis(trajectory(:,4:6)); % get passive fick angle

%function call to transform from IvTrace to IvRender
trajectory = path2tra(trajectory);


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
