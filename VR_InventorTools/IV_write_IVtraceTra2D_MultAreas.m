function IV_write_IVtraceTra2D_MultAreas(tra,filePos)
% This function writes a ivTrace trajectory to an ascii file. During a
% tracing more than one area can be found and this function writes them
% back as well
%
% GETS
%              tra = a cell array containg  a column vector consisting of
%                    the frame number and any number of areas that a 
%                     formatted this way:
%                    1-2) row position
%                    3)   row orientation (yaw)
%                    4)   row size
%                    5)   row excentricity
%          filePos = string with file position
%
% SYNTAX IV_write_IVtraceTra2D(trajectory,filePos);
%
% Author: B. Geurten 13.11.14
%
% see also fprintf, fopen, fclose, dlmwrite, IV_writeInventorTrj,
%           ivT_IO_readLargeNoisySingleAreaTRA

% opening file dialogue
fid = fopen(filePos, 'w');

% area data format
areaDF = ' %11.2f %11.2f %1.5f %5g %1.2f';

% trajectory length
tra_nb = size(tra,1);

for i=1:tra_nb-1
    % numbner of areas
    areaNum = (length(tra{i})-1)/5;

    % write frame to file
    fprintf(fid,['%5g' repmat(areaDF,1,areaNum) ' \n'],tra{i});
end

% closing file dialogue
fclose(fid);