function IV_write_InventorTrj(trajectory,filepos)
% This function writes an inventor camera trajectory to disk.
%
% GETS
%       trajectory = m x 6 matrix with m frames
%                    1-3) row position
%                    4-6) row orientation (rotation axis)
%          filepos = string with file position
%
% SYNTAX IV_writeInventorTrj(trajectory,filepos);
%
% Author: B. Geurten
%
% see also fprintf, fopen, fclose, dlmwrite, IV_ivTrace2IVrenderTrj

% trajectory length
tra_nb = size(trajectory,1);

% writing trajectory to disc
fid = fopen(filepos, 'wt');
for i=1:tra_nb-1
    fprintf(fid, '%11.6f %11.6f %11.6f %11.6f %11.6f %11.6f\n', trajectory(i,:));
end
fprintf(fid, '%11.6f %11.6f %11.6f %11.6f %11.6f %11.6f', trajectory(end,:));
fclose(fid);