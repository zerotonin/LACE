function [tra_all names]= ivT_IO_loadmultFullTra(flist)
% This function reads multiple full traces as returned by ivTrace. All
% traces will be combined in one matrix
%
% GETS:
%          flist = file struct as returned by rdir or a cell array with
%                  strings containing the absolute file position
%
% RETURNS:
%          names = cell matrix containing the file position index
%                  corresponds to first column number of tra_all
%        tra_all = is a cell array in which every cell holds a 
%                  mx5 matrix holding fly trajectories  m is the number 
%                  of frames;
%                  col(1) x-position pixels center of mass 
%                  col(2) y-position pixels center of mass
%                  col(3) yaw in radians center of mass
%                  col(4) space in pixels occupied by the larvae
%                  col(5) ratio between long and short axis of the
%                         ellipsoid 0.5 = circle 1 = line
%
% SYNTAX: [tra_all names]= ivT_IO_loadmultFullTra(flist); 
%
% Author: Bart Geurten
% 
% see also: loadco

fileNb = length(flist);
tra_all =cell(fileNb,1);
names =cell(fileNb,1);



%disp
if iscell(flist),
    for i = 1:fileNb,
        disp(['loading trace No ' num2str(i) ':' flist{i} ' ...'])
        try
            tra_all{i}  = ivT_IO_readIVfullTrace(flist{i});
            names{i} = flist{i};
        catch err
            rethrow(err);
            disp(['loading trace No ' num2str(i) ':' flist{i} ' could not be opened'])
        end
    end
    
elseif isstruct()
    for i = 1:fileNb,
        disp(['loading trace No ' num2str(i) ':' flist(i).name ' ...'])
        try
            tra_all{i}  = ivT_IO_readIVfullTrace(flist(i).name);
            names{i} = flist(i).name;
        catch err
            rethrow(err);
            disp(['loading trace No ' num2str(i) ':' flist{i} ' could not be opened'])
        end
    end
    
else
    error('ivT_IO_loadmultFullTra:fList is neither struct nor cell array!')
end

