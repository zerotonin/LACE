function ivT_combineTraces()
% This function combines to trace files. For example if the trace file were
% split for calculation. The entry variables are acquired in verbose mode
% also the consiting file is writen onto disk in verbose mode.
%
% GETS: nothing
%
% RETURNS: file to disk
%
% SYNTAX: ivT_combineTraces()
%
% Author: Bart Geurten
% 
% see also:

% load files
[fname, pname] = uigetfile( ...
    {'*.tra','ivTrace trace file (*.tra)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Pick different traces','Multiselect','on');

file_nb = length(fname);

% Get Filename prefix and suffix
prompt = {};
for i = 1:file_nb,
    prompt{i}= ['Enter rank of file ' fname{i} ':'];
end
dlg_title = 'Enter the rank of trace files according to their succesion';
num_lines = 1;
ranking = inputdlg(prompt,dlg_title,num_lines);
ranking= str2double(ranking);

% save list

[sname, spath] = uiputfile({'*.tra','ivTrace file';...
    '*.*','All Files' },'Save List',...
    [pname '\trace.tra']);



% open file
fidW = fopen([spath sname],'wt');
frame_nb = 0;
h = waitbar(0,'Combining files...');

for i=1:file_nb,
    fileId = ranking == i;
    fidR = fopen([pname fname{fileId}]);
    % read line from file
    tempLine = fgetl(fidR);
    waitbar(i/file_nb)
    while ischar(tempLine) % if end of file is reached templine = -1 and this criteria
        data = sscanf(tempLine,'%f');
        data(1) =[];
        fprintf(fidW,'%5g',frame_nb);
        fprintf(fidW,' %11.2f %11.2f %11.5f %11g %11.2f',data);
        
        frame_nb = frame_nb+1;
        tempLine = fgetl(fidR);
        
        if i==file_nb &&  ~ischar(tempLine)
        else
            fprintf(fidW,'\n');
        end
    end
    fclose(fidR);
end
fclose(fidW);
close(h)
