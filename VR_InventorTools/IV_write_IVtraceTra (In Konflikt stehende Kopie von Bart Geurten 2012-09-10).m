function IV_write_IVtraceTra(trajectory,filepos)
% This function writes a ivTrace trajectory to an ascii file.
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
% see also fprintf, fopen, fclose, dlmwrite, IV_writeInventorTrj

% trajectory length
tra_nb = size(trajectory,1);

% writing trajectory to disc
fid = fopen(filepos, 'wt');
for i=1:tra_nb-1
    fprintf(fid, '%5g %11.6f %11.6f %11.6f %11.6f %11.6f %11.6f\n', [i-1 trajectory(i,:)]);
end
fprintf(fid, '%5g %11.6f %11.6f %11.6f %11.6f %11.6f %11.6f',[i-1 trajectory(end,:)]);
fclose(fid);