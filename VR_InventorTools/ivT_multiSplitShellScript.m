function ivT_multiSplitShellScript
% This function builts LINUX shell scripts to split avi movies into jpeg
% and organise the data into a subfolder structure. It also creates a list
% of image positions for easier use with ivTrace.
% Generally all high speed movies have automated filenames that follow this
% structure YEAR-MM-DD__HH_MM_SS.avi e.g. 2013-07-28__12-13-59.avi if a
% part of the movie was saved it is usually called:
% YEAR-MM-DD__HH_MM_SS-FRAMES-FRAMES.avi eg 2013-07-28__12-13-59-12-245.avi
%
% This function now splits the avi into images 

path2source= uigetdir(pwd,'Pick the movie directory');
path2split =  uigetdir(pwd,'Pick the directory for the Images');
[script_fn,path2script] = uiputfile('','Name of the script file','multiSplitScript.sh');
%
files = dir([path2source filesep '*.avi']);
files = {files.name};
days = unique(cellfun(@(x) x(1:10),files,'UniformOutput',false));


prompt = {'Enter framerate:','Enter approx. number of frames:', 'Number of useable CPUs:'};
dlg_title = 'Input for peaks function';
num_lines = 1;
def = {'50','10000','2'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
frameRate = str2num(answer{1});
digits = length(answer{2});
cpuNo = str2num(answer{3});



% write shell script header

fid = fopen([path2script  script_fn],'w');

fprintf(fid,'%s\n','# This is a automated shell script to split large numbers of HS movies into frames.');
fprintf(fid,'%s\n','# It uses avconv and works only on LINUX systems on which avconv is installed.');
fprintf(fid,'%s\n',['# The script wa automatically created by ivT_multiSplitShellScript.m @ ' datestr(now)]);
fprintf(fid,'\n');



% make day directories fprintf(fid,'%s\n',[]);

for i =1:length(days)
    fprintf(fid,'%s\n',['mkdir ' path2split filesep days{i} ]);
end
fprintf(fid,'\n');

% movie operations

for i =1:length(files);
    % get recording time
    time = files{i}(13:end-4);
    day = files{i}(1:10);
    
    % make movie directories
    path2movie = [path2split filesep day filesep time];
    path2frames = [path2movie filesep 'frames'];
    
    %built filepositions
    aviPos = [path2source filesep files{i}];
    aviTargetPos = [path2movie filesep files{i}];
    imageTargetPos =[path2frames filesep 'frame_%' num2str(digits) 'd.jpg'];
    listPos = [path2movie filesep 'list.txt'];
    listPos2 = [path2split filesep files{i}(1:end-4) '.txt'];
   
    % write shell commands
    fprintf(fid,'%s\n',['# movie No ' num2str(i)]);
    fprintf(fid,'%s\n',['mkdir ' path2movie]); % make directory
    fprintf(fid,'%s\n',['mkdir ' path2frames]); % make directory
    %split files
    fprintf(fid,'%s\n',['avconv -i ' aviPos ...
            ' -vsync 1 -r ' num2str(frameRate) ' -qscale 1 -an -y ''' imageTargetPos '''' ]);
    %make lists
    fprintf(fid,'%s\n',['find ' path2frames ' -name *.jpg | sort > ' listPos ]);
    fprintf(fid,'%s\n',['find ' path2frames ' -name *.jpg | sort > ' listPos2]);
    
    %move movie
    fprintf(fid,'%s\n',['mv ' aviPos ' ' aviTargetPos]);
    fprintf(fid,'\n');
end

%closing file dialog
fclose(fid);
system(['chmod +x ' path2script script_fn]);