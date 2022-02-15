function IV_write_discArena(trajectory,filepos,colorscheme)
% this function creates an text file to be interpreted by Inventor V1.0.
% The textfile contains the specifications for the VR model of a flight
% arena consisting of four discs. This arena is has the essential parts of
% the fouraging arena used by Geurten&Lunau during their 2009 poject.
%
% GETS
%       trajectory = a trajectory containg the positions and orientation of
%                    in the IVRENDER FROMAT
%          filepos = position of the results file
%      colorscheme = flag variable, for the color of the four discs:
%                    1: White background dark discs
%                    2: Black background white discs
%                    3: colored discs for different 1st 0 0 0 2nd 1 0 0 3rd
%                       0 1 0 4fth 0 0 1 on white background
%                    4: grayscale: 1st disc 0 0 0 2nd .25 .25 . 25 
%                       3rd .5 .5 .5 4fth .75 .75 .75 on white background
%
% SYNTAX IV_write_discArena(trajectory,fileposm,colorscheme);
%
% Author: B. Geurten
%
% see also fprintf, fopen, fclose, dlmwrite, IV_ivTrace2IVrenderTrj      

%get trajectory length
tra_nb = size(trajectory,1);


%define colorscheme
if colorscheme == 1
    colors = zeros(tra_nb,3);
    disp('White background dark discs')
elseif colorscheme == 2
    colors = ones(tra_nb,3);
    disp('Black background white discs')    
elseif colorscheme == 3
    colors = [0 0 0; 1 0 0; 0 1 0; 0 0 1; 0 1 1; 1 0 1; 0 1 1;];
    disp('colored discs for different 1st 0 0 0 2nd 1 0 0 3rd 0 1 0 4fth 0 0 1 on white background')
elseif colorscheme == 4
    temp = linspace(0,.75,tra_nb)';
    colors = [twmp temp temp];
    disp('grayscale: 1st disc 0 0 0 2nd .25 .25 . 25 3rd .5 .5 .5 4fth .75 .75 .75 on white background')
else
    colors = zeros(tra_nb,3);
    disp('WARNING! colorscheme variable set to illegal value! Used white background dark discs')
end
    
    
%wirte file
fid = fopen(filepos, 'wt');
fprintf(fid, '#Inventor V1.0 ascii\n');
fprintf(fid, '\n');
fprintf(fid, '\n');
for i=1:tra_nb
    fprintf(fid, 'Separator {\n');
    fprintf(fid, '           Translation{\n');
    fprintf(fid, '                    translation %1.3f %1.3f %1.3f \n', trajectory(i,1:3));
    fprintf(fid, '           }\n');
    fprintf(fid, '           Rotation{\n');
    fprintf(fid, '                   rotation 0 1 0 %1.3f \n', trajectory(i,4));
    fprintf(fid, '           }\n');
    fprintf(fid, '           Rotation{\n');
    fprintf(fid, '                   rotation 1 0 0 %1.3f \n', trajectory(i,5)); 
    fprintf(fid, '           }\n');
    fprintf(fid, '           Rotation{\n');
    fprintf(fid, '                   rotation 0 0 -1 %1.3f \n', trajectory(i,6));
    fprintf(fid, '           }\n');
    fprintf(fid, '           Rotation{\n');
    fprintf(fid, '                   rotation 0 1 0 1.5708 \n');
    fprintf(fid, '           }\n');
    fprintf(fid, '           Rotation{\n');
    fprintf(fid, '                   rotation 1 0 0 -1.5708 \n');
    fprintf(fid, '           }\n');
    fprintf(fid, '           Material {\n');
    fprintf(fid, '                    emissiveColor %1.2f %1.2f %1.2f \n', colors(i,:));
    fprintf(fid, '           }\n');
    fprintf(fid, '           Cylinder {\n');
    fprintf(fid, '                    radius 1\n');
    fprintf(fid, '                    height 0.1\n');
    fprintf(fid, '           }\n');
    fprintf(fid, '}\n');
    fprintf(fid, '\n');
end
fclose(fid);