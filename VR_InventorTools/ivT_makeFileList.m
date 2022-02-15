function ivT_makeFileList(pname,prefix,suffix,spath,sname)
% This Matlab function creates a list of tif files with full pathname stored 
% in a directory and saves it as filename_list.txt in the same directory. The 
% files must have a common prefix, as for example "first_" or "frame".
%
% GETS:
%       pname = pathname to the folder containing the listed files
%      prefix = common prefix of all to list files, e.g. 'frame_'
%      suffix = common suffix of all to list files, e.g.'tif','jpg' or 'txt'
%       spath = pathname to the folder where the list should be stored
%       sname = name of the list file
%      
% if one of these variables is not given, t will be asked in verbose mode.
%
% RETURNS: dispalys list position and entry number in the command window 
%
% SYNTAX: ivT_makeFileList(pname,prefix,suffix,spath,sname) or ivT_makeFileList
%
% Author: Bart Geurten
% 
% see also: filesep, dir, fopen, fclose, fprintf, inputdlg,ivTmakeFileListFolderWise

% Get directory
if ~exist('pname','var')|| isempty(pname)
        pname= uigetdir('D:\TemperatureMovieTifs\','Pick Tif Directory');
 
end
% Get Filename prefix and suffix
if ~exist('prefix','var') || ~exist('suffix','var') || isempty(prefix) || isempty(suffix) 
    prompt = {'Enter file prefix:','Enter filetyp suffix:'};
    dlg_title = 'filename information';
    num_lines = 1;
    def = {'frame_','tif'};
    fname = inputdlg(prompt,dlg_title,num_lines,def);
else
    fname = {prefix,suffix};
end

% save list
if ~exist('sname','var') || ~exist('spath','var') || isempty(spath) || isempty(sname)
    [sname, spath] = uiputfile({'*.txt','Text file';...
        '*.*','All Files' },'Save List',...
        [pname filesep 'list.txt']);
end
if isunix,
    system(['ls -d ' pname filesep fname{1} '*.' fname{2} ' > ' spath  sname])
else
    % get files
    flist = dir([pname filesep fname{1} '*.' fname{2}]);
    file_nb = size(flist,1);
    
    
    fid1 = fopen( [spath filesep sname], 'w');
    for i=1:file_nb-1,
        output1= [pname filesep flist(i).name];
        fprintf(fid1, '%s\n', output1);
        
    end
    output1= [pname filesep flist(i+1).name];
    fprintf(fid1, '%s', output1);
    fclose(fid1);
    
    disp(['Made file '  [pname filesep sname]  ' with '  num2str(file_nb)  ' entries' ])
end