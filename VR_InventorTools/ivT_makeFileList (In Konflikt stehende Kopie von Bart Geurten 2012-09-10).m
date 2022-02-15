function ivT_makeFileList
% This is only for Bart 
%This Matlab function creates a list of tif files with full pathname stored 
% in a directory and saves it as filename_list.txt in the same directory. The 
% tif files must have a common prefix, as for example first_, the list file 
% name will be prefixlist.txt.
% 
% Author: Bart Geurten


% Get directory
pname= uigetdir('D:\TemperatureMovieTifs\','Pick Tif Directory');

% Get Filename prefix and suffix
prompt = {'Enter file prefix:','Enter filetyp suffix:'};
dlg_title = 'filename information';
num_lines = 1;
def = {'frame_','tif'};
fname = inputdlg(prompt,dlg_title,num_lines,def);

% save list

[sname, spath] = uiputfile({'*.txt','Text file';...
          '*.*','All Files' },'Save List',...
          [pname '\list.txt']);

% get files
flist = dir([pname '\' fname{1} '*.' fname{2}]);
file_nb = size(flist,1);


fid1 = fopen( [spath sname], 'w');
for i=1:file_nb-1,
    output1= [pname '\' flist(i).name];
    fprintf(fid1, '%s\n', output1);

end
output1= [pname '\' flist(i+1).name];
fprintf(fid1, '%s', output1);
fclose(fid1);


disp(['Made file '  [pname '\list.txt']  ' with '  num2str(file_nb)  ' entries' ])
