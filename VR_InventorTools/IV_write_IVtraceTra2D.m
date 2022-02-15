function IV_write_IVtraceTra2D(trajectory,filepos)
% This function writes a ivTrace trajectory to an ascii file.
%
% GETS
%       trajectory = m x 6 matrix with m frames
%                    1-2) row position
%                    3)   row orientation (yaw)
%                    4)   row size
%                    5)   row excentricity
%          filepos = string with file position
%
% SYNTAX IV_write_IVtraceTra2D(trajectory,filepos);
%
% Author: B. Geurten
%
% see also fprintf, fopen, fclose, dlmwrite, IV_writeInventorTrj

% trajectory length
tra_nb = size(trajectory,1);

% writing trajectory to disc
fid = fopen(filepos, 'w');

for i=1:tra_nb-1
    fprintf(fid,'%5g %11.2f %11.2f %1.5f %5g %1.2f \n', [i-1 trajectory(i,:)]);
end

fprintf(fid,'%5g %11.2f %11.2f %1.5f %5g %1.2f ',[i trajectory(end,:)]);
fclose(fid);